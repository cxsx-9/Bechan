import 'dart:developer';

import 'package:bechan/services/user_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {

  final _secureStorage = const FlutterSecureStorage();
  
  Future<void> saveToken(String token) async {
    log("[_DB_] : ^^ ^^ ^^ ^^ ^^ ^^");
    log("[_DB_] : Saved!");
    if (token != await _secureStorage.read(key: 'auth_token')) {
      log("[_DB_] : new token :)");
    }
    log("[_DB_] : vv vv vv vv vv vv");
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    log("[_DB_] : ^^ ^^ ^^ ^^ ^^ ^^");
    log("[_DB_] : Get a token! -> ");
    log(await _secureStorage.read(key: 'auth_token') != null ? "[_DB_] : have token" : "[_DB_] : token is empty");
    log("[_DB_] : vv vv vv vv vv vv");
    return await _secureStorage.read(key: 'auth_token');
  }

  Future<void> deleteToken() async {
    log("[_DB_] : ^^ ^^ ^^ ^^ ^^ ^^");
    log("[_DB_] : Deleted!");
    log("[_DB_] : vv vv vv vv vv vv");
    await _secureStorage.delete(key: 'auth_token');
  }

  Future<bool> isTokenValid() async {
    log("[_DB_] : ^^ ^^ ^^ ^^ ^^ ^^");
    dynamic response = await UserService().callApi('user', null);
    log("[_DB_] : response STATUS");
    if (response.status == "error" || response.status == "ERR_CONNECTION") { 
      log("[_DB_] : " + response.status + " : " + response.message);
      log("[_DB_] : vv vv vv vv vv vv");
      return false;
    }
    log("[_DB_] : Token is OK!");
    log("[_DB_] : vv vv vv vv vv vv");
    return true;
  }
}



/* TAGS

{id, NAME, income}


*/