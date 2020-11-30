import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:pocketbook/config/firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pocketbook/model/http_exception.dart';

class Auth with ChangeNotifier {
  String _userId;
  String _authToken;
  DateTime _expiryDate;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _authToken != null) {
      return _authToken;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlPart) async {
    try {
      final url =
          "https://identitytoolkit.googleapis.com/v1/accounts:$urlPart?key=$apiKey";
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));
      final decodedResponse = json.decode(response.body);
      if (decodedResponse['error'] != null) {
        throw HttpException(decodedResponse['error']['message']);
      }
      _userId = decodedResponse['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(decodedResponse['expiresIn'])));
      _authToken = decodedResponse['idToken'];
      _autoLogout();
      notifyListeners();
      final userData = json.encode({
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
        'authToken': _authToken
      });
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userData', userData);
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _userId = null;
    _expiryDate = null;
    _authToken = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('usedData');
    prefs.clear();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final decodedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(decodedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _authToken = decodedUserData['authToken'];
    _expiryDate = expiryDate;
    _userId = decodedUserData['userId'];

    notifyListeners();
    _autoLogout();
    return true;
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }

    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;

    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
