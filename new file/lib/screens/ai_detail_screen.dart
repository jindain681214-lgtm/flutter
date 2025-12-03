import 'package:flutter/material.dart';
import '../theme/constants.dart';
import '../models/scenario_models.dart';

class AiDetailScreen extends StatelessWidget {
  final String deviceName;
  final String deviceKey;
  final IconData deviceIcon;
  final DeviceSolution solution;
  final String theme;
  final Function(String, String) onApply;

  const AiDetailScreen({
    super.key,
    required this.deviceName,
    required this.deviceKey,
    required this.deviceIcon,
    required this.solution,
    required this.theme,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    // 1. 시나리오 테마(aiTheme)에 따라 색상을 동적으로 결정
    List<Color> heroColors;
    Color applyButtonColor;
    Color checkIconColor;

    if (theme.contains('danger')) {
      heroColors = [Colors.red, Colors.red[200]!];
      applyButtonColor = Colors.red;
      checkIconColor = Colors.red;
    } else if (theme.contains('caution')) {
      heroColors = [Colors.orange, Colors.orange[200]!];
      applyButtonColor = Colors.orange;
      checkIconColor = Colors.orange;
    } else {
      heroColors = [kAccentBlue, Colors.blue[200]!];
      applyButtonColor = kAccentBlue;
      checkIconColor = kAccentBlue;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text("AI 스마트 설정"),
        backgroundColor: const Color(0xFFF6F7F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kTextDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                      // 2. 동적으로 결정된 색상(heroColors)을 그라데이션에 적용
                      Container(
                        width: 100, height: 100,
                        decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: heroColors)),
                        child: Icon(deviceIcon, size: 40, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      Text(solution.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(solution.summary, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Text("AI 추천 설정", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    // 3. 체크 아이콘 색상(checkIconColor) 적용
                    children: solution.recommendations.map((item) => ListTile(
                      leading: Icon(Icons.check_circle_outline, color: checkIconColor, size: 22),
                      title: Text(item, style: const TextStyle(fontSize: 15, height: 1.4)),
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
              // 4. 적용 버튼 색상(applyButtonColor) 적용
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: applyButtonColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                onPressed: () {
                  onApply(deviceKey, solution.title);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("[$deviceName] ${solution.title} 적용 완료!")));
                  Navigator.pop(context);
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
