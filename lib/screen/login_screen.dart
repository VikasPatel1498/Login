import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/authentication.dart';
import '../screen/signup_screen.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formkey = GlobalKey();

    Map<String, String> _authData = {
      'email': '',
      'password': '',
    };

    void _showErrorDialog(String msg) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("An Error Occured"),
          content: Text(msg),
          actions: [
            ElevatedButton(
              child: Text("ok"),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    }

    Future<void> _submit() async {
      if (!_formkey.currentState!.validate()) {
        return;
      }
      _formkey.currentState!.save();
      try {
        await Provider.of<Authentication>(context, listen: false).Login(
          _authData['email'] as String,
          _authData['password'] as String,
        );
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      } catch (error) {
        var errorMessage = 'Authentiocation Failed. Please try again later';
        _showErrorDialog(errorMessage);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        actions: [
          FlatButton(
            child: Row(
              children: [Text("Signup"), Icon(Icons.person_add)],
            ),
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(SignupScreen.routeName);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.lightGreenAccent,
                  Colors.blue,
                ],
              ),
            ),
          ),
          Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                height: 260,
                width: 300,
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formkey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: "Email"),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return "Invalid Email";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['email'] = value.toString();
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Password"),
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 4) {
                              return "Invalid Password";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['password'] = value.toString();
                          },
                        ),
                        const SizedBox(height: 30),
                        // ignore: deprecated_member_use
                        RaisedButton(
                          child: const Text(
                            "Submit",
                          ),
                          onPressed: _submit,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: Colors.blue,
                          textColor: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
