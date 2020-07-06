import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SimpleScatterPlotChart extends StatelessWidget {
  // final List<charts.Series> seriesList;
  // final bool animate;
  Map<String, String> data;

  SimpleScatterPlotChart({this.data});


  @override
  Widget build(BuildContext context) {
    return new charts.ScatterPlotChart(
      _createData(this.data), 
      animate: true,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createData(data) {

    List<LinearSales> newDataList = [];
    data.keys.forEach((key){
      newDataList.add(LinearSales(int.parse(key), int.parse(data[key])));
    });

    //find max first
    int max = 0;
    data.keys.forEach((key){
      int val = int.parse(data[key]) ;
      if(max < val){
        max = val;
      }
    });
    // final maxMeasure = 300;
    final maxMeasure = max;


    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        // Providing a color function is optional.
        colorFn: (LinearSales sales, _) {
          // Bucket the measure column value into 3 distinct colors.
          final bucket = sales.sales / maxMeasure;

          if (bucket < 1 / 3) {
            return charts.MaterialPalette.blue.shadeDefault;
          } else if (bucket < 2 / 3) {
            return charts.MaterialPalette.red.shadeDefault;
          } else {
            return charts.MaterialPalette.green.shadeDefault;
          }
        },
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        // Providing a radius function is optional.
        // radiusPxFn: (LinearSales sales, _) => sales.radius,
        data: newDataList,
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
  // LinearSales(this.year, this.sales, 2);
}

