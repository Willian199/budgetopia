import 'package:budgetopia/common/components/button/container_back_button.dart';
import 'package:budgetopia/common/components/generics/app_scaffold.dart';
import 'package:budgetopia/common/components/generics/page_title.dart';
import 'package:budgetopia/common/enum/modo_importacao_backup.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:budgetopia/ui/backup/controller/backup_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> with DDIInject<BackupController> {
  Future<void> _importarJson() async {
    final BackupController controller = ddi.get<BackupController>();
    final String? filePath = await controller.selecionarArquivoJsonImportacao();
    if (filePath == null || !context.mounted) {
      return;
    }

    final ModoImportacaoBackup? modo = await _selecionarModoImportacao();
    if (modo == null) {
      return;
    }

    await controller.importarJson(filePath: filePath, modo: modo);
  }

  Future<ModoImportacaoBackup?> _selecionarModoImportacao() {
    return showDialog<ModoImportacaoBackup>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Importar backup JSON'),
          content: const Text(
            'Substituir tudo: remove os dados atuais e restaura apenas o arquivo.\n\n'
            'Mesclar: preserva os dados atuais e adiciona apenas novos registros.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(ModoImportacaoBackup.mesclar),
              child: const Text('Mesclar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(ModoImportacaoBackup.substituirTudo),
              child: const Text('Substituir tudo'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;

    return AppScaffold(
      appBar: const Row(
        children: <Widget>[
          ContainerBackButton(),
          Expanded(
            child: Center(
              child: PageTitle(title: 'Backup'),
            ),
          ),
          SizedBox(width: 30),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 14,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface.withAlpha(210),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorScheme.tertiary.withAlpha(120)),
              ),
              child: Text(
                'Exporte suas movimentacoes em JSON para backup e restaure quando necessario.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.45,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: instance.exportarSomenteLocal,
                icon: const Icon(Icons.save_alt_rounded),
                label: const Text('Exportar JSON (salvar local)'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: instance.exportarECompartilhar,
                icon: const Icon(Icons.share_rounded),
                label: const Text('Exportar e compartilhar'),
              ),
            ),
            const Divider(height: 26),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: _importarJson,
                icon: const Icon(Icons.file_upload_rounded),
                label: const Text('Importar JSON'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
