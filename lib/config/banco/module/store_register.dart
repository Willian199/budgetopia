import 'package:budgetopia/config/banco/generated/objectbox.g.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:meta/meta.dart';

extension type Database(Store store) implements Store {
  @redeclare
  void close() {
    throw UnsupportedError('Não é permitido fechar o store');
  }
}

class DatabaseInterceptor extends DDIInterceptor<Database> {
  @override
  void aroundDestroy(Store? instance) {
    instance?.close();
  }

  @override
  void aroundDispose(Store? instance) {
    instance?.close();
  }
}
