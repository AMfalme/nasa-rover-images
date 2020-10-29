import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PhotoModel {
  final int id;
  final int sol;
  Camera camera;
  // ignore: non_constant_identifier_names
  final String image_src;
  // ignore: non_constant_identifier_names
  final String earth_date;
  Rover rover;

  PhotoModel(
      {this.id,
      this.sol,
      this.camera,
      // ignore: non_constant_identifier_names
      this.image_src,
      // ignore: non_constant_identifier_names
      this.earth_date,
      this.rover});

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
        id: json['id'] as int,
        sol: json['sol'] as int,
        camera: json['camera'].fromJson(json['Camera']),
        image_src: json['image_src'] as String,
        earth_date: json['earth_date'] as String,
        rover: json['rover'].fromJson(json['Rover']));
  }
}

class Camera {
  final int id;
  final String name;
  // ignore: non_constant_identifier_names
  final int rover_id;
  // ignore: non_constant_identifier_names
  final String full_name;

  // ignore: non_constant_identifier_names
  Camera({this.id, this.name, this.rover_id, this.full_name});

  factory Camera.fromJson(Map<String, dynamic> json) {
    return Camera(
        id: json['id'] as int,
        name: json['name'] as String,
        rover_id: json['rover_id'] as int,
        full_name: json['full_name'] as String);
  }
}

class Rover {
  final int id;
  final String name;
  // ignore: non_constant_identifier_names
  final String landing_date;
  // ignore: non_constant_identifier_names
  final String launch_date;
  final String status;

  // ignore: non_constant_identifier_names
  Rover({this.id, this.name, this.landing_date, this.launch_date, this.status});
  factory Rover.fromJson(Map<String, dynamic> json) {
    return Rover(
        id: json['id'] as int,
        name: json['name'] as String,
        landing_date: json['landing_date'] as String,
        launch_date: json['launch_date'] as String,
        status: json['status'] as String);
  }
}

// final _photos = {
//   "id": 102685,
//   "sol": 1004,
//   "camera": {
//     "id": 20,
//     "name": "FHAZ",
//     "rover_id": 5,
//     "full_name": "Front Hazard Avoidance Camera"
//   },
//   "img_src":
//       "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01004/opgs/edr/fcam/FLB_486615455EDR_F0481570FHAZ00323M_.JPG",
//   "earth_date": "2015-06-03",
//   "rover": {
//     "id": 5,
//     "name": "Curiosity",
//     "landing_date": "2012-08-06",
//     "launch_date": "2011-11-26",
//     "status": "active"
//   }
// };
List<PhotoModel> getPhotos(String responseBody) {
  print(json.decode(responseBody)['photos']);
  final parsed =
      jsonDecode(responseBody)['photos'].cast<Map<String, dynamic>>();
  if (parsed != null) {
    return parsed.map<PhotoModel>((json) => PhotoModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load Photos');
  }
}

Future<List<PhotoModel>> fetchNasaPhotos(http.Client client) async {
  final response = await http.get(
      'https://mars-photos.herokuapp.com/api/v1/rovers/curiosity/photos?earth_date=2015-6-3');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print('photos found');
    return compute(getPhotos, response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print('Photos not found');
    throw Exception('Failed to load Photos');
  }
}
