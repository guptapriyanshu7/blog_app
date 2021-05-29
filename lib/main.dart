import 'package:blog_app/view_models/blogs_controller.dart';
import 'package:blog_app/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return Provider<BlogsController>.factory(
      (context) => BlogsController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Blog',
        theme: ThemeData(
          fontFamily: 'Roboto',
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: initialization,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Home();
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
