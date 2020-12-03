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
  String image;
  final String authToken;
  final String userId;
  Profile(
    this.authToken,
    this.userId,
  );

  Future<void> addProfile(
      String name, String rollno, String year, String image) async {
    final url = "$firebaseUrl/profiles.json?auth=$authToken";
    try {
      final response = await http.post(url,
          body: json.encode({
            'name': name,
            'rollno': rollno,
            'userId': this.userId,
            'year': year,
            'image': image
          }));

      this.id = json.decode(response.body)['id'];
      this.name = name;
      this.rollno = rollno;
      this.year = year;
      this.image = image;

      notifyListeners();
    } catch (error) {
      print("error in add profile" + error.toString());
      throw error;
    }
  }

  Future<Map<String, String>> getProfile() async {
    try {
      print(userId);
      final filter = 'orderBy="userId"&equalTo="${userId.toString()}"';
      print(filter);
      String url = '$firebaseUrl/profiles.json?auth=$authToken&$filter';
      print(url);
      final response = await http.get(url);
      final decodedResponse =
          json.decode(response.body) as Map<String, dynamic>;
      if (decodedResponse == null) {
        return null;
      }

      decodedResponse.forEach((profileId, profileData) {
        this.name = profileData['name'];
        this.rollno = profileData['rollno'];
        this.year = profileData['year'];
        this.image = profileData['image'];
      });

      var returnProfile = new Map<String, String>();
      returnProfile['name'] = this.name;
      returnProfile['year'] = this.year;
      returnProfile['rollno'] = this.rollno;
      returnProfile['image'] = this.image;

      notifyListeners();

      return returnProfile;
    } catch (e) {
      print("error in getting profile" + e.toString());
    }
    return null;
  }
}
