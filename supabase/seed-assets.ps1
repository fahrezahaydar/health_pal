# seed-assets.ps1
# ==============================================================================
# Upload file dari seed-assets/ ke Supabase Storage local.
#
# Cara pakai:
#   1. Taruh file gambar di supabase/seed-assets/
#       Contoh: banner-promo.jpg, icon-umum.png, dokter-andi.jpg
#   2. Jalankan script ini SEBELUM supabase db reset / seed
#   3. Di seed.sql, referensi URL:
#       http://127.0.0.1:54321/storage/v1/object/public/avatars/banner-promo.jpg
#
# Catatan:
#   - Storage files PERSIST walau db di-reset (Docker volume)
#   - Upload cukup sekali, kecuali file diganti
#   - Kalau file sudah ada, di-skip (on conflict di storage.objects)
# ==============================================================================

$SUPABASE_URL = "http://127.0.0.1:54321"
$BUCKET = "avatars"

# Ambil anon key dari supabase status
$STATUS = & npx supabase status --output json 2>$null | ConvertFrom-Json
if (-not $STATUS) {
  Write-Error "Supabase tidak berjalan. Jalankan: supabase start"
  exit 1
}
# Pakai SERVICE_ROLE_KEY (bypass RLS) untuk upload seed assets.
# Anon key tidak bisa upload ke bucket avatars karena RLS policy
# mewajibkan auth.role() = 'authenticated'.
$ANON_KEY = $STATUS.SERVICE_ROLE_KEY
if (-not $ANON_KEY) {
  Write-Error "Gagal mendapatkan SERVICE_ROLE_KEY dari supabase status"
  exit 1
}

$ASSETS_DIR = Join-Path $PSScriptRoot "seed-assets"

if (-not (Test-Path $ASSETS_DIR)) {
  Write-Host "Folder seed-assets tidak ditemukan. Buat dulu: mkdir supabase/seed-assets"
  exit 0
}

# Recursive: include files di subdirectory (misal banner/, icons/, dll).
# Nama file di storage: subdir/filename.ext (preserve relative path).
$FILES = Get-ChildItem -Path $ASSETS_DIR -File -Recurse
if ($FILES.Count -eq 0) {
  Write-Host "Tidak ada file di seed-assets/. Taruh file gambar di sini."
  exit 0
}

Write-Host "Uploading $($FILES.Count) file(s) to bucket '$BUCKET'..."
Write-Host ""

foreach ($file in $FILES) {
  # Relative path dari seed-assets/ ke file (preserve subfolder structure)
  # Gunakan / sebagai path separator (storage API pakai forward slash)
  $fileName = $file.FullName.Substring($ASSETS_DIR.Length + 1) -replace '\\', '/'
  $filePath = $file.FullName
  $mimeType = switch ($file.Extension) {
    ".jpg" { "image/jpeg" }
    ".jpeg" { "image/jpeg" }
    ".png" { "image/png" }
    ".webp" { "image/webp" }
    ".svg" { "image/svg+xml" }
    default { "application/octet-stream" }
  }

  $url = "$SUPABASE_URL/storage/v1/object/$BUCKET/$fileName"
  $publicUrl = "$SUPABASE_URL/storage/v1/object/public/$BUCKET/$fileName"

  # Gunakan curl.exe untuk hindari bug URI parsing PowerShell 5.1
  $response = & curl.exe -s -o NUL -w "%{http_code}" -X POST `
    -H "Authorization: Bearer $ANON_KEY" `
    -H "Content-Type: $mimeType" `
    --data-binary "@`"$filePath`"" `
    "$url" 2>`$null

  if ($response -eq '200') {
    Write-Host "  [ok]    $fileName"
    Write-Host "         URL: $publicUrl"
  } elseif ($response -eq '409') {
    Write-Host "  [skip]  $fileName — already exists"
  } else {
    Write-Host "  [error] $fileName — HTTP $response"
  }
}

Write-Host ""
Write-Host "Done. File URLs bisa dipakai di seed.sql."
