import 'package:blog_app/models/blog.dart';
import 'package:flutter/material.dart';

class BlogScreen extends StatelessWidget {
  final Blog blog;
  const BlogScreen({this.blog, Key key}) : super(key: key);

  SliverAppBar appBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: blog.id,
          child: Image.network(
            blog.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          appBar(),
          SliverPadding(
            padding: EdgeInsets.all(30),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Center(
                      child: Text(
                    blog.title,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Indie Flower'),
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      blog.content,
                      style: TextStyle(fontSize: 15, wordSpacing: 1),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '- ' + blog.author,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Indie Flower'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
