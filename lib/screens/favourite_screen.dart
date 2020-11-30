import 'package:flutter/material.dart';
import 'package:pocketbook/providers/books.dart';
import 'package:pocketbook/widgets/app_drawer.dart';
import 'package:pocketbook/widgets/books_grid.dart';
import 'package:provider/provider.dart';

class FavouriteScreen extends StatefulWidget {
  static const id = '/favourite-screen';

  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  var _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(Duration.zero).then((_) {
      Provider.of<Books>(context, listen: false).fetchAndSetBooks().then((_) {
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
          : BooksGrid(true),
    );
  }
}
