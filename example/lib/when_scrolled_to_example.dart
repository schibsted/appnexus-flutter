import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_appnexus/flutter_appnexus.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toast/toast.dart';

/// This example demonstrates loading the ad 100 px before appearing on screen while scrolling.
class WhenScrolledToExample extends StatefulWidget {
  @override
  _WhenScrolledToExampleState createState() => _WhenScrolledToExampleState();
}

class _WhenScrolledToExampleState extends State<WhenScrolledToExample> {
  List<Widget> items;
  PublishSubject<ScrollNotification> _scrollNotifications;
  final adListener = StreamController<AdListenerEvent>();

  @override
  void initState() {
    super.initState();
    _scrollNotifications = PublishSubject<ScrollNotification>();

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

  Widget createAd() {
    return Align(
      alignment: Alignment.center,
      child: BannerAdView(
        layoutHeight: 250,
        layoutWidth: 300,
        shouldServePSAs: true,
        placementID: "9924002",
        clickThroughAction: ClickThroughAction.openSdkBrowser(),
        loadMode: LoadMode.whenScrolledToAd(_scrollNotifications, -100),
        adListener: adListener,
      ),
    );
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
        title: Text('Whens scrolled to example'),
      ),
      body: Container(
        color: Colors.yellow,
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scroll) {
            if (!_scrollNotifications.isClosed) {
              _scrollNotifications.add(scroll);
            }
            return true;
          },
          child: Center(
            child: ListView(
              children: items,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollNotifications?.close();
    adListener?.close();
    super.dispose();
  }
}
