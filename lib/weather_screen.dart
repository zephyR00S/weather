import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather/forecast_item.dart';
import 'package:weather/additional_info.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weatherFuture;

  @override
  void initState() {
    super.initState();
    weatherFuture = _fetchWeatherData();
  }

  Future<Map<String, dynamic>> _fetchWeatherData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/India?unitGroup=metric&include=days&key=TN889WPERQQQ3Q2UN3PHQQUY4&contentType=json'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch weather data');
      }
    } catch (e) {
      throw Exception('Error fetching weather data: $e');
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
          IconButton(
            onPressed: () {
              setState(() {
                weatherFuture = _fetchWeatherData();
              });
            },
            icon: const Icon(Icons.refresh_sharp),
          )
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: weatherFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final data = snapshot.data!;
          final currentTemp = data['days'][0]['temp'];
          final currentSky = data['days'][0]['conditions'];
          final currentPressure = data['days'][0]['pressure'];
          final currentWindSpeed = data['days'][0]['windspeed'];
          final currentHumidity = data['days'][0]['humidity'];
          final dayIcon = data['days'][0]['icon'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Text(
                                '${currentTemp.toStringAsFixed(1)}°C',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Icon(
                                _getWeatherIcon(dayIcon),
                                size: 60,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                currentSky,
                                style: const TextStyle(fontSize: 15),
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
                // Weather cards
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var day in data['days'].take(5))
                        SizedBox(
                          width: 100,
                          child: ForecastItem(
                            time: _formatDate(day['datetime']),
                            icon: _getWeatherIcon(
                                day['icon']), // Replace with appropriate icon
                            temp: day['temp'].toStringAsFixed(1),
                          ),
                        ),
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
                // Additional info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfo(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: '$currentHumidity%',
                    ),
                    AdditionalInfo(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: '$currentWindSpeed m/s',
                    ),
                    AdditionalInfo(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: '$currentPressure hPa',
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(String dateTime) {
    DateTime parsedDate = DateTime.parse(dateTime);
    String day = parsedDate.day.toString();
    String month = _getMonth(parsedDate.month);
    return '$day $month';
  }

  String _getMonth(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  IconData _getWeatherIcon(String icon) {
    switch (icon) {
      case 'clear-day':
        return Icons.wb_sunny;
      case 'partly-cloudy-day':
        return Icons.foggy;
      case 'cloudy':
        return Icons.cloud;
      case 'rain':
        return Icons.water_drop;
      case 'wind':
        return Icons.air;

      default:
        return Icons.no_cell_sharp;
    }
  }
}
