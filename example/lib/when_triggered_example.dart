import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_appnexus/flutter_appnexus.dart';
import 'package:toast/toast.dart';

/// This example demonstrates loading the ad in a async way by triggering a Stream.
class WhenTriggeredExample extends StatefulWidget {
  @override
  _WhenTriggeredExampleState createState() => _WhenTriggeredExampleState();
}

class _WhenTriggeredExampleState extends State<WhenTriggeredExample> {
  final adListener = StreamController<AdListenerEvent>();
  final StreamController triggerAdLoading = StreamController();

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
        title: const Text('When triggered example'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: BannerAdView(
                layoutHeight: 250,
                layoutWidth: 300,
                shouldServePSAs: true,
                placementID: "9924002",
                loadMode: LoadMode.whenTriggered(this.triggerAdLoading.stream),
                adListener: adListener,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Stack(
              children: <Widget>[
                Container(
                  color: Colors.blue[100],
                  child: Center(
                    child: RaisedButton(
                      onPressed: () {
                        if (!triggerAdLoading.isClosed) {
                          triggerAdLoading.sink.add(null);
                        }
                      },
                      child: Text("Click to load the ad"),
                    ),
                  ),
                ),
                Align(
                  child: Text("^^^ When loadded, the ad should be above ^^^"),
                  alignment: Alignment.topCenter,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    triggerAdLoading.close();
    adListener.close();
    super.dispose();
  }
}
