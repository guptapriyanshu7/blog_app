import 'package:cloud_firestore/cloud_firestore.dart';

class Blog {
  final String id;
  final String title;
  final String author;
  final String content;
  final String imageUrl;
  final String timestamp;

  const Blog(
      {this.timestamp,
      this.id,
      this.content,
      this.title,
      this.author,
      this.imageUrl});

  factory Blog.fromDocument(DocumentSnapshot doc) {
    return Blog(
      id: doc.id,
      title: doc['title'] as String,
      author: doc['author'] as String,
      content: doc['content'] as String,
      imageUrl: doc['imageUrl'] as String,
      timestamp: doc['timestamp'] as String,
    );
  }

  static Map<String, dynamic> fromBlog(Blog blog) {
    return {
      'title': blog.title,
      'author': blog.author,
      'content': blog.content,
      'imageUrl': blog.imageUrl,
      'timestamp': blog.timestamp
    };
  }
}
