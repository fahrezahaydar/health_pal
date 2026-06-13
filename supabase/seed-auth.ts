/**
 * seed-auth.ts — DEPRECATED
 * ==============================================================================
 * FILE INI TIDAK DIGUNAKAN LAGI.
 * Semua seed data (termasuk auth users) sudah ditangani oleh seed.sql langsung.
 *
 * Referensi: seed.sql section 1 (auth.users) + section 2 (user_profiles)
 *
 * Dulu dipakai karena auth.users dianggap tidak bisa via SQL.
 * Tapi setelah diteliti, INSERT ke auth.users + auth.identities via SQL
 * works dengan syarat semua kolom required diisi (termasuk identity).
 *
 * Ditinggalkan sebagai referensi jika suatu saat ingin pake Admin API.
 * ==============================================================================
 * Backup script — creates auth users + user_profiles via Supabase Admin API.
 *
 * 🔑 PRINSIP KERJA:
 *   Auth users tidak bisa dibuat via SQL langsung (GoTruth mengelola auth.users
 *   secara internal dengan kolom tambahan). Maka gunakan Supabase Admin API
 *   melalui service_role key.
 *
 * 📦 DEPENDENCIES:
 *   "@supabase/supabase-js"  →  npm install
 *   "tsx"                    →  menjalankan TypeScript langsung
 *   "typescript"             →  dev dependency
 *
 * 🚀 CARA PAKAI:
 *   cd supabase
 *   npm install
 *   npx tsx seed-auth.ts
 *
 * 📋 PRASYARAT:
 *   supabase start  →  local Supabase harus berjalan (port 54321)
 * ==============================================================================
 */

import { createClient } from "@supabase/supabase-js";

// ──────────────────────────────────────────────────────────────────────────────
// KONFIGURASI
// ──────────────────────────────────────────────────────────────────────────────
// SUPABASE_URL: default dari config.toml (api.port = 54321)
const SUPABASE_URL = "http://127.0.0.1:54321";

// SUPABASE_SERVICE_ROLE_KEY: key super-admin untuk bypass RLS & manage auth.
//   Ini key DEFAULT untuk local dev — AMAN di-commit karena cuma lokal.
//   Untuk production: ambil dari Settings → API → service_role key (JANGAN di-commit).
const SUPABASE_SERVICE_ROLE_KEY =
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImV4cCI6MTk4MzgxMjk5Nn0.EQ4KBbBlEq8t5fMdl7cBQTR3bBpN-EhC4aHqSFRf";

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, {
  auth: { autoRefreshToken: false, persistSession: false },
});

// ──────────────────────────────────────────────────────────────────────────────
// STRUKTUR DATA USER
// ──────────────────────────────────────────────────────────────────────────────
// email       → login email (harus unik)
// password    → minimal 6 karakter
//
// profile     → data untuk tabel user_profiles:
//   full_name             Nama lengkap (required)
//   nickname              Panggilan (opsional)
//   avatar_url            URL foto dari storage:
//                           upload file → bucket 'avatars/nama-user.jpg'
//                           URL public → http://127.0.0.1:54321/storage/v1/object/public/avatars/nama-user.jpg
//                         Bisa null dulu, isi nanti dari app.
//   date_of_birth         Tanggal lahir (YYYY-MM-DD)
//   gender                'male' | 'female' | 'other'
//   notif_reminder_enabled  Boolean, default true
//   is_profile_complete     Boolean, false sampai user isi profil lengkap
// ──────────────────────────────────────────────────────────────────────────────
interface SeedUser {
  email: string;
  password: string;
  profile: {
    full_name: string;
    nickname: string;
    avatar_url?: string | null;
    date_of_birth: string;
    gender: "male" | "female" | "other";
    notif_reminder_enabled: boolean;
    is_profile_complete: boolean;
  };
}

// ──────────────────────────────────────────────────────────────────────────────
// DATA USER
// ──────────────────────────────────────────────────────────────────────────────
// ✏️ CARA NAMBAH USER BARU:
//    1. Duplikat satu objek {...},
//    2. Isi email & password,
//    3. Isi profile sesuai data user,
//    4. Jalankan ulang: npx tsx seed-auth.ts
//
// 🖼️ CARA KASIH FOTO PROFIL:
//    1. Upload file ke Supabase Studio → Storage → bucket 'avatars'
//       URL hasil: http://127.0.0.1:54321/storage/v1/object/public/avatars/foto-user.jpg
//    2. Isi field avatar_url dengan URL tersebut
//    3. Jalankan ulang script (upsert akan update user_profiles)
// ──────────────────────────────────────────────────────────────────────────────

const USERS: SeedUser[] = [
  {
    email: "test@example.com",
    password: "Test123456!",
    profile: {
      full_name: "Test User",
      nickname: "Test",
      avatar_url: null,
      date_of_birth: "1995-06-15",
      gender: "male",
      notif_reminder_enabled: true,
      is_profile_complete: true,
    },
  },
  {
    email: "user@example.com",
    password: "User123456!",
    profile: {
      full_name: "Rina Susanti",
      nickname: "Rina",
      avatar_url: null,
      date_of_birth: "1992-03-22",
      gender: "female",
      notif_reminder_enabled: true,
      is_profile_complete: true,
    },
  },
  {
    email: "demo@example.com",
    password: "Demo123456!",
    profile: {
      full_name: "Budi Demo",
      nickname: "Budi",
      avatar_url: null,
      date_of_birth: "1988-11-01",
      gender: "male",
      notif_reminder_enabled: false,
      is_profile_complete: false,
    },
  },
  // ── CONTOH: User dengan avatar ─────────────────────────────────
  // {
  //   email: "sinta@example.com",
  //   password: "Sinta123!",
  //   profile: {
  //     full_name: "Sinta Amelia",
  //     nickname: "Sinta",
  //     avatar_url: "http://127.0.0.1:54321/storage/v1/object/public/avatars/sinta.jpg",
  //     date_of_birth: "1998-07-12",
  //     gender: "female",
  //     notif_reminder_enabled: true,
  //     is_profile_complete: true,
  //   },
  // },
];

// ──────────────────────────────────────────────────────────────────────────────
// EKSEKUSI
// ──────────────────────────────────────────────────────────────────────────────
async function main() {
  console.log("Seeding auth users...\n");

  for (const user of USERS) {
    // 1. Buat auth user via Admin API
    //    email_confirm: true → skip konfirmasi email di local dev
    const { data: authData, error: authError } =
      await supabase.auth.admin.createUser({
        email: user.email,
        password: user.password,
        email_confirm: true,
        user_metadata: { full_name: user.profile.full_name },
      });

    if (authError) {
      // Skip kalau user sudah ada (re-run aman)
      if (authError.message?.includes("already exists")) {
        console.log(`  [skip]  ${user.email} — already exists`);
      } else {
        console.error(`  [error] ${user.email} — ${authError.message}`);
        continue;
      }
    } else {
      console.log(`  [ok]    ${user.email} — auth user created (${authData.user.id})`);
    }

    const authId = authData?.user?.id;
    if (!authId) continue;

    // 2. Insert user_profile
    //    Gunakan insert biasa, catch duplicate key (23505) untuk re-run safety.
    const { error: profileError } = await supabase.from("user_profiles").insert({
      auth_id: authId,
      full_name: user.profile.full_name,
      nickname: user.profile.nickname,
      avatar_url: user.profile.avatar_url ?? null,
      date_of_birth: user.profile.date_of_birth,
      gender: user.profile.gender,
      notif_reminder_enabled: user.profile.notif_reminder_enabled,
      is_profile_complete: user.profile.is_profile_complete,
    });

    if (profileError) {
      // 23505 = unique_violation (re-run, profile sudah ada)
      if (profileError.code === "23505") {
        console.log(`  [skip]  ${user.email} — profile already exists`);
      } else {
        console.error(`  [error] ${user.email} — profile: ${profileError.message}`);
      }
    } else {
      console.log(`  [ok]    ${user.email} — user_profile created`);
    }
  }

  console.log("\n✅ Done. Auth users seeded successfully.");
  console.log("   Login credentials:");
  for (const u of USERS) {
    console.log(`   ${u.email} / ${u.password}`);
  }
}

main().catch((err) => {
  console.error("Fatal error:", err);
  process.exit(1);
});
