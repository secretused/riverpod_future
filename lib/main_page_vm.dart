import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/postal_code.dart';
import 'main_logic.dart';

final _logicProvider = Provider<Logic>((ref) => Logic());
final _postalcodeProvider = StateProvider<String>((ref) => "");

// PostalCodeをLogicに渡す
AutoDisposeFutureProviderFamily<PostalCode, String> _apiFamilyProvider =
    FutureProvider.autoDispose
        .family<PostalCode, String>((ref, postalcode) async {
  Logic logic = ref.watch(_logicProvider);
  // 空の場合Emptyを返す
  if (!logic.willProceed(postalcode)) {
    return PostalCode.empty;
  }
  return await logic.getPostalCode(postalcode);
});

class MainPageVM {
  late final WidgetRef _ref;

  // onPostalCodeChagedで更新されたValueを読み込む
  String get postalcode => _ref.watch(_postalcodeProvider);

  AsyncValue<PostalCode> postalCodeWithFamily(String postalCode) =>
      _ref.watch(_apiFamilyProvider(postalcode));

  void setRef(WidgetRef ref) {
    this._ref = ref;
  }

  // Pageで入力されたValueが入る
  void onPostalCodeChaged(String postalcode) {
    _ref.read(_postalcodeProvider.notifier).update((state) => postalcode);
  }
}
