import 'package:flutter/material.dart';
import 'package:flutter_weather_app/datas/network.dart';
import 'package:flutter_weather_app/datas/get_location.dart';
import 'package:flutter_weather_app/screens/weather_screen.dart';
import 'package:flutter_weather_app/widgets/loading_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

String apiKey = dotenv.get('API_KEY');

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);
  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  late Position myCurrentPosition;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  // 내 위치 get
  void getLocation() async {
    GetLocation getLocation = GetLocation();
    await getLocation.getMyCurrentLocation();
    myCurrentPosition = getLocation.myCurrentPosition;
    print(myCurrentPosition.latitude);

    fetchData();
  }

  void fetchData() async {
    String weatherUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=${myCurrentPosition.latitude}&lon=${myCurrentPosition.longitude}&appid=$apiKey&units=metric';
    String airUrl =
        'https://api.openweathermap.org/data/2.5/air_pollution?lat=${myCurrentPosition.latitude}&lon=${myCurrentPosition.longitude}&appid=$apiKey';
    Network network = Network(weatherUrl, airUrl);

    var weatherData = await network.getJsonData();
    print(weatherData);

    var airData = await network.getAirData();
    print(airData);

    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return WeatherScreen(
            parseWeatherData: weatherData, parseAirData: airData);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff698cbf),
                  Color(0xff9bb2e5),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Positioned(
                        bottom: 0,
                        child: Text(
                          'Weather',
                          style: GoogleFonts.montserrat(
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                      Opacity(opacity: 0.54, child: LoadingWidget()),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            )),
      ),
    );
  }
}
