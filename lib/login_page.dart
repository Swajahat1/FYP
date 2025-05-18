import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/forget-password.dart';
import 'package:myapp/home_page.dart';
import 'package:myapp/signup_page.dart';
import 'package:myapp/therapist_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController =
      TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  String? selectedRole;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login(BuildContext context) async {
    if (selectedRole == null) {
      Navigator.pop(context); // close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a role")),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      final userType = selectedRole == "user" ? "users" : "therapists";

      final response = await http.post(
        Uri.parse("http://localhost:3000/api/${userType}/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
            {"email": email, "password": password, "role": selectedRole}),
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
        
      Navigator.pop(context);

      

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
          final userId = responseData['user']['_id'];
            await prefs.setString('userId', userId);

        print("HI");
        print(responseData);
        print("BYE");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                userType == 'users' ?  HomeScreen(userId: responseData['user']['_id']) : TherapistDashboard(therapistId: responseData['user']['_id']),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed: ${response.reasonPhrase}")),
        );
      }
    } catch (error) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $error")),
      );
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "Enter a valid email";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFE29F), Color(0xFFFFC0CB)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _header(),
                const SizedBox(height: 30),
                _inputField(),
                const SizedBox(height: 20),
                _roleSelector(),
                const SizedBox(height: 20),
                _forgotPasswordButton(),
                const SizedBox(height: 10),
                _loginButton(context),
                const SizedBox(height: 20),
                _signup(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      children: const [
        Text(
          "Welcome Back!",
          style: TextStyle(
              fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          "Login to continue",
          style: TextStyle(fontSize: 16, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _inputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: emailController,
          decoration: const InputDecoration(
            hintText: "Email",
            prefixIcon: Icon(Icons.email, color: Colors.purple),
          ),
          validator: validateEmail,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: passwordController,
          obscureText: !isPasswordVisible,
          decoration: InputDecoration(
            hintText: "Password",
            prefixIcon: const Icon(Icons.lock, color: Colors.purple),
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.purple,
              ),
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            ),
          ),
          validator: validatePassword,
        ),
      ],
    );
  }

  Widget _forgotPasswordButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
        );
      },
      child: const Text(
        "Forgot Password?",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await login(context);
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.deepPurple,
      ),
      child: const Text(
        "Login",
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _signup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? ",
            style: TextStyle(color: Colors.black54)),
        TextButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignupPage()));
          },
          child: const Text("Sign Up",
              style:
                  TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _roleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select Role",
            style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text("User"),
                value: "user",
                groupValue: selectedRole,
                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text("therapist"),
                value: "therapist",
                groupValue: selectedRole,
                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
              ),
            ),
          ],
        ),
        if (selectedRole == null)
          const Padding(
            padding: EdgeInsets.only(left: 12.0),
            child: Text("Please select a role",
                style: TextStyle(color: Colors.red)),
          ),
      ],
    );
  }
}



// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:myapp/forget-password.dart';
// import 'package:myapp/home_page.dart';
// import 'package:myapp/signup_page.dart';
// import 'package:myapp/therapist_dashboard.dart'; // Import the therapist dashboard

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool isPasswordVisible = false;
//   bool isLoading = false;

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> login(BuildContext context) async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => const Center(child: CircularProgressIndicator()),
//     );

//     final email = emailController.text.trim();
//     final password = passwordController.text.trim();

//     try {
//       final response = await http.post(
//         Uri.parse("http://localhost:3000/api/users/login"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"email": email, "password": password}),
//       );

//       // Close the loading dialog
//       Navigator.pop(context);
      
//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         final user = responseData['user'];
//         final userRole = user['role'] ?? 'user'; // Default to 'user' if role not specified
        
//         if (userRole == 'therapist') {
//           // Navigate to therapist dashboard
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => TherapistDashboard(therapistId: user['_id']),
//             ),
//           );
//         } else {
//           // Navigate to user home screen
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => HomeScreen(userId: user['_id']),
//             ),
//           );
//         }
//       } else {
//         // Try therapist login if user login fails
//         await tryTherapistLogin(email, password);
//       }
//     } catch (error) {
//       Navigator.pop(context);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("An error occurred: $error")),
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
  
//   Future<void> tryTherapistLogin(String email, String password) async {
//     try {
//       final response = await http.post(
//         Uri.parse("http://localhost:3000/api/therapists/login"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"email": email, "password": password}),
//       );
      
//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         // Navigate to therapist dashboard
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => TherapistDashboard(therapistId: responseData['therapist']['_id']),
//           ),
//         );
//       } else {
//         // Both login attempts failed
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Invalid email or password")),
//         );
//       }
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("An error occurred: $error")),
//       );
//     }
//   }

//   String? validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return "Email is required";
//     }
//     final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//     if (!emailRegex.hasMatch(value)) {
//       return "Enter a valid email";
//     }
//     return null;
//   }

//   String? validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return "Password is required";
//     }
//     if (value.length < 6) {
//       return "Password must be at least 6 characters";
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Color(0xFFFFE29F), Color(0xFFFFC0CB)],
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 _header(),
//                 const SizedBox(height: 30),
//                 _inputField(),
//                 const SizedBox(height: 20),
//                 _forgotPasswordButton(),
//                 const SizedBox(height: 10),
//                 _loginButton(context),
//                 const SizedBox(height: 20),
//                 _signup(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _header() {
//     return Column(
//       children: const [
//         Text(
//           "Welcome Back!",
//           style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
//           textAlign: TextAlign.center,
//         ),
//         SizedBox(height: 10),
//         Text(
//           "Login to continue",
//           style: TextStyle(fontSize: 16, color: Colors.black54),
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }

//   Widget _inputField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         TextFormField(
//           controller: emailController,
//           decoration: const InputDecoration(
//             hintText: "Email",
//             prefixIcon: Icon(Icons.email, color: Colors.purple),
//           ),
//           validator: validateEmail,
//         ),
//         const SizedBox(height: 10),
//         TextFormField(
//           controller: passwordController,
//           obscureText: !isPasswordVisible,
//           decoration: InputDecoration(
//             hintText: "Password",
//             prefixIcon: const Icon(Icons.lock, color: Colors.purple),
//             suffixIcon: IconButton(
//               icon: Icon(
//                 isPasswordVisible ? Icons.visibility : Icons.visibility_off,
//                 color: Colors.purple,
//               ),
//               onPressed: () {
//                 setState(() {
//                   isPasswordVisible = !isPasswordVisible;
//                 });
//               },
//             ),
//           ),
//           validator: validatePassword,
//         ),
//       ],
//     );
//   }

//   Widget _forgotPasswordButton() {
//     return TextButton(
//       onPressed: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
//         );
//       },
//       child: const Text(
//         "Forgot Password?",
//         style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//       ),
//     );
//   }

//   Widget _loginButton(BuildContext context) {
//     return ElevatedButton(
//       onPressed: isLoading ? null : () async {
//         await login(context);
//       },
//       style: ElevatedButton.styleFrom(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         backgroundColor: Colors.deepPurple,
//         disabledBackgroundColor: Colors.deepPurple.withOpacity(0.5),
//       ),
//       child: isLoading 
//         ? const SizedBox(
//             height: 20,
//             width: 20,
//             child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
//           )
//         : const Text(
//             "Login",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//     );
//   }

//   Widget _signup() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Text("Don't have an account? ", style: TextStyle(color: Colors.black54)),
//         TextButton(
//           onPressed: () {
//             Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
//           },
//           child: const Text("Sign Up", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
//         ),
//       ],
//     );
//   }
// }