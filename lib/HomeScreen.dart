import 'package:flutter/material.dart';
import 'main.dart';
import 'package:flutter/foundation.dart';
import 'Game.dart';
class HomeScreen extends StatefulWidget {
  //final String userName;
  final UserInfoDetails detailsUser;

  HomeScreen({Key key, this.detailsUser}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("App Home Screen"),),
      //body: Center(child: Text("Home Screen"),),
      body: new Game(),
      drawer: Drawer(
        child: ListView(children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(widget.detailsUser.displayName,),
            accountEmail: Text(widget.detailsUser.email,),
            currentAccountPicture: CircleAvatar(
              // backgroundColor: Colors.black26,
              child:  new Image.network(
                widget.detailsUser.photoUrl,
                colorBlendMode: BlendMode.dstIn,
              ),
            ),
            //decoration: BoxDecoration(color: Colors.orange),
          ),
          AboutListTile(
              child: Text("About"),
              applicationName: "My Login App",
              applicationVersion: "v1.0.0",
              applicationIcon: Icon(Icons.adb),
              icon: Icon(Icons.info)
          ),
          Divider(),
          ListTile(
            leading: new Icon(Icons.close),
            title: new Text("Cerrar"),
            onTap: () {
              setState(() {
                // pop closes the drawer
                Navigator.pop(context);
              });
            },
          )
        ],),
      ),
    );
  }
}