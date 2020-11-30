import 'package:flutter/material.dart';
import 'package:pocketbook/providers/books.dart';
import 'package:pocketbook/widgets/book_item.dart';
import 'package:provider/provider.dart';

class BooksGrid extends StatelessWidget {
  final bool showFavs;
  BooksGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final booksData = Provider.of<Books>(context);
    final books = showFavs ? booksData.favouriteItems : booksData.items;
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: books[i],
        child: BookItem(),
      ),
      itemCount: books.length,
    );
  }
}
