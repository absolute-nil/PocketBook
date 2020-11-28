import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class ProflieScreen extends StatefulWidget {
  static const String id = 'profile_screen';

  @override
  _ProflieScreenState createState() => _ProflieScreenState();
}

class _ProflieScreenState extends State<ProflieScreen> {
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('PocketBook'),
        backgroundColor: Colors.lightBlueAccent,
      ),
    );
  }
}
