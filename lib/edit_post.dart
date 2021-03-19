import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rim/db_provider.dart';
import 'package:rim/main.dart';

class EditPost extends StatelessWidget{
  final Post post;
  const EditPost({@required this.post}):super();

  @override
  Widget build(BuildContext context) {
    final TextEditingController _txController = new TextEditingController(text: post.getBody);
    // TODO: implement build
    return ChangeNotifierProvider(
      create: (_)=>EditModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 100,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.topRight,
                      width: double.infinity,
                      child: Builder(

                        builder:(context)=> TextButton(
                          child: Text('UpData'),
                          onPressed: (){
                            String currentText = context.select((EditModel value) => value.currentText);
                            if(currentText.isNotEmpty){
                              DBProvider.update(id: post.getId, text:currentText );
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => Archive()),
                                      (_) => false);
                            }
                          },
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      width: double.infinity,
                      child: TextButton(
                        child: Text('Cancel', style: TextStyle(color: Colors.grey),),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
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
                  child: SingleChildScrollView(
                    child: Container(
                      child: Builder(
                        builder: (context){
                          context.read<EditModel>().initText(post);
                          return TextFormField(
                            initialValue: post.getBody,
                            textAlign: TextAlign.center,
                            maxLines: null,
                            controller: _txController,
                            keyboardType: TextInputType.multiline,
                            onChanged: (text){
                              context.read<EditModel>().changeText(text);
                            },
                          );
                        }
                      ),
                    ),
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditModel with ChangeNotifier{
  String currentText;

  void initText(Post post){
    currentText = post.getBody;
  }

  void changeText(String text){
    currentText = text;
    notifyListeners();
  }
}