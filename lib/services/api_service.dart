// import 'dart:convert';

// import 'package:http/http.dart' as http;

// class ApiService {
//   static const String baseUrl = 'http://localhost:3000'; // Backend URL

//   // Signup Function
//   static Future<Map<String, dynamic>> signup(String username, String email, String password, String userType, ) async {
//     final url = Uri.parse('$baseUrl/signup');

//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'username': username, 'email': email, 'password': password, 'role' : ''}),
//       );

//       if (response.statusCode == 201) {
//         return {'success': true, 'message': 'Signup successful'};
//       } else {
//         final data = jsonDecode(response.body);
//         return {'success': false, 'message': data['error'] ?? 'Signup failed'};
//       }
//     } catch (e) {
//       return {'success': false, 'message': 'Error connecting to server'};
//     }
//   }

//   // Login Function
//   static Future<Map<String, dynamic>> login(String username, String password) async {
//     final url = Uri.parse('$baseUrl/login');

//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'username': username, 'password': password}),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return {'success': true, 'token': data['token']};
//       } else {
//         final data = jsonDecode(response.body);
//         return {'success': false, 'message': data['error'] ?? 'Login failed'};
//       }
//     } catch (e) {
//       return {'success': false, 'message': 'Error connecting to server'};
//     }
//   }
// }




import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:3000'; 

  /// Sends signup details to the backend.
  /// [username]: User's name
  /// [email]: User's email
  /// [password]: User's password
  /// [userType]: Role selected (User, Therapist, Admin)
  /// 
  
  static Future<Map<String, dynamic>> signup(
    String username,
    String email,
    String password,
    String userType, {
    String role = '',
  }) async {
    final url = Uri.parse("$baseUrl/api/users/signup");
    

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
          "userType": userType,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {"success": true, "message" : "Click on Login", data: data};
      } else {
        final errorData = jsonDecode(response.body);
        return {"success": false, "": errorData['']};
      }
    } catch (error) {
      return {"success": false, "": ": $error"};
    }
  }
}
