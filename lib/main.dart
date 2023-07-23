import 'dart:convert';

//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:secapp/func.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(MyWidget());
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String url = '';

  String city = ' ';
  String c = '';
  String description = '   ';
  String d = '   ';
  String sunrise = ' ';
  String sunset = ' ';

  var humidity;
  var temperature;
  var data;
  var ans;
  var i;
  var dew_point;
  var pressure_hpa;
  var visibility;
  final fieldText = TextEditingController();
  void clearText() {
    fieldText.text = currentAddress;
  }

  String currentAddress = 'My Address';
  late Position currentposition;
  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Please enable Your Location Service');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg:
              'Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      print(e);
      return;
    }

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];

      setState(() {
        currentposition = position;
        if (currentposition != null) {
          currentAddress = "${place.locality}";
        } else {
          currentAddress = 'Failed to get current location';
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(282, 600),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Text(
                  'SkyCast°',
                  style: TextStyle(
                    fontSize: 27.0.sp,
                    color: Color.fromARGB(255, 220, 234, 241),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('lib/images/back.jpg'),
                      fit: BoxFit.cover),
                ),
                child: SafeArea(
                    child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          //color: Colors.amber,
                          margin: EdgeInsets.all(8).w,
                          padding: EdgeInsets.all(8).w,
                          child: TextField(
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(Icons.location_on),
                                onPressed: () async {
                                  clearText();
                                  _determinePosition();

                                  setState(() {
                                    url =
                                        'http://13.232.87.108:80/weather?city=' +
                                            '$currentAddress';
                                  });

                                  data = await fetchdata(url);
                                  ans = jsonDecode(data);

                                  setState(() {
                                    c = ans["city"];
                                    city = c.toUpperCase();
                                  });
                                  setState(() {
                                    d = ans["description"];
                                    description = d.toUpperCase();
                                    if (description == 'CLEAR SKY') {
                                      setState(() {
                                        i = 0;
                                      });
                                    } else if (description ==
                                        'OVERCAST CLOUDS') {
                                      setState(() {
                                        i = 1;
                                      });
                                    } else if (description ==
                                        'SCATTERED CLOUDS') {
                                      setState(() {
                                        i = 2;
                                      });
                                    } else if (description == 'HEAVY RAIN' ||
                                        description == 'LIGHT RAIN' ||
                                        description == 'MODERATE RAIN' ||
                                        description == 'SHOWERS' ||
                                        description == 'VERY HEAVY RAIN' ||
                                        description == 'HEAVY INTENSITY RAIN' ||
                                        description ==
                                            'THUNDERSTORM WITH LIGHT RAIN') {
                                      setState(() {
                                        i = 3;
                                      });
                                    } else if (description == 'THUNDERSTORM') {
                                      setState(() {
                                        i = 4;
                                      });
                                    } else if (description == 'HAZE') {
                                      setState(() {
                                        i = 5;
                                      });
                                    }
                                  });
                                  setState(() {
                                    humidity = ans['humidity'];
                                  });
                                  setState(() {
                                    temperature = ans['temperature'];
                                  });
                                  setState(() {
                                    dew_point = ans['dew_point'];
                                  });
                                  setState(() {
                                    pressure_hpa = ans['pressure_hpa'];
                                  });
                                  setState(() {
                                    visibility = ans['visibility'];
                                  });
                                  setState(() {
                                    sunrise = ans['sunrise'];
                                  });
                                  setState(() {
                                    sunset = ans['sunset'];
                                  });
                                  setState(() {});
                                },
                              ),
                              labelText: 'Enter City',
                              border: OutlineInputBorder(),
                            ),
                            style: TextStyle(fontSize: 18.sp),
                            onChanged: (value) => {
                              url = 'http://13.232.87.108:80/weather?city=' +
                                  value.toString(),
                            },
                            controller: fieldText,
                          ),
                        ),
                        Container(
                          //color: Colors.amber,
                          margin: EdgeInsets.all(2).w,
                          padding: EdgeInsets.all(2).w,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.grey),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(4).w),
                              ),
                              onPressed: () async {
                                data = await fetchdata(url);
                                ans = jsonDecode(data);
                                setState(() {
                                  c = ans["city"];
                                  city = c.toUpperCase();
                                });
                                setState(() {
                                  d = ans["description"];
                                  description = d.toUpperCase();
                                  if (description == 'CLEAR SKY') {
                                    setState(() {
                                      i = 0;
                                    });
                                  } else if (description == 'OVERCAST CLOUDS') {
                                    setState(() {
                                      i = 1;
                                    });
                                  } else if (description ==
                                      'SCATTERED CLOUDS') {
                                    setState(() {
                                      i = 2;
                                    });
                                  } else if (description == 'HEAVY RAIN' ||
                                      description == 'LIGHT RAIN' ||
                                      description == 'MODERATE RAIN' ||
                                      description == 'SHOWERS' ||
                                      description == 'VERY HEAVY RAIN' ||
                                      description == 'HEAVY INTENSITY RAIN' ||
                                      description ==
                                          'THUNDERSTORM WITH LIGHT RAIN') {
                                    setState(() {
                                      i = 3;
                                    });
                                  } else if (description == 'THUNDERSTORM') {
                                    setState(() {
                                      i = 4;
                                    });
                                  } else if (description == 'HAZE') {
                                    setState(() {
                                      i = 5;
                                    });
                                  }
                                });
                                setState(() {
                                  humidity = ans['humidity'];
                                });
                                setState(() {
                                  temperature = ans['temperature'];
                                });
                                setState(() {
                                  dew_point = ans['dew_point'];
                                });
                                setState(() {
                                  pressure_hpa = ans['pressure_hpa'];
                                });
                                setState(() {
                                  visibility = ans['visibility'];
                                });
                                setState(() {
                                  sunrise = ans['sunrise'];
                                });
                                setState(() {
                                  sunset = ans['sunset'];
                                });
                              },
                              child: Text(
                                  style: TextStyle(
                                      fontSize: 15.0.sp,
                                      color: Color.fromARGB(255, 3, 3, 3),
                                      fontWeight: FontWeight.bold),
                                  '    Fetch    ')),
                        ),
                        Container(
                          height: 157.h,
                          width: 270.w,
                          decoration: BoxDecoration(
                            color: Color(0xFFffffff),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 15.0.sp,
                                spreadRadius: 2.0.sp,
                                offset: Offset(
                                  5.0.sp,
                                  5.0.sp,
                                ),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Image.asset(
                                'lib/images/weather$i.gif',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      description,
                                      style: TextStyle(
                                        fontSize: 20.0.sp,
                                        color:
                                            Color.fromARGB(255, 202, 217, 225),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      "in " + city,
                                      style: TextStyle(
                                        fontSize: 20.0.sp,
                                        color:
                                            Color.fromARGB(255, 220, 234, 241),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Container(
                                height: 120.0.h,
                                width: 125.0.w,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFffffff),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 15, // soften the shadow
                                      spreadRadius: 5.0, //extend the shadow
                                      offset: Offset(
                                        5.0, // Move to right 5  horizontally
                                        5.0, // Move to bottom 5 Vertically
                                      ),
                                    )
                                  ],
                                ), //color: Colors.amber,
                                margin: EdgeInsets.all(8).w,
                                padding: EdgeInsets.all(8).w,
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        Icon(Icons.hot_tub),
                                        Text(
                                            style: TextStyle(
                                                fontSize: 15.0.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                            'Humidty')
                                      ],
                                    ),
                                    SizedBox(height: 25.h),
                                    Center(
                                        child: Text(
                                            style: TextStyle(
                                                fontSize: 30.0.sp,
                                                color: Colors.black45,
                                                fontWeight: FontWeight.bold),
                                            "$humidity" + " %")),
                                  ],
                                ),
                              ),
                              Container(
                                height: 120.h,
                                width: 125.w,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFffffff),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 15.0, // soften the shadow
                                      spreadRadius: 5.0, //extend the shadow
                                      offset: Offset(
                                        5.0, // Move to right 5  horizontally
                                        5.0, // Move to bottom 5 Vertically
                                      ),
                                    )
                                  ],
                                ), //color: Colors.amber,
                                margin: EdgeInsets.all(8).w,
                                padding: EdgeInsets.all(8),
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Icon(Icons.hot_tub_outlined),
                                          Text(
                                              style: TextStyle(
                                                  fontSize: 14.0.sp,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                              'Temperature')
                                        ],
                                      ),
                                      SizedBox(height: 31.h),
                                      Center(
                                          child: Text(
                                              style: TextStyle(
                                                  fontSize: 26.sp,
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold),
                                              "$temperature" + " °C")),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Container(
                                height: 120.h,
                                width: 125.w,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFffffff),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 15.0, // soften the shadow
                                      spreadRadius: 5.0, //extend the shadow
                                      offset: Offset(
                                        5.0, // Move to right 5  horizontally
                                        5.0, // Move to bottom 5 Vertically
                                      ),
                                    )
                                  ],
                                ), //color: Colors.amber,
                                margin: EdgeInsets.all(8).w,
                                padding: EdgeInsets.all(8).w,
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Icon(Icons.hot_tub),
                                          Text(
                                              style: TextStyle(
                                                  fontSize: 14.0.sp,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                              'Pressure_hpa')
                                        ],
                                      ),
                                      SizedBox(height: 29.sp),
                                      Center(
                                          child: Text(
                                              style: TextStyle(
                                                  fontSize: 25.sp,
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold),
                                              "$pressure_hpa" + " hPa")),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 120.h,
                                width: 125.w,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFffffff),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 15.0, // soften the shadow
                                      spreadRadius: 5.0, //extend the shadow
                                      offset: Offset(
                                        5.0, // Move to right 5  horizontally
                                        5.0, // Move to bottom 5 Vertically
                                      ),
                                    )
                                  ],
                                ), //color: Colors.amber,
                                margin: EdgeInsets.all(8).w,
                                padding: EdgeInsets.all(8).w,
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        Icon(Icons.dew_point),
                                        Text(
                                            style: TextStyle(
                                                fontSize: 14.0.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                            'Dewpoint')
                                      ],
                                    ),
                                    SizedBox(height: 28.h),
                                    Center(
                                        child: Text(
                                            style: TextStyle(
                                                fontSize: 27.sp,
                                                color: Colors.black45,
                                                fontWeight: FontWeight.bold),
                                            "$dew_point" + " °C")),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Container(
                                height: 120.h,
                                width: 125.w,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'lib/images/time-sunset.gif'),
                                      fit: BoxFit.cover),
                                  color: Color(0xFFffffff),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 15.0, // soften the shadow
                                      spreadRadius: 5.0, //extend the shadow
                                      offset: Offset(
                                        5.0, // Move to right 5  horizontally
                                        5.0, // Move to bottom 5 Vertically
                                      ),
                                    )
                                  ],
                                ), //color: Colors.amber,
                                margin: EdgeInsets.all(8).w,
                                padding: EdgeInsets.all(7.5).w,
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.sunny,
                                          color: Colors.white,
                                        ),
                                        Text(
                                            style: TextStyle(
                                                fontSize: 13.0.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                            'Sunrise Sunset')
                                      ],
                                    ),
                                    SizedBox(height: 27.sp),
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                              child: Text(
                                                  style: TextStyle(
                                                      fontSize: 20.0.sp,
                                                      color: Color.fromARGB(
                                                          255, 214, 236, 214),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  sunrise)),
                                          Center(
                                              child: Text(
                                                  style: TextStyle(
                                                      fontSize: 20.sp,
                                                      color: Colors.black45,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  sunset)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 120.h,
                                width: 125.0.w,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFffffff),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 15.0, // soften the shadow
                                      spreadRadius: 5.0, //extend the shadow
                                      offset: Offset(
                                        5.0, // Move to right 5  horizontally
                                        5.0, // Move to bottom 5 Vertically
                                      ),
                                    )
                                  ],
                                ), //color: Colors.amber,
                                margin: EdgeInsets.all(8).w,
                                padding: EdgeInsets.all(7.5).w,
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Icon(Icons.visibility),
                                          Text(
                                              style: TextStyle(
                                                  fontSize: 15.0.sp,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                              'Visibility')
                                        ],
                                      ),
                                      SizedBox(height: 27.h),
                                      Center(
                                          child: Text(
                                              style: TextStyle(
                                                  fontSize: 27.0.sp,
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold),
                                              "$visibility" + " hPa")),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),
              ),
            ),
          );
        });
  }
}
