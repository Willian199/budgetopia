import 'dart:async';

import 'package:flutter_ddi/flutter_ddi.dart';

final class HomeCase with PreDestroy {
  double positionValue = 0.0;

  late final StreamController<double> _position = StreamController<double>.broadcast();

  Stream<double> get position => _position.stream;

  void changePosition(double value) {
    positionValue = value;

    _position.add(value);
  }

  @override
  FutureOr<void> onPreDestroy() {
    _position.close();
  }
}
