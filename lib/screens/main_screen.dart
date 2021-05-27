import 'package:blog_app/controllers/blogs_controller.dart';
import 'package:blog_app/screens/blog_screen.dart';
import 'package:blog_app/screens/create_blog_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  final int index;
  const MainScreen(this.index, {Key key1}) : super(key: key1);
  @override
  Widget build(BuildContext context) {
    // final TextTheme textTheme = Theme.of(context).textTheme;
    final blogsController =
        Provider.of<BlogsController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: index == 0 ? Text('Blogs') : Text('Drafts'),
      ),
      body: StreamBuilder(
        stream: index == 0
            ? blogsController.fetchBlogs()
            : blogsController.fetchDrafts(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final blogs = snapshot.data;
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: blogs.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                      child: ListTile(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => this.index == 0
                                ? BlogScreen(blog: blogs[index])
                                : CreateBlogScreen(blog: blogs[index]),
                          ),
                        ),
                        leading: Container(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: Center(
                                child: Image.network(blogs[index].imageUrl))),
                        title: Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Text(
                            blogs[index].title,
                            style: TextStyle(
                                fontFamily: 'Indie Flower',
                                fontWeight: FontWeight.w600,
                                fontSize: 20),
                          ),
                        ),
                        subtitle: Text(
                          DateFormat('MMMM d, yyyy').format(
                                  DateTime.parse(blogs[index].timestamp)) +
                              ' - ' +
                              blogs[index].author,
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.more_vert),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  'Delete Blog',
                                  style: TextStyle(color: Colors.red),
                                ),
                                content:
                                    Text('Do you want to delete this blog?'),
                                actions: [
                                  TextButton(
                                    child: Text(
                                      'YES',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () {
                                      blogsController.removeBlog(
                                        blogs[index].id,
                                        draft: this.index != 0,
                                      );
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: Text('NO'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
