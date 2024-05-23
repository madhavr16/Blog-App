import 'dart:io';
import 'package:blog_app/services/crud.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class CreateBlog extends StatefulWidget {
  const CreateBlog({super.key});

  @override
  State<CreateBlog> createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {

  late String authorName, title, description;
  File? selectedImage;
  final picker = ImagePicker();
  bool _isLoading = false;
  CrudMethods crudMethods = CrudMethods();

  Future getImage() async{
    var image = await picker.pickImage(source: ImageSource.gallery);
    if(image == null) return;
    setState(() {
      selectedImage = File(image.path);
    });
  }
  
  uploadBlog() async{
    if(selectedImage != null){
      setState(() {
        _isLoading = true;
      });
      //upload image to firebase storage
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child("blogImages").child("${randomAlphaNumeric(9)}.jpg");

      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);

       await task.whenComplete(() async {
        var downloadUrl = await firebaseStorageRef.getDownloadURL();
        print("this is url $downloadUrl");
        Map<String, String> blogMap = {
          "imgUrl": downloadUrl,
          "authorName": authorName,
          "title": title,
          "description": description
        };
        crudMethods.addData(blogMap).then((result){
          Navigator.pop(context);
        });
      });
    }else{

    }
  }
  

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Flutter', 
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold
              )
            ),
             Text(
              'Blog', 
              style: TextStyle(
                fontSize: 22,
                color: Colors.blue,
                fontWeight: FontWeight.bold 
              )
            ),
          ]
        ),
        actions: <Widget>[
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            onPressed: (){
              uploadBlog();
            }, 
            icon: const Icon(Icons.file_upload),
          )
        ],
      ),
      body: _isLoading? Container(
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ) : Container(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            GestureDetector(
              onTap: (){
                getImage();
              },
              child: selectedImage != null?
               Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                height: 170,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.file(selectedImage!, fit: BoxFit.cover),
                ),
               ):
               Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                height: 170,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.add_a_photo,
                  color: Colors.black45,
                  size: 25,
                ),
              ),
            ),

            const SizedBox(height: 8),
          
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Author Name'
                    ),
                    onChanged: (value){
                      authorName = value;
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Title'
                    ),
                    onChanged: (value){
                      title = value;
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Description'
                    ),
                    onChanged: (value){
                      description = value;
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}