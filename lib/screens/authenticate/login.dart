import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rsldb/components/extended_button.dart';
import 'package:rsldb/components/horizontal_divider.dart';
import 'package:rsldb/components/input_text_field.dart';
import 'package:rsldb/components/loading.dart';
import 'package:rsldb/helpers/validators.dart';
import 'package:rsldb/routes/application.dart';
import 'package:rsldb/services/auth.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key key}) : super(key: key);

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String email = 'kenneth.j.mcginnis@gmail.com';
  String password = 'Millennia@9';
  String error = '';

  void handleSubmit() async {
    dynamic result;
    if (_formKey.currentState.validate()) {
      setState(() => loading = true);
      result = await _authService.signInWithEmailAndPassword(
        email,
        password,
      );
      Application.router.navigateTo(context, '/', transition: TransitionType.fadeIn);
    }
    if (result == null) {
      setState(() {
        loading = false;
        error = 'Could not sign in with those credentials';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Loading();
    return Material(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 40.0),
                InputTextField(
                  icon: Icons.mail_outline,
                  initialValue: email,
                  keyboardType: TextInputType.emailAddress,
                  labelText: 'Email',
                  onChanged: (value) => setState(() => email = value),
                  validator: Validators.validateEmail,
                ),
                SizedBox(height: 10.0),
                InputTextField(
                  icon: Icons.lock_outline,
                  initialValue: password,
                  labelText: 'Password',
                  obscureText: true,
                  onChanged: (value) => setState(() => password = value),
                  validator: Validators.validatePassword,
                ),
                SizedBox(height: 20.0),
                ExtendedButton(text: 'Sign In', onTap: handleSubmit),
                Text(error, style: TextStyle(color: Theme.of(context).errorColor, fontSize: 14.0)),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: FlatButton(
                    onPressed: () => print('Forgot Password'),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(fontSize: 16.0, decoration: TextDecoration.underline),
                    ),
                  ),
                ),
                HorizontalDivider(text: "OR"),
                Row(
                  key: ValueKey('facebook-google'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, right: 40.0),
                      child: GestureDetector(
                        onTap: () => print("Facebook button pressed"),
                        child: Container(
                          padding: const EdgeInsets.all(15.0),
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: new Icon(
                            FontAwesomeIcons.facebookF,
                            color: Color(0xFF0084ff),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: GestureDetector(
                        onTap: () => print("Google button pressed"),
                        child: Container(
                          padding: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            FontAwesomeIcons.google,
                            color: Color(0xFF0084ff),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
