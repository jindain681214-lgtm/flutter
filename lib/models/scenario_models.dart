import 'package:flutter/material.dart';

class SolutionItem {
  final String label;
  final String val;
  final IconData icon;
  final Color color;

  SolutionItem(this.label, this.val, this.icon, this.color);
}

class DeviceSolution {
  final String title;
  final String desc;
  final List<SolutionItem> items;

  DeviceSolution(this.title, this.desc, this.items);
}

class WaterStatus {
  final double val;
  final String status;
  final Color color;
  final Color bgColor;

  WaterStatus(this.val, this.status, this.color, this.bgColor);
}

class ScenarioData {
  final String location;
  final WaterStatus tds;
  final WaterStatus turbidity;
  final String aiTheme;
  final Map<String, DeviceSolution> solutions;

  ScenarioData({
    required this.location,
    required this.tds,
    required this.turbidity,
    required this.aiTheme,
    required this.solutions,
  });
}