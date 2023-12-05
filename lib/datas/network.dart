import 'package:dio/dio.dart';

class Network {
  final String weatherUrl;
  final String airUrl;
  Network(this.weatherUrl, this.airUrl);

  Future<dynamic> getJsonData() async {
    try {
      //  dio가 http에 비하여 cors 우회가 더 잘된다
      Dio dio = Dio();
      Response response = await dio.get(weatherUrl);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = response.data;
        return jsonData;
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> getAirData() async {
    try {
      //  dio가 http에 비하여 cors 우회가 더 잘된다
      Dio dio = Dio();
      Response response = await dio.get(airUrl);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = response.data;
        return jsonData;
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
