class QueryObject{
  int id;
  String query;
  String title;
  String chartType;

  QueryObject({this.query, this.chartType, this.title, this.id});

  QueryObject.fromMap(map){
    this.id = map["id"];
    this.query = map["query"];
    this.chartType = map["chartType"];
    this.title = map["title"];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "query": this.query,
      "chartType": this.chartType,
      "title": this.title,
    };
  }

  @override
  String toString() {
    return "ID: ${this.id} ${this.title}: ${this.chartType}, \nQuery: ${this.query}\n";
  }
}