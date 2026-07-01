// lib/features/settings/presentation/page/terms_and_conditions_page.dart
//
// Halaman Terms & Conditions. Per wireframe 20-tnc.md.
// Halaman statis, scroll-only. Konten placeholder — akan disiapkan tim legal.

import 'package:flutter/material.dart';

import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  static const _sections = [
    {
      'title': '1. Ketentuan Umum',
      'body':
          'Dengan mengunduh, menginstal, atau menggunakan aplikasi Health Pal, Anda setuju untuk terikat dengan Syarat dan Ketentuan ini. Aplikasi ini disediakan oleh PT Health Pal Indonesia untuk membantu pengguna menemukan dan membuat janji dengan dokter.',
    },
    {
      'title': '2. Privasi & Data',
      'body':
          'Kami berkomitmen melindungi privasi Anda. Data pribadi yang dikumpulkan (nama, email, tanggal lahir, riwayat appointment) akan digunakan hanya untuk keperluan layanan dan tidak akan dibagikan ke pihak ketiga tanpa persetujuan Anda, kecuali diwajibkan oleh hukum.',
    },
    {
      'title': '3. Penggunaan Layanan',
      'body':
          'Layanan Health Pal hanya untuk keperluan informasi dan pembuatan janji medis. Aplikasi ini TIDAK menggantikan konsultasi medis langsung. Dalam keadaan darurat, segera hubungi rumah sakit atau call center 119.',
    },

    {
      'title': '4. Batasan Tanggung Jawab',
      'body':
          'Health Pal tidak bertanggung jawab atas kerugian yang timbul dari penggunaan informasi di aplikasi ini, termasuk namun tidak terbatas pada keputusan medis yang diambil berdasarkan konten dalam aplikasi. Selalu konsultasikan dengan dokter profesional.',
    },
    {
      'title': '5. Perubahan Ketentuan',
      'body':
          'Kami berhak mengubah Syarat dan Ketentuan ini sewaktu-waktu. Perubahan akan diinformasikan melalui notifikasi dalam aplikasi. Dengan tetap menggunakan aplikasi setelah perubahan, Anda dianggap menyetujui ketentuan yang baru.',
    },
    {
      'title': '6. Pembatalan & Refund',
      'body':
          'Appointment yang sudah dibooking dapat dibatalkan maksimal 1 (satu) jam sebelum jadwal konsultasi. Pembayaran (jika berlaku) akan dikembalikan sesuai kebijakan klinik terkait.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextTheme.headlineLarge,
        leading: IconButton(
          icon: const Icon(AppIcons.arrowBack, color: AppTheme.grey900),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Terms & Conditions'),
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
                const Icon(
                  AppIcons.description,
                  size: 32,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Syarat & Ketentuan',
                        style: AppTextTheme.titleLarge,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Terakhir diperbarui: Juni 2026',
                        style: AppTextTheme.labelSmall.copyWith(
                          color: AppTheme.grey500,
                        ),
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
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.grey200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: _sections.map((e) {
                return SectionBlock(
                  title: e['title'] ?? '',
                  body: e['body'] ?? '',
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionBlock extends StatelessWidget {
  const SectionBlock({super.key, this.title = '', this.body = ''});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextTheme.titleLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Text(
          body,
          textAlign: .justify,
          style: AppTextTheme.bodySmall.copyWith(
            fontSize: 11,
            color: AppTheme.grey500,
          ),
        ),
      ],
    );
  }
}
