import 'package:flutter/material.dart';
import '../models/scenario_models.dart';

// 지역: 베트남으로 통일, 수질 시나리오 세분화
final Map<String, ScenarioData> scenarioData = {
  // --- 1. 표준 시나리오 ---
  'vn_standard': ScenarioData(
    location: "🇻🇳 베트남",
    aiTheme: 'standard',
    tds: WaterStatus(val: 100, status: "표준", color: Colors.blue[600]!, bgColor: Colors.blue[50]!),
    turbidity: WaterStatus(val: 2.0, status: "표준", color: Colors.blue[600]!, bgColor: Colors.blue[50]!),
    solutions: {
      'washer': DeviceSolution(title: "표준 세탁", summary: "최적의 수질입니다. 표준 코스를 시작합니다.", recommendations: ["에너지 효율 코스 권장"]),
      'dishwasher': DeviceSolution(title: "표준 세척", summary: "물 얼룩 걱정 없는 최적의 상태입니다.", recommendations: ["표준 절전 모드로 운전"]),
      'purifier': DeviceSolution(title: "정상 정수", summary: "깨끗한 물이 정상적으로 공급되고 있습니다.", recommendations: ["표준 필터링 모드로 동작"]),
      'styler': DeviceSolution(title: "표준 관리", summary: "스팀 분사가 원활합니다.", recommendations: ["표준 코스로 의류를 관리"]),
      'dryer': DeviceSolution(title: "표준 건조", summary: "기본 건조 모드로 운전합니다.", recommendations: ["표준 건조 시간 및 온도 적용"]),
    },
  ),

  // --- 2. 탁도 주의 (A) ---
  'vn_turbidity_caution': ScenarioData(
    location: "🇻🇳 베트남",
    aiTheme: 'turbid_caution',
    tds: WaterStatus(val: 130, status: "표준", color: Colors.blue[600]!, bgColor: Colors.blue[50]!),
    turbidity: WaterStatus(val: 7.5, status: "탁도 주의", color: Colors.orange[800]!, bgColor: Colors.orange[50]!),
    solutions: {
      'washer': DeviceSolution(title: "부유물 증가 초기 경고", summary: "옷 오염 방지 및 세제 효율 유지를 목표로 자동 제어합니다.", recommendations: ["예비 불림 단계 추가", "온수 세탁 자동 추천", "헹굼 강화 (추가 1회)", "오염 제거 중심 동작으로 미세 조정"]),
      'dishwasher': DeviceSolution(title: "배관 노후 · 부유물 증가", summary: "증가된 부유물에 대응하여 살균 및 건조를 강화합니다.", recommendations: ["고온 살균 옵션 자동 활성화", "건조 단계 강화 (시간/풍량 최적화)"]),
      'purifier': DeviceSolution(title: "미세 부유물 증가", summary: "필터 보호 및 살균 강화를 위해 자동 제어합니다.", recommendations: ["출수 속도 조절(유속 완화)", "냉수 탱크 내부 살균 주기 증가", "출수구/코크 살균 기준 강화"]),
      'styler': DeviceSolution(title: "스팀 품질 저하 가능성", summary: "스팀 분사 품질을 유지하기 위해 자동 제어합니다.", recommendations: ["스팀 예열 시간 자동 확장", "위생 살균 코스 우선 적용"]),
      'dryer': DeviceSolution(title: "표준 건조", summary: "기본 건조 모드로 운전합니다.", recommendations: ["표준 건조 시간 및 온도 적용"]),
    },
  ),

  // --- 3. 탁도 위험 (B) ---
  'vn_turbidity_danger': ScenarioData(
    location: "🇻🇳 베트남",
    aiTheme: 'turbid_danger',
    tds: WaterStatus(val: 150, status: "표준", color: Colors.blue[600]!, bgColor: Colors.blue[50]!),
    turbidity: WaterStatus(val: 12.0, status: "탁도 위험", color: Colors.red[800]!, bgColor: Colors.red[50]!),
    solutions: {
      'washer': DeviceSolution(title: "흙탕물 수준", summary: "위생 보호와 오염물 제거에 집중합니다.", recommendations: ["Pre-Wash(예비세탁) 활성화", "살균/고온 위생 세탁 코스로 자동 전환", "강력 세탁(물살/RPM 강화) 모드로 우회"]),
      'dishwasher': DeviceSolution(title: "수질 위험", summary: "강력한 살균으로 식기 위생을 확보합니다.", recommendations: ["스팀 살균 코스 자동 대체", "UV + 강화 건조 패턴 적용"]),
      'purifier': DeviceSolution(title: "흙탕물 수준", summary: "필터 보호를 위해 즉시 대응합니다.", recommendations: ["고온 살균수 우선 제공", "필터 즉시 세척 (세디먼트/프리필터)"]),
      'styler': DeviceSolution(title: "급수 오염 위험", summary: "의류와 기기 보호를 위해 스팀 사용을 제한합니다.", recommendations: ["고급 의류/섬세 코스 제한", "스팀 차단 → 저온 제습 + 무빙행어로 전환", "급수통 세척 안내 + 보호 모드"]),
      'dryer': DeviceSolution(title: "표준 건조", summary: "기본 건조 모드로 운전합니다.", recommendations: ["표준 건조 시간 및 온도 적용"]),
    },
  ),

  // --- 4. 전도도 주의 (C) ---
  'vn_conductivity_caution': ScenarioData(
    location: "🇻🇳 베트남",
    aiTheme: 'conductivity_caution',
    tds: WaterStatus(val: 320, status: "경수 주의", color: Colors.orange[800]!, bgColor: Colors.orange[50]!),
    turbidity: WaterStatus(val: 3.0, status: "표준", color: Colors.blue[600]!, bgColor: Colors.blue[50]!),
    solutions: {
      'washer': DeviceSolution(title: "경수 구간 시작", summary: "세제 용해력 보완으로 세탁 품질을 유지합니다.", recommendations: ["세제량 자동 증량(표준 대비 약간 증가)", "섬유유연제 권장 메시지 제공", "동적 불림(예비 불림 시간 확장)", "세탁 패턴 조정(강한 교반 → 부드러운 텀블링)"]),
      'dishwasher': DeviceSolution(title: "물 얼룩 위험", summary: "경수로 인한 물 얼룩 발생을 최소화합니다.", recommendations: ["린스 투입량 자동 증가", "건조 알고리즘을 물 얼룩 최소화 중심으로 조정"]),
      'purifier': DeviceSolution(title: "필터 부하 증가", summary: "필터 수명 유지를 위해 자동 제어합니다.", recommendations: ["RO 멤브레인 자동 세척 주기 증가", "정수 속도 자동 조절"]),
      'styler': DeviceSolution(title: "스케일 위험", summary: "스팀 품질 유지를 위해 내부 부품을 보호합니다.", recommendations: ["먼지 제거 중심 코스 자동 추천", "보일러 내부 배수 주기 증가"]),
      'dryer': DeviceSolution(title: "표준 건조", summary: "기본 건조 모드로 운전합니다.", recommendations: ["표준 건조 시간 및 온도 적용"]),
    },
  ),

  // --- 5. 전도도 위험 (D) ---
  'vn_conductivity_danger': ScenarioData(
    location: "🇻🇳 베트남",
    aiTheme: 'conductivity_danger',
    tds: WaterStatus(val: 450, status: "고경도/스케일 위험", color: Colors.red[800]!, bgColor: Colors.red[50]!),
    turbidity: WaterStatus(val: 4.0, status: "표준", color: Colors.blue[600]!, bgColor: Colors.blue[50]!),
    solutions: {
      'washer': DeviceSolution(title: "고경도 / 스케일 위험", summary: "섬유 보호와 세탁조 스케일 방지에 집중합니다.", recommendations: ["헹굼 강화 (2회 이상)", "물살 강화 (세제 잔여물 최소화)", "삶음 코스 제한 (스케일 급증 방지)", "세탁조 관리 안내 메시지"]),
      'dishwasher': DeviceSolution(title: "고경수", summary: "과도한 경수로 인한 문제를 방지합니다.", recommendations: ["세제량 증량 안내", "자동 세제 증량(약 1.5배 수준)", "헹굼 온도를 일정 범위로 유지"]),
      'purifier': DeviceSolution(title: "정수 불가 가능성", summary: "심각한 수질 문제로부터 시스템을 보호합니다.", recommendations: ["일시 정수 중단 + 경고 메시지", "온수 가열 기능 자동 제한", "내부 세척/플러싱 주기 확장"]),
      'styler': DeviceSolution(title: "스팀 사용 불가", summary: "기기 보호를 위해 스팀 기능을 비활성화합니다.", recommendations: ["정수된 물 요청 메시지", "스팀 비활성화 → 건조·제습 중심 모드로 전환"]),
      'dryer': DeviceSolution(title: "표준 건조", summary: "기본 건조 모드로 운전합니다.", recommendations: ["표준 건조 시간 및 온도 적용"]),
    },
  ),

  // --- 6. 철분 위험 (E+A+C) ---
  'vn_iron_danger': ScenarioData(
    location: "🇻🇳 베트남",
    aiTheme: 'iron_danger',
    tds: WaterStatus(val: 325, status: "경수 주의", color: Colors.orange[800]!, bgColor: Colors.orange[50]!),
    turbidity: WaterStatus(val: 8.0, status: "탁도 주의", color: Colors.orange[800]!, bgColor: Colors.orange[50]!),
    solutions: {
      'washer': DeviceSolution(title: "철분 오염 위험", summary: "철분으로 인한 옷감 손상 및 변색을 방지하는 특수 코스입니다.", recommendations: ["저온수(15도) 사용", "중성/산소계 세제 권장 (염소계 표백제 금지)", "저강도(30rpm) 회전", "고수위 헹굼 (재오염 방지)", "최단 시간 탈수"]),
      'dryer': DeviceSolution(title: "얼룩 방지 건조 (철분)", summary: "철분으로 인한 얼룩이 고착되지 않도록 송풍 건조합니다.", recommendations: ["송풍 건조 자동 적용 (고온 건조 제한)"]),
      'dishwasher': DeviceSolution(title: "사용주의 (철분)", summary: "철분 농도가 높아 기기 및 식기에 영향을 줄 수 있습니다.", recommendations: ["사용 전 전문가의 점검을 권장합니다."]),
      'purifier': DeviceSolution(title: "사용주의 (철분)", summary: "철분 농도가 높아 필터 성능에 영향을 줄 수 있습니다.", recommendations: ["필터 상태 점검 및 교체 주기 단축이 필요할 수 있습니다."]),
      'styler': DeviceSolution(title: "사용주의 (철분)", summary: "철분 농도가 높아 스팀 노즐에 영향을 줄 수 있습니다.", recommendations: ["정기적인 노즐 청소 및 점검이 필요합니다."]),
    },
  ),
};
