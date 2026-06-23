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

param(
  [string]$Bucket = ""
)

$SUPABASE_URL = "http://127.0.0.1:54321"

# Mapping subfolder → bucket name
$BUCKET_MAP = @{
  "banner"               = "avatars"
  "specialization_icon"  = "specialization-icons"
}

# Ambil anon key dari supabase status
$STATUS = & npx supabase status --output json 2>$null | ConvertFrom-Json
if (-not $STATUS) {
  Write-Error "Supabase tidak berjalan. Jalankan: supabase start"
  exit 1
}
# Pakai SERVICE_ROLE_KEY (bypass RLS) untuk upload seed assets.
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

# Tentukan subfolder mana yang akan di-upload
if ($Bucket -ne "" -and $BUCKET_MAP.ContainsKey($Bucket)) {
  $SUBFOLDERS = @($Bucket)
} else {
  $SUBFOLDERS = $BUCKET_MAP.Keys
}

$totalUploaded = 0

foreach ($sub in $SUBFOLDERS) {
  $targetBucket = $BUCKET_MAP[$sub]
  $subDir = Join-Path $ASSETS_DIR $sub

  if (-not (Test-Path $subDir)) {
    Write-Host "Folder seed-assets/$sub tidak ditemukan, skip."
    continue
  }

  $FILES = Get-ChildItem -Path $subDir -File
  if ($FILES.Count -eq 0) {
    Write-Host "Tidak ada file di seed-assets/$sub/."
    continue
  }

  Write-Host "Uploading $($FILES.Count) file(s) to bucket '$targetBucket'..."
  foreach ($file in $FILES) {
    $fileName = $file.Name
    $filePath = $file.FullName
    $mimeType = switch ($file.Extension) {
      ".jpg" { "image/jpeg" }
      ".jpeg" { "image/jpeg" }
      ".png" { "image/png" }
      ".webp" { "image/webp" }
      ".svg" { "image/svg+xml" }
      default { "application/octet-stream" }
    }

    $url = "$SUPABASE_URL/storage/v1/object/$targetBucket/$fileName"
    $publicUrl = "$SUPABASE_URL/storage/v1/object/public/$targetBucket/$fileName"

    $response = & curl.exe -s -o NUL -w "%{http_code}" -X POST `
      -H "Authorization: Bearer $ANON_KEY" `
      -H "Content-Type: $mimeType" `
      --data-binary "@`"$filePath`"" `
      "$url" 2>`$null

    if ($response -eq '200') {
      Write-Host "  [ok]    $fileName"
      Write-Host "         URL: $publicUrl"
      $totalUploaded++
    } elseif ($response -eq '409') {
      Write-Host "  [skip]  $fileName — already exists"
    } else {
      Write-Host "  [error] $fileName — HTTP $response"
    }
  }
  Write-Host ""
}

Write-Host "Done. $totalUploaded file(s) uploaded."
