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
$ANON_KEY = $STATUS.api_keys.anon
# Fallback: default anon key untuk local dev
if (-not $ANON_KEY) {
  $ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdEDwNda5pI5QmK2Z6Ew"
}

$ASSETS_DIR = Join-Path $PSScriptRoot "seed-assets"

if (-not (Test-Path $ASSETS_DIR)) {
  Write-Host "Folder seed-assets tidak ditemukan. Buat dulu: mkdir supabase/seed-assets"
  exit 0
}

$FILES = Get-ChildItem -Path $ASSETS_DIR -File
if ($FILES.Count -eq 0) {
  Write-Host "Tidak ada file di seed-assets/. Taruh file gambar di sini."
  exit 0
}

Write-Host "Uploading $($FILES.Count) file(s) to bucket '$BUCKET'..."
Write-Host ""

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

  $uri = "$SUPABASE_URL/storage/v1/object/$BUCKET/$fileName"

  try {
    $response = Invoke-RestMethod -Uri $uri -Method Post -Headers @{
      "Authorization" = "Bearer $ANON_KEY"
      "Content-Type"  = $mimeType
    } -InFile $filePath -ErrorAction Stop

    $publicUrl = "$SUPABASE_URL/storage/v1/object/public/$BUCKET/$fileName"
    Write-Host "  [ok]    $fileName"
    Write-Host "         URL: $publicUrl"
  }
  catch {
    if ($_.Exception.Response.StatusCode -eq 409) {
      Write-Host "  [skip]  $fileName — already exists"
    } else {
      Write-Host "  [error] $fileName — $_"
    }
  }
}

Write-Host ""
Write-Host "Done. File URLs bisa dipakai di seed.sql."
