import 'package:flutter/material.dart';
import 'package:internet_speed_test/internet_speed_test.dart';
import 'package:internet_speed_test/callbacks_enum.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final internetSpeedTest = InternetSpeedTest();

  double downloadRate = 0;
  double uploadRate = 0;
  String downloadProgress = '0';
  String uploadProgress = '0';

  String unitText = 'Mb/s';

  int downloadVelocity = 1;

  void _parserDownloadVelocity(double transferRate, SpeedUnit unit) {
    switch (unit) {
      case SpeedUnit.Kbps:
        downloadVelocity = (transferRate / 1000).round();
        break;
      default:
        downloadVelocity = transferRate.round();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text('Progress $downloadProgress%'),
                  Text('Download rate  $downloadRate $unitText'),
                ],
              ),
              MaterialButton(
                child: Text('start testing'),
                onPressed: () {
                  internetSpeedTest.startDownloadTesting(
                    testServer: "https://ipv4.k-net.testdebit.info/1G.iso",
                    fileSize: 1073741824,
                    onDone: (double transferRate, SpeedUnit unit) {
                      setState(() {
                        downloadRate = transferRate;
                        unitText = unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
                        downloadProgress = '100';
                      });
                    },
                    onProgress:
                        (double percent, double transferRate, SpeedUnit unit) {
                      setState(() {
                        downloadRate = transferRate;
                        unitText = unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
                        downloadProgress = percent.toStringAsFixed(2);
                      });
                    },
                    onError: (String errorMessage, String speedTestError) {},
                    //fileSize: 1100,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
