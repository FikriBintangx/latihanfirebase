import 'package:flutter/material.dart';

/// Halaman yang dibuka ketika notifikasi FCM di-klik.
class NotificationDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const NotificationDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final extraData = Map<String, dynamic>.from(data)
      ..remove('title')
      ..remove('body');

    final kategori = data['kategori']?.toString().toLowerCase();
    final isPromo = kategori == 'promo';

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Detail Notifikasi'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE6EAF2)),
            ),
            child: Column(
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: isPromo
                        ? const Color(0xFFFFF3E0)
                        : const Color(0xFFE8F0FF),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Icon(
                    isPromo
                        ? Icons.shopping_cart_rounded
                        : Icons.notifications_active_rounded,
                    size: 40,
                    color: isPromo
                        ? const Color(0xFFEF6C00)
                        : const Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(height: 16),
                if (kategori != null && kategori.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isPromo
                          ? const Color(0xFFFFF3E0)
                          : const Color(0xFFEFF4FF),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      kategori.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        color: isPromo
                            ? const Color(0xFFE65100)
                            : const Color(0xFF1D4ED8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Text(
                  data['title']?.toString() ?? '-',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  data['body']?.toString() ?? '-',
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.45,
                    color: Color(0xFF475569),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'DATA TAMBAHAN (DATA PAYLOAD)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 10),
          if (extraData.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE6EAF2)),
              ),
              child: const Text(
                'Tidak ada data tambahan.',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            )
          else
            ...extraData.entries.map(
              (entry) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE6EAF2)),
                ),
                child: ListTile(
                  title: Text(
                    entry.key,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      entry.value.toString(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
