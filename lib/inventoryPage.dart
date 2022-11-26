import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'product.dart';
import 'productManager.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  ProductManager pMan = ProductManager();
  late List<Product> productList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('คลังสินค้า'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  _displayTextInputDialog(context);
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: StreamBuilder(
          stream: pMan.getAll().asStream(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Product>?> snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Quantity')),
                      DataColumn(label: Text('Price')),
                    ],
                    rows: snapshot.data!
                        .map((data) => DataRow(cells: [
                              DataCell(Text(data.id.toString())),
                              DataCell(Text(data.name.toString())),
                              DataCell(Text(data.quantity.toString())),
                              DataCell(Text(data.price.toString())),
                            ]))
                        .toList()),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    final TextEditingController _textFieldIDController =
        TextEditingController();
    final TextEditingController _textFieldNameController =
        TextEditingController();
    final TextEditingController _textFieldPriceController =
        TextEditingController();
    final TextEditingController _textFieldQuantityController =
        TextEditingController();

    final focusNode1 = FocusNode();
    final focusNode2 = FocusNode();
    final focusNode3 = FocusNode();
    final focusNode4 = FocusNode();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Product'),
            content: Column(
              children: [
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
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: const Text(
                  'SAVE',
                  style: TextStyle(color: Colors.amber),
                ),
                onPressed: () {
                  setState(() {
                    // codeDialog = valueText;
                    // GoogleSheetAPI()
                    //     .appendRow(historicalData, codeDialog ??= 'data');

                    // print(_textFieldIDController.text);
                    // print(_textFieldNameController.text);
                    // print(_textFieldPriceController.text);
                    // print(_textFieldQuantityController.text);

                    if (_textFieldIDController.text.isEmpty) {
                      focusNode1.requestFocus();
                    } else if (_textFieldNameController.text.isEmpty) {
                      focusNode2.requestFocus();
                    } else if (_textFieldPriceController.text.isEmpty) {
                      focusNode3.requestFocus();
                    } else if (_textFieldQuantityController.text.isEmpty) {
                      focusNode4.requestFocus();
                    } else {

                      setState(() {
                        pMan.insertProduct(Product(
                            id: int.parse(_textFieldIDController.text),
                            name: _textFieldNameController.text,
                            quantity:
                            int.parse(_textFieldQuantityController.text),
                            price: double.parse(_textFieldPriceController.text)));

                        Navigator.pop(context);
                      });


                    }
                  });
                },
              ),
            ],
          );
        });
  }
}
