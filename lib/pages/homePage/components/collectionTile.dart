import 'package:data_viewing_app/pages/collectionPage/collectionPage.dart';
import 'package:flutter/material.dart';

class CollectionTile extends StatelessWidget {
  //Varibles
  final String collectionTitle;
  final DateTime dateCreated;
  final DateTime dateModified;

  const CollectionTile({
    Key key,
    @required this.collectionTitle,
    @required this.dateCreated,
    @required this.dateModified,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Card(
        shadowColor: Theme.of(context).shadowColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          leading: Icon(Icons.source, color: Theme.of(context).accentColor),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CollectionPage(
                  title: collectionTitle,
                ),
              ),
            );
          },
          title: Text(collectionTitle),
          subtitle: Text("Collection Folder"),
          // subtitle: Text("Date Created: " +
          //     dateCreated.toString() +
          //     "Last Modified: " +
          //     dateCreated.toString()),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
    );
  }
}
