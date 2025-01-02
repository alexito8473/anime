import 'package:flutter/material.dart';

class LoadWidget extends StatelessWidget {
  const LoadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black54,
        child: const Center(
            child: CircularProgressIndicator(
                backgroundColor: Colors.red,
                strokeWidth: 10,
                strokeAlign: 3,
                color: Colors.orange)));
  }
}
