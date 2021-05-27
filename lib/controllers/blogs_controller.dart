import 'dart:io';

import 'package:blog_app/models/blog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';

class BlogsController {
  final _blogsRef = FirebaseFirestore.instance.collection('blogs');
  final _draftsRef = FirebaseFirestore.instance.collection('drafts');

  Stream<List<Blog>> fetchBlogs() {
    return _blogsRef.snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => Blog.fromDocument(doc)).toList(),
        );
  }

  Stream<List<Blog>> fetchDrafts() {
    return _draftsRef.snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => Blog.fromDocument(doc)).toList(),
        );
  }

  Future<String> saveImage(File file, String blogId) async {
    if (file != null) {
      final dir = await getTemporaryDirectory();
      final path = dir.path;
      final image = decodeImage(file.readAsBytesSync());
      final compressedImage = File('$path/img_$blogId.jpg')
        ..writeAsBytesSync(
          encodeJpg(image, quality: 70),
        );
      final snap = await FirebaseStorage.instance
          .ref('img_$blogId.jpg')
          .putFile(compressedImage);
      return snap.ref.getDownloadURL();
    }
    return 'https://images.unsplash.com/photo-1500485035595-cbe6f645feb1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NHx8fGVufDB8fHx8&w=1000&q=80';
  }

  Future<void> postBlog(Blog blog) async {
    await _blogsRef.doc(blog.id).set(Blog.fromBlog(blog));
  }

  Future<void> postDraft(Blog blog) async {
    await _draftsRef.doc(blog.id).set(Blog.fromBlog(blog));
  }

  Future<void> removeBlog(String id, {@required bool draft}) async {
    if (draft)
      await _draftsRef.doc(id).delete();
    else
      await _blogsRef.doc(id).delete();
  }
}
