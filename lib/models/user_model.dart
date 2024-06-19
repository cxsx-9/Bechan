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
        token: json['data'] != null ? (json['data']['token'].runtimeType == "String" ? json['data']['token']: json['data']['token'].toString()) : "",
      );
  }

  Map<String, dynamic> toObject(){
    return {
      'status' : status,
      'message' : message,
      'data' : token,
    };
  }
}

class User {
  String status;
  String message;
  String userId;
  String email;
  String firstname;
  String lastname;
  String token;
  // int exp;

  User({
    String ? status,
    String ? message,
    String ? userId,
    String ? email,
    String ? firstname,
    String ? lastname,
    String ? token,
    // int ? exp,
  })
  :
    status = status ?? "" ,
    message = message ?? "" ,
    userId = userId ?? "" ,
    email = email ?? "" ,
    firstname = firstname ?? "" ,
    lastname = lastname ?? "" ,
    token = token ?? ""
    // exp = exp ?? 0
  ;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      status: json['status'] as String,
      message: json['message'] as String,
      userId: json['data'] != null ? (json['data']['user']['user_id'].runtimeType == "String" ? json['data']['user']['user_id']: json['data']['user']['user_id'].toString()) : "",
      email: json['data'] != null ? (json['data']['user']['email'] as String) : "",
      firstname: json['data'] != null ? (json['data']['user']['firstname'] as String) : "",
      lastname: json['data'] != null ? (json['data']['user']['lastname'] as String) : "",
      // exp: json['data'] != null ? (json['data']['user'] != null ? (json['data']['user']['exp'] != null ? json['data']['user']['exp'] as int : 0): 0) : 0,
      token: json['data'] != null ? (json['data']['token'] as String) : "",
    );
  }

  Map<String, dynamic> toObject(){
    return {
      'status' : status,
      'user_id' : userId,
      'email' : email,
      'firstname' : firstname,
      'lastname' : lastname,
      'token' : token,
      // 'exp' : exp,
    };
  }
}