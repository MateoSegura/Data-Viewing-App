class CollectinPageSettings {
  //Variables
  String title;
  DateTime dateCreated;
  DateTime lastModified;

  //Initializers
  CollectinPageSettings({this.title, this.dateCreated, this.lastModified});

  //Create settings from JSON
  CollectinPageSettings.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    dateCreated = json['dateCreated'];
    lastModified = json['lastModified'];
  }

  //Create JSON settings
  Map<String, dynamic> toJson() => {
        'title': title,
        'dateCreated': dateCreated,
        'lastModified': lastModified,
      };
}
