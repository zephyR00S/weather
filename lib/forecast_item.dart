import 'package:flutter/material.dart';

class ForecastItem extends StatelessWidget {
  const ForecastItem({super.key});

  @override
  Widget build(BuildContext) {
    return const Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      elevation: 8,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              '0300',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Icon(
              Icons.cloud,
              size: 30,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              '0300',
              style: TextStyle(
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
