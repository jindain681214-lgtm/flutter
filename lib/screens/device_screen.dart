import 'package:flutter/material.dart';
import '../theme/constants.dart';
import '../models/device_model.dart';
import '../models/notification_model.dart'; // [중요]
import 'notification_screen.dart';

class DeviceScreen extends StatelessWidget {
  final List<Device> devices;
  final Function(int) onToggle;
  final List<NotificationItem> notifications; // [중요]

  const DeviceScreen({
    super.key,
    required this.devices,
    required this.onToggle,
    required this.notifications, // [중요]
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text("기기 목록", style: TextStyle(fontWeight: FontWeight.bold, color: kTextDark)),
        backgroundColor: const Color(0xFFF6F7F9),
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          // [알림 버튼 연결]
          IconButton(
            icon: const Icon(Icons.notifications, color: kTextDark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(notifications: notifications),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFF6F7F9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[300]!, width: 2),
              ),
              child: const Center(
                child: Text(
                  "디바이스 추가 +",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 30),

            const Text("내 기기", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kTextDark)),
            const SizedBox(height: 15),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 1.0,
              ),
              itemCount: devices.length,
              itemBuilder: (context, index) {
                return _buildDeviceCard(devices[index], index);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceCard(Device device, int index) {
    return InkWell(
      onTap: () => onToggle(index),
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
          border: device.isOn ? Border.all(color: kAccentBlue.withOpacity(0.3), width: 2) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(device.icon, size: 32, color: device.isOn ? kTextDark : Colors.grey[300]),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: device.isOn ? Colors.green : Colors.grey[300],
                    boxShadow: device.isOn ? [BoxShadow(color: Colors.green.withOpacity(0.4), blurRadius: 4)] : [],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(device.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextDark)),
            const SizedBox(height: 5),
            Text(
              device.isOn ? device.statusOn : device.statusOff,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: device.isOn ? kAccentBlue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}