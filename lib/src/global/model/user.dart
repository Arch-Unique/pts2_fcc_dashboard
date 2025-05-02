class User {
  String username,password;

  User(
      {this.username = "Fisayo",this.password=""});
}

class JsonPTSReq {
  String title;
  Map<String,dynamic> data;

  JsonPTSReq(this.title,{this.data=const{}});
}

class JsonPTSRes {
  String title;
  dynamic data;

  JsonPTSRes(this.title,{this.data=const{}});

  factory JsonPTSRes.fromJson(Map<String, dynamic> json){
return JsonPTSRes(json["Type"],data: json["Data"]);
  }
}
