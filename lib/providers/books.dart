import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pocketbook/config/firebase.dart';
import 'package:pocketbook/data/books.dart';
import 'package:pocketbook/model/http_exception.dart';

import './book.dart';

class Books with ChangeNotifier {
  List<Book> _items = []; //= [...BooksData];

  final String authToken;
  final String userId;

  Books(this.authToken, this.userId, this._items);

  List<Book> get items {
    return [..._items];
  }

  List<Book> get favouriteItems {
    return _items.where((item) => item.isFavourite).toList();
  }

  Book findById(String id) {
    return _items.firstWhere((book) => book.id == id);
  }

  // void showFavouritesOnly(){
  //   _showFavouriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll(){
  //   _showFavouriteOnly = false;
  //   notifyListeners();
  // }

  Future<void> updateBook(String id, Book book) async {
    final url = "$firebaseUrl/books/$id.json?auth=$authToken";

    final bookIndex = _items.indexWhere((book) => book.id == id);
    if (bookIndex >= 0) {
      try {
        await http.patch(url,
            body: json.encode({
              'title': book.title,
              'description': book.description,
              'size': book.size,
              'imageUrl': book.imageUrl,
              'author': book.author,
              'duration': book.duration,
              'downloadUrl': book.downloadUrl,
              'subject': book.subject,
            }));
      } catch (e) {
        throw e;
      }
      _items[bookIndex] = book;
    } else {
      print("invalid");
    }

    notifyListeners();
  }

  Future<void> fetchAndSetBooks({String subjectId = ""}) async {
    final filterString =
        subjectId.isNotEmpty ? 'orderBy="subject"&equalTo="$subjectId"' : "";
    var url = '$firebaseUrl/books.json?auth=$authToken&$filterString';
    print("URL");
    print(url);
    try {
      final response = await http.get(Uri.encodeFull(url));
      final decodedResponse =
          json.decode(response.body) as Map<String, dynamic>;
      print(decodedResponse);
      final List<Book> loadedBooks = [];
      if (decodedResponse == null) {
        return;
      }
      url = '$firebaseUrl/userFavourites/$userId.json?auth=$authToken';
      final userResponse = await http.get(url);
      final decodedUserResponse = json.decode(userResponse.body);
      print(decodedUserResponse);
      decodedResponse.forEach((bookId, bookdata) {
        loadedBooks.add(Book(
            id: bookId,
            title: bookdata['title'],
            description: bookdata['description'],
            imageUrl: bookdata['imageUrl'],
            isFavourite: decodedUserResponse == null
                ? false
                : decodedUserResponse[bookId] ?? false,
            author: bookdata['author'],
            duration: bookdata['duration'],
            downloadUrl: bookdata['downloadUrl'],
            subject: bookdata['subject'],
            size: bookdata['size']));
      });
      _items = loadedBooks;
      notifyListeners();
    } catch (e) {
      print("error");
      print(e.toString());
    }
  }

  // Future<void> setBooks() async {
  //   final url = "$firebaseUrl/books.json?auth=$authToken";
  //   try {
  //     BOOK_DATA.forEach((Book book) async {
  //       final response = await http.post(url,
  //           body: json.encode({
  //             'title': book.title,
  //             'description': book.description,
  //             'imageUrl': book.imageUrl,
  //             'creatorId': userId,
  //             'author': book.author,
  //             'duration': book.duration,
  //             'downloadUrl': book.downloadUrl,
  //             'subject': book.subject,
  //             'size': book.size
  //           }));
  //       print(json.decode(response.body));
  //     });
  //   } catch (error) {
  //     print("error in add book" + error.toString());
  //     throw error;
  //   }
  // }

  Future<void> addBook(Book book) async {
    final url = "$firebaseUrl/books.json?auth=$authToken";
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': book.title,
            'description': book.description,
            'imageUrl': book.imageUrl,
            'creatorId': userId,
            'author': book.author,
            'duration': book.duration,
            'downloadUrl': book.downloadUrl,
            'subject': book.subject,
            'size': book.size
          }));

      final newBook = Book(
          id: json.decode(response.body)['name'],
          title: book.title,
          description: book.description,
          imageUrl: book.imageUrl,
          author: book.author,
          duration: book.duration,
          downloadUrl: book.downloadUrl,
          subject: book.subject,
          size: book.size);
      _items.add(newBook);
      notifyListeners();
    } catch (error) {
      print("error in add book" + error.toString());
      throw error;
    }
  }

  Future<void> deleteBook(String id) async {
    final url = "$firebaseUrl/books/$id.json?auth=$authToken";

    final deletedBookIndex = _items.indexWhere((book) => book.id == id);
    var deletedBook = _items[deletedBookIndex];
    _items.removeWhere((book) => book.id == id);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(deletedBookIndex, deletedBook);
      notifyListeners();
      throw HttpException('Could not delete book');
    }
    deletedBook = null;
  }
}
