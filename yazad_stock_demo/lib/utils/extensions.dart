import 'package:flutter/widgets.dart';

extension ExpandedExtension on Widget {
  Widget expand() {
    return Expanded(
      child: this,
    );
  }
}