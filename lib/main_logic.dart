import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_future/data/postal_code.dart';

class Logic {
  Future<PostalCode> getPostalCode(String postalCode) async {
    if (postalCode.length != 7) {
      throw Exception("Postal Code Must Be 7 Characters");
    }

    // 123-4567
    final upper = postalCode.substring(0, 3); //123
    final lower = postalCode.substring(3); //4567

    final apiUrl =
        "https://madefor.github.io/postal-code-api/api/v1/$upper/$lower.json";
    final apiUri = Uri.parse(apiUrl);
    http.Response response = await http.get(apiUri);

    // 200 = 処理が成功した時
    if (response.statusCode != 200) {
      throw Exception("No Postal Code: $postalCode");
    }
    var jsonData = json.decode(response.body);
    return PostalCode.fromJson(jsonData);
  }

  // 条件によって進むか決める
  bool willProceed(String postalcode) {
    return postalcode.length == 7;
  }
}
