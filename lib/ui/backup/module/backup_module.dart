import 'package:budgetopia/data/repository/backup/backup_repository.dart';
import 'package:budgetopia/data/repository/backup/backup_repository_impl.dart';
import 'package:budgetopia/data/service/backup/backup_service.dart';
import 'package:budgetopia/data/service/backup/backup_service_impl.dart';
import 'package:budgetopia/ui/backup/controller/backup_controller.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class BackupModule with DDIModule {
  @override
  void onPostConstruct() {
    application<BackupService>(BackupServiceImpl.new);
    application<BackupRepository>(BackupRepositoryImpl.new);
    application(BackupController.new);
  }
}
