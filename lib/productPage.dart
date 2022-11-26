import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:howmuch/product.dart';
import 'package:howmuch/productManager.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductPage extends StatefulWidget {
  const ProductPage(
      {Key? key,
      this.id = '',
      this.name = '',
      this.price = '',
      this.quantity = ''})
      : super(key: key);
  final String id;
  final String name;
  final String price;
  final String quantity;

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _textFieldIDController =
        TextEditingController();
    final TextEditingController _textFieldNameController =
        TextEditingController();
    final TextEditingController _textFieldPriceController =
        TextEditingController();
    final TextEditingController _textFieldQuantityController =
        TextEditingController();

    _textFieldIDController.text = widget.id;
    _textFieldNameController.text = widget.name;
    _textFieldPriceController.text = widget.price;
    _textFieldQuantityController.text = widget.quantity;

    final focusNode1 = FocusNode();
    final focusNode2 = FocusNode();
    final focusNode3 = FocusNode();
    final focusNode4 = FocusNode();

    return Scaffold(
      appBar: AppBar(
        title: const Text('สินค้า'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('BarCode'),
            TextField(
              controller: _textFieldIDController,
              focusNode: focusNode1,
              decoration: const InputDecoration(hintText: "barcode"),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            TextField(
              controller: _textFieldNameController,
              focusNode: focusNode2,
              decoration: const InputDecoration(hintText: "ชื่อสินค้า"),
            ),
            TextField(
              controller: _textFieldPriceController,
              focusNode: focusNode3,
              decoration: const InputDecoration(hintText: "ราคา"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _textFieldQuantityController,
              focusNode: focusNode4,
              decoration: const InputDecoration(hintText: "จำนวน"),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          setState(() {
            if (_textFieldIDController.text.isEmpty) {
              focusNode1.requestFocus();
            } else if (_textFieldNameController.text.isEmpty) {
              focusNode2.requestFocus();
            } else if (_textFieldPriceController.text.isEmpty) {
              focusNode3.requestFocus();
            } else if (_textFieldQuantityController.text.isEmpty) {
              focusNode4.requestFocus();
            } else {
              setState(() async {
                showLoaderDialog(context);
                await ProductManager().insertProduct(Product(
                    id: int.parse(_textFieldIDController.text),
                    name: _textFieldNameController.text,
                    quantity: int.parse(_textFieldQuantityController.text),
                    price: double.parse(_textFieldPriceController.text)));
                Navigator.pop(context);
                Navigator.pop(context);
              });
            }
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      persistentFooterButtons: [
        TextButton.icon(
            onPressed: () {
              _launchUniversalLinkIos(
                  'https://www.google.com/search?q=${widget.id}');
            },
            icon: const Icon(Icons.open_in_browser),
            label: const Text("Google Search")),
      ],
    );
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
}

void showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        const CircularProgressIndicator(),
        Container(
            margin: const EdgeInsets.only(left: 7),
            child: const Text("Loading...")),
      ],
    ),
  );

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
