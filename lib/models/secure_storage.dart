import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bechan/services/user_service.dart';

class SecureStorage {

  final _secureStorage = const FlutterSecureStorage();
  
  Future<void> saveToken(String token) async {
    print("[_DB_] : ----(start) [Save]");
    print("[_DB_] : Saved!");
    if (token != await _secureStorage.read(key: 'auth_token')) {
      print("[_DB_] : new token :)");
    }
    print("[_DB_] : ----(end)");
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    print("[_DB_] : ----(start) [Get]");
    print("[_DB_] : Get a token! -> ");
    print(await _secureStorage.read(key: 'auth_token') != null ? "[_DB_] : have token" : "[_DB_] : token is empty");
    print("[_DB_] : ----(end)");
    return await _secureStorage.read(key: 'auth_token');
  }

  Future<void> deleteToken() async {
    print("[_DB_] : ----(start) [Delete]");
    print("[_DB_] : Deleted!");
    print("[_DB_] : ----(end)");
    await _secureStorage.delete(key: 'auth_token');
  }

  Future<bool> isTokenValid() async {
    print("[_DB_] : ----(start) [Check]");
    if (await _secureStorage.read(key: 'auth_token') == null) {
      print("[_DB_] : token is Empty");
      print("[_DB_] : ----(end)");
      return false;
    }
    print("[_DB_] : token is EXIST");
    dynamic response = await UserService().fetch();
    print("[_DB_] : response STATUS");
    if (response.status == "error" || response.status == "ERR_CONNECTION") { 
      print("[_DB_] : ${response.status} : ${response.message}");
      print("[_DB_] : ----(end)");
      return false;
    }
    print("[_DB_] : Token is OK!");
    print("[_DB_] : ----(end)");
    return true;
  }
}



/* TAGS

{id, NAME, income}


*/