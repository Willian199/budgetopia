import 'package:budgetopia/common/components/button/container_back_button.dart';
import 'package:budgetopia/common/components/button/salvar_button.dart';
import 'package:budgetopia/common/components/generics/app_scaffold.dart';
import 'package:budgetopia/common/components/generics/custom_snackbar.dart';
import 'package:budgetopia/common/components/input_formatters/decimal_input_formatter.dart';
import 'package:budgetopia/common/components/generics/page_title.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:budgetopia/common/utils/moeda.dart';
import 'package:budgetopia/common/components/user_imagem/controller/user_image_controller.dart';
import 'package:budgetopia/ui/perfil/controller/data_nascimento_controller.dart';
import 'package:budgetopia/ui/perfil/controller/perfil_controller.dart';
import 'package:budgetopia/ui/perfil/mixin/perfil_page_mixin.dart';
import 'package:budgetopia/ui/perfil/view/widget/data_nascimento_field.dart';
import 'package:budgetopia/common/components/fields/info_fields.dart';
import 'package:budgetopia/ui/perfil/view/widget/info_usuario.dart';
import 'package:budgetopia/ui/perfil/view/widget/user_imagem_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> with PerfilPageMixin, DDIInject<PerfilController> {
  @override
  void initState() {
    super.initState();

    if (instance.registroSalvo case final item?) {
      nomeController.text = item.nome;
      valorObjetivoController.text = Moeda.format(valor: item.valor, simbolo: 'R\$');
      Future.delayed(Duration.zero, () {
        ddi.get<DataNascimentoController>().alterarDataNascimento(item.dataNascimento);
      });
    } else {
      valorObjetivoController.text = Moeda.format(valor: 0, simbolo: 'R\$', decimalDigits: 2);
    }
  }

  void _validarSalvar() {
    if (formKey.currentState?.validate() ?? false) {
      FocusManager.instance.primaryFocus?.unfocus();

      final dataNascimentoController = ddi.get<DataNascimentoController>();
      final userImageController = ddi.get<UserImageController>();
      final bool status = instance.salvar(
        nome: nomeController.text.trim(),
        valorObjetivo: Moeda.parse(valor: valorObjetivoController.text, simbolo: 'R\$').toDouble(),
        dataNascimento: dataNascimentoController.value,
        pathImagem: userImageController.pathImagem,
      );

      if (!status) {
        CustomSnackBar.informacacao(mensagem: 'Verifique os dados informados!');
        return;
      }

      CustomSnackBar.sucesso(mensagem: 'Dados de Perfil salvos com sucesso!');
    } else {
      CustomSnackBar.informacacao(mensagem: 'Verifique os dados informados!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    // Cores do tema
    final primaryColor = theme.colorScheme.primary;
    final backgroundColor = theme.colorScheme.surface;

    return AppScaffold(
      appBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Botão de menu
          const ContainerBackButton(),

          // Título
          const PageTitle(title: Strings.PERFIL),

          // Botão de salvar
          SalvarButton(
            onPressed: _validarSalvar,
          ),
        ],
      ),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          spacing: 20,
          children: [
            // Avatar do usuário
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withAlpha(77),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const UserImagemAvatar(),
            ),
            const SizedBox(height: 20),

            // Campo Nome
            InfoFields(
              label: Strings.NOME,
              icon: FontAwesomeIcons.noteSticky,
              controller: nomeController,
              focusNode: nomeFocusNode,
              nextFocus: dataNascimentoFocusNode,
              validator: (value) {
                if (value?.isEmpty ?? false) {
                  return Strings.INFORME_NOME;
                }
                return null;
              },
              primaryColor: primaryColor,
              backgroundColor: backgroundColor,
            ),

            // Campo Data de Nascimento
            DataNascimentoField(
              focusNode: dataNascimentoFocusNode,
              nextFocus: valorObjetivoFocusNode,
            ),

            // Campo Objetivo Saldo Mensal
            InfoFields(
              label: Strings.OBJETIVO_SALDO_MENSAL,
              icon: FontAwesomeIcons.moneyBill1Wave,
              controller: valorObjetivoController,
              focusNode: valorObjetivoFocusNode,
              keyboardType: TextInputType.number,
              inputFormatters: [
                DecimalInputFormatter(allowNegative: false),
              ],
              onFieldSubmitted: (_) => _validarSalvar(),
              onTap: () {
                if (!valorObjetivoFocusNode.hasPrimaryFocus) {
                  valorObjetivoController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: valorObjetivoController.value.text.length,
                  );
                }
              },
              validator: (value) {
                if (value?.isEmpty ?? false) {
                  return Strings.INFORME_VALOR;
                }
                return null;
              },
              primaryColor: primaryColor,
              backgroundColor: backgroundColor,
            ),

            const SizedBox(height: 10),

            // Indicador de status
            const InfoUsuario(),
          ],
        ),
      ),
    );
  }
}
