import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pocketbook/config/firebase.dart';
import 'package:pocketbook/model/http_exception.dart';

class Profile with ChangeNotifier {
  String id;
  String name;
  String rollno;
  String year;
  final String authToken;
  final String userId;
  Profile(
    this.authToken,
    this.userId,
  );

  Future<void> addProfile(Profile profile) async {
    final url = "$firebaseUrl/profiles.json?auth=$authToken";
    try {
      final response = await http.post(url,
          body: json.encode({
            'name': profile.name,
            'rollno': profile.rollno,
            'userId': profile.userId,
            'year': profile.year
          }));

      this.id = json.decode(response.body)['id'];
      this.name = profile.name;
      this.rollno = profile.rollno;

      notifyListeners();
    } catch (error) {
      print("error in add profile" + error.toString());
      throw error;
    }
  }

  Future<void> getProfile() async {
    var url = '$firebaseUrl/profiles/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final decodedResponse = json.decode(response.body) as Map<String, dynamic>;
    if (decodedResponse == null) {
      return;
    }

    this.name = decodedResponse['name'];
    this.rollno = decodedResponse['rollno'];
    this.year = decodedResponse['year'];

    notifyListeners();
  }
}
