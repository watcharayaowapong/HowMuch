
import 'package:gsheets/gsheets.dart';

import 'product.dart';

class ProductManager {

  static const _spreadsheetId = '1o_QgXpN4iVNbK1G2GlE03pF4kIpB5P6AR5UYLRzMSzE';
  static const _credentials = r'''{
  "type": "service_account",
  "project_id": "civic-athlete-322908",
  "private_key_id": "a0f3a675c75f8b7f9288d75370a87d44da90c790",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCUN3rgPgXmk94b\n10vzjzfxVfv8p2w/yzzela9OrBehVuf/y93IK3RYbuTpSfT2xSyZr1ftTnx1yECp\n+qhF4n4bT5FVg1VOZz9rHB3VyoGjdqZuQpdqvTlSLTsjaFwbBc/D7+CCLgjUmsP9\nZY+G3P0D1FKIIPmwpnR7U+10Na2ZCXbqYTG2888hasPCzAHKyCG52SLYxTJP6cAc\nGO5NQPOJJYH1eFuuEi8M+NW83nIeD+D+YQLmOUeaDaO0kW0tyRM4rXgiVfg1MGxv\nVQdc6Y3SqA95a9moLgVsMV1+jUFu2Wsfa0IONjQV1JCcgzuqiuhjs1sM4Nn4QhSE\nDB2ki9PdAgMBAAECggEAQWATT9OrsJ+qSWd2ddDHISkHA9MpOR5BFAC8GZxos95s\naHSYt5ELOXJ4f7oCVdJ0sLkZtG95EE6qzw7jqCeV7h/zf991AiciXvFA66rt8ZcF\nI/81YHxkSy3uNtjyP20ZzlgBFAqQFI7LQfrJCvhwlX7ShH7fA574I+nKBAclMinB\nb/q67p9C2KnarKkVWAUrru4NEmmhY2IqBEAOvayls+f3PQZopCz2CifbOZxR5dkx\nnDL8tyCpORD0Qo2INIFMiIcVCljOwv6VKhqBl81MwWm4cY45ervDqKMAC1x9IiUj\nA0GdyVvoJXQJA6oHJPfm8NzreGOR75iYCn68tNIYVQKBgQDOHBqaFpoJ1YIBvvqd\n04VASFHiF++ElbZXMqmyuXSr4bl9CY6xC3LV2/DVfYuxqasOsnNK7XsLCS0SSVOr\n/zrYg3NJ3YtMAftKZvdprGGCARjdHLvIv+VnaxyrrI1PBFDCZ2pABNb5Xmm1kWou\nX5XsFFzYoBoFXq4+zk7t+gEorwKBgQC4F/J83otngyWK2K68qqA3bOPgsDJpUtZ0\nLo4IrzHoaWyTbFz07EW5Un12oUrNrxuzz5FKGm/SlHQWkrJNMdYxVv5+xlIY8cbG\n7xWy/o26DcaeZxQqOhxehV2gYTJFaKmuf4zhB9MtIxY9zJMAJEYLlGgxIhE1gm6d\nxlQHRycXMwKBgCTpgZYhABtMwoi/hDCpxg56JTgBo2KyUUKSjzOz5QI3XbnX8Vch\nvsIwLpR9dHwv77OlH+LGXyfdz9WbjkGaZxaJjCcpZx4IqNFtWVfyiE/5FFPdJoBQ\nZaw80ZipQXFqS3BVhwDKHRnx36qlzUda1QW/q9Ub7y0RBNG4rwgNoxF/AoGAI4z8\nVwDjCupYpaeSlvycVBfDKfDcy1oj7+vNof+zM56oSQ/0I5g9Hry/XdloCLB4OREs\njZLtZU0l3fYWWLH3GzAhlXnXANov+NrS5e4ikHt4j754Nm9iax52JjKe8qhznC8l\nlY9dSKot8WFAQha/MB1IwbRCfoLhubZDI+Spt+ECgYBG2yMbWV0r37aabHcyzMcT\nFmgDE+URbVJl/icYg19/4FhBBxgFBr6k4iYypL3CRdcPveXfeBIqCN9VSDbkPGCW\npimzXp+jK/8kZ6e1YwgVKwC6H9tjonmsjZL4cZniAJIIeEwNXfwMOgfpeeJdbhKv\nxwGuY8T7ehZNhrnd3EXpiA==\n-----END PRIVATE KEY-----\n",
  "client_email": "flutter-sheet@civic-athlete-322908.iam.gserviceaccount.com",
  "client_id": "111718386466257387669",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/flutter-sheet%40civic-athlete-322908.iam.gserviceaccount.com"
}
  ''';

  final GSheets _gsheets = GSheets(_credentials);
  late Spreadsheet _spreadsheet;
  late Worksheet _productSheet;

  Future<void> init() async {
    _spreadsheet  = await _gsheets.spreadsheet(_spreadsheetId);
    _productSheet = (_spreadsheet.worksheetByTitle('products'))!;
  }

  Future<List<Product>?> getAll() async {
    await init();
    final products = await _productSheet.values.map.allRows();
    return products?.map((json) => Product.fromGsheets(json)).toList();
  }

  Future<Product?> getById(int id) async {
    await init();
    final map = await _productSheet.values.map.rowByKey(
      id,
      fromColumn: 1,
    );
    return map == null ? null : Product.fromGsheets(map);
  }

  Future<double> priceOf(int id) async {
    await init();
    var price = await _productSheet.values.valueByKeys(
      columnKey: 'price',
      rowKey: id,
    );
    return double.parse(price ?? '');
  }

  Future<bool> setPriceFor(int id, double price) async {
    await init();
    return _productSheet.values.insertValueByKeys(
      price,
      columnKey: 'price',
      rowKey: id,
      eager: false,
    );
  }

  Future<bool> insertProduct(Product product) async {
    await init();
    return _productSheet.values.map.insertRowByKey(
      product.id,
      product.toGsheets(),
      appendMissing: true,
    );
  }

  Future<bool> deleteById(int id) async {
    await init();
    final index = await _productSheet.values.rowIndexOf(id);
    if (index > 0) {
      return _productSheet.deleteRow(index);
    }
    return false;
  }

  Future<bool> delete(Product product) => deleteById(product.id);


}