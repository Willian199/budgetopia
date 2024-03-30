import 'dart:async';

import 'package:budgetopia/config/banco/generated/objectbox.g.dart';
import 'package:budgetopia/config/banco/module/store_register.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ObjectBox {
  /// The Store of this

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<Database> create() async {
    final docsDir = await getApplicationDocumentsDirectory();

    final store = await openStore(directory: p.join(docsDir.path, "box-data"));

    return Database(store);
  }
}
