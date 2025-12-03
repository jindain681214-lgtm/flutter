import 'package:flutter/material.dart';
import '../theme/constants.dart';
import '../models/device_model.dart';
import '../models/notification_model.dart';
import 'notification_screen.dart';

class DeviceScreen extends StatelessWidget {
  final List<Device> devices;
  final Function(int) onToggle;
  final List<NotificationItem> notifications;
  final Function(Device) onRemoveDevice;
  final VoidCallback onNavigateToAddDevice;

  const DeviceScreen({
    super.key,
    required this.devices,
    required this.onToggle,
    required this.notifications,
    required this.onRemoveDevice,
    required this.onNavigateToAddDevice,
  });

  void _showRemoveConfirmDialog(BuildContext context, Device device) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("기기 삭제"),
          content: Text("'${device.name}' 기기를 목록에서 삭제하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("취소"),
            ),
            TextButton(
              onPressed: () {
                onRemoveDevice(device);
                Navigator.of(context).pop();
              },
              child: const Text("삭제", style: TextStyle(color: kLgRed)),
            ),
          ],
        );
      },
    );
  }

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
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: kTextDark),
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
            GestureDetector(
              onTap: onNavigateToAddDevice,
              child: Container(
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
                return InkWell(
                  onTap: () => onToggle(index),
                  onLongPress: () => _showRemoveConfirmDialog(context, devices[index]),
                  borderRadius: BorderRadius.circular(25),
                  child: _buildDeviceCard(devices[index]), // index는 여기서 필요 없으므로 제거
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // 1. 여기에 실수로 지웠던 함수 내용을 복원합니다.
  Widget _buildDeviceCard(Device device) {
    return Container(
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
    );
  }
}
