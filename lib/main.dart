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
      ),
      home: _Archive(),

    );
  }
}

class _Archive extends StatelessWidget{

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
              child: FutureBuilder(
                future: DBProvider.getAll(),
                builder:(BuildContext context, AsyncSnapshot snapshot){
                  int gridCount = context.select((MainModel value) => value.currentSliderValue).toInt();
                  if(snapshot == null)return Center(child: Text('no item'),);
                  return GridView.count(
                    crossAxisCount: gridCount,
                    children: snapshot.data.map((post){
                      return _Rim(post: post,);
                    }),
                  );
                }
              )
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: _GridSlider(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
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

final String url = 'https://pro2-bar-s3-cdn-cf4.myportfolio.com/c5cab9ad-7bfc-47d4-9c71-feeeab8bf97d/f7fe0671-eae4-4b66-8aa2-ae0519279a5c_rw_1920.jpg?h=3df818a92f73c21875c39fad9b1ca8b1';

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
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(
              blurRadius: 4,
              offset: Offset(3,3),
              color: Colors.grey
            )]
          ),
          padding: EdgeInsets.all(30/_currentSliderValue),
          child: Stack(
            children: <Widget>[
              Center(child: Image.network(url)),
              Center(
                child: Text(
                  post.getBody,
                  style: TextStyle(
                    color: Colors.white
                  ),
                )
              )
            ],
          )
        ),
      ),
    );
  }
}

