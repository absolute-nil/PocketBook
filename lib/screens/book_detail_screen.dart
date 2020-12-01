import 'package:flutter/material.dart';
import 'package:pocketbook/data/subject_data.dart';
import 'package:pocketbook/providers/books.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BookDetailScreen extends StatefulWidget {
  static const id = '/book-detail-screen';

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final bookId = ModalRoute.of(context).settings.arguments as String;
    final loadedBook =
        Provider.of<Books>(context, listen: false).findById(bookId);
    final subject =
        SUBJECT_DATA.firstWhere((sub) => sub.id == loadedBook.subject).title;
    var top = 0.0;
    Widget _leading() {
      if (top != (MediaQuery.of(context).padding.top + kToolbarHeight))
        return BackButton(color: Colors.black);
      return null;
    }

    _launchURL() async {
      final url = loadedBook.downloadUrl;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      // appBar: AppBar(title: ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            // leading: _leading(),
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                top = constraints.biggest.height;
                return FlexibleSpaceBar(
                  title: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(right: 10),
                    color: top !=
                            (MediaQuery.of(context).padding.top +
                                kToolbarHeight)
                        ? Colors.black54
                        : Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        loadedBook.title,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  background: Hero(
                      tag: loadedBook.id,
                      child: Image.network(
                        loadedBook.imageUrl,
                        fit: BoxFit.cover,
                      )),
                );
              },
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              alignment: Alignment.topLeft,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "  Subject :",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w500),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.blueAccent, width: 2)),
                      child: Text(
                        "$subject",
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              alignment: Alignment.topLeft,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "  Title :",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w500),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.blueAccent, width: 2)),
                      child: Text(
                        "${loadedBook.title}",
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 25,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ]),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              alignment: Alignment.topLeft,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "  Author :",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w500),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.blueAccent, width: 2)),
                      child: Text(
                        "${loadedBook.author}",
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ]),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              alignment: Alignment.topLeft,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "  Description :",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w500),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.blueAccent, width: 2)),
                      child: Text(
                        "${loadedBook.description}",
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                        softWrap: true,
                      ),
                    ),
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: _launchURL,
              child: Container(
                color: Colors.pinkAccent,
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.download_outlined,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Download",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 800,
            )
          ]))
        ],
      ),
    );
  }
}
