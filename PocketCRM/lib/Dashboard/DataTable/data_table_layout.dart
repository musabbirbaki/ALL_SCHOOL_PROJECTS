import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';

class DataTableLayout extends StatefulWidget {
  DataTableLayout({Key key, this.makeItemsSelectable, this.tableData}) : super(key: key);

  // final String title;
  final bool makeItemsSelectable;
  final List<Map<String,String>> tableData;

  @override
  _DataTableLayoutState createState() => _DataTableLayoutState();
}

class _DataTableLayoutState extends State<DataTableLayout> {
  List<Map<String, String>> tableData;

  // GlobalKey<_DataTableLayoutState> gk = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadTableData();
    print("Initializing DataTable.");
    // getListOfColumns();
    // getListOfRows();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
          child: DataTable(
            columns: getListOfColumns(), //gets list of DataColumn Objects from data
            rows: getListOfRows(), //gets list of DataRow
          ),
        ),
    );
  }

  // bool cellIsSeletect = false;
  // Map<String, String> selectedCell;
  List<Map<String,String>> selectedItems = [];
  void addToSelectedItemList(val){
    selectedItems.add(val);    
  }
  void removeFromSelectedItemList(val){
    selectedItems.remove(val);
  }

  //Returns list of DataRow
  List<DataRow> getListOfRows(){
    List<DataRow> dataRows = [];
    tableData.forEach((val){
      // print("DataRow map val: $val");
      dataRows.add(
        DataRow(
          cells: getListOfDataCell(val),
          selected: widget.makeItemsSelectable ? selectedItems.contains(val) : false,
          onSelectChanged: (bool selected){
            if(widget.makeItemsSelectable){
              setState(() {
                // selectedCell = val;
                if(!selectedItems.contains(val)){
                  addToSelectedItemList(val);
                  print("List: $selectedItems");
                }else{
                  removeFromSelectedItemList(val);
                  print("List: $selectedItems");
                }
              });
            }
          },
        )
      );
    });
    return dataRows;
  }

  //Helper function for getListOfRows()
  List<DataCell> getListOfDataCell(val){
    List<DataCell> listOfDataCells = [];
    int index = tableData.indexOf(val);

    tableData[index].keys.forEach((key){
      String cellValue = tableData[index][key];
      // print("CellValue: $cellValue");
      listOfDataCells.add(
          DataCell(Text(cellValue))
        );
    });

    return listOfDataCells;
  }

  /*
    Returns list of Data Columns Objects from data
  */
  List<DataColumn> getListOfColumns(){
    List<DataColumn> columnNames = [];

    // tableData[0].keys.forEach((key){
    //   // print("Column Keys: $key");
    //   columnNames.add( DataColumn(
    //     label: Text("$key", style: TextStyle(fontWeight: FontWeight.bold),),
    //   ));
    // });

    getColumnNames().forEach((String name){
      columnNames.add( DataColumn(
        label: Text("$name", style: TextStyle(fontWeight: FontWeight.bold),),
      ));
    });

    return columnNames;
  }

  //This helper funciton gets column names from the data.
  List<String> getColumnNames(){
    List<String> columnNames = [];

    tableData.forEach((Map<String, String> map){
      map.keys.forEach((key){
        if(!columnNames.contains("$key")){
          columnNames.add("$key");
        }
      });
    });

    // print("${columnNames}");
    return columnNames;
  }


  //Load the data here to 
  Future<void> _loadTableData() async {
  // void _loadTableData() {
    
    tableData = widget.tableData;

    // tableData = [
    //   {
    //     "Id": "1",
    //   "Name" : "Jason",
    //   "Age" : "20",
    //   "Title" : "Student",
    //   },

    //   {
    //     "Id": "2",
    //   "Name" : "Tomy",
    //   "Age" : "30",
    //   "Title" : "Teacher",
    //   },

    //   {
    //     "Id": "3",
    //   "Name" : "Adrian",
    //   "Age" : "29",
    //   "Title" : "Principle",
    //   },

    //   {
    //     "Id": "4",
    //   "Name" : "Andoid",
    //   "Age" : "21",
    //   "Title" : "Mechanic",
    //   },

    //   {
    //     "Id": "5",
    //   "Name" : "Sammy",
    //   "Age" : "19",
    //   "Title" : "Singer",
    //   },

    //   {
    //     "Id": "6",
    //   "Name" : "Boston",
    //   "Age" : "31",
    //   "Title" : "Student",
    //   },
    // ];
  }




}

