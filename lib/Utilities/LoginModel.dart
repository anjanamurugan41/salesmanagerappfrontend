
import 'package:sales_manager_app/Models/UserDetails.dart';

class LoginModel {
  static final LoginModel _singleton = LoginModel._internal();

  factory LoginModel() => _singleton;

  LoginModel._internal(); // private constructor
  var authToken = "";
  bool isNetworkAvailable = true;
  UserDetails userDetails = new UserDetails();
  bool isTutor = false;

  void clearInfo() {
    authToken = "";
    userDetails = null;
  }
}
