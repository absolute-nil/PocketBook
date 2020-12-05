import 'package:flutter/material.dart';
import 'package:pocketbook/providers/auth.dart';
import 'package:pocketbook/screens/book_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/book.dart';

class BookItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final int duration;
  // final int size;
  // final String imageUrl;

  // BookItem({
  //   @required this.id,
  //   @required this.title,
  //   @required this.imageUrl,
  //   @required this.duration,
  //   @required this.size,
  // });

  // void _selectBook(BuildContext context) {
  //   Navigator.of(context).pushNamed(BookDetailScreen.id, arguments: book.id);
  // }

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    final book = Provider.of<Book>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(BookDetailScreen.id, arguments: book.id);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
        margin: EdgeInsets.all(10),
        child: Column(children: <Widget>[
          Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: Image.network(
                  book.imageUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 20,
                right: 10,
                child: Container(
                  width: 300,
                  color: Colors.black54,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Text(
                    book.title,
                    style: TextStyle(color: Colors.white, fontSize: 26),
                    softWrap: true,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.schedule),
                    SizedBox(
                      width: 6,
                    ),
                    Text('${book.duration} min'),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.arrow_circle_down_outlined),
                    SizedBox(
                      width: 6,
                    ),
                    Text("${book.size} KB"),
                  ],
                ),
                Consumer<Book>(
                  builder: (ctx, book, child) => Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(book.isFavourite
                            ? Icons.favorite
                            : Icons.favorite_border),
                        onPressed: () async {
                          try {
                            await book.toggleFavourite(auth.token, auth.userId);
                          } catch (e) {
                            scaffold.showSnackBar(SnackBar(
                                content: Text(
                              e.toString(),
                              textAlign: TextAlign.center,
                            )));
                          }
                        },
                        color: Theme.of(context).accentColor,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text("Save"),
                    ],
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
