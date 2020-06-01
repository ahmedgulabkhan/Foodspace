import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Center(
        child: SpinKitRing(
          color: Colors.white,
          size: 50.0,
        )
      ),
    );
  }
}

class LoadingAlt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SpinKitRing(
          color: Theme.of(context).primaryColor,
          size: 50.0,
        )
      ),
    );
  }
}