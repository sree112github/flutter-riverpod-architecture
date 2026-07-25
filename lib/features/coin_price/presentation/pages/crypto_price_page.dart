

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/crypto_price_controller.dart';

class CryptoPricePage extends ConsumerWidget {
  const CryptoPricePage({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    final cryptoPrice = ref.watch(cryptoPriceControllerProvider);
    final controller = ref.read(cryptoPriceControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Price'),
      ),
      body: cryptoPrice.when(
          data: (data){
            return Column(
              children: [
                Text(data.symbol),
                Text(data.price),
                ElevatedButton(onPressed:controller.refreshPage , child: Text("refresh"))
              ],
            );
          },
          error:(error,_){
            return Text(error.toString());
          },
          loading:(){
            return const Center(child: CircularProgressIndicator(),);
          }
      )

    );
  }
}
