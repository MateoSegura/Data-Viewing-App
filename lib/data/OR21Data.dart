import 'package:google_maps_flutter/google_maps_flutter.dart';

class OR21Data {
  OR21Data({
    this.time,
    this.ath,
    this.rpm,
    this.gear,
    this.location,
  });

  //Data
  DateTime time;
  double ath;
  double rpm;
  double gear;
  LatLng location;
}

class NewOR21Data {
  Map<String, double> data;
}

//Have not found a better way of doing this
class DataParser {
  List<OR21Data> parseData(dynamic fields) {
    //return data
    List<OR21Data> parsedData = [];

    //List helpers
    List<String> timeString;
    List<DateTime> time;
    //OR21 Data
    List<double> ath; // index 1
    List<double> rpm; // index 2
    List<double> gear; // index 3
    List<double> latitude;
    List<double> longitude;

    //time
    timeString =
        fields.map<String>((row) => row[0].toString()).toList(growable: false);

    time = timeString.map((e) => DateTime.parse(e)).toList();

    //MS4 ECU

    //latitude
    latitude = fields
        .map<double>((row) => double.parse(row[2].toString()))
        .toList(growable: false);

    //longitude
    longitude = fields
        .map<double>((row) => double.parse(row[2].toString()))
        .toList(growable: false);

    //Throttle Percentage
    ath = fields
        .map<double>((row) => double.parse(row[3].toString()))
        .toList(growable: false);

    //rpm
    rpm = fields
        .map<double>((row) => double.parse(row[4].toString()))
        .toList(growable: false);

    //gear
    gear = fields
        .map<double>((row) => double.parse(row[5].toString()))
        .toList(growable: false);

    for (int i = 0; i < time.length; i++) {
      parsedData.add(
        OR21Data(
          time: time[i],
          location: LatLng(latitude[i], longitude[i]),
          ath: ath[i],
          rpm: rpm[i],
          gear: gear[i],
        ),
      );
    }
    return parsedData;
  }
}
