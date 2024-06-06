class User {
  int? id;
  String? username; 
  String? password; 
  String? token;

  User ({
    this.id,
    this.username,
    this.password,
    this.token
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      token: json['token'],
      username: json['username'],
      password: json['password'],
      // cityName: json['name'],
      // temperature: json['main']['temp'].toDouble(),
      // mainCondition: json['weather'][0]['main']
    );
  }
}

class Status {
  final String status;
  final String message;
  // final String ? token;

  const Status({
    required this.status,
    required this.message,
    // required this.token,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'status': String status,
        'message': String message,
        // 'token': String ? token,
      } =>
        Status(
          status: status,
          message: message,
          // token: token,
        ),
      _ => throw const FormatException('Failed to load user.'),
    };
  }
}