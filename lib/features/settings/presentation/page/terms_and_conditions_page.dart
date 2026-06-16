// lib/features/settings/presentation/page/terms_and_conditions_page.dart
//
// Halaman Terms & Conditions. Per wireframe 20-tnc.md.
// Halaman statis, scroll-only. Konten placeholder — akan disiapkan tim legal.

import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  static const _sections = <_TncSection>[
    _TncSection(
      title: '1. Ketentuan Umum',
      body:
          'Dengan mengunduh, menginstal, atau menggunakan aplikasi Health Pal, Anda setuju untuk terikat dengan Syarat dan Ketentuan ini. Aplikasi ini disediakan oleh PT Health Pal Indonesia untuk membantu pengguna menemukan dan membuat janji dengan dokter.',
    ),
    _TncSection(
      title: '2. Privasi & Data',
      body:
          'Kami berkomitmen melindungi privasi Anda. Data pribadi yang dikumpulkan (nama, email, tanggal lahir, riwayat appointment) akan digunakan hanya untuk keperluan layanan dan tidak akan dibagikan ke pihak ketiga tanpa persetujuan Anda, kecuali diwajibkan oleh hukum.',
    ),
    _TncSection(
      title: '3. Penggunaan Layanan',
      body:
          'Layanan Health Pal hanya untuk keperluan informasi dan pembuatan janji medis. Aplikasi ini TIDAK menggantikan konsultasi medis langsung. Dalam keadaan darurat, segera hubungi rumah sakit atau call center 119.',
    ),
    _TncSection(
      title: '4. Batasan Tanggung Jawab',
      body:
          'Health Pal tidak bertanggung jawab atas kerugian yang timbul dari penggunaan informasi di aplikasi ini, termasuk namun tidak terbatas pada keputusan medis yang diambil berdasarkan konten dalam aplikasi. Selalu konsultasikan dengan dokter profesional.',
    ),
    _TncSection(
      title: '5. Perubahan Ketentuan',
      body:
          'Kami berhak mengubah Syarat dan Ketentuan ini sewaktu-waktu. Perubahan akan diinformasikan melalui notifikasi dalam aplikasi. Dengan tetap menggunakan aplikasi setelah perubahan, Anda dianggap menyetujui ketentuan yang baru.',
    ),
    _TncSection(
      title: '6. Pembatalan & Refund',
      body:
          'Appointment yang sudah dibooking dapat dibatalkan maksimal 1 (satu) jam sebelum jadwal konsultasi. Pembayaran (jika berlaku) akan dikembalikan sesuai kebijakan klinik terkait.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.grey50,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          // TODO: change to iconsax — currently Material fallback
          icon: const Icon(Icons.arrow_back, color: AppTheme.grey900),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Terms & Conditions', style: AppTextTheme.titleLarge),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Header ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.grey200),
            ),
            child: Row(
              children: [
                // TODO: change to iconsax — currently Material fallback
                const Icon(Icons.description,
                    size: 32, color: AppTheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Syarat & Ketentuan', style: AppTextTheme.titleLarge),
                      const SizedBox(height: 2),
                      Text(
                        // TODO: sync with konten aktual — hardcoded sementara
                      'Terakhir diperbarui: Juni 2026',
                        style: AppTextTheme.labelSmall
                            .copyWith(color: AppTheme.grey500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Sections ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.grey200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < _sections.length; i++) ...[
                  _sectionBlock(_sections[i]),
                  if (i < _sections.length - 1) const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionBlock(_TncSection s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.title,
          style: AppTextTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Text(
          s.body,
          style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey700, height: 1.5),
        ),
      ],
    );
  }
}

class _TncSection {
  final String title;
  final String body;
  const _TncSection({required this.title, required this.body});
}
