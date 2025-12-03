import 'package:flutter/material.dart';
import '../theme/constants.dart';
import '../models/notification_model.dart'; // 모델 import

class NotificationScreen extends StatelessWidget {
  final List<NotificationItem> notifications; // 외부에서 받을 데이터 리스트

  const NotificationScreen({
    super.key,
    required this.notifications, // 생성자에서 필수 입력
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("알림", style: TextStyle(fontWeight: FontWeight.bold, color: kTextDark)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kTextDark),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
        ],
      ),
      // 데이터가 없을 때와 있을 때 구분
      body: notifications.isEmpty
          ? const Center(child: Text("새로운 알림이 없습니다.", style: TextStyle(color: Colors.grey)))
          : ListView.separated(
        itemCount: notifications.length,
        separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF0F0F0)),
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Container(
            color: item.isNew ? const Color(0xFFF8F9FA) : Colors.white,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
                child: Icon(item.icon, color: kAccentBlue, size: 24),
              ),
              title: Text(
                item.title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: item.isNew ? FontWeight.bold : FontWeight.normal,
                  color: kTextDark,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(item.time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ),
              trailing: item.isNew
                  ? Container(width: 6, height: 6, decoration: const BoxDecoration(color: kLgRed, shape: BoxShape.circle))
                  : null,
            ),
          );
        },
      ),
    );
  }
}