import 'dart:convert';
import 'dart:io';
import 'package:bechan/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:bechan/config.dart' as config;
// import 'package:flutter_client_sse/flutter_client_sse.dart';

class ApiService {

  Future<dynamic> callApi(String method, String endPoint, dynamic data) async {
    print('[API] $method, $endPoint, $data');
    try {
      dynamic response;
      if (method == 'get') {
        response = await _get(endPoint, data);
      } else if (method == 'post') {
        response = await _post(endPoint, data);
      } else if (method == 'put') {
        response = await _put(endPoint, data);
      } else if (method == 'delete') {
        response = await _delete(endPoint, data);
      } else {
        print('[API] : unknown type : $method');
      }

      if (response.statusCode != 200) {
        print('[API] : status Error');
        print(response.statusCode);
        // print(response.body);
        return null;
      }
      return response;
    } catch (e) {
      print('[API] : Error during API call >> \n"$e"\n\n');
      return null;
    }
  }

  Future<http.Response> _post(String endPoint, dynamic data) async {
    dynamic response = await http.post(
        Uri.parse('${config.BASE_URL}/$endPoint'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${config.USER_DATA.token}',
        },
        body: jsonEncode(data),
      );
    return response;
  }

  Future<http.Response> _get(String endPoint, dynamic data) async {
    dynamic response = await http.get(
      Uri.parse('${config.BASE_URL}/$endPoint$data'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${config.USER_DATA.token}',
      },
    );
    return response;
  }

  Future<http.Response> _put(String endPoint, dynamic data) async {
    dynamic response = await http.put(
      Uri.parse('${config.BASE_URL}/$endPoint'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${config.USER_DATA.token}',
      },
      body: jsonEncode(data),
    );
    return response;
  }

  Future<http.Response> _delete(String endPoint, dynamic data) async {
    dynamic response = await http.delete(
      Uri.parse('${config.BASE_URL}/$endPoint'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${config.USER_DATA.token}',
      },
      body: jsonEncode(data),
    );
    return response;
  }

}

class ApiFileService {
  Future<dynamic> callApi(String method, String endPoint, dynamic data) async {
    print('[API]-file $method, $endPoint, $data');
    try {
      dynamic response;
      if (method == 'post') {
        response = await _post(endPoint, data);
      } else {
        print('[API]-file : unknown type : $method');
      }

      if (response.statusCode != 200) {
        print('[API]-file : status Error');
        print(response.statusCode);
        print(response.body);
        return null;
      }
      return response;
    } catch (e) {
      print('[API]-file : Error during API call >> \n"$e"\n\n');
      return null;
    }
  }
  
  Future<dynamic> _post(String endPoint, dynamic data) async {
    var request = http.MultipartRequest('POST', Uri.parse('${config.BASE_URL}/$endPoint'));
    File file = File(data.path!);
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer ${config.USER_DATA.token}',
    });
    var fileStream = http.ByteStream(file.openRead());
    var fileLength = await file.length();
    var multipartFile = http.MultipartFile(
      'file',
      fileStream,
      fileLength,
      filename: data.name,
    );
    request.files.add(multipartFile);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    return response;
  }
}

// class ApiSseService {
//   Future<dynamic> callApi(String method, String endPoint, dynamic data) async {
//   print('[API]-SSE $method, $endPoint, $data');
//     try {
//       dynamic response;
//       if (method == 'get') {
//         response = await _get(endPoint, data);
//       } else {
//         print('[API]-SSE : unknown type : $method');
//       }

//       if (response.statusCode != 200) {
//         print('[API]-SSE : status Error');
//         print(response.statusCode);
//         print(response.body);
//         return null;
//       }
//       return response;
//     } catch (e) {
//       print('[API]-SSE : Error during API call >> \n"$e"\n\n');
//       return null;
//     }
//   }

//   _get(endPoint, data){

//   }
// }

Status errorApiService() {
  return Status(status: 'ERR_CONNECTION', message: 'Connection error');
}