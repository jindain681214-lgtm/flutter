import 'package:flutter/material.dart';
import '../theme/constants.dart';
import '../data/scenario_data.dart';
import '../models/scenario_models.dart';
import '../models/device_model.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';
import 'home_screen.dart';
import 'device_screen.dart';
import 'water_q_screen.dart';
import 'menu_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _selectedIndex = 0;
  String _currentScenarioKey = 'h_soft';

  List<NotificationItem> myNotifications = [
    NotificationItem(title: "새로운 기능이 추가되었습니다!", time: "어제", icon: Icons.new_releases, isNew: false),
  ];

  void _addNotificationLog(String title, IconData icon) {
    setState(() {
      myNotifications.insert(0, NotificationItem(title: title, time: "방금 전", icon: icon, isNew: true));
    });
  }

  List<Device> myDevices = [
    Device(id: 'washer', name: "세탁기", icon: Icons.local_laundry_service, isOn: true, statusOn: "세탁 중 • 34분", statusOff: "전원 꺼짐"),
    Device(id: 'dishwasher', name: "식기세척기", icon: Icons.restaurant, isOn: false, statusOn: "작동 준비", statusOff: "대기 중"),
    Device(id: 'purifier', name: "정수기", icon: Icons.water_drop, isOn: true, statusOn: "냉수 켜짐", statusOff: "전원 꺼짐"),
    Device(id: 'dryer', name: "건조기", icon: Icons.air, isOn: false, statusOn: "건조 준비", statusOff: "전원 꺼짐"),
    Device(id: 'styler', name: "스타일러", icon: Icons.checkroom, isOn: false, statusOn: "스타일링 중", statusOff: "전원 꺼짐"),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLocationPermissionDialog();
    });
  }

  void _showLocationPermissionDialog() {
    // ... (기존 팝업 코드 유지) ...
  }

  void _toggleDevice(int index) {
    setState(() {
      myDevices[index].isOn = !myDevices[index].isOn;
    });
  }

  void _changeScenario(String key) {
    if (!scenarioData.containsKey(key)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("해당 시나리오는 준비 중입니다.")));
      return;
    }

    setState(() {
      _currentScenarioKey = key;
    });

    String statusMsg = "";
    if (key.contains('muddy') || key.contains('hard') || key.contains('salty')) {
      statusMsg = "주의/위험 수질 단계가 발령되었습니다.";
      _addNotificationLog(statusMsg, Icons.warning_amber_rounded);
      NotificationService.showNotification(title: '⚠️ 수질 경고', body: statusMsg);
    } else {
      statusMsg = "수질 상태가 안정적입니다.";
      _addNotificationLog(statusMsg, Icons.check_circle_outline);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    ScenarioData currentData = scenarioData[_currentScenarioKey] ?? scenarioData['h_soft']!;

    final List<Widget> pages = [
      HomeScreen(devices: myDevices, onToggle: _toggleDevice, notifications: myNotifications),
      DeviceScreen(devices: myDevices, onToggle: _toggleDevice, notifications: myNotifications),
      WaterQScreen(
          scenarioData: currentData,
          onApplyAi: (deviceId, modeName) {
            setState(() {
              final index = myDevices.indexWhere((d) => d.id == deviceId);
              if(index != -1) {
                myDevices[index].isOn = true;
                myDevices[index].statusOn = "AI 코스: $modeName";
                String logMsg = "${myDevices[index].name}에 [$modeName]이(가) 적용되었습니다.";
                _addNotificationLog(logMsg, Icons.auto_awesome);
                Future.delayed(const Duration(seconds: 2), () {
                  NotificationService.showNotification(title: '✨ AI 설정 완료', body: logMsg);
                });
              }
            });
          }
      ),
      const MenuScreen(),
    ];

    return Scaffold(
      // [수정] Drawer 배경색 제거 (기본 흰색 사용)
      endDrawer: Drawer(
        child: Column(
          children: [
            // Drawer 헤더 (밝은 디자인)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Scenario Controller', style: TextStyle(color: kTextDark, fontSize: 20, fontWeight: FontWeight.bold)),
                  Icon(Icons.tune, color: kTextDark),
                ],
              ),
            ),

            // 리스트
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildGroupTitle("🇻🇳 하노이 (TDS 기준)"),
                  _buildScenarioBtn("1. 좋음 (Soft)", 'h_soft', Colors.blue),
                  _buildScenarioBtn("2. 보통 (Normal)", 'h_normal', Colors.green),
                  _buildScenarioBtn("3. 주의 (Hard)", 'h_hard', Colors.amber),
                  _buildScenarioBtn("4. 위험 (Very Hard)", 'h_veryhard', Colors.red),

                  const SizedBox(height: 30),

                  _buildGroupTitle("🇻🇳 호찌민 (탁도/염분 기준)"),
                  _buildScenarioBtn("1. 청정 (Clean)", 'hc_clean', Colors.blue),
                  _buildScenarioBtn("2. 흐림 (Cloudy)", 'hc_cloudy', Colors.amber),
                  _buildScenarioBtn("3. 염분 (Salty)", 'hc_salty', Colors.orange),
                  _buildScenarioBtn("4. 오염 (Muddy)", 'hc_muddy', Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),

      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))]),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey[400],
          showUnselectedLabels: true,
          backgroundColor: Colors.white,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
            BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "디바이스"),
            BottomNavigationBarItem(icon: Icon(Icons.water_drop), label: "수질"),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: "메뉴"),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 5),
      child: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
    );
  }

  // [수정] 밝은 테마용 버튼 디자인
  Widget _buildScenarioBtn(String title, String key, Color dotColor) {
    bool isActive = _currentScenarioKey == key;
    bool isAvailable = scenarioData.containsKey(key);

    return GestureDetector(
      onTap: isAvailable ? () => _changeScenario(key) : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          // 활성화: 연한 색상 / 비활성화: 흰색 or 회색
          color: isAvailable
              ? (isActive ? dotColor.withOpacity(0.1) : Colors.white)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          // 선택된 항목은 진한 테두리
          border: isActive ? Border.all(color: dotColor, width: 2) : Border.all(color: Colors.grey[300]!),
          boxShadow: isActive ? [BoxShadow(color: dotColor.withOpacity(0.2), blurRadius: 8)] : [],
        ),
        child: Row(
          children: [
            Container(
              width: 10, height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isAvailable ? dotColor : Colors.grey,
              ),
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                color: isAvailable ? (isActive ? dotColor : kTextDark) : Colors.grey,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}