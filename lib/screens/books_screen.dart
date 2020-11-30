import 'package:flutter/material.dart';
import 'package:pocketbook/providers/books.dart';
import 'package:pocketbook/widgets/app_drawer.dart';
import 'package:pocketbook/widgets/books_grid.dart';
import 'package:provider/provider.dart';

class BooksScreen extends StatefulWidget {
  static const id = '/books-screen';

  @override
  _BooksScreenState createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  var _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(Duration.zero).then((_) {
      final subjectId = ModalRoute.of(context).settings.arguments as String;
      print("Subject id recieved");
      print(subjectId);
      Provider.of<Books>(context, listen: false)
          .fetchAndSetBooks(subjectId: subjectId)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select A Book"),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : BooksGrid(false),
    );
  }
}
