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
import '../../../../widgets/layouts/card_container.dart';
import '../../../../widgets/shared/app_divider.dart';
import '../../../../widgets/shared/contact_card.dart';
import '../../../../widgets/shared/faq_tile.dart';
import '../../../../widgets/shared/section_label.dart';

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
          CardContainer(
            children: [
              for (int i = 0; i < _faqs.length; i++) ...[
                FaqTile(question: _faqs[i].question, answer: _faqs[i].answer),
                if (i < _faqs.length - 1) const AppDivider(),
              ],
            ],
          ),
          const SizedBox(height: 24),

          // ── Contact Us Section ──
          const SectionLabel(text: 'Hubungi Kami'),
          ContactCard(
            icon: Iconsax.sms,
            label: 'Email',
            value: 'support@healthpal.app',
            onTap: () => _launchUrl('mailto:support@healthpal.app'),
          ),
          const SizedBox(height: 8),
          ContactCard(
            icon: Iconsax.call,
            label: 'Telepon',
            value: '021-12345678',
            onTap: () => _launchUrl('tel:+622112345678'),
          ),
        ],
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
