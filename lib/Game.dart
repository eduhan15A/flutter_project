import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'HomeScreen.dart';
import 'main.dart';

class Game extends StatefulWidget {
  final UserInfoDetails detailsUser;

  Game({Key key, this.detailsUser}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  static const String rock = "rock";
  static const String paper = "paper";
  static const String scissors = "scissors";
  static const String lizard = "lizard";
  static const String spock = "spock";

  int myPoints = 0;
  int oponentPoints = 0;
  int difference = 0;

  String rockImage = "assets/images/rock.png";
  String paperImage = "assets/images/paper.png";
  String scissorsImage = "assets/images/scissors.png";
  String lizardImage = "assets/images/lizard.png";
  String spockImage = "assets/images/spock.png";
  String defaultImage = "assets/images/question.png";

  String myChoiceImg = "assets/images/question.png";
  String oponentsChoiceImg = "assets/images/question.png";
  String myChoice = "";
  String oponentsChoice = "";
  Random random = new Random();

  void selectRock(){
    print("Rock selected");
    setState(() {
      myChoiceImg = rockImage;
      myChoice = rock;
      oponentsTurn();
    });
  }
  void selectPaper(){
    print("Paper selected");
    setState(() {
      myChoiceImg = paperImage;
      myChoice = paper;
      oponentsTurn();
    });
  }
  void selectScissors(){
    print("Scissors selected");
    setState(() {
      myChoiceImg = scissorsImage;
      myChoice = scissors;
      oponentsTurn();
    });
  }
  void selectLizard(){
    print("Lizzard selected");
    setState(() {
      myChoiceImg = lizardImage;
      myChoice = lizard;
      oponentsTurn();
    });
  }
  void selectSpock(){
    print("Spock selected");
    setState(() {
      myChoiceImg = spockImage;
      myChoice = spock;
      oponentsTurn();
    });
  }

  void oponentsTurn(){
    var choice = random.nextInt(5);
    print(choice);
    switch(choice){
      case 0 : oponentsChoiceImg = rockImage; oponentsChoice = rock; break;
      case 1 : oponentsChoiceImg = paperImage; oponentsChoice = paper;  break;
      case 2 : oponentsChoiceImg = scissorsImage; oponentsChoice = scissors;  break;
      case 3 : oponentsChoiceImg = lizardImage; oponentsChoice = lizard;  break;
      case 4 : oponentsChoiceImg = spockImage; oponentsChoice = spock;   break;
    }

      switch(myChoice){
        case rock:
          switch(oponentsChoice){
            case rock:
              showShortToast("It´s a Tie!");
              break;

            case paper:
              showShortToast("Paper Covers Rock!");
              pointsForOponent();
              break;

            case scissors:
              showShortToast("Scissors are crushed by Rock!");
              pointsForMe();
              break;

            case lizard:
              showShortToast("Lizard is crushed by Rock!");
              pointsForMe();
              break;

            case spock:
              showShortToast("Spock vaporices Rock!");
              pointsForOponent();
              break;
          }
          break;

        case paper:
          switch(oponentsChoice){
            case rock:
              showShortToast("Paper covers Rock!");
              pointsForMe();
              break;

            case paper:
              showShortToast("It´s a Tie!");
              break;

            case scissors:
              showShortToast("Paper is cut by Scissors!");
              pointsForOponent();
              break;

            case lizard:
              showShortToast("Lizard eats paper!");
              pointsForOponent();
              break;

            case spock:
              showShortToast("Spock is disproved by Paper!");
              pointsForMe();
              break;
          }
          break;

        case scissors:
          switch(oponentsChoice){
            case rock:
              showShortToast("Rock crushes Scissors!");
              pointsForOponent();
              break;

            case paper:
              showShortToast("Paper is cut by Scissors!");
              pointsForMe();
              break;

            case scissors:
              showShortToast("It´s a Tie!");
              break;

            case lizard:
              showShortToast("Lizard is decapitated by Scissors!");
              pointsForMe();
              break;

            case spock:
              showShortToast("Spock smashes Scissors!");
              pointsForOponent();
              break;
          }
          break;

        case lizard:
          switch(oponentsChoice){
            case rock:
              showShortToast("Lizard is crushed by Rock!");
              pointsForOponent();
              break;

            case paper:
              showShortToast("Lizard eats Paper!");
              pointsForMe();
              break;

            case scissors:
              showShortToast("Lizard is decapitated by Scissors!");
              pointsForOponent();
              break;

            case lizard:
              showShortToast("It´s a Tie!");
              break;

            case spock:
              showShortToast("Lizard poisons Spock!");
              pointsForMe();
              break;
          }
          break;

        case spock:
          switch(oponentsChoice){
            case rock:
              showShortToast("Spock vaporices Rock!");
              pointsForMe();
              break;

            case paper:
              showShortToast("Spock is disproved by Paper!");
              pointsForOponent();
              break;

            case scissors:
              showShortToast("Spock smashes Scissors!");
              pointsForMe();
              break;

            case lizard:
              showShortToast("Spock is poisoned by Lizard!");
              pointsForOponent();
              break;

            case spock:
              showShortToast("It´s a Tie!");
              break;
          }
          break;


      }

  }

  void pointsForMe(){
    setState(() {
      myPoints = myPoints + 1;
    });
    savePointsInCloud();

  }

  void pointsForOponent(){
    setState(() {
      oponentPoints = oponentPoints + 1;
    });
    savePointsInCloud();
  }

  void savePointsInCloud() {
    print("Saving Points in Cloud");

    difference = myPoints - oponentPoints;
      print(this.widget.detailsUser.email);
      print(this.widget.detailsUser.uid);

      print("Saving Points");
      Firestore.instance.collection('scores').where('userid', isEqualTo: this.widget.detailsUser.uid).getDocuments().then((result){
        print("Documents: " + result.documents.length.toString());
        if(result.documents.length > 0 ){
          print(result.documents.first["score"]);

          Firestore.instance.runTransaction((Transaction transaction)
          async{
            DocumentSnapshot snap = await transaction.get(result.documents.first.reference);
            await transaction.update(snap.reference, { "score": difference , "oponentpoints": oponentPoints, "userpoints": myPoints, });
          });
        }
        else{




          Firestore.instance.collection('scores').reference().add({ "score": difference , "userid": this.widget.detailsUser.uid,
            "name":this.widget.detailsUser.displayName, "oponentpoints": oponentPoints, "userpoints": myPoints,
          });

        }//IF

      });



    }




  void showShortToast(String message) {
    Fluttertoast.showToast(
      msg:"     "+ message+"     ",
     // gravity: ToastGravity.CENTER,
      bgcolor: "#0033cc",
      textcolor: '#ffffff',
      toastLength: Toast.LENGTH_SHORT,
    );
  }




  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(title: Text("Game"),),
      //body: Center(child: Text("Home Screen"),),
        body: new Container(
      padding:  EdgeInsets.all(10.0),
      child: new Center(
           child: new Column(

             children: <Widget>[
               new Row(
                 children: <Widget>[
                   new  Expanded( child: Center(child:Text("You", style: TextStyle(fontSize: 28.0, color: Colors.green, fontWeight: FontWeight.bold),), )),
                   new  Expanded( child: Center(child:Text("Your Oponent", style: TextStyle(fontSize: 28.0, color: Colors.red, fontWeight: FontWeight.bold),), )),
                 ],
               ),
              new SizedBox(height: 10.0,),
               new Row(
                 children: <Widget>[
                   new  Expanded( child: Center(child:Text(myPoints.toString(), style: TextStyle(fontSize: 38.0, color: Colors.black54, fontWeight: FontWeight.bold),), )),
                   new  Expanded( child: Center(child:Text(oponentPoints.toString(), style: TextStyle(fontSize: 38.0, color: Colors.black54,fontWeight: FontWeight.bold),), )),
                 ],
               ),
               new SizedBox(height: 10.0,),
               new Row(
                 children: <Widget>[
                   new Expanded( child: Center(child:Image.asset( myChoiceImg, width: 150.0, height: 150.0, fit: BoxFit.cover,), )),
                   new Expanded( child: Center(child:Image.asset(oponentsChoiceImg, width: 150.0, height: 150.0, fit: BoxFit.cover,), )),
                 ],
               ),
               new SizedBox(height: 10.0,),
               new Row(
                 children: <Widget>[
                   new Expanded( child: Center(child:Text("Choose your Warrior!", style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),), )),
                 ],
               ),
               new SizedBox(height: 10.0,),
               new Row(
                 children: <Widget>[
                   new Expanded( child: Center(child: GestureDetector(onTap: selectRock, child:Image.asset('assets/images/rock.png', width: 100.0, height: 100.0, fit: BoxFit.cover,)),)),
                   new Expanded( child: Center(child: GestureDetector(onTap: selectPaper, child:Image.asset('assets/images/paper.png', width: 100.0, height: 100.0, fit: BoxFit.cover,)),)),
                   new Expanded( child: Center(child: GestureDetector(onTap: selectScissors, child:Image.asset('assets/images/scissors.png', width: 100.0, height: 100.0, fit: BoxFit.cover,)),)),

                 ],
               ),
               new SizedBox(height: 10.0,),
               new Row(
                 children: <Widget>[
                   new Expanded( child: Center(child: GestureDetector(onTap: selectLizard, child:Image.asset('assets/images/lizard.png', width: 100.0, height: 100.0, fit: BoxFit.cover,)),)),
                   new Expanded( child: Center(child: GestureDetector(onTap: selectSpock, child:Image.asset('assets/images/spock.png', width: 100.0, height: 100.0, fit: BoxFit.cover,)),)),

                 ],
               ),

             ],
           ),
        ),
        ),
    );
  }


}
