import 'package:flutter/material.dart';

class Book {
  final String id;
  final String title;
  final String subject;
  final String author;
  final String description;
  final int duration;
  final int size;

  Book(
      {@required this.id,
      @required this.title,
      @required this.subject,
      @required this.author,
      @required this.description,
      @required this.duration,
      @required this.size});
}
