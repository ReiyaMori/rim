import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rim/db_provider.dart';

class ShowPost extends StatelessWidget{
  final Post post;
  const ShowPost({this.post}):super();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(post.getBody),
      ),
    );
  }
}