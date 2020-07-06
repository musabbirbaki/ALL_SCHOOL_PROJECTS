import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SimpleBarChart extends StatelessWidget {
  // final List<charts.Series> seriesList;
  // final bool animate;
  final Map<String, String> data;
  SimpleBarChart({this.data});

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      _createData(this.data),
      animate: true,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<StringIntDataClass, String>> _createData(data) {
    // final data = [
    //   new StringIntDataClass('Flutter', 5),
    //   new StringIntDataClass('React', 25),
    //   new StringIntDataClass('Xamarin', 100),
    //   new StringIntDataClass('Ionic', 75),
    // ];

    

    List<StringIntDataClass> newDataList = [];
    data.keys.forEach((key){
      newDataList.add(StringIntDataClass(key, int.parse(data[key]) ));
    });


    return [
      new charts.Series<StringIntDataClass, String>(
        id: 'Data',
        // colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,

        colorFn: (StringIntDataClass obj, _) {
          // Bucket the measure column value into 3 distinct colors.
          // final bucket = obj.value;

          if (obj.value % 3 == 0) {
            return charts.MaterialPalette.blue.shadeDefault;
          } else if (obj.value % 3 == 1) {
            return charts.MaterialPalette.red.shadeDefault;
          } else {
            return charts.MaterialPalette.green.shadeDefault;
          }
        },

        domainFn: (StringIntDataClass dataClass, _) => dataClass.label,
        measureFn: (StringIntDataClass dataClass, _) => dataClass.value,
        data: newDataList,
      )
    ];
  }
}

int barCounter = 0;
/// Sample label value data type.
class StringIntDataClass {
  String label;
  int value;

  StringIntDataClass(this.label, this.value);

  StringIntDataClass.fromMap(Map<dynamic, dynamic> map){
    this.label = map['label'];
    this.value = map['value'];
  }

  Map<String,dynamic> toMap() {
    return {
      'label': this.label,
      'value': this.value,
    };
  }
}

