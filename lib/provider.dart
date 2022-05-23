import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_future/data/postal_code.dart';
import 'package:http/http.dart' as http;

StateProvider<String> postalCodeProvider = StateProvider((ref) => "");

FutureProvider<PostalCode> apiProvider = FutureProvider((ref) async {
  final postalCode = ref.watch(postalCodeProvider.notifier).state;
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
});
