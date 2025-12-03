import 'package:flutter/material.dart';

class NotificationItem {
  final String title;   // 알림 내용
  final String time;    // 시간 (예: 방금 전)
  final IconData icon;  // 아이콘
  final bool isNew;     // 읽지 않음 표시 (빨간 점)

  NotificationItem({
    required this.title,
    required this.time,
    required this.icon,
    this.isNew = true,
  });
}