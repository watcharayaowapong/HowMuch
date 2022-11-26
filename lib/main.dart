import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:howmuch/product.dart';
import 'package:howmuch/productManager.dart';
import 'package:url_launcher/url_launcher.dart';

import 'google_sheet_api.dart';
import 'productPage.dart';
import 'scanPage.dart';

void main() {
  GoogleSheetAPI();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HowMuch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'QR code Barcode Scanner'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _barcode = 'null';

  late String productID;
  String? productName;
  String? productPrice;
  String? productQuantity;

  Future<void> _incrementCounter() async {
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => const ScanPage()),
    );

    setState(() {
      if (result != null) {
        _barcode = result;
      } else {
        _barcode = 'null';
      }
    });
  }

  Future<bool> _launchUniversalLinkIos(String url) async {
    try {
      await launch(
        url,
        enableJavaScript: true,
      );
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.qr_code,size: 80,),
              const Text(
                'barcode',
              ),
              Text(
                _barcode,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              _barcode != "null"
                  ? StreamBuilder(
                      stream: ProductManager()
                          .getById(int.parse(_barcode))
                          .asStream(),
                      builder: (BuildContext context,
                          AsyncSnapshot<Product?> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasData) {
                          return Column(
                            children: [
                              Text(snapshot.data!.name +
                                  '\n' +
                                  'ราคา : ${snapshot.data!.price} บาท\n' +
                                  'คงเหลือ : ${snapshot.data!.quantity} \n'),
                              TextButton.icon(
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      // Create the SelectionScreen in the next step.
                                      MaterialPageRoute(
                                          builder: (context) => ProductPage(
                                                id: snapshot.data!.id.toString(),
                                                name: snapshot.data!.name
                                                    .toString(),
                                                price: snapshot.data!.price
                                                    .toString(),
                                                quantity: snapshot.data!.quantity
                                                    .toString(),
                                              )),
                                    );
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.open_in_browser),
                                  label: const Text("แก้ไขสินค้า")),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              const Text("ไม่พบข้อมูล"),
                              TextButton.icon(
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      // Create the SelectionScreen in the next step.
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProductPage(id: _barcode)),
                                    );
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.open_in_browser),
                                  label: const Text("เพิ่มสินค้า")),
                            ],
                          );
                        }
                      })
                  : const Text('Please scan barcode'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.qr_code_scanner),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      persistentFooterButtons: [
        TextButton.icon(
            onPressed: () {
              _launchUniversalLinkIos(
                  'https://www.google.com/search?q=$_barcode');
            },
            icon: const Icon(Icons.open_in_browser),
            label: const Text("Google Search")),
        TextButton.icon(
            onPressed: () {
              _launchUniversalLinkIos(
                  'https://www.bigc.co.th/search?q=$_barcode');
            },
            icon: const Icon(Icons.open_in_browser),
            label: const Text("Big C")),
        TextButton.icon(
            onPressed: () {
              _launchUniversalLinkIos('https://www.tops.co.th/th/$_barcode');
            },
            icon: const Icon(Icons.open_in_browser),
            label: const Text("Top market")),
      ],
    );
  }
}
