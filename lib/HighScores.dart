import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HighScores extends StatefulWidget {
  @override
  _HighScoresState createState() => _HighScoresState();
}

class _HighScoresState extends State<HighScores> {

  Widget _buildListItem (BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Row(children: <Widget>[
        Expanded(child: Text(document["name"], style: Theme
            .of(context)
            .textTheme
            .headline,),
        ),
        Container(
          decoration: BoxDecoration(color: Colors.blueAccent),
          padding: EdgeInsets.all(10.0),
          child: new Text(document["score"].toString(), style: TextStyle(color: Colors.white, fontSize: 28.0) ),
        ),

      ],),
    );}

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("High Scores"),),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('scores').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          //   if(snapshot.hasError)
          //    return new Text('Error: ${snapshot.error}');
          // switch (snapshot.connectionState){
          if(!snapshot.hasData)
            return new Text('Loading ...');
          return  ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (count,index) => _buildListItem(context, snapshot.data.documents[index]),
          );
        },
      ) ,
    );
  }
}
