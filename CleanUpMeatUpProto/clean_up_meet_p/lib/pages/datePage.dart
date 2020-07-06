import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePage extends StatefulWidget {

	final String appBarTitle;

	DatePage(this.appBarTitle);

	@override
  State<StatefulWidget> createState() {
    return DatePageState(this.appBarTitle);
  }
}

class DatePageState extends State<DatePage> {
    // Variable for date selector
  DateTime selectedDate = DateTime.now();

  DatePageState(String appBarTitle);

  @override
  Widget build(BuildContext context) {
  
     return Scaffold(

      appBar: AppBar(
        title: Text("Date Page"),
      ),
      
      body:  Container(alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

             //  UI FOR BIRTHDAY SELECTION FIELD
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[ 
                    Text("Date", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 48)),
                  ],
                ),
            ),


            //  Select Date
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[ 
                    Text("Select Date", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    SizedBox(height: 50.0, width: 50.0),
                    RaisedButton(
                      color: Colors.white,
                      onPressed: () => _selectDate(context),
                      child: Text(' '),
                    ),   
                  ],
                ),
            ),

            
            //  Select Start Time
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[ 
                    Text("Start Time", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    SizedBox(height: 50.0, width: 50.0),
                    RaisedButton(
                      color: Colors.white,
                      onPressed: () => _selectTime(context),
                      child: Text(' '),
                    ),   
                  ],
                ),
            ),

            //  Select End Time
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[ 
                    Text("End Time", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    SizedBox(height: 50.0, width: 50.0),
                    RaisedButton(
                      color: Colors.white,
                      onPressed: () => _selectTimeEnd(context),
                      child: Text(' '),
                    ),   
                  ],
                ),
            ),

             //  Display
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[ 
                    Text('Date: ' + toDateString(selectedDate)),
                    Text('Start Time: ' + toTimeString(selectedTime)),
                    Text('End Time: ' + toTimeString(selectedTimeEnd)),
                    //Text("${selectedDate.year}, ${selectedDate.month}, ${selectedDate.day}, ${selectedTime.hour}, ${selectedTime.minute}"),
                  ],
                ),
            ),

            Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15, right: 15),
					    child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                
						    children: <Widget>[
                  
								    RaisedButton(
									    color: Colors.blue,
									    textColor: Colors.white,
									    child: Text(
										    'Prev',
										    textScaleFactor: 1.5,
									    ),
									    onPressed: () {
									    	setState(() {
									    	  debugPrint("Prev clicked");
									    	});
									    },
								    ),
                    
                    RaisedButton(
									    color: Colors.blue,
									    textColor: Colors.white,
									    child: Text(
										    'Next',
										    textScaleFactor: 1.5,
									    ),
									    onPressed: () {
									    	setState(() {
									    	  debugPrint("Next clicked");
									    	});
									    },
								    ),
                  
                ]
                
              )
            )

          ],
        ),
      ),
      
    );

  }


  // Date thing
  String toOrdinal(number) {
      if ((number >= 10) && (number <= 19)) {
        return number.toString() + 'th';
        } else if ((number % 10) == 1) {
        return number.toString() + 'st';
        } else if ((number % 10) == 2) {
        return number.toString() + 'nd';
        } else if ((number % 10) == 3) {
        return number.toString() + 'rd';
        } else {
        return number.toString() + 'th';
      }
    }

    String toMonthName(monthNum) {
      switch (monthNum) {
      case 1:
      return 'January';
      case 2:
      return 'February';
      case 3:
      return 'March';
      case 4:
      return 'April';
      case 5:
      return 'May';
      case 6:
      return 'June';
      case 7:
      return 'July';
      case 8:
      return 'August';
      case 9:
      return 'September';
      case 10:
      return 'October';
      case 11:
      return 'November';
      case 12:
      return 'December';
      default:
      return 'Error';
      }
    } 

  String toDateString(DateTime date) {
    return '${toMonthName(date.month)} ${toOrdinal(date.day)}, ${date.year}';
  }

  String toTimeString(TimeOfDay time) {
    String ampm = 'AM';
    int hour = time.hour;
    if (time.hour > 12) {
      ampm = "PM";
      hour = hour - 12;
    } else if (time.hour == 0) {
      ampm = "AM";
      hour = hour + 12;
    }
    return '${time.hour}:${time.minute}';
  }

  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay selectedTimeEnd = TimeOfDay.now();

  // Select Time
  Future<Null> _selectTime(BuildContext context) async {
      final TimeOfDay pickedS = await showTimePicker(
          context: context,
          initialTime: selectedTime, builder: (BuildContext context, Widget child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
              child: child,
            );});

      if (pickedS != null && pickedS != selectedTime )
        setState(() {
          selectedTime = pickedS;
        });
  }

    Future<Null> _selectTimeEnd(BuildContext context) async {
      final TimeOfDay pickedS = await showTimePicker(
          context: context,
          initialTime: selectedTimeEnd, builder: (BuildContext context, Widget child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
              child: child,
            );});

      if (pickedS != null && pickedS != selectedTimeEnd )
        setState(() {
          selectedTimeEnd = pickedS;
        });
  }

  // SELECT date
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }


}



