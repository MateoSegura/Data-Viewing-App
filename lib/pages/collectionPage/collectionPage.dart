import 'dart:math';

import 'package:data_viewing_app/data/OR21Data.dart';
import 'package:data_viewing_app/data/settings/collectionPageSettings.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'dart:io';
import 'dart:convert' show utf8;
import 'dart:typed_data';
import 'dart:math' as math;

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import 'components/dataGraph.dart';
import 'components/menuButton.dart';
import 'components/popUpButton.dart';
import 'components/track.dart';
import 'components/viewPage.dart';

class CollectionPage extends StatefulWidget {
  //Init Variables
  final String title;
  CollectionPage({
    Key key,
    @required this.title,
  }) : super(key: key);

  @override
  _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  DateTime _min;
  DateTime _max;
  DateTime _min2;
  DateTime _max2;
  SfRangeValues _values =
      SfRangeValues(DateTime(2002, 01, 01), DateTime(2003, 01, 01));
  RangeController _rangeController;
  SfCartesianChart splineChart;
  SfCartesianChart splineChart2;
  DataParser myDataHelper;

  List<String> timeString;

  List<OR21Data> fileData = [];
  List<OR21Data> newData = [];
  List<OR21Data> fakefields = [];
  List<NewOR21Data> tryoutData = [];
  bool data;

  //OR21 Data
  List<DateTime> time = [];
  List<double> ath = []; // index 1
  List<double> rpm = []; // index 2
  List<double> gear = []; // index 3
  List<dynamic> laps = [];
  int lapsCounter = 0;
  //Map
  //Latitue & Longitude
  List<dynamic> latitude;
  List<dynamic> longitude;
  List<LatLng> locations = [];
  List<Point> track = [];

  //For controlling the view of the map
  GoogleMapController mapController;

// List of coordinates to join
  List<LatLng> polylineCoordinates = [];

// Map storing polylines created by connecting
  Map<PolylineId, Polyline> polylines = {};

  Uint8List uploadedCsv;
  String option1Text;

  List<List<int>> juan;
  var bytes;

  //for track
  List<int> start = [];
  List<int> end = [];
  List<List<LatLng>> lapsLocations = [];

  //For saving settings
  CollectinPageSettings mySettingsSave = CollectinPageSettings();
  CollectinPageSettings mySettingsLoad = CollectinPageSettings();
  bool settingsLoaded = false;

  @override
  void initState() {
    super.initState();
    data = false;
    _rangeController = RangeController(start: _values.start, end: _values.end);
  }

  @override
  void dispose() {
    _rangeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabsTitles.length,
      child: Scaffold(
        appBar: buildAppBar(context),
        body: data != false
            ? TabBarView(
                children: List<Widget>.generate(
                  myTabsTitles.length,
                  (int index) {
                    return new ViewPage(
                        time: time, ath: ath, max2: _max2, min2: _min2);
                  },
                ),
              )
            : Center(
                child: Text(
                  "Open GPS File",
                  style: TextStyle(fontSize: 24),
                ),
              ),
      ),
    );
  }

  //App bar
  List<String> myTabsTitles = ["Default"];

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      bottom: TabBar(
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 5,
        tabs: List<Widget>.generate(
          myTabsTitles.length,
          (index) {
            return GestureDetector(
              onSecondaryTap: () {
                deletePagePopUp(index);
              },
              child: Tab(
                iconMargin: EdgeInsets.all(50),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    myTabsTitles[index],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      leading: Row(
        children: [
          IconButton(
            icon: Icon(Icons.keyboard_arrow_left),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      title: Text(widget.title),
      actions: [
        CollectionPageMenuButton(
          onPressed: () {
            addPagePopUp();
          },
          icon: Icon(Icons.note_add),
        ),
        CollectionPageMenuButton(
          onPressed: () {
            pickFile();
          },
          icon: Icon(Icons.folder_open),
        ),
        CollectionPageMenuButton(
          onPressed: () {
            setState(() {
              print("tu mama we");
            });
          },
          icon: Icon(Icons.save),
        ),
      ],
    );
  }

  //Get Data From File
  pickFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        withData: true,
        allowedExtensions: ['csv'],
        type: FileType.custom,
        allowMultiple: false);

    if (result != null) {
      var fields;

      PlatformFile file = result.files.first;

      print("bueno");
      //Web
      if (kIsWeb) {
        bytes = utf8.decode(file.bytes);

        fields = const CsvToListConverter().convert(bytes);
      } else {
        // Code Below works for iOS
        final input = new File(file.path).openRead();
        fields = await input
            .transform(utf8.decoder)
            .transform(new CsvToListConverter())
            .toList();
      }

      //Get Variables needed for widgets here

      //time
      timeString = fields
          .map<String>((row) => row[0].toString())
          .toList(growable: false);

      time = timeString.map((e) => DateTime.parse(e)).toList();

      //laps
      laps = fields
          .map<int>((row) => int.parse(row[1].toString()))
          .toList(growable: false);

      //latitude
      latitude = fields
          .map<double>((row) => double.parse(row[2].toString()))
          .toList(growable: false);

      //longitude
      longitude = fields
          .map<double>((row) => double.parse(row[3].toString()))
          .toList(growable: false);

      //longitude
      ath = fields
          .map<double>((row) => double.parse(row[24].toString())) //12.8 at 22
          .toList(growable: false);
      //Add GPS positions to the map
      // for (int i = 0; i < longitude.length; i++) {
      //   //Count number of laps
      //   if (laps[i] == 1) {
      //     if (lapsCounter == 0) {
      //       start.add(0);
      //     } else {
      //       end.add(i);
      //       start.add(i + 1);
      //     }
      //     lapsCounter = lapsCounter + 1;
      //   }
      //   locations.add(LatLng(latitude[i] / 10, longitude[i] / 10));
      // }

      //Parse all the data
      fakefields = DataParser().parseData(fields);

      // Creating 4 Laps
      setState(() {
        _rangeController =
            RangeController(start: time[0], end: time[time.length - 1]);
        _min = time[0];
        _max = time[time.length - 1];
        Stopwatch stopwatch = new Stopwatch()..start();
        //print("Laps:" + (lapsCounter).toString());
        //print(start[1].toString() + end[1].toString());
        this.data = true;
        print('doSomething() executed in ${stopwatch.elapsed}');
      });

      //print(ath);
    } else {
      print("null result");
    }
  }

  //Add Page
  addPagePopUp() {
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
                        myTabsTitles.add(value);
                        Navigator.of(context).pop();
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Page Name",
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  //Delete Page
  deletePagePopUp(int index) {
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
            child: Container(
              height: MediaQuery.of(context).size.height / 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Are you sure you want to delete this page?",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "This action can't be undone",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PopUpButton(
                          onPressed: () {
                            setState(() {
                              myTabsTitles.removeAt(index);
                              Navigator.of(context).pop();
                            });
                          },
                          text: "Delete",
                          color: Theme.of(context).appBarTheme.color),
                      PopUpButton(
                        onPressed: () {
                          setState(() {
                            Navigator.of(context).pop();
                          });
                        },
                        text: "Cancel",
                        color: Theme.of(context).primaryColor,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static SharedPref() {}
}
