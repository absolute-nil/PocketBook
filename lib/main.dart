import 'package:flutter/material.dart';
import 'package:pocketbook/providers/auth.dart';
import 'package:pocketbook/providers/books.dart';
import 'package:pocketbook/providers/profile.dart';
import 'package:pocketbook/screens/book_detail_screen.dart';
import 'package:pocketbook/screens/book_form_screen.dart';
import 'package:pocketbook/screens/books_screen.dart';
import 'package:pocketbook/screens/favourite_screen.dart';
import 'package:pocketbook/screens/home_screen.dart';
import 'package:pocketbook/screens/splash_screen.dart';
import 'package:pocketbook/screens/subjects_screen.dart';
import 'package:pocketbook/screens/welcome_screen.dart';
import 'package:pocketbook/screens/login_screen.dart';
import 'package:pocketbook/screens/registration_screen.dart';
import 'package:pocketbook/screens/profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Auth()),
          ChangeNotifierProxyProvider<Auth, Books>(
              create: (_) => Books(null, null, []),
              update: (ctx, auth, previousBooks) => Books(
                  auth.token,
                  auth.userId,
                  previousBooks == null ? [] : previousBooks.items)),
          ChangeNotifierProxyProvider<Auth, Profile>(
              create: (_) => Profile(null, null),
              update: (ctx, auth, _) => Profile(
                    auth.token,
                    auth.userId,
                  )),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.pink,
              accentColor: Colors.amber,
              canvasColor: Color.fromRGBO(245, 244, 240, 1),
              fontFamily: 'Raleway',
              textTheme: ThemeData.light().textTheme.copyWith(
                  bodyText1: TextStyle(
                    color: Color.fromRGBO(20, 51, 51, 1),
                  ),
                  bodyText2: TextStyle(
                    color: Color.fromRGBO(20, 51, 51, 1),
                  ),
                  headline6: TextStyle(
                      fontSize: 20,
                      fontFamily: 'RobotoCondensed',
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
            home: auth.isAuth
                ? HomeScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnap) =>
                        authResultSnap.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : WelcomeScreen()),
            routes: {
              WelcomeScreen.id: (context) => WelcomeScreen(),
              LoginScreen.id: (context) => LoginScreen(),
              RegistrationScreen.id: (context) => RegistrationScreen(),
              ProfileScreen.id: (context) => ProfileScreen(),
              SubjectsScreen.id: (context) => SubjectsScreen(),
              HomeScreen.id: (context) => HomeScreen(),
              FavouriteScreen.id: (context) => FavouriteScreen(),
              BookDetailScreen.id: (context) => BookDetailScreen(),
              BooksScreen.id: (context) => BooksScreen(),
              BookFormScreen.id: (context) => BookFormScreen()
            },
          ),
        ));
  }
}
