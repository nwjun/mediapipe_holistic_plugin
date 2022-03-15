import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mediapipe_holistic/gen/landmark.pb.dart';
import 'package:mediapipe_holistic/mediapipe_holistic.dart';
import 'package:mediapipe_holistic/native_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NAMESPACE = 'mediapipe_holistic';
  final Map<String, dynamic> creationParams = <String, dynamic>{};
  HolisticViewController? _controller;
  var landmark=null;
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

  }

  void _onLandMarkStream(NormalizedLandmarkList landmarkList) {
    if (landmarkList.landmark != null && landmarkList.landmark.length != 0) {
      print(landmarkList.landmark);
      setState(() {
        landmark = landmarkList.landmark;
      });

    } else
      print('jsafjasflkajsf');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 300,
                child: HolisticView(
                  onViewCreated: (HolisticViewController c) => setState(() {
                    _controller = c;
                    if (_controller != null)
                      _controller?.landMarksStream.listen(_onLandMarkStream);
                  }),
                ),),
              _controller == null?
                  Text('Please grant camera permissions and reopen the application')
                  : Column(
                children: [
                  Text(landmark==null?"no landmarks":landmark.toString()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
