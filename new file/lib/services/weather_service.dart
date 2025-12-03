import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  // TODO: 여기에 OpenWeatherMap에서 발급받은 API 키를 넣으세요.
  static const String apiKey = 'a9be253a83103c32802a3b24b0cd8bb5';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherModel> fetchWeather(String city) async {
    final url = Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('날씨 데이터를 불러오는데 실패했습니다.');
    }
  }
}