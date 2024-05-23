import 'dart:async';

import 'package:blog_app/components/my_blogs_tile.dart';
import 'package:blog_app/services/crud.dart';
import 'package:blog_app/views/create_blog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CrudMethods crudMethods = CrudMethods();
  Stream<QuerySnapshot>? blogsStream;

  Widget blogList() {
    return Container(
      child: blogsStream != null
          ? Column(
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                  stream: blogsStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return BlogsTile(
                          imgUrl: snapshot.data!.docs[index].get('imgUrl'),
                          title: snapshot.data!.docs[index].get('title'),
                          description: snapshot.data!.docs[index].get('description'),
                          authorName: snapshot.data!.docs[index].get('authorName'),
                        );
                      },
                    );
                  },
                )
              ],
            )
          : Container(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }

  @override
  void initState() {
    super.initState();

    crudMethods.getData().then((result) {
      setState(() {
        blogsStream = result;
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Flutter',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              'Blog',
              style: TextStyle(fontSize: 22, color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(child: blogList()),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: Colors.blue,
              hoverColor: Colors.blue[900],
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateBlog()));
              },
              child: const Icon(
                Icons.add,
              ),
            ),
          ],
        ),
      ),
    );
  }
}