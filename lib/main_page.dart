import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'provider.dart';

class MyHomePage extends ConsumerWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postalCode = ref.watch(apiProvider);
    final familyPostalCode =
        ref.watch(apifamilyProvider(ref.watch(postalCodeProvider)));

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                onChanged: (text) => onPostalCodeChanges(ref, text),
              ),
              // Expanded(
              //   child: postalCode.when(
              //     data: (data) => ListView.separated(
              //       itemCount: data.data.length,
              //       itemBuilder: (context, index) => ListTile(
              //         title: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(data.data[index].ja.prefecture),
              //             Text(data.data[index].ja.address1),
              //             Text(data.data[index].ja.address2),
              //             Text(data.data[index].ja.address3),
              //             Text(data.data[index].ja.address4),
              //           ],
              //         ),
              //       ),
              //       separatorBuilder: (BuildContext context, int index) =>
              //           Divider(
              //         color: Colors.black,
              //       ),
              //     ),
              //     error: (error, stack) => Text(error.toString()),
              //     loading: () => AspectRatio(
              //       aspectRatio: 1,
              //       child: const CircularProgressIndicator(),
              //     ),
              //   ),
              // ),
              Expanded(
                child: familyPostalCode.when(
                  data: (data) => ListView.separated(
                    itemCount: data.data.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.data[index].ja.prefecture),
                          Text(data.data[index].ja.address1),
                          Text(data.data[index].ja.address2),
                          Text(data.data[index].ja.address3),
                          Text(data.data[index].ja.address4),
                        ],
                      ),
                    ),
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                      color: Colors.black,
                    ),
                  ),
                  error: (error, stack) => Text(error.toString()),
                  loading: () => AspectRatio(
                    aspectRatio: 1,
                    child: const CircularProgressIndicator(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onPostalCodeChanges(WidgetRef ref, String text) {
    if (text.length != 7) {
      return;
    }
    try {
      int.parse(text);
      ref.watch(postalCodeProvider.notifier).state = text;
    } catch (ex) {}
  }
}
