import 'package:flutter/material.dart';
import 'package:rim/db_provider.dart';
import 'package:rim/main.dart';

class AddPost extends StatelessWidget{
  final TextEditingController _txController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('How was today?'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              child: AspectRatio(
                aspectRatio: 3/2,
                child: Container(
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: TextButton(
                child: Text('Post'),
                onPressed: (){
                  if(_txController.text.isNotEmpty){
                    DBProvider.create(_txController.text);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Archive()),
                            (_) => false);
                  }
                },
              ),
            ),
            SingleChildScrollView(
              child: Container(
                child: TextField(
                  maxLines: null,
                  controller: _txController,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'input'
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}