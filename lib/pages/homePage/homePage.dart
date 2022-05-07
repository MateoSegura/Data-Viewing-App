import 'package:data_viewing_app/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/collectionTile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Variables
  final myController = TextEditingController();
  final myFolders = [];

  //Dispose text field
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Vieweing Application"),
        backgroundColor: Theme.of(context).appBarTheme.color,
        actions: [
          Switch(
            value: themeProvider.isLightTheme,
            onChanged: (val) {
              themeProvider.setThemeData = val;
            },
          ),
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: myFolders.length,
          itemBuilder: (context, index) {
            return CollectionTile(
              collectionTitle: myFolders[index],
              dateCreated: DateTime(2021),
              dateModified: DateTime(2022),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            Theme.of(context).floatingActionButtonTheme.backgroundColor,
        child: Icon(Icons.add),
        onPressed: openAlertBox,
      ),
    );
  }

  openAlertBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).backgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            contentPadding: EdgeInsets.all(30),
            content: Container(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                      autofocus: true,
                      onFieldSubmitted: (value) {
                        setState(() {
                          myFolders.add(value);
                          myController.clear();
                          Navigator.of(context).pop();
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter Folder Name",
                      )),
                ],
              ),
            ),
          );
        });
  }
}
