import 'package:flutter/material.dart';

class Degrade {
  Degrade();

  ///
  /// @return BoxDecoration()
  ///
  static BoxDecoration efeitoDegrade({List<Color>? cores, Alignment begin = Alignment.topCenter, Alignment end = Alignment.bottomCenter}) {
    cores ??= <Color>[Colors.blue[800]!, Colors.blueAccent[100]!];

    return BoxDecoration(
      gradient: LinearGradient(
        colors: cores,
        begin: begin,
        end: end,
      ),
    );
  }

  ///
  /// @return Container()
  ///
  static Widget containerEfeitoDegrade({
    List<Color>? cores,
    Alignment begin = Alignment.topCenter,
    Alignment end = Alignment.bottomCenter,
  }) {
    return Container(
      decoration: efeitoDegrade(
        cores: cores,
        begin: begin,
        end: end,
      ),
    );
  }
}
