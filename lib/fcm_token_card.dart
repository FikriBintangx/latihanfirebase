import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_firebase/notification_service.dart';

/// Kartu untuk menampilkan FCM Token, tombol salin, dan toggle topic "kelas".
class FcmTokenCard extends StatefulWidget {
  const FcmTokenCard({super.key});

  @override
  State<FcmTokenCard> createState() => _FcmTokenCardState();
}

class _FcmTokenCardState extends State<FcmTokenCard> {
  // ignore: deprecated_member_use
  late Future<String?> _tokenFuture = FirebaseMessaging.instance.getToken();
  bool _isUpdatingTopic = false;

  void _refreshToken() {
    setState(() {
      // ignore: deprecated_member_use
      _tokenFuture = FirebaseMessaging.instance.getToken();
    });
  }

  Future<void> _handleToggleTopic() async {
    setState(() => _isUpdatingTopic = true);
    try {
      await NotificationService.toggleTopicSubscription();
      if (!mounted) return;
      final subscribed = NotificationService.isSubscribedKelas.value;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            subscribed
                ? 'Subscribed ke topic "${NotificationService.defaultTopic}"'
                : 'Unsubscribed dari topic "${NotificationService.defaultTopic}"',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengubah status topic: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isUpdatingTopic = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6EAF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.notifications_active_outlined,
                color: Color(0xFF2563EB),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Firebase Cloud Messaging',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              IconButton(
                onPressed: _refreshToken,
                tooltip: 'Muat ulang token',
                icon: const Icon(Icons.refresh_rounded, size: 20),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'FCM Token',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 6),
          FutureBuilder<String?>(
            future: _tokenFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              }

              final token = snapshot.data ?? 'Token tidak tersedia';
              final hasToken = snapshot.data != null && snapshot.data!.isNotEmpty;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: SelectableText(
                      token,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                        color: Color(0xFF334155),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: hasToken
                        ? () {
                            Clipboard.setData(ClipboardData(text: token));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('FCM Token berhasil disalin!'),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    label: const Text(
                      'Salin Token',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              );
            },
          ),
          const Divider(height: 28),
          ValueListenableBuilder<bool>(
            valueListenable: NotificationService.isSubscribedKelas,
            builder: (context, subscribed, _) {
              return Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Topic: kelas',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          kIsWeb
                              ? 'Topic hanya tersedia di Android/iOS'
                              : (subscribed
                                    ? 'Aktif menerima broadcast kelas'
                                    : 'Berhenti berlangganan topic kelas'),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: (kIsWeb || _isUpdatingTopic)
                        ? null
                        : _handleToggleTopic,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: subscribed
                          ? const Color(0xFFDC2626)
                          : const Color(0xFF16A34A),
                      side: BorderSide(
                        color: subscribed
                            ? const Color(0xFFFCA5A5)
                            : const Color(0xFF86EFAC),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isUpdatingTopic
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(subscribed ? 'Unsubscribe' : 'Subscribe'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
