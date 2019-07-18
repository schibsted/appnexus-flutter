import 'package:flutter/material.dart';
import 'package:flutter_appnexus_example/when_created_example.dart';
import 'package:flutter_appnexus_example/when_in_viewport_example.dart';
import 'package:flutter_appnexus_example/when_triggered_example.dart';

void main() => runApp(MaterialApp(home: BannerAdViewExamples()));

class BannerAdViewExamples extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BannerAdView examples'),
      ),
      body: Center(
        child: Column(
          children: [
            buildButton(context, WhenTriggeredExample(), "Load when triggered"),
            buildButton(context, WhenCreatedExample(), "Load when created"),
            buildButton(context, WhenInViewportExample(), "Load when -100 px before in viewport"),
          ],
        ),
      ),
    );
  }

  Padding buildButton(BuildContext context, Widget widget, String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => widget),
          );
        },
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
