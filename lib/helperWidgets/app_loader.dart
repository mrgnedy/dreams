import 'package:flutter/material.dart';

class AppLoader extends StatelessWidget {
  final bool isCentered;
  const AppLoader({Key? key, this.isCentered = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(!isCentered) return const   CircularProgressIndicator();
    return const Center(child: CircularProgressIndicator());
  }
}
