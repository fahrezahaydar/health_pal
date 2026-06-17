# Icon Migration Audit — Material Icons → AppIcons

**Tanggal:** 16 Juni 2026
**Tujuan:** Centralize semua icon ke AppIcons class (single source of truth)

---

## Material Icons Ditemukan

| # | Icons.xxx | File | Baris | Konteks | Iconsax Saran |
|---|-----------|------|-------|---------|---------------|
| 1 | Icons.search | doctor_search_page.dart | 134 | Search bar prefix | `Iconsax.searchNormal` |
| 2 | Icons.close | doctor_search_page.dart | 138 | Search clear button | `Iconsax.closeCircle` |
| 3 | Icons.arrow_back | booking_detail_page.dart | 76 | Back button nav | `Iconsax.arrowLeft01` |
| 4 | Icons.arrow_back | doctor_detail_page.dart | 108 | Back button nav | `Iconsax.arrowLeft01` |
| 5 | Icons.arrow_back | doctor_search_page.dart | 118 | Back button nav | `Iconsax.arrowLeft01` |
| 6 | Icons.arrow_back | book_appointment_page.dart | 189 | Back button nav | `Iconsax.arrowLeft01` |
| 7 | Icons.arrow_back | edit_profile_page.dart | 169 | Back button nav | `Iconsax.arrowLeft01` |
| 8 | Icons.arrow_back | favorite_page.dart | 34 | Back button nav | `Iconsax.arrowLeft01` |
| 9 | Icons.arrow_back | notification_page.dart | 54 | Back button nav | `Iconsax.arrowLeft01` |
| 10 | Icons.arrow_back | help_support_page.dart | 53 | Back button nav | `Iconsax.arrowLeft01` |
| 11 | Icons.arrow_back | terms_and_conditions_page.dart | 56 | Back button nav | `Iconsax.arrowLeft01` |
| 12 | Icons.arrow_back | forgot_password_page.dart | 62 | Back button nav | `Iconsax.arrowLeft01` |
| 13 | Icons.arrow_back | create_profile_page.dart | 150 | Back button nav | `Iconsax.arrowLeft01` |
| 14 | Icons.person | sign_up_page.dart | 108 | Name field prefix | `Iconsax.user` |
| 15 | Icons.person | booking_detail_page.dart | 156/163 | Doctor avatar placeholder | `Iconsax.user` |
| 16 | Icons.person | booking_success_page.dart | 122 | Doctor name row | `Iconsax.user` |
| 17 | Icons.person | book_appointment_page.dart | 240 | Doctor avatar | `Iconsax.user` |
| 18 | Icons.person | profile_page.dart | 179 | Edit Profile menu | `Iconsax.user` |
| 19 | Icons.person | settings_page.dart | 141 | Edit Profile menu | `Iconsax.user` |
| 20 | Icons.person | doctor_card.dart | 67 | Doctor avatar fallback | `Iconsax.user` |
| 21 | Icons.person | doctor_card_detail.dart | 50/56 | Doctor avatar fallback | `Iconsax.user` |
| 22 | Icons.person | appointment_card.dart | 68/74 | Doctor avatar fallback | `Iconsax.user` |
| 23 | Icons.person | booking_summary_card.dart | 67 | Doctor name row | `Iconsax.user` |
| 24 | Icons.email | login_page.dart | 143 | Email field prefix | `Iconsax.smsStyle5` |
| 25 | Icons.email | sign_up_page.dart | 122 | Email field prefix | `Iconsax.smsStyle5` |
| 26 | Icons.email | forgot_password_page.dart | 146 | Email field prefix | `Iconsax.smsStyle5` |
| 27 | Icons.email | help_support_page.dart | 75 | Email contact icon | `Iconsax.sms` |
| 28 | Icons.email | settings_page.dart | 154 | Email registered | `Iconsax.sms` |
| 29 | Icons.lock | login_page.dart | 165 | Password field prefix | `Iconsax.padlockStyle5` |
| 30 | Icons.lock | sign_up_page.dart | 144 | Password field prefix | `Iconsax.padlockStyle5` |
| 31 | Icons.lock | forgot_password_page.dart | 324/354 | Password field prefix | `Iconsax.padlockStyle5` |
| 32 | Icons.lock | settings_page.dart | 147 | Ubah Password menu | `Iconsax.lock` |
| 33 | Icons.visibility_off | login_page.dart | 183 | Hide password | `Iconsax.eyeSlash` |
| 34 | Icons.visibility | login_page.dart | 184 | Show password | `Iconsax.eye` |
| 35 | Icons.visibility_off | sign_up_page.dart | 162 | Hide password | `Iconsax.eyeSlash` |
| 36 | Icons.visibility | sign_up_page.dart | 163 | Show password | `Iconsax.eye` |
| 37 | Icons.visibility_off | forgot_password_page.dart | 339/373 | Hide password | `Iconsax.eyeSlash` |
| 38 | Icons.visibility | forgot_password_page.dart | 339/373 | Show password | `Iconsax.eye` |
| 39 | Icons.calendar_today | booking_detail_page.dart | 206 | Appointment date | `Iconsax.calendar` |
| 40 | Icons.calendar_today | booking_success_page.dart | 127 | Success date row | `Iconsax.calendar` |
| 41 | Icons.calendar_today | booking_summary_card.dart | 71 | Summary date | `Iconsax.calendar` |
| 42 | Icons.calendar_today | booking_history_page.dart | 120 | Empty state icon | `Iconsax.calendar` |
| 43 | Icons.calendar_today | book_appointment_page.dart | 272 | Date picker icon | `Iconsax.calendar` |
| 44 | Icons.calendar_today | doctor_detail_page.dart | 356 | CTA button | `Iconsax.calendar` |
| 45 | Icons.calendar_today_outlined | slot_availability_text.dart | 36 | Slot section header | `Iconsax.calendar` |
| 46 | Icons.access_time | booking_detail_page.dart | 210 | Appointment time | `Iconsax.clock` |
| 47 | Icons.access_time | booking_success_page.dart | 130 | Success time row | `Iconsax.clock` |
| 48 | Icons.access_time | booking_summary_card.dart | 73 | Summary time | `Iconsax.clock` |
| 49 | Icons.local_hospital | booking_detail_page.dart | 213 | Clinic name | `Iconsax.hospital` |
| 50 | Icons.local_hospital | booking_success_page.dart | 124 | Success clinic row | `Iconsax.hospital` |
| 51 | Icons.local_hospital | clinic_card.dart | 54/61 | Clinic placeholder | `Iconsax.hospital` |
| 52 | Icons.local_hospital | loc_page.dart | 385 | Empty state | `Iconsax.hospital` |
| 53 | Icons.local_hospital | loc_map_widget.dart | 106 | Map marker | `Iconsax.hospital` |
| 54 | Icons.local_hospital | placeholder_image.dart | 26 | Placeholder fallback | `Iconsax.hospital` |
| 55 | Icons.local_hospital | category_card.dart | 76/86 | Category icon fallback | `Iconsax.hospital` |
| 56 | Icons.local_hospital_outlined | doctor_detail_page.dart | 286 | Clinic info | `Iconsax.hospital` |
| 57 | Icons.location_on | booking_detail_page.dart | 216 | Clinic address | `Iconsax.location` |
| 58 | Icons.location_on | clinic_card.dart | 81 | Address icon | `Iconsax.location` |
| 59 | Icons.location_on | nearby_clinic_card.dart | 87 | Address icon | `Iconsax.location` |
| 60 | Icons.phone | booking_detail_page.dart | 220 | Clinic phone | `Iconsax.call` |
| 61 | Icons.phone | help_support_page.dart | 82 | Phone contact | `Iconsax.call` |
| 62 | Icons.phone | settings_page.dart | 164 | Emergency phone | `Iconsax.call` |
| 63 | Icons.payments | booking_detail_page.dart | 224 | Fee display | `Iconsax.wallet` |
| 64 | Icons.payments | booking_success_page.dart | 134 | Success fee row | `Iconsax.wallet` |
| 65 | Icons.payments | book_appointment_page.dart | 387 | Fee summary | `Iconsax.wallet` |
| 66 | Icons.payments | booking_summary_card.dart | 76 | Summary fee | `Iconsax.wallet` |
| 67 | Icons.payments_outlined | doctor_detail_page.dart | 306/420 | Doctor fee | `Iconsax.wallet` |
| 68 | Icons.check_circle | booking_success_page.dart | 56 | Success icon | `Iconsax.tickCircle` |
| 69 | Icons.check | status_timeline.dart | 147 | Timeline checkmark | `Iconsax.tickCircle` |
| 70 | Icons.info_outline | booking_success_page.dart | 141 | Status badge | `Iconsax.infoCircle` |
| 71 | Icons.info_outline | doctor_detail_page.dart | 272 | About doctor | `Iconsax.infoCircle` |
| 72 | Icons.edit_calendar | book_appointment_page.dart | 281 | Date picker button | `Iconsax.calendarEdit` |
| 73 | Icons.share_outlined | doctor_detail_page.dart | 114 | Share button | `Iconsax.share` |
| 74 | Icons.school_outlined | doctor_detail_page.dart | 249/408 | Education | `Iconsax.graduation` |
| 75 | Icons.work_outline | doctor_detail_page.dart | 264/416 | Experience | `Iconsax.briefcase` |
| 76 | Icons.rate_review_outlined | doctor_detail_page.dart | 326 | Reviews | `Iconsax.messageText` |
| 77 | Icons.search_off | doctor_search_page.dart | 207 | Empty search | `Iconsax.searchNormal` |
| 78 | Icons.location_off | nearby_facilities.dart | 61 | Empty nearby | `Iconsax.locationSlash` |
| 79 | Icons.location_disabled | loc_page.dart | 310 | Location denied | `Iconsax.locationSlash` |
| 80 | Icons.location_disabled | nearby_facilities.dart | 83 | Location denied | `Iconsax.locationSlash` |
| 81 | Icons.error_outline | nearby_facilities.dart | 105 | Error state | `Iconsax.infoCircle` |
| 82 | Icons.error_outline | error_section.dart | 31 | Error widget | `Iconsax.warning2` |
| 83 | Icons.arrow_drop_down | loc_page.dart | 74 | Radius dropdown | `Iconsax.arrowDown01` |
| 84 | Icons.sort | loc_page.dart | 251 | Sort button | `Iconsax.sort` |
| 85 | Icons.my_location | loc_map_widget.dart | 96 | User location pin | `Iconsax.location` |
| 86 | Icons.favorite | profile_page.dart | 193 | Favorite menu | `Iconsax.heart` |
| 87 | Icons.favorite | favorite_page.dart | 93 | Empty state | `Iconsax.heart` |
| 88 | Icons.favorite | category_card.dart | 79 | Cardiology | `Iconsax.heart` |
| 89 | Icons.favorite_border | doctor_card_detail.dart | 111 | Not favorite | `Iconsax.heart` |
| 90 | Icons.notifications | profile_page.dart | 199 | Notification menu | `Iconsax.notification` |
| 91 | Icons.notifications | notification_page.dart | 177 | Empty state | `Iconsax.notification` |
| 92 | Icons.notifications | settings_page.dart | 179 | Push notification | `Iconsax.notification` |
| 93 | Icons.settings | profile_page.dart | 205 | Settings menu | `Iconsax.setting2` |
| 94 | Icons.help | profile_page.dart | 211 | Help menu | `Iconsax.messageQuestion` |
| 95 | Icons.help | settings_page.dart | 265 | Bantuan menu | `Iconsax.messageQuestion` |
| 96 | Icons.description | profile_page.dart | 217 | T&C menu | `Iconsax.documentText` |
| 97 | Icons.description | settings_page.dart | 259 | S&K menu | `Iconsax.documentText` |
| 98 | Icons.description | terms_and_conditions_page.dart | 75 | Document icon | `Iconsax.documentText` |
| 99 | Icons.logout | profile_page.dart | 230 | Logout button | `Iconsax.logout01` |
| 100 | Icons.logout | settings_page.dart | 276 | Logout button | `Iconsax.logout01` |
| 101 | Icons.wifi_off | no_internet_page.dart | 65 | No connection | `Iconsax.wifiSquare` |
| 102 | Icons.dark_mode | settings_page.dart | 187 | Dark mode toggle | `Iconsax.moon` |
| 103 | Icons.delete | settings_page.dart | 200 | Hapus Cache | `Iconsax.trash` |
| 104 | Icons.storage | settings_page.dart | 222 | Hapus Data Lokal | `Iconsax.data` |
| 105 | Icons.info | settings_page.dart | 250 | Version info | `Iconsax.infoCircle` |
| 106 | Icons.star | doctor_card.dart | 108 | Rating star | `Iconsax.star` |
| 107 | Icons.star | doctor_card_detail.dart | 78 | Rating star | `Iconsax.star` |
| 108 | Icons.medical_services | category_card.dart | 78 | Dental | `Iconsax.hospital` |
| 109 | Icons.medical_services | booking_summary_card.dart | 69 | Specialization | `Iconsax.hospital` |
| 110 | Icons.air | category_card.dart | 80 | Pulmonology | `Iconsax.hospital` |
| 111 | Icons.psychology | category_card.dart | 81 | Neurology | `Iconsax.hospital` |
| 112 | Icons.science | category_card.dart | 82 | Gastro | `Iconsax.hospital` |
| 113 | Icons.biotech | category_card.dart | 83 | Lab | `Iconsax.hospital` |
| 114 | Icons.vaccines | category_card.dart | 84 | Vaccination | `Iconsax.hospital` |
| 115 | Icons.people | clinic_card.dart | 147 | Doctor count | `Iconsax.people` |
| 116 | Icons.map | clinic_card.dart | 161 | Lihat Peta | `Iconsax.map` |

## Iconsax Existing Usage (tidak perlu diubah, hanya di-reference via AppIcons)

| # | Iconsax.xxx | File | Konteks |
|---|-------------|------|---------|
| 1 | Iconsax.notificationBingStyle5 | greeting_section.dart | Notification bell |
| 2 | Iconsax.searchNormal | search_bar_home.dart | Search icon |
| 3 | Iconsax.filter | search_bar_home.dart | Filter icon |
| 4 | Iconsax.calendar | app_shell.dart, upcoming_card.dart, date_picker etc | Calendar/date |
| 5 | Iconsax.home | app_shell.dart | Bottom nav home |
| 6 | Iconsax.location | app_shell.dart, upcoming_card.dart | Location |
| 7 | Iconsax.user | app_shell.dart, upcoming_card.dart | User/profile |
| 8 | Iconsax.gallery | banner_card.dart | Gallery image |
| 9 | Iconsax.tickCircle | notification_card.dart | Success notification |
| 10 | Iconsax.closeCircle | notification_card.dart | Cancelled notification |
| 11 | Iconsax.clock | notification_card.dart | Reminder notification |
| 12 | Iconsax.notification | notification_card.dart | Default notification |
| 13 | Iconsax.shieldTick | app_succes_dialog.dart | Success dialog |
| 14 | Iconsax.closeCircle | app_succes_dialog.dart | Error dialog |
| 15 | Iconsax.warning2 | app_succes_dialog.dart | Warning dialog |
| 16 | Iconsax.infoCircle | app_succes_dialog.dart | Info dialog |
| 17 | Iconsax.arrowDown01 | date_picker_field.dart | Dropdown arrow |
| 18 | Iconsax.calendar2Style8 | app_date_picker_field.dart | Date picker |
| 19 | Iconsax.arrowUp02 | drop_down_button.dart | Dropup arrow |
| 20 | Iconsax.arrowDown02 | drop_down_button.dart | Dropdown arrow |
| 21 | Iconsax.profileCircle | app_image_picker.dart | Profile placeholder |
| 22 | Iconsax.editStyle4 | app_image_picker.dart | Edit button |
| 23 | Iconsax.cameraStyle4 | app_image_picker.dart | Camera option |
| 24 | Iconsax.galleryStyle4 | app_image_picker.dart | Gallery option |
| 25 | Iconsax.trashStyle4 | app_image_picker.dart | Delete option |
| 26 | Iconsax.arrowRight03 | contact_card.dart, menu_item_tile.dart | Chevron right |
| 27 | Iconsax.messageQuestion | faq_tile.dart | FAQ question icon |

---

## Status: Belum Migrasi
- **Total icon unik perlu di-mapping ke AppIcons:** ~60
- **Total file yang perlu diubah:** ~35 files
