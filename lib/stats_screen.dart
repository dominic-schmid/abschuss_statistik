import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:jagdverband_scraper/widgets/wildart_pie_chart.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body: Center(child: Text('Stats')),

      //body: WildartPieChart(),
      body: Center(
        child: MaterialButton(
            child: Text('Piechart'),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => WildartPieChart()));
            }),
      ),
    );
  }
}
