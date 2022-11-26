import 'package:flutter/material.dart' ;
import 'package:scan/scan.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {

  ScanController controller = ScanController();
  String qrcode = 'Unknown';

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(
        title: const Text("สแกนราคาสินค้า"),centerTitle: true
      ),
      body: Center(
        child: ScanView(
          controller: controller,
          // custom scan area, if set to 1.0, will scan full area
          scanAreaScale: .7,
          scanLineColor: Colors.green.shade400,
          onCapture: (data) {
            Navigator.pop(context, data);
          },
        )
        ,
      ),floatingActionButton: FloatingActionButton(
      onPressed: (){controller.toggleTorchMode();},
      child: const Icon(Icons.lightbulb),
    ),
    );
  }
}
