/**
 * seed-auth.ts
 * ------------------------------------------------------------------
 * Creates auth users + user_profiles for local Supabase development.
 *
 * Uses the Supabase Admin SDK (service_role key) to:
 *   1. Sign up auth users via the Auth Admin API
 *   2. Insert corresponding user_profiles rows
 *
 * Usage:
 *   cd supabase
 *   npm install
 *   npx tsx seed-auth.ts
 *
 * Prerequisite:
 *   - `supabase start` must be running
 * ------------------------------------------------------------------
 */

import { createClient } from "@supabase/supabase-js";

const SUPABASE_URL = "http://127.0.0.1:54321";
const SUPABASE_SERVICE_ROLE_KEY =
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImV4cCI6MTk4MzgxMjk5Nn0.EQ4KBbBlEq8t5fMdl7cBQTR3bBpN-EhC4aHqSFRf";

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, {
  auth: { autoRefreshToken: false, persistSession: false },
});

interface SeedUser {
  email: string;
  password: string;
  profile: {
    full_name: string;
    nickname: string;
    date_of_birth: string;
    gender: "male" | "female" | "other";
    notif_reminder_enabled: boolean;
    is_profile_complete: boolean;
  };
}

const USERS: SeedUser[] = [
  {
    email: "test@example.com",
    password: "Test123456!",
    profile: {
      full_name: "Test User",
      nickname: "Test",
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
      date_of_birth: "1988-11-01",
      gender: "male",
      notif_reminder_enabled: false,
      is_profile_complete: false,
    },
  },
];

async function main() {
  console.log("Seeding auth users...\n");

  for (const user of USERS) {
    // 1. Create auth user via Admin API
    const { data: authData, error: authError } =
      await supabase.auth.admin.createUser({
        email: user.email,
        password: user.password,
        email_confirm: true,
        user_metadata: { full_name: user.profile.full_name },
      });

    if (authError) {
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
    const { error: profileError } = await supabase.from("user_profiles").insert({
      auth_id: authId,
      full_name: user.profile.full_name,
      nickname: user.profile.nickname,
      date_of_birth: user.profile.date_of_birth,
      gender: user.profile.gender,
      notif_reminder_enabled: user.profile.notif_reminder_enabled,
      is_profile_complete: user.profile.is_profile_complete,
    });

    if (profileError) {
      console.error(`  [error] ${user.email} — profile: ${profileError.message}`);
    } else {
      console.log(`  [ok]    ${user.email} — user_profile created`);
    }
  }

  console.log("\nDone. Auth users seeded successfully.");
}

main().catch((err) => {
  console.error("Fatal error:", err);
  process.exit(1);
});
