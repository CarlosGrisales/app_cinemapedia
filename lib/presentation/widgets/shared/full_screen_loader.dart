import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         Text('Espere por favor', style: TextStyle(color: Colors.white),),
        SizedBox(height: 10),
        CircularProgressIndicator(),
        SizedBox(height: 10)
      ]),
    );
  }
}
