import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weather/forecast_item.dart';
import 'package:weather/additional_info.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double temp = 0;
  @override
  void initState() {
    super.initState();
    getWeather();
  }

//url is a subtyoe of uri - bigger set and url is susbset
  Future getWeather() async {
    // String cityName = 'London';

    try {
      final res = await http.get(
        Uri.parse(
            'https://pro.openweathermap.org/data/2.5/forecast/hourly?lat={20.5937}&lon={78.9629}&appid={1e7f75aedd5ec69a5b6e264e8c26c8c5}'),
      );
// we decode the res.body as it is in a string format
      final data = (res.body);
      // we have the data and put checking conditions
      // we can convert it to int by using int.parse and then check
      if (data['cod'] != '200') {
        throw 'An unexpected error occurred';
      }

//initially the value is 0 then it is retrieving the value in the mean time we will show 0 in the text and then we finally get the value of temp
// which we have assigned and we call set state to rebuild the build function and that we get the value of temp
      setState(() {
        temp = data['list'][0]['main']['temp'];
      });
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather Today',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh_sharp))
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //main card
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                              '$temp k',
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Icon(
                              Icons.cloud,
                              size: 40,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              'rain',
                              style: TextStyle(fontSize: 15),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Weather Forecast',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              //weather cards

              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                        width: 100,
                        child: ForecastItem(
                          time: '12:00',
                          icon: Icons.cloud,
                          temp: '301.22',
                        )),
                    SizedBox(
                        width: 100,
                        child: ForecastItem(
                          time: '12:00',
                          icon: Icons.water_drop,
                          temp: '301.22',
                        )),
                    SizedBox(
                        width: 100,
                        child: ForecastItem(
                          time: '12:00',
                          icon: Icons.light_mode,
                          temp: '301.22',
                        )),
                    SizedBox(
                        width: 100,
                        child: ForecastItem(
                          time: '12:00',
                          icon: Icons.air,
                          temp: '301.22',
                        )),
                    SizedBox(
                        width: 100,
                        child: ForecastItem(
                          time: '12:00',
                          icon: Icons.water_drop,
                          temp: '301.22',
                        )),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              const Text(
                'Details',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),

              const SizedBox(
                height: 15,
              ),

              //additional info

              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInfo(
                    icon: Icons.water_drop,
                    label: 'Humidity',
                    value: '8.8%',
                  ),
                  AdditionalInfo(
                    icon: Icons.air,
                    label: 'Wind Speed',
                    value: '7.5',
                  ),
                  AdditionalInfo(
                    icon: Icons.beach_access,
                    label: 'Pressure',
                    value: '850',
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
