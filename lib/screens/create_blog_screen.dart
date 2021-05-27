import 'dart:async';
import 'dart:io';

import 'package:blog_app/controllers/blogs_controller.dart';
import 'package:blog_app/models/blog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreateBlogScreen extends StatefulWidget {
  final Blog blog;
  const CreateBlogScreen({this.blog});
  @override
  _CreateBlogScreenState createState() => _CreateBlogScreenState();
}

class _CreateBlogScreenState extends State<CreateBlogScreen> {
  File file;
  String title;
  String author;
  String content;
  bool isUploading = false;

  final formkey = GlobalKey<FormState>();

  Future<void> update(BuildContext context, {bool draft}) async {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      FocusScope.of(context).unfocus();
      setState(() {
        isUploading = true;
      });
      final blogId = Uuid().v4();
      final blogsController =
          Provider.of<BlogsController>(context, listen: false);
      final url = widget.blog != null && file == null
          ? widget.blog.imageUrl
          : await blogsController.saveImage(file, blogId);
      if (widget.blog != null)
        blogsController.removeBlog(widget.blog.id, draft: true);
      final blog = Blog(
        id: blogId,
        title: title,
        author: author,
        content: content,
        imageUrl: url,
        timestamp: DateTime.now().toString(),
      );
      draft
          ? await blogsController.postDraft(blog)
          : await blogsController.postBlog(blog);
      setState(() {
        isUploading = false;
        file = null;
        form.reset();
      });
      final snackbar = SnackBar(
        content: !draft ? Text('Blog Created!') : Text('Draft Saved!'),
        duration: Duration(milliseconds: 500),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      if (widget.blog != null) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final blog = widget.blog;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Create Blog'),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              if (isUploading) LinearProgressIndicator(),
              Form(
                key: formkey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: GestureDetector(
                          child: file != null
                              ? Image.file(file)
                              : blog != null
                                  ? Image.network(blog.imageUrl)
                                  : Icon(
                                      Icons.camera_alt_rounded,
                                      color: Colors.grey,
                                      size: 60,
                                    ),
                          onTap: () async {
                            final pickerFile = await ImagePicker()
                                .getImage(source: ImageSource.gallery);
                            setState(() {
                              file = File(pickerFile.path);
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Title",
                        style: TextStyle(color: Colors.blue),
                      ),
                      TextFormField(
                        validator: (val) {
                          if (val.trim().length < 3) {
                            return 'Title too short!';
                          } else if (val.trim().length > 50) {
                            return 'Title too big!';
                          }
                          return null;
                        },
                        onSaved: (val) => title = val,
                        initialValue: blog != null ? blog.title : null,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12),
                        child: const Text(
                          "Write your content ...",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      TextFormField(
                        onSaved: (val) => content = val,
                        initialValue: blog != null ? blog.content : null,
                        maxLines: 4,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12),
                        child: const Text(
                          "Display Name",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      TextFormField(
                        validator: (val) {
                          if (val.trim().length > 50) return 'Name too big!';
                          return null;
                        },
                        initialValue: blog != null ? blog.author : null,
                        onSaved: (val) => author = val,
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () => update(context, draft: false),
                child: const Text('Upload'),
              ),
              TextButton(
                onPressed: () => update(context, draft: true),
                child: const Text('Save as draft'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
