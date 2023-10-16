import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/Ui/detailspage.dart';
import 'package:weatherapp/components/weatheritem.dart';
import 'package:weatherapp/widget/constants.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _cityController = TextEditingController();
  final Constants _constants = Constants();

  static String API_KEY = 'f5d9bc9f82f04e94817202331231310';

  String location = 'Kochi';
  String weatherIcon = 'heavycloudy.png';
  int temperature = 0;
  int humidity = 0;
  int windspeed = 0;
  int cloud = 0;
  String currentDate = '';

  List hourlyWeatherForecast = [];
  List dailyWeatherForecast = [];

  String currentWeatherstatus = '';

  //apicall

  String searchWeatherAPI =
      "http://api.weatherapi.com/v1/current.json?key=" + API_KEY + "&days=7&q=";

  //get currentWeather => null;

  void fetchweatherdata(String searchText) async {
    try {
      var searchResult =
          await http.get(Uri.parse(searchWeatherAPI + searchText));
      final weatherData = Map<String, dynamic>.from(
          json.decode(searchResult.body) ?? 'No Data');

      var locationData = weatherData['location'];
      var currentweather = weatherData['current'];

      setState(() {
        location = getShortLocationName(locationData['name']);

        var parseData =
            DateTime.parse(locationData["localtime"].substring(0, 10));
        var newDate = DateFormat('MMMMEEEd').format(parseData);
        currentDate = newDate;

        //update weather

        currentWeatherstatus = currentweather['condition']['text'];
        weatherIcon =
            currentWeatherstatus.replaceAll(' ', ' ').toLowerCase() + '.png';
        temperature = currentweather['temp_c'].toInt();
        humidity = currentweather['humidity'].toInt();
        windspeed = currentweather['wind_kph'].toInt();
        cloud = currentweather['cloud'].toInt();

        //Forecast data
        dailyWeatherForecast = weatherData["forecast"]["forecastday"];
        hourlyWeatherForecast = dailyWeatherForecast[0]["hour"];
        print(dailyWeatherForecast);
      });
    } catch (e) {
      //print(e);
    }
  }

  static String getShortLocationName(String s) {
    List<String> wordList = s.split('');

    if (wordList.isNotEmpty) {
      if (wordList.length > 1) {
        return wordList[0] + ' ' + wordList[1];
      } else {
        return wordList[0];
      }
    } else {
      return "";
    }
  }

  @override
  void initState() {
    fetchweatherdata(location);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blue[100],
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
        color: _constants.primaryColor.withOpacity(.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              height: size.height * 0.7,
              decoration: BoxDecoration(
                gradient: _constants.LinearGradientBlue,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                      color: _constants.primaryColor.withOpacity(.6),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 3))
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 35,
                      ),
                      // Image.asset(
                      //   'assets/menu.png',
                      //   width: 35,
                      //   height: 35,
                      // ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/pin.png',
                            width: 20,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            location,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                          IconButton(
                              onPressed: () {
                                _cityController.clear();
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => SingleChildScrollView(
                                    controller:
                                        ModalScrollController.of(context),
                                    child: Container(
                                      height: size.height * .2,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: 70,
                                            child: Divider(
                                              thickness: 3.5,
                                              color: _constants.primaryColor,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextField(
                                            onChanged: (searchText) {
                                              fetchweatherdata(searchText);
                                            },
                                            controller: _cityController,
                                            autofocus: true,
                                            decoration: InputDecoration(
                                                prefixIcon: Icon(
                                                  Icons.search,
                                                  color:
                                                      _constants.primaryColor,
                                                ),
                                                suffixIcon: GestureDetector(
                                                  onTap: () =>
                                                      _cityController.clear(),
                                                  child: Icon(
                                                    Icons.close,
                                                    color:
                                                        _constants.primaryColor,
                                                  ),
                                                ),
                                                hintText:
                                                    'Search city e.g. London',
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color:
                                                        _constants.primaryColor,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.red,
                                size: 18,
                              ))
                        ],
                      ),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: const CircleAvatar(

                              // child: Container(
                              //   height: 35 ,
                              //   width: 35,
                              //   color: Colors.white),),
                              // child: Image.asset('assets/profile.png',height: 35,width: 35,),
                              ))
                    ],
                  ),
                  SizedBox(
                    height: 160,
                    child: Image.asset('assets/' + weatherIcon),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          temperature.toString(),
                          style: TextStyle(
                              fontSize: 80,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()..shader = _constants.shader),
                        ),
                      ),
                      Text(
                        'O',
                        style: TextStyle(
                            fontSize: 33,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()..shader = _constants.shader),
                      )
                    ],
                  ),
                  Text(
                    currentWeatherstatus,
                    style: const TextStyle(color: Colors.white, fontSize: 19),
                  ),
                  Text(
                    currentDate,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Divider(
                      color: Colors.white70,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WeatherItem(
                            value: windspeed.toInt(),
                            unit: 'Km/hr',
                            imageUrl: 'assets/windspeed.png'),
                        WeatherItem(
                            value: humidity.toInt(),
                            unit: '%',
                            imageUrl: 'assets/humidity.png'),
                        WeatherItem(
                            value: cloud.toInt(),
                            unit: '%',
                            imageUrl: 'assets/cloud.png')
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10),
              height: size.height * .2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(),)),
                        child: Text(
                          'Forecast',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                      height: 110,
                      child: ListView.builder(
                          itemCount: hourlyWeatherForecast.length,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            String currentTime =
                                DateFormat('HH:mm:ss').format(DateTime.now());
                            String currentHour = currentTime.substring(0, 2);

                            String forecastTime = hourlyWeatherForecast[index]
                                    ["time"]
                                .substring(11, 16);
                            String forecastHour = hourlyWeatherForecast[index]
                                    ["time"]
                                .substring(11, 13);

                            String forecastWeatherName =
                                hourlyWeatherForecast[index]["condition"]
                                    ["text"];
                            String forecastWeatherIcon = forecastWeatherName
                                    .replaceAll(' ', '')
                                    .toLowerCase() +
                                ".png";

                            String forecastTemperature =
                                hourlyWeatherForecast[index]["temp_c"]
                                    .round()
                                    .toString();

                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              margin: const EdgeInsets.only(right: 20),
                              width: 65,
                              decoration: BoxDecoration(
                                  color: currentHour == forecastHour
                                      ? _constants.primaryColor
                                      : Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(50)),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: const Offset(0, 1),
                                        blurRadius: 5,
                                        color: _constants.primaryColor
                                            .withOpacity(.2))
                                  ]),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    forecastTime,
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: _constants.greyColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Image.asset(
                                    'asset/' + forecastWeatherIcon,
                                    width: 20,
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        forecastTemperature,
                                        style: TextStyle(
                                            color: _constants.greyColor,
                                            fontWeight: FontWeight.w600,
                                            foreground: Paint()
                                              ..shader = _constants.shader,
                                            fontSize: 17),
                                      ),
                                      Text(
                                        'o',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            foreground: Paint()
                                              ..shader = _constants.shader),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          }))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
