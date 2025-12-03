import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  // 1. 초기화 (앱 시작 시 한 번 실행)
  static Future<void> init() async {
    // 안드로이드 설정 (앱 아이콘 사용)
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS 설정 (권한 요청 포함)
    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings =
    InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _notifications.initialize(settings);
  }

  // 2. 알림 띄우기 함수
  static Future<void> showNotification({
    required String title,
    required String body
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'lg_thinq_channel', // 채널 ID
      'LG ThinQ 알림',      // 채널 이름
      channelDescription: 'LG ThinQ의 중요 알림입니다.',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    // 0은 알림 ID (계속 쌓이게 하려면 숫자를 바꾸면 됨)
    await _notifications.show(0, title, body, details);
  }
}