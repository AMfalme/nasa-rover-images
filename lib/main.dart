// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:nasa_photos/model/photos.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mars Rover Photos',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Mars Rover Photos'),
        ),
        body: Photos(),
      ),
    );
  }
}

class Photos extends StatefulWidget {
  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  Future<List<PhotoModel>> futurePhotos;
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    futurePhotos = fetchNasaPhotos(http.Client());
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // final _photosList = <Photo>[]
  // final _photosList = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            RaisedButton(
              onPressed: () => _selectDate(context),
              child: Text('Select date'),
            ),
            Text("${selectedDate.toLocal()}".split(' ')[0]),
            FutureBuilder<List<PhotoModel>>(
                future: futurePhotos,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.data);
                    return Text("${snapshot.error}");
                  }

                  return snapshot.hasData
                      ? PhotosList(photos: snapshot.data)
                      : Center(child: CircularProgressIndicator());
                })
          ],
        ),
      ],
    );
  }
}

class PhotosList extends StatelessWidget {
  final List<PhotoModel> photos;

  PhotosList({Key key, this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return Image.network(photos[index].image_src);
      },
    );
  }
}
