// ignore_for_file: unrelated_type_equality_checks

class User {
  int? id;
  String? token;

  User ({
    this.id,
    this.token
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      token: json['token'],
      // cityName: json['name'],
      // temperature: json['main']['temp'].toDouble(),
      // mainCondition: json['weather'][0]['main']
    );
  }
}

class Status {
  String status;
  String message;
  String token;

  Status({
    String ? status,
    String ? message,
    String ? token,
  })
  :
    status =status ?? "" ,
    message =message ?? "" ,
    token =token ?? "" 
  ;

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
        status: json['status'].runtimeType == "String" ? json['status']: json['status'].toString(),
        message: json['message'].runtimeType == "String" ? json['message']: json['message'].toString(),
        token: json['token'].runtimeType == "String" ? json['token']: json['token'].toString(),
      );
  }

  Map<String, dynamic> toObject(){
    return {
      'status' : status,
      'message' : message,
      'token' : token,
    };
  }
}