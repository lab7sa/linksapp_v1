import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'HttpHandler.dart';

void main() => runApp(LinksApp());

class LinksApp extends StatefulWidget {
  @override
  _LinksAppState createState() => _LinksAppState();
}

class _LinksAppState extends State<LinksApp> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _link = TextEditingController();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  var _listLink;
  bool _isDeleted;
  int _totalNumLinks;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTotalLinks();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _key,
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text('linksapp', style: TextStyle(
            fontWeight: FontWeight.bold,
          ),),
        ),
        floatingActionButton: Builder( builder: (context) =>FloatingActionButton(
              child: Icon(
                Icons.add,
              ),
              backgroundColor: Colors.redAccent,

              onPressed: (){
                showModalBottomSheet(context: context,
                    isScrollControlled: true,
                    builder: (context) => SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),

                    child: Container(
                      margin: EdgeInsets.all(15.0),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text('Add a new link', textAlign: TextAlign.center, style: TextStyle(
                          fontSize: 31.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),),

                        TextField(
                          controller: _title,
                          maxLength: 20,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: 'Title',
                            hintText: 'Type your title here...',
                          ),
                        ),

                        TextField(
                          controller: _link,
                          maxLength: 45,
                          decoration: InputDecoration(
                            labelText: 'Link',
                            hintText: 'Type your link here... Please make sure to shorten the URL',
                          ),
                        ),

                        SizedBox(height: 19.0,),

                        FlatButton(
                          child: Text('Add'),
                          color: Colors.green,
                          onPressed: () async{
                            if(_title.text != '' && _link.text != ''){
                              var isAdded = await HttpHandler.addLinks(_title.text, _link.text);
                              if(isAdded == true){
                                await _getTotalLinks();
                                setState((){
                                  _clearTextFields();
                                  Navigator.pop(context);
                                  _showSnackBar(Text('Link has been added. Thank you'));
                                });
                              }else{
                                Navigator.pop(context);
                                _showSnackBar(Text('Link was not added. Please try again later...'));
                              }
                            }else{
                              setState(() {
                                _showSnackBar(Text('Error, both title and link textfields are required'));
                                Navigator.pop(context);
                              });

                            }

                          },
                        ),


                        FlatButton(
                          child: Text('Close'),
                          color: Colors.redAccent,
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),


                      ],
                    ),
                  ),
                ),),
                );
              },
            ),
        ),

        body: Container(
          margin: EdgeInsets.symmetric(vertical: 17.0, horizontal: 17.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('Total number of links:', style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(width: 7,),
                  Text(_totalNumLinks.toString(), style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),),
                ],
              ),
              SizedBox(height: 19.0,),
              Expanded(
                child: FutureBuilder(
                    future: HttpHandler.getLinks(),
                    builder: (BuildContext context
                        , AsyncSnapshot snapshot){
                      if(snapshot.connectionState == ConnectionState.done){

                        _totalNumLinks = snapshot.data.length;
                        return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index){
                              return ListTile(
                                title: Text(snapshot.data[index].title),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async{
                                    // add the delete function here
                                      _isDeleted = await HttpHandler.deleteLink(snapshot.data[index].l_id);

                                    if(_isDeleted == true){
                                      await _getTotalLinks();
                                      _showSnackBar(Text('Link has been deleted.'));
                                      setState((){

                                      });
                                    }else{
                                      _showSnackBar(Text('Error... Sorry, we could not delete this link. Try again later...'));
                                    }


                                  },
                                ),
                                subtitle: Text(snapshot.data[index].link),
                              );
                            });
                      }else{
                        return Align(child: CircularProgressIndicator(),);
                      }
                    }
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  //get total number of links
  Future<void> _getTotalLinks() async{
    _listLink = await HttpHandler.getLinks();
    if(_listLink != null){
      _totalNumLinks = _listLink.length;
    }else{
      _totalNumLinks = 0;
    }

  }

  _showSnackBar(Text message){
    SnackBar snackBar = SnackBar(content: message,);
    _key.currentState.showSnackBar(snackBar);
  }

  void _clearTextFields(){
    _title.text = '';
    _link.text = '';
  }







}


/*

/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'HttpHandler.dart';
import 'BottomSheetForm.dart';

void main() => runApp(LinksApp());

class LinksApp extends StatefulWidget {
  @override
  _LinksAppState createState() => _LinksAppState();
}

class _LinksAppState extends State<LinksApp> {
  bool _isDeleted;
  BottomSheetForm _getBottomSheet = BottomSheetForm();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  int _totalNumLinks;


  @override
  Widget build(BuildContext context) {

    _getNumLinks();

    return MaterialApp(
      home: Scaffold(
        key: _key,
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text('linksapp', style: TextStyle(
            fontWeight: FontWeight.bold,
          ),),
        ),
        floatingActionButton: Builder( builder: (context) =>FloatingActionButton(
              child: Icon(
                Icons.add,
              ),
              backgroundColor: Colors.redAccent,

              onPressed: (){
                showModalBottomSheet(context: context,
                    isScrollControlled: true,
                    builder: (context) => SingleChildScrollView(
                  child: _getBottomSheet
                ),);
              },
            ),
        ),

        body: Container(
          margin: EdgeInsets.symmetric(vertical: 17.0, horizontal: 17.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('Number of add links:', style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(width: 7,),
                  Text(_totalNumLinks.toString(), style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),),
                ],
              ),
              SizedBox(height: 19.0,),
              Expanded(
                child: FutureBuilder(
                    future: HttpHandler.getLinks(),
                    builder: (BuildContext context
                        , AsyncSnapshot snapshot){
                      if(snapshot.connectionState == ConnectionState.done){
                        return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index){
                              return ListTile(
                                title: Text(snapshot.data[index].title),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async{
                                    // add the delete function here
                                      _isDeleted = await HttpHandler.deleteLink(snapshot.data[index].l_id);
                                    if(_isDeleted == true){
                                      _showSnackBar(Text('Link has been deleted.'));
                                      setState((){});
                                    }else{
                                      _showSnackBar(Text('Error... Sorry, we could not delete this link. Try again later...'));
                                    }


                                  },
                                ),
                                subtitle: Text(snapshot.data[index].link),
                              );
                            });
                      }else{
                        return Align(child: CircularProgressIndicator(),);
                      }
                    }
                ),
              ),
            ],
          ),
        ),
      )
    );
  }


  _showSnackBar(Text message){
    SnackBar snackBar = SnackBar(content: message,);
    _key.currentState.showSnackBar(snackBar);
  }

  void _getNumLinks() async{
    var numLinks = await HttpHandler.getTotalLinks();
    if(numLinks != null){
      _totalNumLinks = numLinks;
    }
  }






}

 */

 */