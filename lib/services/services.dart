import 'dart:convert';
import 'package:rest_api/models/user.dart';

import 'package:http/http.dart' as http;

class UsersService {
  static const _url = 'https://gorest.co.in/public/v2/users';
  static const _token =
      'Bearer 80e80c7662c51b1cec7cbae1f327a25c5defaaadc507a05f57318d7893093b4b';
  static const _headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': _token,
  };

  static Future<bool> deleteUser(int id) async {
    final uri = Uri.parse('$_url/$id');
    final response = await http.delete(uri, headers: _headers);

    return response.statusCode == 204;
  }

  static Future<bool> updateUser(int id, User user) async {
    final uri = Uri.parse('$_url/$id');
    final body = jsonEncode(user);
    final response = await http.put(uri, body: body, headers: _headers);

    return response.statusCode == 200;
  }

  static Future<bool> addUser(User user) async {
    print("dsfkjhslfgjhdfljkhfgd");
    final uri = Uri.parse(_url);
    final body = jsonEncode(user);
    final response = await http.post(uri, body: body, headers: _headers);
    print(response.body);
    return response.statusCode == 201;
  }

  static Future<List<User>?> getUsers() async {
    final uri = Uri.parse(_url);
    final response = await http.get(uri, headers: _headers);
    // debugPrint(response.body);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body.map<User>((json) => User.fromJson(json)).toList();
    }
    return null;
  }
}
