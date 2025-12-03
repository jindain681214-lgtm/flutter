import 'package:flutter/material.dart';
import '../theme/constants.dart';
import '../models/device_model.dart';
import '../models/notification_model.dart'; // [중요]
import 'notification_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Device> devices;
  final Function(int) onToggle;
  final List<NotificationItem> notifications; // [중요] 알림 리스트 받기

  const HomeScreen({
    super.key,
    required this.devices,
    required this.onToggle,
    required this.notifications, // [중요]
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [kBgTop, Colors.white],
          stops: [0.0, 0.4],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text("LG DX 홈", style: TextStyle(fontWeight: FontWeight.bold, color: kTextDark)),
          actions: [
            // [알림 버튼 연결]
            IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationScreen(notifications: notifications),
                    ),
                  );
                }
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.access_time, color: Colors.amber), SizedBox(width: 8), Text("루틴 알아보기", style: TextStyle(fontWeight: FontWeight.bold))]),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)]),
              child: const Row(
                children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("제품에 이상 징후가 발견되면\n전문 상담사가 알려드려요.", style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(height: 10), ])),
                  Icon(Icons.assignment_turned_in, size: 40, color: Colors.greenAccent),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text("즐겨 찾는 제품", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.4,
              ),
              itemCount: devices.length,
              itemBuilder: (context, index) {
                return _buildDeviceCard(devices[index], index);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceCard(Device device, int index) {
    return InkWell(
      onTap: () => onToggle(index),
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
          border: device.isOn ? Border.all(color: kAccentBlue.withOpacity(0.3), width: 2) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(device.icon, size: 28, color: device.isOn ? kTextDark : Colors.grey[300]),
                  Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: device.isOn ? Colors.green : Colors.grey[300]))
                ]
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(device.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(device.isOn ? device.statusOn : device.statusOff, style: TextStyle(fontSize: 12, color: device.isOn ? kAccentBlue : Colors.grey))
                ]
            )
          ],
        ),
      ),
    );
  }
}