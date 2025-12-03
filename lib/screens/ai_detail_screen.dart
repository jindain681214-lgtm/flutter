import 'package:flutter/material.dart';
import '../theme/constants.dart';
import '../models/scenario_models.dart';

class AiDetailScreen extends StatelessWidget {
  final String deviceName;
  final String deviceKey; // [추가] 어떤 기기인지 식별하기 위한 ID (예: 'washer')
  final IconData deviceIcon;
  final DeviceSolution solution;
  final String theme;
  final Function(String, String) onApply; // [추가] 본부에 요청할 함수 (ID, 모드이름)

  const AiDetailScreen({
    super.key,
    required this.deviceName,
    required this.deviceKey, // [추가]
    required this.deviceIcon,
    required this.solution,
    required this.theme,
    required this.onApply, // [추가]
  });

  @override
  Widget build(BuildContext context) {
    List<Color> heroColors = [kAccentBlue, Colors.blue[200]!];
    if(theme == "muddy") heroColors = [Colors.red, Colors.red[200]!];
    if(theme == "cloudy") heroColors = [Colors.orange, Colors.orange[200]!];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text("AI 스마트 설정"),
        backgroundColor: const Color(0xFFF6F7F9),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)]),
                  child: Column(
                    children: [
                      Container(
                        width: 100, height: 100,
                        decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: heroColors)),
                        child: Icon(deviceIcon, size: 40, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      Text(solution.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(solution.desc, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Text("AI 추천 설정", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: solution.items.map((item) => ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: item.color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                        child: Icon(item.icon, color: item.color),
                      ),
                      title: Text(item.label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                      trailing: Text(item.val, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    )).toList(),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: kAccentBlue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                onPressed: () {
                  // [여기!] 버튼 누르면 본부 함수 실행
                  onApply(deviceKey, solution.title);

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("[${deviceName}] ${solution.title} 적용 완료!")));
                  Navigator.pop(context); // 화면 닫기
                },
                child: const Text("설정 적용하여 시작", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
      ),
    );
  }
}