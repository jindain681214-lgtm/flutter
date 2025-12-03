class WeatherModel {
  final String cityName;
  final double lat;
  final double lon;
  final double temp;
  final int humidity;
  final double rain1h; // 1시간 강수량

  WeatherModel({
    required this.cityName,
    required this.lat,
    required this.lon,
    required this.temp,
    required this.humidity,
    required this.rain1h,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    // 강수량 데이터는 비가 안 오면 null일 수 있으므로 처리 필요
    double rain = 0.0;
    if (json['rain'] != null && json['rain']['1h'] != null) {
      rain = (json['rain']['1h'] as num).toDouble();
    }

    return WeatherModel(
      cityName: json['name'] ?? '',
      lat: (json['coord']['lat'] as num).toDouble(),
      lon: (json['coord']['lon'] as num).toDouble(),
      temp: (json['main']['temp'] as num).toDouble(),
      humidity: (json['main']['humidity'] as num).toInt(),
      rain1h: rain,
    );
  }
}