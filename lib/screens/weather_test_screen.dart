import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../models/weather_model.dart';
import '../theme/constants.dart';

class WeatherTestScreen extends StatefulWidget {
  const WeatherTestScreen({super.key});

  @override
  State<WeatherTestScreen> createState() => _WeatherTestScreenState();
}

class _WeatherTestScreenState extends State<WeatherTestScreen> {
  final TextEditingController _cityController = TextEditingController(text: "Danang");
  final WeatherService _weatherService = WeatherService();

  WeatherModel? _weather;
  bool _isLoading = false;
  String _errorMessage = "";

  void _getWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
      _weather = null;
    });

    try {
      final weather = await _weatherService.fetchWeather(_cityController.text);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "도시를 찾을 수 없습니다.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text("날씨 기반 수질 분석", style: TextStyle(fontWeight: FontWeight.bold, color: kTextDark)),
        backgroundColor: const Color(0xFFF6F7F9),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kTextDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 1. 검색창
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: TextField(
                controller: _cityController,
                style: const TextStyle(fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: "도시 이름 (예: Seoul, Hanoi)",
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: kAccentBlue),
                  suffixIcon: IconButton(icon: const Icon(Icons.arrow_forward, size: 18, color: kAccentBlue), onPressed: _getWeather),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                onSubmitted: (_) => _getWeather(),
              ),
            ),
            const SizedBox(height: 30),

            // 2. 결과 화면
            if (_isLoading)
              const Center(child: CircularProgressIndicator(color: kAccentBlue))
            else if (_errorMessage.isNotEmpty)
              _buildErrorCard()
            else if (_weather != null)
                _buildAnalysisResult()
              else
                _buildEmptyState(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        const SizedBox(height: 50),
        Icon(Icons.science_outlined, size: 80, color: Colors.grey[300]),
        const SizedBox(height: 20),
        Text("도시를 검색하여\n기상 데이터 기반 수질 솔루션을 확인하세요.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[500], fontSize: 16)),
      ],
    );
  }

  Widget _buildErrorCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(16)),
      child: Row(children: [const Icon(Icons.error_outline, color: Colors.red), const SizedBox(width: 10), Expanded(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)))]),
    );
  }

  Widget _buildAnalysisResult() {
    return Column(
      children: [
        // 날씨 요약 카드
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(children: [const Icon(Icons.location_on, color: kAccentBlue), const SizedBox(height: 5), Text(_weather!.cityName, style: const TextStyle(fontWeight: FontWeight.bold))]),
              Column(children: [const Icon(Icons.thermostat, color: Colors.orange), const SizedBox(height: 5), Text("${_weather!.temp}°C", style: const TextStyle(fontWeight: FontWeight.bold))]),
              Column(children: [const Icon(Icons.umbrella, color: Colors.blue), const SizedBox(height: 5), Text("${_weather!.rain1h}mm", style: const TextStyle(fontWeight: FontWeight.bold))]),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // [핵심] 4대 가전 솔루션 카드 생성
        _buildDynamicSolutionList(_weather!),
      ],
    );
  }

  Widget _buildDynamicSolutionList(WeatherModel weather) {
    // 1. 날씨 데이터를 수질 데이터(가상)로 변환
    double estimatedNTU = weather.rain1h * 2.0; // 비 1mm당 탁도 2 증가 가정
    double estimatedTDS = 100 + (weather.temp * 10); // 기본 100 + 온도*10 가정

    // 2. 상태 판단 및 UI 설정
    String statusTitle = "수질 상태 양호";
    Color statusColor = kAccentBlue;
    String statusDesc = "표준 모드로 운전합니다.";

    // 우선순위: 탁도 위험 > TDS 위험 > 탁도 주의 > TDS 주의 > 양호
    if (estimatedNTU >= 10) {
      statusTitle = "흙탕물 유입 위험 (탁도 높음)";
      statusColor = Colors.red;
      statusDesc = "강수량 증가로 인한 탁도 급증. 위생 보호 모드를 가동합니다.";
    } else if (estimatedTDS >= 400) {
      statusTitle = "스케일 생성 위험 (고경수)";
      statusColor = Colors.red;
      statusDesc = "고온으로 인한 미네랄 농축. 스케일 방지 모드를 가동합니다.";
    } else if (estimatedNTU >= 5) {
      statusTitle = "부유물 증가 (탁도 주의)";
      statusColor = Colors.orange;
      statusDesc = "초기 부유물 감지. 세제 효율 유지에 집중합니다.";
    } else if (estimatedTDS >= 201) {
      statusTitle = "경수 구간 진입 (TDS 주의)";
      statusColor = Colors.orange;
      statusDesc = "경수 구간입니다. 세제 용해력을 보완합니다.";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 진단 결과 헤더
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(15), border: Border.all(color: statusColor.withOpacity(0.3))),
          child: Column(
            children: [
              Text(statusTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: statusColor)),
              const SizedBox(height: 5),
              Text("추정치: TDS ${estimatedTDS.toInt()}ppm / 탁도 ${estimatedNTU.toStringAsFixed(1)} NTU", style: TextStyle(fontSize: 12, color: statusColor)),
              const SizedBox(height: 5),
              Text(statusDesc, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Colors.black87)),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 4대 가전 솔루션 리스트
        _buildDeviceCard("세탁기", Icons.local_laundry_service, _getWasherSolution(estimatedNTU, estimatedTDS)),
        _buildDeviceCard("식기세척기", Icons.restaurant, _getDishwasherSolution(estimatedNTU, estimatedTDS)),
        _buildDeviceCard("정수기", Icons.water_drop, _getPurifierSolution(estimatedNTU, estimatedTDS)),
        _buildDeviceCard("스타일러", Icons.checkroom, _getStylerSolution(estimatedNTU, estimatedTDS)), // 스타일러 아이콘 대체

        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildDeviceCard(String name, IconData icon, Map<String, String> solution) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: kTextDark, size: 24),
              const SizedBox(width: 10),
              Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextDark)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFF0F4FF), borderRadius: BorderRadius.circular(8)),
                child: const Text("AI 적용됨", style: TextStyle(fontSize: 10, color: kAccentBlue, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 12),
          Text(solution['title']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kAccentBlue)),
          const SizedBox(height: 6),
          Text(solution['desc']!, style: const TextStyle(fontSize: 13, color: Color(0xFF555555), height: 1.5)),
        ],
      ),
    );
  }

  // ====================================================================================
  // [솔루션 로직] 요청하신 텍스트를 그대로 반영한 로직들입니다.
  // ====================================================================================

  // 1. 세탁기 솔루션
  Map<String, String> _getWasherSolution(double ntu, double tds) {
    if (ntu >= 10) {
      return {
        "title": "위생 보호 + 오염물 제거 집중",
        "desc": "• Pre-Wash(예비세탁) 활성화\n• 살균/고온 위생 세탁 코스로 자동 전환\n• 강력 세탁(물살/RPM 강화) 모드로 우회"
      };
    } else if (tds >= 400) {
      return {
        "title": "섬유 보호 + 세탁조 스케일 방지",
        "desc": "• 헹굼 강화(2회 이상)\n• 물살 강화(세제 잔여물 최소화)\n• 삶음 코스 제한 & 세탁조 관리 안내"
      };
    } else if (tds >= 201) {
      return {
        "title": "세제 용해력 보완 + 세탁 품질 유지",
        "desc": "• 세제량 자동 증량 & 섬유유연제 권장\n• 동적 불림(예비 불림 시간 확장)\n• 패턴 조정 (강한 교반 → 부드러운 텀블링)"
      };
    } else if (ntu >= 5) {
      return {
        "title": "부유물 증가 초기 경고",
        "desc": "• 예비 불림 단계 추가\n• 온수 세탁 자동 추천\n• 헹굼 강화(추가 1회)"
      };
    }
    return {"title": "표준 세탁 모드", "desc": "• 최적의 수질 상태입니다.\n• 에너지 절약 표준 알고리즘을 수행합니다."};
  }

  // 2. 식기세척기 솔루션
  Map<String, String> _getDishwasherSolution(double ntu, double tds) {
    if (ntu >= 10) {
      return {
        "title": "수질 위험 대응",
        "desc": "• 스팀 살균 코스 자동 대체\n• UV + 강화 건조 패턴 적용"
      };
    } else if (tds >= 400) {
      return {
        "title": "고경수 대응 모드",
        "desc": "• 세제량 증량 안내 (약 1.5배)\n• 헹굼 온도 일정 범위 유지 (스케일 방지)"
      };
    } else if (tds >= 201) {
      return {
        "title": "물 얼룩 방지 모드",
        "desc": "• 린스 투입량 자동 증가\n• 건조 알고리즘 조정 (물 얼룩 최소화)"
      };
    } else if (ntu >= 5) {
      return {
        "title": "배관 노후/부유물 대응",
        "desc": "• 고온 살균 옵션 자동 활성화\n• 건조 단계 강화 (시간·풍량 최적화)"
      };
    }
    return {"title": "표준 세척 모드", "desc": "• 물 얼룩 걱정 없는 최적 상태입니다.\n• 표준 절전 모드로 운전합니다."};
  }

  // 3. 정수기 솔루션
  Map<String, String> _getPurifierSolution(double ntu, double tds) {
    if (tds >= 401) { // 401 이상 (정수 불가 가능성) - 우선순위 최상으로 배치
      return {
        "title": "정수 불가 가능성 경고",
        "desc": "• 일시 정수 중단 + 경고 메시지\n• 온수 가열 기능 자동 제한\n• 내부 세척/플러싱 주기 확장"
      };
    } else if (ntu >= 10) {
      return {
        "title": "흙탕물 수준 감지",
        "desc": "• 고온 살균수 우선 제공\n• 필터 즉시 세척 (세디먼트/프리필터)"
      };
    } else if (tds >= 201) {
      return {
        "title": "필터 부하 증가 대응",
        "desc": "• RO 멤브레인 자동 세척 주기 증가\n• 정수 속도 자동 조절"
      };
    } else if (ntu >= 5) {
      return {
        "title": "미세 부유물 증가 대응",
        "desc": "• 출수 속도 조절(유속 완화)\n• 냉수 탱크/코크 살균 기준 강화"
      };
    }
    return {"title": "안심 정수 모드", "desc": "• 깨끗한 물이 공급되고 있습니다.\n• 표준 필터링 모드로 동작합니다."};
  }

  // 4. 스타일러 솔루션
  Map<String, String> _getStylerSolution(double ntu, double tds) {
    if (tds >= 401) {
      return {
        "title": "스팀 사용 불가 경고",
        "desc": "• 정수된 물 요청 메시지 발송\n• 스팀 비활성화 → 건조·제습 중심 모드 전환"
      };
    } else if (ntu >= 10) {
      return {
        "title": "급수 오염 위험 대응",
        "desc": "• 고급 의류/섬세 코스 제한\n• 스팀 차단 후 저온 제습 전환\n• 급수통 세척 안내"
      };
    } else if (tds >= 201) {
      return {
        "title": "스케일 위험 방지",
        "desc": "• 먼지 제거 중심 코스 자동 추천\n• 보일러 내부 배수 주기 증가"
      };
    } else if (ntu >= 5) {
      return {
        "title": "스팀 품질 저하 방지",
        "desc": "• 스팀 예열 시간 자동 확장\n• 위생 살균 코스 우선 적용"
      };
    }
    return {"title": "표준 스타일링", "desc": "• 스팀 분사가 원활합니다.\n• 표준 코스로 의류를 관리합니다."};
  }
}