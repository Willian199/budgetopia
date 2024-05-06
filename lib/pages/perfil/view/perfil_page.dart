import 'package:budgetopia/common/components/generics/custom_snackbar.dart';
import 'package:budgetopia/common/components/generics/default_back_button.dart';
import 'package:budgetopia/common/components/generics/degrade.dart';
import 'package:budgetopia/common/components/input_formatters/decimal_input_formatter.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:budgetopia/common/utils/moeda.dart';
import 'package:budgetopia/pages/perfil/controller/data_nascimento_controller.dart';
import 'package:budgetopia/pages/perfil/controller/salvar_perfil_controller.dart';
import 'package:budgetopia/pages/perfil/mixin/perfil_page_mixin.dart';
import 'package:budgetopia/pages/perfil/widget/data_nascimento_field.dart';
import 'package:budgetopia/pages/perfil/widget/user_imagem_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> with PerfilPageMixin, DDIInject<SalvarPerfilController> {
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

  void validarSalvar() {
    if (formKey.currentState?.validate() ?? false) {
      FocusManager.instance.primaryFocus?.unfocus();

      final bool status = instance.salvar(
        nome: nomeController.text.trim(),
        valorObjetivo: Moeda.parse(valor: valorObjetivoController.text, simbolo: 'R\$').toDouble(),
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
    final ThemeData tema = context.theme;
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.PERFIL),
        leading: const DefaultBackButton(),
        actions: [
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.floppyDisk,
              color: tema.colorScheme.primary,
            ),
            onPressed: validarSalvar,
          ),
        ],
      ),
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: Degrade.efeitoDegrade(
          cores: <Color>[
            tema.colorScheme.primaryContainer,
            tema.colorScheme.onSecondary,
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: [
                const UserImagemAvatar(),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: TextFormField(
                    controller: nomeController,
                    focusNode: nomeFocusNode,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      prefixIcon: SizedBox(
                        width: 40,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: FaIcon(
                              FontAwesomeIcons.noteSticky,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(dataNascimentoFocusNode);
                    },
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Por favor, informe o seu nome';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                DataNascimentoField(
                  focusNode: dataNascimentoFocusNode,
                  nextFocus: valorObjetivoFocusNode,
                ),
                const SizedBox(height: 20.0),
                FocusScope(
                  onFocusChange: (bool value) {
                    if (value) {
                      valorObjetivoController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: valorObjetivoController.value.text.length,
                      );
                    }
                  },
                  child: TextFormField(
                    controller: valorObjetivoController,
                    focusNode: valorObjetivoFocusNode,
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (_) => validarSalvar(),
                    onTap: () {
                      if (!valorObjetivoFocusNode.hasPrimaryFocus) {
                        valorObjetivoController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: valorObjetivoController.value.text.length,
                        );
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Objetivo Saldo Mensal',
                      prefixIcon: SizedBox(
                        width: 40,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: FaIcon(
                              FontAwesomeIcons.moneyBill1Wave,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.done,
                    inputFormatters: [
                      DecimalInputFormatter(allowNegative: false),
                    ],
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Por favor, insira um valor';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
