import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

dynamic getWeatherIconPath(int condition) {
  if (condition < 300) {
    return 'assets/svg/Cloud-Lightning.svg';
  } else if (condition < 500) {
    return 'assets/svg/Cloud-Drizzle.svg';
  } else if (condition < 510) {
    return 'assets/svg/Cloud-Rain-Sun.svg';
  } else if (condition == 504) {
    return 'assets/svg/Snowflake.svg';
  } else if (condition < 600) {
    return 'assets/svg/Cloud-Drizzle.svg';
  } else if (condition < 700) {
    return 'assets/svg/Snowflake.svg';
  } else if (condition < 800) {
    return 'assets/svg/Tornado.svg';
  } else if (condition == 800) {
    return 'assets/svg/Cloud-Sun.svg';
  } else if (condition <= 804) {
    return 'assets/svg/Cloud.svg';
  } else {
    return null;
  }
}

dynamic getAirIconPath(int index) {
  if (index == 1) {
    return 'assets/images/good.png';
  } else if (index == 2) {
    return 'assets/images/fair.png';
  } else if (index == 3) {
    return 'assets/images/moderate.png';
  } else if (index == 4) {
    return 'assets/images/poor.png';
  } else if (index == 5) {
    return 'assets/images/bad.png';
  } else {
    return null;
  }
}

class Model {
  Widget getWeatherIcon(int condition) {
    dynamic iconPath = getWeatherIconPath(condition);
    if (iconPath != null) {
      return SvgPicture.asset(
        iconPath,
        width: 220,
        height: 220,
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
      );
    } else {
      return Text('');
    }
  }

  Widget getAirIcon(int index) {
    dynamic iconPath = getAirIconPath(index);
    if (iconPath != null) {
      return Image.asset(
        iconPath,
        width: 37.0,
        height: 35.0,
      );
    } else {
      return Text('');
    }
  }

  Widget getAirCondition(int index) {
    if (index == 1) {
      return Text(
        'Good',
      );
    } else if (index == 2) {
      return Text(
        'Fair',
      );
    } else if (index == 3) {
      return Text(
        'Moderate',
      );
    } else if (index == 4) {
      return Text(
        'Poor',
      );
    } else if (index == 5) {
      return Text(
        'Very Poor',
      );
    } else {
      return Text('');
    }
  }

  Widget getPm10Condition(int index) {
    if (index < 20) {
      return Text(
        'Good',
      );
    } else if (index < 50) {
      return Text(
        'Fair',
      );
    } else if (index < 100) {
      return Text(
        'Moderate',
      );
    } else if (index < 200) {
      return Text(
        'Poor',
      );
    } else if (index >= 200) {
      return Text(
        'Very Poor',
      );
    } else {
      return Text('');
    }
  }

  Widget getPm2_5Condition(int index) {
    if (index < 10) {
      return Text(
        'Good',
      );
    } else if (index < 25) {
      return Text(
        'Fair',
      );
    } else if (index < 50) {
      return Text(
        'Moderate',
      );
    } else if (index < 75) {
      return Text(
        'Poor',
      );
    } else if (index >= 75) {
      return Text(
        'Very Poor',
      );
    } else {
      return Text('');
    }
  }
}
