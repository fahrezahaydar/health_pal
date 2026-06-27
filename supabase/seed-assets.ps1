# seed-assets.ps1
# ==============================================================================
# Upload/update semua file dari seed-assets/ ke Supabase Storage local.
#
# Cara pakai:
#   1. Taruh file di supabase/seed-assets/<subfolder>/
#       banner/              -> bucket 'avatars/banner/'
#       specialization_icon/ -> bucket 'specialization-icons/'
#       doctor_avatar/       -> bucket 'doctor-avatars/'
#   2. Jalankan script SETELAH supabase start
#       \supabase\seed-assets.ps1
#   3. Untuk subfolder tertentu:
#       \supabase\seed-assets.ps1 -Bucket doctor_avatar
#   4. Jalankan ulang kapan saja - file existing di-update (upsert).
#   5. Di seed.sql, referensi URL:
#       banner  -> http://127.0.0.1:54321/storage/v1/object/public/avatars/banner/nama-file.jpg
#       doctor  -> http://127.0.0.1:54321/storage/v1/object/public/doctor-avatars/nama-file.jpg
#
# Catatan:
#   - Storage files PERSIST walau db di-reset (Docker volume)
#   - Gunakan PUT (upsert) - file yang sudah ada tetap di-update
# ==============================================================================

param(
  [string]$Bucket = ""
)

$SUPABASE_URL = "http://127.0.0.1:54321"

# Mapping subfolder -> target bucket
$BUCKET_MAP = @{
  "banner"               = "avatars"
  "specialization_icon"  = "specialization-icons"
  "doctor_avatar"        = "doctor-avatars"
}

# Ambil service role key dari supabase status (bypass RLS)
$STATUS = & npx supabase status --output json 2> $null | ConvertFrom-Json
if (-not $STATUS) {
  Write-Error "Supabase tidak berjalan. Jalankan: supabase start"
  exit 1
}
$SERVICE_KEY = $STATUS.SERVICE_ROLE_KEY
if (-not $SERVICE_KEY) {
  Write-Error "Gagal mendapatkan SERVICE_ROLE_KEY dari supabase status"
  exit 1
}

$ASSETS_DIR = Join-Path $PSScriptRoot "seed-assets"

if (-not (Test-Path $ASSETS_DIR)) {
  Write-Host "Folder seed-assets tidak ditemukan. Buat dulu: mkdir supabase/seed-assets"
  exit 0
}

# Tentukan subfolder yang akan di-upload
if ($Bucket -ne "" -and $BUCKET_MAP.ContainsKey($Bucket)) {
  $SUBFOLDERS = @($Bucket)
} else {
  $SUBFOLDERS = $BUCKET_MAP.Keys
}

$totalUploaded = 0
$totalSkipped = 0
$totalErrors = 0

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

  Write-Host ""
  Write-Host "Uploading $($FILES.Count) file(s) to bucket '$targetBucket'..."

  foreach ($file in $FILES) {
    if ($sub -eq "banner") {
      $relativePath = $file.FullName.Substring($ASSETS_DIR.Length + 1) -replace '\\', '/'
      $fileName = $relativePath
    } else {
      $fileName = $file.Name
    }

    $filePath = $file.FullName
    $mimeType = switch ($file.Extension) {
      ".jpg"  { "image/jpeg" }
      ".jpeg" { "image/jpeg" }
      ".png"  { "image/png" }
      ".webp" { "image/webp" }
      ".svg"  { "image/svg+xml" }
      default { "application/octet-stream" }
    }

    $url = "$SUPABASE_URL/storage/v1/object/$targetBucket/$fileName"
    $publicUrl = "$SUPABASE_URL/storage/v1/object/public/$targetBucket/$fileName"

    # Gunakan PUT (upsert) - create jika belum ada, update jika sudah ada
    $dataArg = "--data-binary"
    $fileArg = '@"' + $filePath + '"'
    $response = & curl.exe -s -o NUL -w "%{http_code}" -X PUT `
      -H "Authorization: Bearer $SERVICE_KEY" `
      -H "Content-Type: $mimeType" `
      $dataArg $fileArg `
      "$url" 2> $null

    if ($response -eq '200') {
      Write-Host "  [ok]    $fileName" -ForegroundColor Green
      Write-Host "         URL: $publicUrl"
      $totalUploaded++
    } elseif ($response -eq '201') {
      Write-Host "  [ok]    $fileName" -ForegroundColor Green
      Write-Host "         URL: $publicUrl"
      $totalUploaded++
    } else {
      Write-Host "  [error] $fileName - HTTP $response" -ForegroundColor Red
      $totalErrors++
    }
  }
}

Write-Host ""
Write-Host "Done. $totalUploaded uploaded, $totalSkipped skipped, $totalErrors errors."
