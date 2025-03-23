import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:budgetopia/common/components/button/container_back_button.dart';
import 'package:budgetopia/common/components/generics/custom_snackbar.dart';
import 'package:budgetopia/common/components/input_formatters/decimal_input_formatter.dart';
import 'package:budgetopia/common/components/painter/grid_painter.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/utils/moeda.dart';
import 'package:budgetopia/ui/perfil/case/salvar_perfil_case.dart';
import 'package:budgetopia/ui/perfil/controller/data_nascimento_controller.dart';
import 'package:budgetopia/ui/perfil/mixin/perfil_page_mixin.dart';
import 'package:budgetopia/ui/perfil/view/widget/data_nascimento_field.dart';
import 'package:budgetopia/ui/perfil/view/widget/info_fields.dart';
import 'package:budgetopia/ui/perfil/view/widget/user_imagem_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> with PerfilPageMixin, DDIInject<PerfilCase> {
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
    final theme = AdaptiveTheme.of(context).theme;
    final isDarkMode = theme.brightness == Brightness.dark;

    // Cores do tema
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    final tertiaryColor = theme.colorScheme.tertiary;
    final backgroundColor = isDarkMode
        ? const Color(0xFF002215) // Dark theme background
        : const Color(0xFFebffe5); // Light theme background

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Grid de fundo estilo cyberpunk
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(
                lineColor: primaryColor.withAlpha(26),
                lineWidth: 0.8,
              ),
            ),
          ),

          // Efeito de luz no topo
          Positioned(
            top: -50,
            right: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: tertiaryColor.withAlpha(51),
                    blurRadius: 80,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),

          // Conteúdo principal
          SafeArea(
            child: Column(
              children: [
                // Barra superior personalizada
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Botão de menu
                      const ContainerBackButton(),

                      // Título
                      Text(
                        Strings.PERFIL,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                          color: primaryColor,
                          shadows: [
                            Shadow(
                              color: primaryColor.withAlpha(128),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),

                      // Botão de salvar
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: tertiaryColor.withAlpha(128),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: tertiaryColor.withAlpha(77),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                            BoxShadow(
                              color: tertiaryColor.withAlpha(100),
                              blurRadius: 9,
                              blurStyle: BlurStyle.outer,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.floppyDisk,
                            color: primaryColor,
                            size: 20,
                          ),
                          onPressed: validarSalvar,
                        ),
                      ),
                    ],
                  ),
                ),

                // Área de conteúdo com rolagem
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Form(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.always,
                      child: Column(
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
                          const SizedBox(height: 40),

                          // Campo Nome
                          InfoFields(
                            context: context,
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

                          const SizedBox(height: 20),

                          // Campo Data de Nascimento
                          DataNascimentoField(
                            focusNode: dataNascimentoFocusNode,
                            nextFocus: valorObjetivoFocusNode,
                          ),

                          const SizedBox(height: 20),

                          // Campo Objetivo Saldo Mensal
                          InfoFields(
                            context: context,
                            label: Strings.OBJETIVO_SALDO_MENSAL,
                            icon: FontAwesomeIcons.moneyBill1Wave,
                            controller: valorObjetivoController,
                            focusNode: valorObjetivoFocusNode,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              DecimalInputFormatter(allowNegative: false),
                            ],
                            onFieldSubmitted: (_) => validarSalvar(),
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

                          const SizedBox(height: 30),

                          // Indicador de status
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                              color: isDarkMode ? primaryColor.withAlpha(26) : primaryColor.withAlpha(13),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: secondaryColor.withAlpha(102),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: tertiaryColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: tertiaryColor.withAlpha(153),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "DADOS DO USUÁRIO",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                          color: tertiaryColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Preencha seus dados para personalizar seu perfil",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: theme.textTheme.bodyMedium?.color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
