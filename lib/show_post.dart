import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rim/db_provider.dart';
import 'package:rim/edit_post.dart';
import 'package:rim/main.dart';

class ShowPost extends StatelessWidget{
  final Post post;
  const ShowPost({this.post}):super();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 100,),
              Container(
                alignment: Alignment.topRight,
                width: double.infinity,
                child: TextButton(
                  child: Text('Edit'),
                  onPressed: (){
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => EditPost(post: post)),
                            (_) => false);
                  },
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Material(
                  elevation: 10,
                  child: Image.network(url[post.getId]),
                )
              ),
              SizedBox(height: 20,),
              Container(
                child: Text(
                  post.getBody
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}