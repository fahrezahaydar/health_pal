// lib/features/settings/presentation/page/help_support_page.dart
//
// Halaman Help & Support. Per wireframe 19-help-support.md.
// - FAQ list (ExpansionTile) — 4 item placeholder
// - Contact Us section: email + telepon (url_launcher)

import 'package:flutter/material.dart';
import 'package:iconsax_latest/iconsax_latest.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  static const _faqs = <_FaqItem>[
    _FaqItem(
      question: 'Bagaimana cara booking dokter?',
      answer:
          'Buka tab Home, gunakan search bar untuk mencari dokter berdasarkan nama atau spesialisasi. Pilih dokter yang tersedia, lalu klik "Book Appointment" untuk memilih tanggal dan slot waktu.',
    ),
    _FaqItem(
      question: 'Bagaimana cara membatalkan appointment?',
      answer:
          'Buka tab Booking History, pilih appointment yang ingin dibatalkan (status Pending atau Upcoming), lalu klik tombol "Batalkan Appointment". Konfirmasi pembatalan dan appointment akan otomatis di-cancel.',
    ),
    _FaqItem(
      question: 'Apakah data saya aman?',
      answer:
          'Ya. Kami menggunakan Supabase dengan Row-Level Security (RLS) yang memastikan data Anda hanya dapat diakses oleh Anda sendiri. Semua komunikasi dienkripsi via HTTPS.',
    ),
    _FaqItem(
      question: 'Bagaimana cara ganti password?',
      answer:
          'Buka tab Profile, pilih Settings, lalu klik "Ubah Password". Kami akan mengirim link reset ke email terdaftar Anda.',
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
          icon: const Icon(Iconsax.arrowLeft01, color: AppTheme.grey900),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Help & Support', style: AppTextTheme.titleLarge),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── FAQ Section ──
          Container(
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.grey200),
            ),
            child: Column(
              children: [
                for (int i = 0; i < _faqs.length; i++) ...[
                  _faqTile(_faqs[i]),
                  if (i < _faqs.length - 1)
                    const Divider(height: 1, color: AppTheme.grey200),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Contact Us Section ──
          _sectionLabel('Hubungi Kami'),
          _contactCard(
            icon: Iconsax.sms,
            label: 'Email',
            value: 'support@healthpal.app',
            onTap: () => _launchUrl('mailto:support@healthpal.app'),
          ),
          const SizedBox(height: 8),
          _contactCard(
            icon: Iconsax.call,
            label: 'Telepon',
            value: '021-12345678',
            onTap: () => _launchUrl('tel:+622112345678'),
          ),
        ],
      ),
    );
  }

  Widget _faqTile(_FaqItem faq) {
    return Theme(
      // Hilangkan default ExpansionTile divider lines.
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding:
            const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: const Icon(Iconsax.messageQuestion, color: AppTheme.primary),
        title: Text(
          faq.question,
          style: AppTextTheme.bodyLarge,
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              faq.answer,
              style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 4),
        child: Text(
          text,
          style: AppTextTheme.bodySmall.copyWith(
            color: AppTheme.grey600,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      );

  Widget _contactCard({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.grey200),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppTheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextTheme.labelSmall
                        .copyWith(color: AppTheme.grey500),
                  ),
                  const SizedBox(height: 2),
                  Text(value, style: AppTextTheme.bodyMedium),
                ],
              ),
            ),
            const Icon(Iconsax.arrowRight03, color: AppTheme.grey400, size: 18),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _FaqItem {
  final String question;
  final String answer;
  const _FaqItem({required this.question, required this.answer});
}
