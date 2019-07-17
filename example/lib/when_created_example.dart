import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_appnexus/flutter_appnexus.dart';
import 'package:toast/toast.dart';

/// This example demonstrates loading the app right after it is created by the ListView.
class WhenCreatedExample extends StatefulWidget {
  @override
  _WhenCreatedExampleState createState() => _WhenCreatedExampleState();
}

class _WhenCreatedExampleState extends State<WhenCreatedExample> {
  List<Widget> items;
  final adListener = StreamController<AdListenerEvent>();

  @override
  void initState() {
    super.initState();
    items = [
      Container(height: 200, color: Colors.blueAccent),
      Container(height: 200, color: Colors.pink),
      Container(height: 200, color: Colors.lightBlue),
      Container(height: 200, color: Colors.amber),
      Container(height: 200, color: Colors.red),
      Container(height: 200, color: Colors.purple),
      Container(
        height: 200,
        color: Colors.green,
        child: Align(
          child: Text("When loadded, the ad should be below"),
          alignment: Alignment.bottomCenter,
        ),
      ),
      createAd(),
      Container(
        height: 200,
        color: Colors.lightBlue,
        child: Align(
          child: Text("When loadded, the ad should be above"),
          alignment: Alignment.topCenter,
        ),
      ),
      Container(height: 200, color: Colors.pink),
      Container(height: 200, color: Colors.lightBlue),
      Container(height: 200, color: Colors.amber),
      Container(height: 200, color: Colors.red),
      Container(height: 200, color: Colors.purple),
      Container(height: 200, color: Colors.green),
    ];
  }

  Builder createAd() {
    return Builder(builder: (BuildContext context) {
      // ignore: close_sinks
      return Align(
        alignment: Alignment.center,
        child: BannerAdView(
          layoutHeight: 250,
          layoutWidth: 300,
          shouldServePSAs: true,
          placementID: "9924002",
          loadMode: LoadMode.whenCreated(),
          adListener: adListener,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    adListener.stream.listen((AdListenerEvent event) {
      Toast.show(
        event.toString(),
        context,
        duration: Toast.LENGTH_SHORT,
        gravity: Toast.BOTTOM,
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('When created example'),
      ),
      body: Container(
        color: Colors.yellow,
        child: Center(
          child: ListView(
            children: items,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    adListener?.close();
    super.dispose();
  }
}
