import 'package:flutter/material.dart';

class LoadMoreWidget extends StatelessWidget {
  const LoadMoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(child: Container()),
          const CircularProgressIndicator(),
          const Text("Cargando elementos"),
          Expanded(child: Container())
        ],
      ),
    );
  }
}
