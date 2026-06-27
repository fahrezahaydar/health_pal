-- Migration: 009_total_patients
-- Deskripsi: Tambah kolom total_patients di tabel doctors untuk
--           Doctor Detail Page v2.0 (ADR-009).
--
-- Kolom ini adalah denormalized field — display only. Nilai bisa
-- di-update manual oleh admin atau via trigger di sprint mendatang.

ALTER TABLE doctors
  ADD COLUMN total_patients INT4 NOT NULL DEFAULT 0;

COMMENT ON COLUMN doctors.total_patients IS 'Total pasien yang pernah ditangani (display only — denormalized)';
