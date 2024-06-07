// ignore_for_file: unrelated_type_equality_checks
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

class User {
  String username;
  String firstname;
  String lastname;

  User({
    String ? username,
    String ? firstname,
    String ? lastname,
  })
  :
    username = username ?? "" ,
    firstname = firstname ?? "" ,
    lastname = lastname ?? "" 
  ;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['Data']['User']['username'] as String,
      firstname: json['Data']['User']['firstname'] as String,
      lastname: json['Data']['User']['lastname'] as String,
    );
  }

  Map<String, dynamic> toObject(){
    return {
      'username' : username,
      'firstname' : firstname,
      'lastname' : lastname,
    };
  }
}