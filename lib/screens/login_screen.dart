import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pocketbook/constants.dart';
import 'package:pocketbook/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pocketbook/model/http_exception.dart';
import 'package:pocketbook/providers/auth.dart';
import 'package:pocketbook/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  String email;
  String password;

  void _showErrorDialogue(String error) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("An Error occoured"),
              content: Text(error),
              actions: [
                FlatButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text("Okay"))
              ],
            ));
  }

  void _submit() async {
    setState(() {
      showSpinner = true;
    });
    try {
      // Log user in
      await Provider.of<Auth>(context, listen: false).signin(email, password);
      setState(() {
        showSpinner = false;
      });
      Navigator.of(context).pushReplacementNamed("/");
    } on HttpException catch (error) {
      var errorMessage = "Authentication Failed";
      if (error.toString().contains("EMAIL_EXISTS")) {
        errorMessage = "An account with this email already exists";
      } else if (error.toString().contains("INVALID_EMAIL")) {
        errorMessage = "This email is not valid";
      } else if (error.toString().contains("WEAK_PASSWORD")) {
        errorMessage = "Password is too weak";
      } else if (error.toString().contains("EMAIL_NOT_FOUND")) {
        errorMessage = "Couldnt find a user with that email";
      }
      if (error.toString().contains("INVALID_PASSWORD")) {
        errorMessage = "Invalid Password";
      }
      _showErrorDialogue(errorMessage);
    } catch (error) {
      var errorMessage =
          "could not authenticate you please try again in a while";
      _showErrorDialogue(errorMessage);
    }

    setState(() {
      showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              Text(
                'LOGIN',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    prefixIcon: Icon(Icons.email), hintText: 'Email'),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    prefixIcon: Icon(Icons.lock), hintText: 'Password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Log In',
                colour: Colors.lightBlueAccent,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
