import 'package:blog_app/views/create_blog_screen.dart';
import 'package:blog_app/views/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pageIndex = 0;
  PageController pageController = PageController();
  void changePage(int i) {
    setState(() {
      pageIndex = i;
      pageController.jumpToPage(i);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: changePage,
        children: [
          const MainScreen(0),
          CreateBlogScreen(),
          const MainScreen(2),
        ],
        controller: pageController,
      ),
      bottomNavigationBar: CupertinoTabBar(
        onTap: changePage,
        currentIndex: pageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
          ),
        ],
      ),
    );
  }
}
