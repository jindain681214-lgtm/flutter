import 'package:flutter/material.dart';
import '../models/scenario_models.dart';

final Map<String, ScenarioData> scenarioData = {
  // ================= [하노이 그룹: TDS 기준] =================

  // 1. 좋음 (Soft) - 0~100 ppm
  'h_soft': ScenarioData(
    location: "베트남 하노이 (Soft)",
    tds: WaterStatus(80, "좋음 (연수)", Colors.blue[800]!, Colors.blue[50]!),
    turbidity: WaterStatus(0.1, "맑음", Colors.blue[800]!, Colors.blue[50]!),
    aiTheme: "clean",
    solutions: {
      'washer': DeviceSolution("세제 절약 모드", "연수에서는 거품이 과하게 발생할 수 있습니다.", [
        SolutionItem("세제", "-30% 감소", Icons.local_drink, Colors.blue),
        SolutionItem("헹굼", "표준 유지", Icons.refresh, Colors.green),
      ]),
      'dishwasher': DeviceSolution("연수 최적화", "연수 장치 작동을 최소화합니다.", [
        SolutionItem("연수장치", "OFF (H0)", Icons.tune, Colors.grey),
        SolutionItem("린스", "최소 (L1)", Icons.opacity, Colors.blue),
      ]),
      'purifier': DeviceSolution("청정 모드", "최적의 수질 상태입니다.", [
        SolutionItem("필터", "정상", Icons.check_circle, Colors.green),
      ]),
      'dryer': DeviceSolution("표준 건조", "특이 사항 없습니다.", [
        SolutionItem("모드", "표준", Icons.wb_sunny, Colors.blue),
      ]),
      'styler': DeviceSolution("표준 스타일링", "스팀 분사가 원활합니다.", [
        SolutionItem("코스", "표준", Icons.checkroom, Colors.blue),
      ]),
    },
  ),

  // 2. 보통 (Normal) - 101~200 ppm
  'h_normal': ScenarioData(
    location: "베트남 하노이 (Normal)",
    tds: WaterStatus(150, "보통", Colors.green[800]!, Colors.green[50]!),
    turbidity: WaterStatus(0.5, "맑음", Colors.blue[800]!, Colors.blue[50]!),
    aiTheme: "clean",
    solutions: {
      'washer': DeviceSolution("표준 운전 모드", "하노이 평균 수돗물 수질입니다.", [
        SolutionItem("알고리즘", "표준", Icons.settings, Colors.green),
        SolutionItem("세제", "권장량", Icons.local_drink, Colors.green),
      ]),
      'dishwasher': DeviceSolution("표준 운전", "제조사 권장 표준 알고리즘을 수행합니다.", [
        SolutionItem("모드", "표준", Icons.restaurant, Colors.green),
      ]),
      'purifier': DeviceSolution("정수 모드", "깨끗한 물을 공급합니다.", [
        SolutionItem("출수", "정상", Icons.water_drop, Colors.blue),
      ]),
      'styler': DeviceSolution("표준 스타일링", "정상 작동 중입니다.", [
        SolutionItem("스팀", "정상", Icons.cloud_upload, Colors.green),
      ]),
      'dryer': DeviceSolution("표준 건조", "에너지 최적화 모드", [
        SolutionItem("모드", "절전", Icons.eco, Colors.green),
      ]),
    },
  ),

  // 3. 주의 (Hard) - TDS 201~400 ppm (User Scenario C)
  'h_hard': ScenarioData(
    location: "베트남 하노이 (Hard)",
    tds: WaterStatus(320, "주의 (경수)", Colors.amber[800]!, Colors.amber[50]!),
    turbidity: WaterStatus(0.5, "보통", Colors.blue[800]!, Colors.blue[50]!),
    aiTheme: "cloudy",
    solutions: {
      'washer': DeviceSolution("세제 용해력 보완", "경수 구간입니다. 세탁 품질을 유지합니다.", [
        SolutionItem("세제", "자동 증량", Icons.add_circle, Colors.orange),
        SolutionItem("불림", "동적 확장", Icons.timer, Colors.orange),
        SolutionItem("패턴", "텀블링 위주", Icons.rotate_right, Colors.blue),
      ]),
      'dishwasher': DeviceSolution("물 얼룩 위험 방지", "경수로 인한 얼룩을 최소화합니다.", [
        SolutionItem("린스", "투입 증가", Icons.opacity, Colors.orange),
        SolutionItem("건조", "알고리즘 조정", Icons.air, Colors.blue),
      ]),
      'purifier': DeviceSolution("필터 부하 관리", "미네랄로 인한 필터 부하를 줄입니다.", [
        SolutionItem("세척", "RO 주기 증가", Icons.cleaning_services, Colors.orange),
        SolutionItem("유속", "자동 조절", Icons.speed, Colors.blue),
      ]),
      'styler': DeviceSolution("스케일 위험 방지", "내부 스케일 생성을 억제합니다.", [
        SolutionItem("코스", "먼지 제거", Icons.checkroom, Colors.blue),
        SolutionItem("배수", "주기 증가", Icons.water_damage, Colors.orange),
      ]),
      'dryer': DeviceSolution("스팀 제한", "노즐 막힘 방지를 위해 직수를 차단합니다.", [
        SolutionItem("급수", "물통 권장", Icons.invert_colors_off, Colors.orange),
      ]),
    },
  ),

  // 4. 위험 (Very Hard) - TDS > 400 ppm (User Scenario D)
  'h_veryhard': ScenarioData(
    location: "베트남 하노이 (Very Hard)",
    tds: WaterStatus(450, "위험 (고경도)", Colors.red[800]!, Colors.red[50]!),
    turbidity: WaterStatus(1.0, "보통", Colors.blue[800]!, Colors.blue[50]!),
    aiTheme: "muddy",
    solutions: {
      'washer': DeviceSolution("섬유 보호 & 스케일 방지", "고경도로부터 세탁조와 섬유를 보호합니다.", [
        SolutionItem("헹굼", "2회 이상", Icons.autorenew, Colors.blue),
        SolutionItem("물살", "강화", Icons.waves, Colors.red),
        SolutionItem("코스", "삶음 제한", Icons.block, Colors.red),
      ]),
      'dishwasher': DeviceSolution("고경수 대응", "강력한 세척으로 스케일을 예방합니다.", [
        SolutionItem("세제", "1.5배 증량", Icons.add_circle, Colors.red),
        SolutionItem("온도", "일정 유지", Icons.thermostat, Colors.orange),
      ]),
      'purifier': DeviceSolution("정수 불가 위험", "정수기 보호를 위해 기능을 제한합니다.", [
        SolutionItem("정수", "일시 중단", Icons.block, Colors.red),
        SolutionItem("온수", "가열 제한", Icons.no_drinks, Colors.orange),
        SolutionItem("세척", "주기 확장", Icons.cleaning_services, Colors.blue),
      ]),
      'styler': DeviceSolution("스팀 사용 불가", "스팀을 차단하고 건조 모드로 전환합니다.", [
        SolutionItem("물", "정수 요청", Icons.water_drop, Colors.red),
        SolutionItem("모드", "건조/제습", Icons.air, Colors.orange),
      ]),
      'dryer': DeviceSolution("세척 강화", "콘덴서 세척 주기를 단축합니다.", [
        SolutionItem("세척", "빈도 2배", Icons.cleaning_services, Colors.orange),
      ]),
    },
  ),

  // ================= [호찌민 그룹: 탁도/염분 기준] =================

  // 1. 청정 (Clean)
  'hc_clean': ScenarioData(
    location: "베트남 호찌민 (Clean)",
    tds: WaterStatus(60, "좋음", Colors.blue[800]!, Colors.blue[50]!),
    turbidity: WaterStatus(1.5, "청정", Colors.blue[800]!, Colors.blue[50]!),
    aiTheme: "clean",
    solutions: {
      'washer': DeviceSolution("표준 모드", "에너지와 물 절약을 우선합니다.", [
        SolutionItem("코스", "표준", Icons.check, Colors.blue),
      ]),
      'dishwasher': DeviceSolution("표준 세척", "물 절약 알고리즘 가동", [
        SolutionItem("세척", "표준", Icons.restaurant, Colors.blue),
      ]),
      'purifier': DeviceSolution("표준 정수", "맑은 물이 공급됩니다.", [
        SolutionItem("상태", "양호", Icons.check_circle, Colors.green),
      ]),
      'styler': DeviceSolution("표준 모드", "정상 작동 중입니다.", [
        SolutionItem("스팀", "준비 완료", Icons.cloud_done, Colors.blue),
      ]),
      'dryer': DeviceSolution("표준 건조", "옷감 손상 최소화", [
        SolutionItem("모드", "표준", Icons.wb_sunny, Colors.blue),
      ]),
    },
  ),

  // 2. 흐림 (Cloudy) - 탁도 5~10 NTU (User Scenario A)
  'hc_cloudy': ScenarioData(
    location: "베트남 호찌민 (Cloudy)",
    tds: WaterStatus(120, "보통", Colors.blue[800]!, Colors.blue[50]!),
    turbidity: WaterStatus(8.5, "흐림 (부유물)", Colors.amber[800]!, Colors.amber[50]!),
    aiTheme: "cloudy",
    solutions: {
      'washer': DeviceSolution("부유물 증가 초기 경고", "오염 방지 및 세제 효율을 유지합니다.", [
        SolutionItem("불림", "예비 추가", Icons.layers, Colors.orange),
        SolutionItem("수온", "온수 추천", Icons.thermostat, Colors.red),
        SolutionItem("헹굼", "+1회 추가", Icons.autorenew, Colors.blue),
      ]),
      'dishwasher': DeviceSolution("배관 노후/부유물 대응", "살균과 건조를 강화합니다.", [
        SolutionItem("살균", "고온 활성", Icons.thermostat, Colors.red),
        SolutionItem("건조", "시간/풍량↑", Icons.air, Colors.orange),
      ]),
      'purifier': DeviceSolution("미세 부유물 증가", "유속을 조절하고 살균을 강화합니다.", [
        SolutionItem("유속", "완화", Icons.slow_motion_video, Colors.blue),
        SolutionItem("살균", "주기 증가", Icons.cleaning_services, Colors.orange),
      ]),
      'styler': DeviceSolution("스팀 품질 저하 방지", "스팀 예열을 강화합니다.", [
        SolutionItem("예열", "시간 확장", Icons.timer, Colors.orange),
        SolutionItem("코스", "위생 살균", Icons.health_and_safety, Colors.red),
      ]),
      'dryer': DeviceSolution("먼지 필터 케어", "먼지 부착을 방지합니다.", [
        SolutionItem("필터", "청소 요망", Icons.cleaning_services, Colors.orange),
      ]),
    },
  ),

  // 3. 염분 (Salty) - TDS > 400 ppm (User Scenario D)
  'hc_salty': ScenarioData(
    location: "베트남 호찌민 (Salty)",
    tds: WaterStatus(420, "염분 높음", Colors.orange[800]!, Colors.orange[50]!),
    turbidity: WaterStatus(3.0, "보통", Colors.blue[800]!, Colors.blue[50]!),
    aiTheme: "salty",
    solutions: {
      'washer': DeviceSolution("고경도/스케일 위험", "염분으로 인한 스케일을 방지합니다.", [
        SolutionItem("헹굼", "2회 이상", Icons.autorenew, Colors.blue),
        SolutionItem("물살", "강화", Icons.waves, Colors.red),
        SolutionItem("관리", "세탁조 케어", Icons.settings, Colors.orange),
      ]),
      'dishwasher': DeviceSolution("고경수 대응", "세제량을 늘리고 온도를 유지합니다.", [
        SolutionItem("세제", "1.5배 증량", Icons.add_circle, Colors.red),
        SolutionItem("온도", "일정 유지", Icons.thermostat, Colors.orange),
      ]),
      'purifier': DeviceSolution("정수 불가 위험", "염분 과다로 기능을 제한합니다.", [
        SolutionItem("정수", "일시 중단", Icons.block, Colors.red),
        SolutionItem("세척", "주기 확장", Icons.cleaning_services, Colors.blue),
      ]),
      'styler': DeviceSolution("스팀 사용 불가", "스팀을 끄고 건조 모드로 전환합니다.", [
        SolutionItem("물", "정수 요청", Icons.water_drop, Colors.red),
        SolutionItem("모드", "건조/제습", Icons.air, Colors.orange),
      ]),
      'dryer': DeviceSolution("필수 건조", "자연 건조 시 끈적임이 발생합니다.", [
        SolutionItem("살균", "강력", Icons.thermostat, Colors.red),
        SolutionItem("세척", "콘덴서 2배", Icons.refresh, Colors.blue),
      ]),
    },
  ),

  // 4. 오염 (Muddy) - 탁도 > 10 NTU (User Scenario B)
  'hc_muddy': ScenarioData(
    location: "베트남 호찌민 (Muddy)",
    tds: WaterStatus(180, "보통", Colors.blue[800]!, Colors.blue[50]!),
    turbidity: WaterStatus(25.0, "위험 (진흙탕)", Colors.red[800]!, Colors.red[50]!),
    aiTheme: "muddy",
    solutions: {
      'washer': DeviceSolution("흙탕물 수준 위험", "위생 보호 및 오염 제거에 집중합니다.", [
        SolutionItem("세탁", "Pre-Wash", Icons.layers, Colors.orange),
        SolutionItem("코스", "살균/고온", Icons.thermostat, Colors.red),
        SolutionItem("모드", "강력 세탁", Icons.bolt, Colors.red),
      ]),
      'dishwasher': DeviceSolution("수질 위험 대응", "스팀 대신 UV/건조를 강화합니다.", [
        SolutionItem("스팀", "살균 대체", Icons.autorenew, Colors.orange),
        SolutionItem("건조", "UV+강화", Icons.wb_sunny, Colors.red),
      ]),
      'purifier': DeviceSolution("흙탕물 유입 감지", "고온 살균수 제공 및 필터 세척을 권장합니다.", [
        SolutionItem("출수", "고온 살균", Icons.hot_tub, Colors.red),
        SolutionItem("필터", "즉시 세척", Icons.cleaning_services, Colors.red),
      ]),
      'styler': DeviceSolution("급수 오염 위험", "의류 및 기기 보호를 위해 스팀을 차단합니다.", [
        SolutionItem("코스", "섬세 제한", Icons.block, Colors.grey),
        SolutionItem("모드", "저온 제습", Icons.ac_unit, Colors.blue),
        SolutionItem("관리", "급수통 세척", Icons.cleaning_services, Colors.red),
      ]),
      'dryer': DeviceSolution("비상 살균", "오염된 옷감을 살균합니다.", [
        SolutionItem("코스", "살균(Sanitary)", Icons.medical_services, Colors.red),
      ]),
    },
  ),
};