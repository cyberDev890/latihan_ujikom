import 'package:flutter/material.dart';
import 'package:lat_ujikom/home.dart';
import 'package:lat_ujikom/register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Login')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context) => MyHomePage()));},
              child: const Text('Login'),
            ),
            SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {Navigator.of(context).push( MaterialPageRoute(builder: (context) => RegisterScreen()));},
              child: const Text('Register Disini'),
            ),
          ],
        ),
      ),
    );
  }
}
