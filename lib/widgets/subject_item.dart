import 'package:flutter/material.dart';
import 'package:pocketbook/screens/book_detail_screen.dart';
import 'package:pocketbook/screens/books_screen.dart';

class SubjectItem extends StatelessWidget {
  final String id;
  final String title;

  const SubjectItem({Key key, this.id, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print("id");
    print(this.id);
    return InkWell(
      splashColor: Colors.amber,
      onTap: () =>
          Navigator.of(context).pushNamed(BooksScreen.id, arguments: this.id),
      child: Container(
        height: 70,
        margin: EdgeInsets.only(right: 5),
        padding: EdgeInsets.only(left: 10, right: 10, top: 3),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          shadowColor: Colors.amber,
          child: ListTile(
            title: Text(
              title,
              style: TextStyle(color: Colors.blueGrey),
            ),
          ),
        ),
      ),
    );
  }
}
