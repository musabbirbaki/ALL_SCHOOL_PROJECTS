/// Simple pie chart with outside labels example.
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

//Max number of colors are 13......

class PieOutsideLabelChart extends StatelessWidget {
  // Map<String, int> data;
  Map<String, String> data;

  PieOutsideLabelChart({this.data});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      //Set This to daata
      dataMap: getData(this.data),
      legendFontColor: Colors.blueGrey[900],
      legendFontSize: 14.0,
      legendFontWeight: FontWeight.w500,
      animationDuration: Duration(milliseconds: 80),
      chartLegendSpacing: 2.0,
      chartRadius: MediaQuery.of(context).size.width / 1.8,
      showChartValuesInPercentage: true,
      showChartValues: true,
      showChartValuesOutside: false,
      chartValuesColor: Colors.blueGrey[900].withOpacity(0.9),
      colorList: listOfColors(this.data),
      showLegends: true,
      decimalPlaces: 1,
      showChartValueLabel: true,
      chartValueFontSize: 12,
      chartValueFontWeight: FontWeight.bold,
      chartValueLabelColor: Colors.grey[200],
      initialAngle: 0,
    );
  }

  //Get data for graphs
  Map<String, double> getData(data) {
    //Print out error if data type is wrong:
    if (data.keys.take(1) is int) {
      print("Error: Wrong data type for keys, it should be String.");
    }

    Map<String, double> dataMap = new Map();
    data.keys.forEach((key) {
      dataMap.putIfAbsent(key, () => double.parse(data[key]));
    });

    return dataMap;
  }

  List<Color> listOfColors(data) {
    var colors = [
      Colors.red,
      Colors.blue,
      Colors.purple,
      Colors.yellow,
      Colors.pink,
      Colors.purple,
      Colors.amber,
      Colors.brown,
      Colors.green,
      Colors.brown,
      Colors.cyan,
      Colors.orange,
      Colors.black,
    ];

    // List<Color> colors = [Colors.green];

    // //find max first
    // int max = 0;
    // data.keys.forEach((key){
    //   int val = data[key];
    //   if(max < val){
    //     max = val;
    //   }
    // });

    // data.keys.forEach((key){
    //   int val = data[key];
    //   int colorVal = ((val/max) * 290).round() ;
    //   print(colorVal);

    //   colors.add(Colors.green[colorVal]);
    // });

    return colors;
  }
}
