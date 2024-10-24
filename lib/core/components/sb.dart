import 'package:flutter/material.dart';

class SB extends StatelessWidget {
  final Widget _child;

  SB.h(double height, {Key? key})
      : _child = _WH(h: height),
        super(key: key);

  SB.w(double width, {Key? key})
      : _child = _WH(w: width),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return _child;
  }
}

class _WH extends StatelessWidget {
  final double? h, w;

  const _WH({this.h, this.w, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: h, width: w);
  }
}
