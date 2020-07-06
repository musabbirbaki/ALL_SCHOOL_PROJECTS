//This import is used to convert String verion of map to datamap
import 'dart:convert';

class Dashboard {
  Dashboard(
      {this.id,
      this.data,
      this.graphType,
      this.graphTitle,
      this.dataInString,
      this.isGraph,
      this.query,
      this.tableData});

  int id;
  String graphTitle;
  String graphType;
  Map<String, String> data;
  String dataInString;
  List<Map<String, String>> tableData;

  //Query
  String query;
  bool isGraph;

  /*
    This function is used to create dashboard using datamap
  */
  static Dashboard createDashboardUsingData(int id, String graphTitle,
      String graphType, Map<String, String> data, bool isGraph, List<Map<String, String>> tableData) {
    return Dashboard(
      id: id,
      graphTitle: graphTitle,
      graphType: graphType,
      data: data,
      dataInString: DataMapToString(data),
      isGraph: true,
      tableData: tableData,
    );
  }

  /*
    This function is used to create dashboard using string version
    of data map
  */
  static Dashboard createDashboardUsingString(
      int id, String graphTitle, String graphType, String data, bool isGraph) {
    return Dashboard(
      id: id,
      graphTitle: graphTitle,
      graphType: graphType,
      data: StringToDataMap(data),
      dataInString: data,
    );
  }

  /*
    this.data = StringToDataMap(map["dataInString"]); included
    because it needs to be added when reading from db
  */
  Dashboard.fromMap(map) {
    this.id = map["id"];
    this.graphTitle = map["graphTitle"];
    this.graphType = map["graphType"];
    this.dataInString = map["dataInString"];
    this.isGraph = map["isGraph"];

    this.data = StringToDataMap(map["dataInString"]);
  }

  /*
    this.data not included
    since it is not saved in db
  */
  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "graphTitle": this.graphTitle,
      "graphType": this.graphType,
      "dataInString": this.dataInString,
      "isGraph": this.isGraph,
    };
  }

  /*
    This function returns a string version of the datamap
  */
  static String DataMapToString(data) {
    String finalString = "";
    finalString += "{";
    data.keys.forEach((key) {
      finalString += "\"${key}\" : \"${data[key]}\", ";
    });

    //Remove Last comma
    finalString = finalString.substring(0, finalString.length - 2) +
        finalString.substring(finalString.length - 1, finalString.length);

    finalString += "}";
    // print(finalString + "\n");
    // print(json.decode(finalString).toString());

    return finalString;
  }

  /*
    This function returns the map from the String version of the 
    data
  */
  static Map<String, String> StringToDataMap(data) {
    // this.data = json.decode(this.dataInString);
    return json.decode(data);
  }

  String toString() {
    String s = "";
    s += "Dashboard";
    s += " ${this.id}, ";
    s += "Title: ${this.graphTitle}, " ;
    s += "Type: ${this.graphType}, " ;
    s += "Is Graph: ${this.isGraph}." ;
    return s;
  }
}
