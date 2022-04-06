import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/authentication.dart';
import '../screen/home_screen.dart';
import '../screen/login_screen.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formkey = GlobalKey();
    TextEditingController _passwordController = new TextEditingController();

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
        await Provider.of<Authentication>(context, listen: false).signUp(
          _authData['email'] as String,
          _authData['password'] as String,
        );
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      } catch (error) {
        var errorMessage = 'Authentiocation Failed. Please try again later';
        _showErrorDialog(errorMessage);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Signup"),
        actions: [
          FlatButton(
            child: Row(
              children: [Text("Login"), Icon(Icons.person)],
            ),
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
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
                  Colors.limeAccent,
                  Colors.grey,
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
                height: 300,
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
                          controller: _passwordController,
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
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: "Confirm Password"),
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty ||
                                value != _passwordController.text) {
                              return "Invalid Password";
                            }
                            return null;
                          },
                          onSaved: (value) {},
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
