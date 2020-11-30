import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pocketbook/config/firebase.dart';
import 'package:pocketbook/model/http_exception.dart';

class Book with ChangeNotifier {
  final String id;
  final String title;
  final String subject;
  final String author;
  final String description;
  final int duration;
  final int size;
  final String imageUrl;
  final String downloadUrl;
  bool isFavourite;

  Book(
      {@required this.imageUrl,
      @required this.downloadUrl,
      @required this.id,
      @required this.title,
      @required this.subject,
      @required this.author,
      @required this.description,
      @required this.duration,
      @required this.size,
      this.isFavourite = false});

  Future<void> toggleFavourite(String token, String userId) async {
    var previousValue = isFavourite;
    isFavourite = !previousValue;
    notifyListeners();
    final url = "$firebaseUrl/userFavourites/$userId/$id.json?auth=$token";
    try {
      final response = await http.put(url, body: json.encode(!previousValue));
      if (response.statusCode >= 400) {
        throw HttpException('failed to edit favourite status');
      }
      print(response.statusCode);
      previousValue = null;
    } catch (e) {
      print("exception");
      isFavourite = previousValue;
      notifyListeners();
      throw e;
    }
  }
}
