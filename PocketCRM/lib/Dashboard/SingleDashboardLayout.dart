import 'package:flutter/material.dart';
import 'Dashboard_Model/dashboard.dart';
import 'Charts/barchart.dart';
import 'Charts/linechart.dart';
import 'Charts/piechart.dart';
import 'Charts/scatterchart.dart';

/*
  This widget one dashboard (One graph)
*/
class DashboardLayout extends StatefulWidget {
  DashboardLayout({Key key, this.dashboard}) : super(key: key);

  final Dashboard dashboard;

  @override
  _DashboardLayoutState createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  // String dashboardType;

  @override
  Widget build(BuildContext context) {
    // dashboardType = widget.dashboard.graphType;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  child: Text(
                widget.dashboard.graphTitle,
                style: TextStyle(fontSize: 25),
              )),

              /////////////DROP DOWN LIST
              // Container(
              //   child: DropdownButton<String>(
              //   items: <String>['Pie', 'Bar', 'Scatter', 'Line']
              //       .map((String value) {
              //     return new DropdownMenuItem<String>(
              //       value: value,
              //       child: Container(
              //         width: 100,
              //         child: Text(
              //           value,
              //           style: TextStyle(fontSize: 25),
              //         ),
              //       ),
              //     );
              //   }).toList(),
              //   value: dashboardType,
              //   onChanged: (String newValue) {
              //     setState(() {
              //       dashboardType = newValue;
              //       print('Setting value to $dashboardType');
              //     });
              //   },
              // ),
              // ),
            ],
          ),
        ),
        Center(
          child: Container(
              padding: EdgeInsets.only(bottom: 20),
              width: 350,
              height: 350,
              child: chooseGraph(context)),
        ),
      ],
    );
  }

  //Choose which graph
  dynamic chooseGraph(BuildContext context) {
    if(widget.dashboard.isGraph){
      //'Pie', 'Bar', 'Scatter', 'Line'
      if (widget.dashboard.graphType == "Line") {
        //Data type Int Int
        return SimpleLineChart(data: widget.dashboard.data);
      } else if (widget.dashboard.graphType == "Scatter") {
        //Data type int int
        return SimpleScatterPlotChart(data: widget.dashboard.data);
      } else if (widget.dashboard.graphType == "Bar") {
        //Data type String Int
        return SimpleBarChart(data: widget.dashboard.data);
      } else {
        //Map...String double
        return PieOutsideLabelChart(data: widget.dashboard.data);
      }
    }
    // else{
    //   return null;
    // }
  }
}
