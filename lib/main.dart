import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rim/add_post.dart';
import 'package:rim/db_provider.dart';
import 'package:rim/main_model.dart';
import 'package:rim/show_post.dart';


void main()=>runApp(new MyApp());



class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'rim',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'GenEiKoburi'
      ),
      home: Archive(),

    );
  }
}

class Archive extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider(
      create: (_)=>MainModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: FutureBuilder(
                  future: DBProvider.getAll(),
                  builder:(BuildContext context, AsyncSnapshot snapshot) {
                    int gridCount = context.select((MainModel value) =>
                    value.currentSliderValue).toInt();
                    if (!snapshot.hasData) {
                      return Center(child: Text('no item'),);
                    } else {
                      return GridView.count(
                        crossAxisCount: gridCount,
                        children: List.generate(snapshot.data.length, (index) => _Rim(post: snapshot.data[index]))
                        ,
                      );
                    }
                  }
                ),
              )
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: _GridSlider(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: Icon(Icons.add,color: Colors.grey,),
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddPost()));
          },
        ),
      ),
    );
  }
}

class _GridSlider extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    double _currentSliderValue = context
        .select((MainModel value) => value.currentSliderValue);

    // TODO: implement build
    return Container(
      height: 100,
      padding: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(
              blurRadius: 4,
              color: Colors.grey
          )]
      ),
      child: Slider(
        value: _currentSliderValue,
        min: 1,
        max: 10,
        divisions: 9,
        // label: _currentSliderValue.round().toString(),/*いらない？？*/
        onChanged: (value){
          context.read<MainModel>().changeSlider(value);
        },
        activeColor: Color(0xFF0A0A0A),
        inactiveColor: Colors.grey,
      ),
    );
  }
}

final List url = [
  'https://pro2-bar-s3-cdn-cf4.myportfolio.com/c5cab9ad-7bfc-47d4-9c71-feeeab8bf97d/f7fe0671-eae4-4b66-8aa2-ae0519279a5c_rw_1920.jpg?h=3df818a92f73c21875c39fad9b1ca8b1',
  'https://pro2-bar-s3-cdn-cf2.myportfolio.com/c5cab9ad-7bfc-47d4-9c71-feeeab8bf97d/31310ead-c642-4aaf-9cdc-b1c23b695410_rw_1920.jpg?h=2d4c726747edbac689d07f03839dc39c',
  'https://pro2-bar-s3-cdn-cf2.myportfolio.com/c5cab9ad-7bfc-47d4-9c71-feeeab8bf97d/da45a202-cce7-4052-b5ab-3e7fc5ae8c7a_rw_1920.jpg?h=210fe85b738ca839dfeff04e5d73b72b',
  'https://pro2-bar-s3-cdn-cf3.myportfolio.com/c5cab9ad-7bfc-47d4-9c71-feeeab8bf97d/44d4c2e5-38bb-493f-a116-6c2588f90560_rw_1920.jpg?h=44f3e7be4840f9dd02515f4049928b52',
  'https://pro2-bar-s3-cdn-cf3.myportfolio.com/c5cab9ad-7bfc-47d4-9c71-feeeab8bf97d/ec8a4828-728b-40e7-8eac-823940e9eb0c_rw_1920.jpg?h=af0575cb6bb0b5be01bfc8a3790a94dd',
  'https://pro2-bar-s3-cdn-cf6.myportfolio.com/c5cab9ad-7bfc-47d4-9c71-feeeab8bf97d/7249cc65-e620-4678-b063-717c5be00849_rw_1920.jpg?h=9ff5ae81105d83729032456d185075cd'
];

class _Rim extends StatelessWidget{
  final Post post;
  const _Rim({this.post}):super();

  @override
  Widget build(BuildContext context) {
    double _currentSliderValue = context
        .select((MainModel value) => value.currentSliderValue);
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ShowPost(post: post)));
        },
        child: Material(
          elevation: 7,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(30/_currentSliderValue),
            child: Stack(
              children: <Widget>[
                Center(
                  child: Image.network(url[post.getId]),
                ),
                Center(
                  child: Text(
                    post.getBody,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30/_currentSliderValue,
                      fontFamily: 'GenEiKoburi',
                      shadows: [Shadow(
                        blurRadius: 20/_currentSliderValue,
                        color: Colors.black
                      )]
                    ),
                  )
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}

