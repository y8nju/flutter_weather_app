import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_weather_app/datas/loading_images.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(milliseconds: 150), (Timer timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % imageList.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      imageList[_currentIndex],
      width: 200,
      height: 200,
      colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
    );
  }
}
