import 'package:flutter/material.dart';
import '../models/device_model.dart';
import '../theme/constants.dart';

class AddDeviceScreen extends StatelessWidget {
  final List<Device> removedDevices;
  final Function(Device) onAddDevice;

  const AddDeviceScreen({
    super.key,
    required this.removedDevices,
    required this.onAddDevice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text("디바이스 추가", style: TextStyle(fontWeight: FontWeight.bold, color: kTextDark)),
        backgroundColor: const Color(0xFFF6F7F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kTextDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: removedDevices.isEmpty
          ? const Center(
              child: Text(
                "추가할 수 있는 기기가 없습니다.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: removedDevices.length,
              itemBuilder: (context, index) {
                final device = removedDevices[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  shadowColor: Colors.black.withOpacity(0.05),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    leading: Icon(device.icon, size: 32, color: kTextDark),
                    title: Text(device.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: ElevatedButton(
                      onPressed: () {
                        onAddDevice(device);
                        // 추가 후 화면을 빠져나감
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kLgRed,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("추가"),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
