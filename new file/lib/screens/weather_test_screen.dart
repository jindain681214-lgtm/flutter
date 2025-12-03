import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../models/weather_model.dart';
import '../theme/constants.dart';
import '../models/scenario_models.dart'; // AI 솔루션 모델 import
import '../models/device_model.dart'; // Device 모델 import

class WeatherTestScreen extends StatefulWidget {
  // 1. 외부에서 데이터 받기 위한 변수 추가
  final List<Device> devices;
  final ScenarioData scenarioData;

  const WeatherTestScreen({
    super.key,
    required this.devices,
    required this.scenarioData,
  });

  @override
  State<WeatherTestScreen> createState() => _WeatherTestScreenState();
}

class _WeatherTestScreenState extends State<WeatherTestScreen> {
  final TextEditingController _cityController = TextEditingController();
  final WeatherService _weatherService = WeatherService();

  WeatherModel? _weather;
  bool _isLoading = false;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    // 초기 도시 설정 및 날씨 정보 자동 로드
    _cityController.text = widget.scenarioData.location.split(' ').last; // 시나리오의 지역명으로 초기화
    _getWeather();
  }

  void _getWeather() async {
    if (_cityController.text.isEmpty) return;
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
        title: const Text("날씨 정보", style: TextStyle(fontWeight: FontWeight.bold, color: kTextDark)),
        backgroundColor: const Color(0xFFF6F7F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kTextDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // 2. 새로운 UI - 검색창
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: _cityController,
              style: const TextStyle(fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: "도시 검색",
                prefixIcon: const Icon(Icons.search, color: kAccentBlue),
                suffixIcon: IconButton(icon: const Icon(Icons.arrow_forward_rounded, color: kAccentBlue), onPressed: _getWeather),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onSubmitted: (_) => _getWeather(),
            ),
          ),
          // 3. 새로운 UI - 결과 표시 영역
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: kAccentBlue))
                : _errorMessage.isNotEmpty
                    ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)))
                    : _weather != null
                        ? _buildWeatherResult(_weather!)
                        : const Center(child: Text("날씨 정보를 불러오세요.")),
          ),
        ],
      ),
    );
  }

  // 4. 날씨 결과 UI 빌더
  Widget _buildWeatherResult(WeatherModel weather) {
    // 이미지의 UI를 구성하는 부분
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(weather.cityName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: kTextDark)),
          const SizedBox(height: 5),
          Text("${weather.temp.toStringAsFixed(1)}°", style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: kTextDark)),
          const Text("현재 기온", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 30),
          Row(
            children: [
              _buildInfoCard(Icons.water_drop_outlined, "현재 습도", "${weather.humidity}%"),
              const SizedBox(width: 15),
              _buildInfoCard(Icons.umbrella_outlined, "강수량", "${weather.rain1h}mm"),
            ],
          ),
          const SizedBox(height: 30),
          _buildAiSolutionCard(), // AI 솔루션 카드 추가
        ],
      ),
    );
  }

  // 5. 정보 카드 (습도, 강수량)
  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Icon(icon, color: kAccentBlue, size: 28),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kTextDark)),
              ],
            )
          ],
        ),
      ),
    );
  }

  // 6. AI 실시간 솔루션 카드
  Widget _buildAiSolutionCard() {
    // 현재 수질 시나리오에 따라 분기 (이미지의 '좋음 (Soft)' 부분)
    String statusText = widget.scenarioData.tds.status;
    Color statusColor = widget.scenarioData.tds.color;
    String solutionTitle = "";
    String solutionDesc = "";

    // 이미지에 있는 '세탁기 세제 절약 모드' 예시
    if (widget.devices.any((d) => d.id == 'washer')) {
      solutionTitle = "[세탁기] 세제 절약 모드";
      solutionDesc = "• 세제량 -30% 감소 (기름 과다 방지)\n• 표준 코스로 운전합니다.";
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: statusColor, size: 20),
              const SizedBox(width: 8),
              Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 4),
          const Text("현재 기상 상태 안정적", style: TextStyle(color: Colors.grey)),
          const Divider(height: 30, thickness: 1),
          const Text("AI 실시간 솔루션", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kTextDark)),
          const SizedBox(height: 10),
          Text(solutionTitle, style: const TextStyle(fontWeight: FontWeight.w500, color: kTextDark)),
          const SizedBox(height: 5),
          Text(solutionDesc, style: const TextStyle(color: Colors.black54, height: 1.5)),
        ],
      ),
    );
  }
}
