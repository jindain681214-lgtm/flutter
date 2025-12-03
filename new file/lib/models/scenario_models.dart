import 'package:flutter/material.dart';

// 1. DeviceSolution 클래스 수정
class DeviceSolution {
  final String title;
  final String summary; // 'desc' -> 'summary'로 변경 및 필드 추가
  final List<String> recommendations; // 'items' -> 'recommendations'로 변경 및 필드 추가

  // 2. 생성자를 이름 기반의 선택적 파라미터로 변경
  DeviceSolution({
    required this.title,
    required this.summary,
    required this.recommendations,
  });
}

// 3. ScenarioData 클래스는 변경 없음 (이미 올바르게 되어 있음)
class ScenarioData {
  final String location;
  final String aiTheme;
  final WaterStatus tds;
  final WaterStatus turbidity;
  final Map<String, DeviceSolution> solutions;

  ScenarioData({
    required this.location,
    required this.aiTheme,
    required this.tds,
    required this.turbidity,
    required this.solutions,
  });
}

// 4. WaterStatus 클래스 수정
class WaterStatus {
  final double val;
  final String status;
  final Color color;
  final Color bgColor;

  // 5. 생성자를 이름 기반의 선택적 파라미터로 변경
  WaterStatus({
    required this.val,
    required this.status,
    required this.color,
    required this.bgColor,
  });
}
