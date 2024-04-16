import 'package:budgetopia/common/components/generics/gradient_rect.dart';
import 'package:budgetopia/common/constantes/qualifiers.dart';
import 'package:budgetopia/common/enum/categoria_enum.dart';
import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:budgetopia/common/extensions/datetime_extension.dart';
import 'package:budgetopia/common/utils/moeda.dart';
import 'package:budgetopia/pages/home/controller/home_controller.dart';
import 'package:budgetopia/pages/movimentacao/model/movimentacao_model.dart';
import 'package:budgetopia/pages/movimentacao/module/movimentacao_module.dart';
import 'package:budgetopia/pages/movimentacao/view/movimentacao_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ItemListTile extends StatefulWidget {
  const ItemListTile({required this.item, required this.isLast, super.key});

  final MovimentacaoModel item;
  final bool isLast;

  @override
  State<ItemListTile> createState() => _ItemListTileState();
}

class _ItemListTileState extends State<ItemListTile> {
  @override
  Widget build(BuildContext context) {
    final bool darMode = context.get(Qualifier.dark_mode);
    return SizedBox(
      height: 110,
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    '${widget.item.data.day}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.item.data.getFormattedMonth(),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          // Divisor vertical com ícone circular no topo
          SizedBox(
            width: 50,
            height: 111,
            child: Stack(
              children: [
                Positioned(
                  top: 40,
                  left: 21,
                  child: Visibility(
                    visible: !widget.isLast,
                    replacement: GradientRect(
                      boxShadow: GradientBoxShadow(
                        gradient: LinearGradient(
                          colors: [
                            context.colorScheme.primary.withOpacity(0.2),
                            Colors.transparent,
                          ],
                        ),
                        blurRadius: 3,
                        spreadRadius: 4,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        width: 6,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [context.colorScheme.tertiaryContainer, Colors.transparent],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    child: Container(
                      width: 6,
                      height: 111,
                      decoration: BoxDecoration(
                        color: context.colorScheme.tertiaryContainer,
                        boxShadow: [
                          BoxShadow(
                            color: context.colorScheme.primary.withOpacity(0.2),
                            spreadRadius: 6,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 3,
                  child: Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: darMode ? Colors.transparent : context.colorScheme.tertiary.withOpacity(0.8),
                      border: Border.all(width: 4, color: context.colorScheme.tertiaryContainer),
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: [
                        BoxShadow(
                          color: context.colorScheme.primary.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 4,
                          blurStyle: BlurStyle.inner,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage('assets/icons/${TipoMovimentacaoEnum.getById(widget.item.tipoMovimentacao)!.icone}'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Botão à direita
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: context.colorScheme.onPrimary,
                boxShadow: [
                  BoxShadow(
                    color: context.colorScheme.primary.withOpacity(0.2),
                    spreadRadius: 6,
                    blurRadius: 5,
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FlutterDDIFutureWidget(
                          module: MovimentacaoModule.new,
                          child: (_) => MovimentacaoPage(
                            movimentacaoModel: widget.item,
                          ),
                        ),
                      ),
                    );
                    final HomeController controller = ddi.get();
                    controller.refresh({controller.tabSelecionada});
                  },
                  splashColor: context.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              widget.item.titulo,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              CategoriaEnum.getById(widget.item.codigoCategoria)?.nome ?? '',
                              style: TextStyle(
                                color: context.colorScheme.onTertiaryContainer,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              'R\$ ${Moeda.format(valor: widget.item.valor.toDouble())}',
                              style: TextStyle(
                                color: context.colorScheme.tertiary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: widget.item.status,
                          child: FaIcon(
                            FontAwesomeIcons.circleCheck,
                            size: 18,
                            color: context.colorScheme.secondary,
                          ),
                          replacement: FaIcon(
                            FontAwesomeIcons.circleExclamation,
                            size: 18,
                            color: context.colorScheme.secondary,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
