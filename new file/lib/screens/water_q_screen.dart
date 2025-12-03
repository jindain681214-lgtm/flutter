import 'package:flutter/material.dart';
import '../theme/constants.dart';
import '../models/device_model.dart';
import '../models/scenario_models.dart';
import 'ai_detail_screen.dart';

class WaterQScreen extends StatelessWidget {
  final List<Device> devices;
  final ScenarioData scenarioData;
  final Function(String, String) onApplyAi;
  final VoidCallback onNavigateToWeather; // 1. 날씨 화면 이동 콜백 추가

  const WaterQScreen({
    super.key,
    required this.devices,
    required this.scenarioData,
    required this.onApplyAi,
    required this.onNavigateToWeather, // 생성자에서 콜백 받기
  });

  @override
  Widget build(BuildContext context) {
    IconData weatherIcon;
    Color weatherColor;
    if (scenarioData.aiTheme == 'muddy') {
      weatherIcon = Icons.flash_on;
      weatherColor = Colors.grey;
    } else if (scenarioData.aiTheme == 'cloudy' || scenarioData.aiTheme == 'salty' || scenarioData.aiTheme == 'iron') {
        weatherIcon = Icons.cloudy_snowing; // 아이콘 변경
        weatherColor = Colors.grey;
    } else {
      weatherIcon = Icons.wb_sunny;
      weatherColor = Colors.orangeAccent;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text("LG WaterQ", style: TextStyle(fontWeight: FontWeight.bold, color: kTextDark)),
        backgroundColor: const Color(0xFFF6F7F9),
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          Builder(
            builder: (context) => GestureDetector(
              // 2. onTap에 전달받은 콜백 함수 연결
              onTap: onNavigateToWeather,
              onLongPress: () {
                Scaffold.of(context).openEndDrawer();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("개발자 모드: 시나리오 설정을 엽니다."), duration: Duration(seconds: 1)),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      scenarioData.location.split(' ').last,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kTextDark),
                    ),
                    const SizedBox(width: 8),
                    Icon(weatherIcon, size: 16, color: weatherColor),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
            ),
            child: Row(
              children: [
                _buildStatusItem("TDS (용존고형물)", scenarioData.tds),
                Container(width: 1, height: 100, color: Colors.grey[200]),
                _buildStatusItem("탁도 (NTU)", scenarioData.turbidity),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text("WaterQ AI 연동 기기", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
              if (scenarioData.solutions.containsKey(device.id)) {
                return _buildAiDeviceBtn(context, device.name, device.icon, device.id);
              }
              return const SizedBox.shrink();
            },
            separatorBuilder: (context, index) {
              final device = devices[index];
              if (scenarioData.solutions.containsKey(device.id)) {
                return const SizedBox(height: 10);
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String label, WaterStatus status) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 10),
          Text(status.val.toString(), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: status.bgColor, borderRadius: BorderRadius.circular(8)),
            child: Text(status.status, style: TextStyle(color: status.color, fontSize: 12, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildAiDeviceBtn(BuildContext context, String name, IconData icon, String deviceKey) {
    return InkWell(
      onTap: () {
        DeviceSolution? solution = scenarioData.solutions[deviceKey];
        if (solution != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AiDetailScreen(
            deviceName: name,
            deviceKey: deviceKey,
            deviceIcon: icon,
            solution: solution,
            theme: scenarioData.aiTheme,
            onApply: onApplyAi,
          )));
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
        ),
        child: Row(
          children: [
            Container(width: 45, height: 45, decoration: BoxDecoration(color: const Color(0xFFF0F4FF), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: kAccentBlue)),
            const SizedBox(width: 15),
            Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
