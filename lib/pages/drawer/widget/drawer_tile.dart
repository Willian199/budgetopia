import 'package:budgetopia/common/constantes/double.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class DrawerTile extends StatefulWidget {
  const DrawerTile(this.icon, this.text, this.page, {super.key});

  final IconData icon;
  final String text;
  final int page;

  @override
  State<DrawerTile> createState() => _DrawerTileState();
}

class _DrawerTileState extends State<DrawerTile> with DDIInject<PageController> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        splashColor: Colors.transparent,
        onTap: () {
          ddi<ZoomDrawerController>().close?.call();

          instance.jumpToPage(widget.page);
        },
        child: Container(
          height: Double.SETENTA,
          padding: const EdgeInsets.only(left: Double.VINTE),
          child: Row(
            children: <Widget>[
              Icon(
                widget.icon,
                size: Double.QUARENTA,
                color: instance.page?.round() == widget.page ? scheme.primary : scheme.onInverseSurface,
              ),
              const SizedBox(
                width: Double.TRINTA_DOIS,
              ),
              Text(
                widget.text,
                style: TextStyle(
                  fontSize: Double.VINTE,
                  color: instance.page?.round() == widget.page ? scheme.primary : scheme.onInverseSurface,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
