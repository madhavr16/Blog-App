import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BlogsTile extends StatelessWidget {

  String imgUrl, title, description, authorName;

  BlogsTile({
    super.key,
    required this.imgUrl,
    required this.title,
    required this.description,
    required this.authorName
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, top: 16),
      height: 170,
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CachedNetworkImage(
              imageUrl: imgUrl,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              )
          ),
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.black45.withOpacity(0.3),
              borderRadius: BorderRadius.circular(6)
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  title, 
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 25, fontWeight: FontWeight.w500
                  )
                ),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(fontSize: 17)),
                const SizedBox(height: 4),
                Text(authorName, style: const TextStyle(fontSize: 15))
              ],
            ),
          )
        ],
      ),
    );
  }
}