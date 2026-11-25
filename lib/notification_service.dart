import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:login_firebase/firebase_options.dart';
import 'package:login_firebase/notification_detail_screen.dart';

/// Kunci global Navigator untuk navigasi dari callback notifikasi.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Handler pesan saat aplikasi di background atau terminated.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('[FCM] Pesan BACKGROUND: ${message.messageId}');
  debugPrint('[FCM] Data: ${message.data}');
}

class NotificationService {
  NotificationService._();

  static const String defaultTopic = 'kelas';

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotif =
      FlutterLocalNotificationsPlugin();

  static final ValueNotifier<bool> isSubscribedKelas = ValueNotifier<bool>(
    true,
  );

  /// Channel Android 8+ yang selaras dengan AndroidManifest.xml & payload Postman.
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'Notifikasi Penting',
    description: 'Channel untuk notifikasi dari Firebase Cloud Messaging',
    importance: Importance.max,
  );

  static Future<void> init() async {
    // 1. Minta izin notifikasi (Android 13+ & iOS)
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('[FCM] Status izin: ${settings.authorizationStatus}');

    // 2. Inisialisasi flutter_local_notifications + buat channel Android
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await _localNotif.initialize(
      settings: const InitializationSettings(
        android: androidInit,
        iOS: darwinInit,
        macOS: darwinInit,
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          _openDetail(jsonDecode(response.payload!) as Map<String, dynamic>);
        }
      },
    );
    await _localNotif
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    // 3. Ambil FCM Token
    try {
      // ignore: deprecated_member_use
      final token = await _messaging.getToken();
      debugPrint('[FCM] TOKEN: $token');
    } catch (e) {
      debugPrint('[FCM] Gagal mengambil token: $e');
    }
    // ignore: deprecated_member_use
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('[FCM] TOKEN BARU: $newToken');
    });

    // 4. Subscribe ke topic default "kelas" (khusus mobile non-web)
    if (!kIsWeb) {
      try {
        await _messaging.subscribeToTopic(defaultTopic);
        isSubscribedKelas.value = true;
      } catch (e) {
        debugPrint('[FCM] Gagal subscribe topic $defaultTopic: $e');
      }
    }

    // 5. FOREGROUND: pesan masuk saat aplikasi sedang dibuka
    FirebaseMessaging.onMessage.listen(_showForegroundNotification);

    // 6. BACKGROUND -> klik notifikasi -> aplikasi kembali terbuka
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('[FCM] Dibuka dari BACKGROUND');
      _openDetail(_messageToMap(message));
    });

    // 7. TERMINATED -> klik notifikasi -> aplikasi dijalankan dari awal
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('[FCM] Dibuka dari kondisi MATI (terminated)');
      _openDetail(_messageToMap(initialMessage));
    }

    // 8. Aplikasi dibuka dari notifikasi lokal saat app sudah mati
    final launchDetails = await _localNotif.getNotificationAppLaunchDetails();
    final payload = launchDetails?.notificationResponse?.payload;
    if ((launchDetails?.didNotificationLaunchApp ?? false) && payload != null) {
      _openDetail(jsonDecode(payload) as Map<String, dynamic>);
    }
  }

  static Future<void> toggleTopicSubscription() async {
    if (kIsWeb) return;
    final currentlySubscribed = isSubscribedKelas.value;
    if (currentlySubscribed) {
      await _messaging.unsubscribeFromTopic(defaultTopic);
      isSubscribedKelas.value = false;
      debugPrint('[FCM] Unsubscribed dari topic "$defaultTopic"');
    } else {
      await _messaging.subscribeToTopic(defaultTopic);
      isSubscribedKelas.value = true;
      debugPrint('[FCM] Subscribed ke topic "$defaultTopic"');
    }
  }

  static Future<void> _showForegroundNotification(RemoteMessage message) async {
    debugPrint('[FCM] Pesan FOREGROUND: ${message.notification?.title}');
    final notification = message.notification;
    if (notification == null) return;

    await _localNotif.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(_messageToMap(message)),
    );
  }

  static Map<String, dynamic> _messageToMap(RemoteMessage message) {
    return {
      'title': message.notification?.title ?? '-',
      'body': message.notification?.body ?? '-',
      ...message.data,
    };
  }

  static void _openDetail(Map<String, dynamic> data) {
    void push() {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => NotificationDetailScreen(data: data),
        ),
      );
    }

    if (navigatorKey.currentState != null) {
      push();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => push());
    }
  }
}
