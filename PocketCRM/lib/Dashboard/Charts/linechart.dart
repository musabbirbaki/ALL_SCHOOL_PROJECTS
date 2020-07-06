import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

///////////////////////////////////////////////////////////LINE CHART

class SimpleLineChart extends StatelessWidget {
  final Map<String, String> data;

  SimpleLineChart({this.data});

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(
      _createData(this.data), 
      animate: true,
      );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<IntIntDataClass, int>> _createData(data) {


    List<IntIntDataClass> newDataList = [];
    data.keys.forEach((key){
      newDataList.add(IntIntDataClass(int.parse(key), int.parse(data[key])));
    });


    return [
      new charts.Series<IntIntDataClass, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (IntIntDataClass dataClass, _) => dataClass.label,
        measureFn: (IntIntDataClass dataClass, _) => dataClass.value,
        data: newDataList,
      )
    ];
  }
}

/// Sample linear data type.
class IntIntDataClass {
  final int label;
  // final String label;
  final int value;

  IntIntDataClass(this.label, this.value);
}




