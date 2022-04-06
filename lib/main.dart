import 'package:flutter/material.dart';
import './models/authentication.dart';
import './screen/home_screen.dart';
import './screen/login_screen.dart';
import './screen/signup_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (ctx) => Authentication())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Login App",
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
        home: LoginScreen(),
        routes: {
          SignupScreen.routeName: (ctx) => SignupScreen(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
        },
      ),
    );
  }
}
