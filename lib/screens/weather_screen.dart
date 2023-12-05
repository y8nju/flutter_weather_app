import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_weather_app/datas/get_location.dart';
import 'package:flutter_weather_app/datas/network.dart';
import 'package:flutter_weather_app/models/model.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String apiKey = dotenv.get('API_KEY');

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key, this.parseWeatherData, this.parseAirData})
      : super(key: key);
  final parseWeatherData;
  final parseAirData;

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Model model = Model();
  late Widget icon;
  late Widget aqiIcon;
  late Widget airContition;
  late Widget pm10Contition;
  late Widget pm2_5Contition;
  late String cityName;
  late int temp;
  late String description;
  late dynamic tempInfo;
  final date = DateTime.now();
  late int pm2_5;
  late int pm10;
  late Position myCurrentPosition;

  @override
  void initState() {
    super.initState();
    updateData(widget.parseWeatherData, widget.parseAirData['list'][0]);
  }

  void updateData(dynamic weatherData, dynamic airData) {
    temp = weatherData['main']['temp'].round();
    tempInfo = weatherData['main'];
    cityName = weatherData['name'];
    description = weatherData['weather'][0]['description'];
    int condition = weatherData['weather'][0]['id'];
    icon = model.getWeatherIcon(condition);
    int aqi = airData['main']['aqi'];
    aqiIcon = model.getAirIcon(aqi);
    airContition = model.getAirCondition(aqi);
    pm2_5 = airData['components']['pm2_5'].round();
    pm2_5Contition = model.getPm2_5Condition(pm2_5);
    pm10 = airData['components']['pm10'].round();
    pm10Contition = model.getPm10Condition(pm10);
  }

  String getSystemtime() {
    var now = DateTime.now();
    return DateFormat('h:mm a').format(now);
  }

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

    setState(() {
      updateData(weatherData, airData['list'][0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.location_searching_rounded,
              color: Colors.white,
            ),
            onPressed: () => getLocation(),
            iconSize: 28.0,
          )
        ],
      ),
      body: Container(
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
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
              16, (AppBar().preferredSize.height + 24), 16, 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            '$cityName',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 4,
                          ),
                          TimerBuilder.periodic(
                            Duration(minutes: 1),
                            builder: (context) {
                              return Text.rich(
                                TextSpan(
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w200,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '${getSystemtime()}',
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(width: 8),
                                    ),
                                    TextSpan(
                                      text: DateFormat(
                                        'EEEE,',
                                      ).format(date),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(width: 8),
                                    ),
                                    TextSpan(
                                      text: DateFormat('yyy. MM. dd', 'ko')
                                          .format(date),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          child: Stack(
                            alignment: AlignmentDirectional.centerStart,
                            children: [
                              Positioned(
                                right: -60,
                                top: -20,
                                child: Opacity(opacity: 0.7, child: icon),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$temp°',
                                    style: TextStyle(
                                      fontSize: 80,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      style: TextStyle(
                                        fontSize: 22,
                                      ),
                                      children: [
                                        TextSpan(
                                            text:
                                                '${tempInfo['temp_min'].round()}°'),
                                        TextSpan(text: '  /  '),
                                        TextSpan(
                                            text:
                                                '${tempInfo['temp_max'].round()}°'),
                                      ],
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      style: GoogleFonts.montserrat(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w200,
                                      ),
                                      children: [
                                        TextSpan(text: 'wind chill '),
                                        TextSpan(
                                            text:
                                                '${tempInfo['feels_like'].round()}°'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    '$description',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('AQI'),
                          SizedBox(
                            height: 14,
                          ),
                          aqiIcon,
                          SizedBox(
                            height: 12,
                          ),
                          airContition,
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('PM 10'),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '$pm10',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '㎍/m³',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          pm10Contition,
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('PM 2.5'),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '$pm2_5',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '㎍/m³',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          pm2_5Contition,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
