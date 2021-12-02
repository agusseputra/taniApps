
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:tanijaya/Models/errMsg.dart';
import 'package:tanijaya/Services/apiStatic.dart';
import 'package:tanijaya/UI/homePage.dart';
const users = const {
  'sas@gmail.com': '12345',
  'sa@gmail.com': 'hunter',
};
class LoginScreen extends StatelessWidget {
  static var routeName="login";
  late ErrorMSG res;
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String> _authUser(LoginData data) {
    //print('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      var params =  {
        'email':data.name,
        'password':data.password,
        'device_name':'flutterMobile'
      };
      res=await ApiStatic.sigIn(params);
      if (res.success!=true) {
        return res.message;
      }
      return '';
    });
  }

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      logo: 'assets/images/logo.png',
      onLogin: _authUser,
      onSignup: _authUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}