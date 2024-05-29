import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weather/forecast_item.dart';
import 'package:weather/additional_info.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

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
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                              '300° F',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Icon(
                              Icons.cloud,
                              size: 40,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
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

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(width: 100, child: const ForecastItem()),
                    Container(width: 100, child: const ForecastItem()),
                    Container(width: 100, child: const ForecastItem()),
                    Container(width: 100, child: const ForecastItem()),
                    Container(width: 100, child: const ForecastItem()),
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
