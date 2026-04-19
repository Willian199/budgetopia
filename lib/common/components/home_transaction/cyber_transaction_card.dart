import 'dart:math' as math;
import 'dart:ui';

import 'package:budgetopia/common/enum/categoria_enum.dart';
import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/common/extensions/datetime_extension.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:budgetopia/common/utils/moeda.dart';
import 'package:budgetopia/common/components/generics/custom_snackbar.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:budgetopia/ui/movimentacao/module/movimentacao_module.dart';
import 'package:budgetopia/ui/movimentacao/view/movimentacao_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CyberpunkTransactionCard extends StatefulWidget {
  const CyberpunkTransactionCard({
    required this.transaction,
    this.onRefresh,
    this.onConfirmSuggestion,
    super.key,
  });
  final MovimentacaoModel transaction;
  final VoidCallback? onRefresh;
  final Future<bool> Function(MovimentacaoModel sugestao)? onConfirmSuggestion;

  @override
  State<CyberpunkTransactionCard> createState() => _CyberpunkTransactionCardState();
}

class _CyberpunkTransactionCardState extends State<CyberpunkTransactionCard> with TickerProviderStateMixin {
  // Múltiplos controladores para efeitos diversos
  late AnimationController _pressController;
  late AnimationController _pulseController;
  late AnimationController _scanLineController;

  // Animações
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _scanLineAnimation;

  // Estado de interatividade
  bool _isLongPressing = false;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();

    // Animação principal de pressionar
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOutCubic),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOutCubic),
    );

    // Animação de pulso constante para elementos internos
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _pulseController.repeat(reverse: true);

    // Animação de linha de scanner
    _scanLineController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scanLineAnimation = Tween<double>(begin: -0.2, end: 1.2).animate(
      CurvedAnimation(parent: _scanLineController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    _pulseController.dispose();
    _scanLineController.dispose();
    super.dispose();
  }

  Future<void> _onTapCard() async {
    if (_isLongPressing) {
      return;
    }

    HapticFeedback.selectionClick();

    if (widget.transaction.sugestao) {
      final bool? confirmar = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirmar sugestão'),
            content: Text(
              'Deseja confirmar "${widget.transaction.titulo}" em ${widget.transaction.data.format()} por '
              '${Moeda.format(valor: widget.transaction.valor, simbolo: 'R\$')}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Editar recorrência'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Confirmar'),
              ),
            ],
          );
        },
      );

      if (confirmar == null) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FlutterDDIBuilder(
              module: MovimentacaoModule.new,
              child: (_) => MovimentacaoPage(
                codigoRecorrencia: widget.transaction.codigoRecorrencia,
              ),
            ),
          ),
        );

        widget.onRefresh?.call();
        return;
      }

      if (confirmar != true || widget.onConfirmSuggestion == null) {
        return;
      }

      final bool status = await widget.onConfirmSuggestion!(widget.transaction);

      if (status) {
        CustomSnackBar.sucesso(mensagem: 'Sugestão confirmada e salva!');
        widget.onRefresh?.call();
      } else {
        CustomSnackBar.informacacao(mensagem: 'Não foi possível confirmar a sugestão');
      }
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FlutterDDIBuilder(
          module: MovimentacaoModule.new,
          child: (_) => MovimentacaoPage(
            movimentacaoModel: widget.transaction,
          ),
        ),
      ),
    );

    widget.onRefresh?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDarkMode = theme.brightness == Brightness.dark;

    // Cores principais do tema
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;

    // Cores específicas para entrada e saída
    final statusColor = widget.transaction.status ? secondaryColor : Colors.red.shade600;

    final transactionColor = widget.transaction.tipoMovimentacao == 1 ? Colors.green.shade600 : Colors.red.shade600;

    // Dados da transação
    final tipoMovimentacao = TipoMovimentacaoEnum.getById(widget.transaction.tipoMovimentacao);
    final nomeCategoria = CategoriaEnum.getById(widget.transaction.codigoCategoria)?.nome ?? '';

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTapDown: (_) {
          HapticFeedback.lightImpact();
          _pressController.forward();
        },
        onTapUp: (_) {
          _pressController.reverse();
        },
        onTapCancel: () {
          _pressController.reverse();
        },
        onLongPressStart: (_) {
          HapticFeedback.mediumImpact();
          _isLongPressing = true;
          _pressController.forward();
          // Iniciar o scanner durante o long press
          _scanLineController.repeat();
        },
        onLongPressEnd: (_) {
          _isLongPressing = false;
          _pressController.reverse();
          _scanLineController.stop();
          _scanLineController.reset();
        },
        onLongPressCancel: () {
          _isLongPressing = false;
          _pressController.reverse();
          _scanLineController.stop();
          _scanLineController.reset();
        },
        onTap: () async {
          await _onTapCard();
        },
        child: AnimatedBuilder(
          animation: Listenable.merge([_pressController, _pulseController, _scanLineController]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.black.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Color.lerp(
                      transactionColor.withAlpha(100),
                      transactionColor,
                      _isHovering ? 0.7 : _glowAnimation.value * 0.5,
                    )!,
                    width: 1.5,
                  ),
                  boxShadow: [
                    // Sombra base
                    BoxShadow(
                      color: primaryColor.withAlpha(20 + (_glowAnimation.value * 10).toInt()),
                      blurRadius: 8 + (_glowAnimation.value * 4),
                      spreadRadius: 1 + (_glowAnimation.value * 0.5),
                    ),
                    // Sombra de cor pelo tipo de transação
                    BoxShadow(
                      color: transactionColor.withAlpha(
                        (_glowAnimation.value * 80).toInt() + (_pulseController.value * 20).toInt(),
                      ),
                      blurRadius: 12 + (_glowAnimation.value * 8),
                      spreadRadius: -2 + (_glowAnimation.value * 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Stack(
                      children: [
                        // Fundo com padrão de grade
                        Positioned.fill(
                          child: CustomPaint(
                            painter: CyberpunkGridPainter(
                              color: transactionColor,
                              intensity: _pulseController.value * 0.2 + (_isHovering ? 0.3 : 0.1),
                            ),
                          ),
                        ),

                        // Linha de scanner durante interação
                        if (_scanLineController.isAnimating || _isLongPressing || _isHovering)
                          Positioned(
                            left: 0,
                            right: 0,
                            top: MediaQuery.sizeOf(context).height * _scanLineAnimation.value,
                            height: 15,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    transactionColor.withAlpha(0),
                                    transactionColor.withAlpha(100),
                                    transactionColor.withAlpha(0),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        // Conteúdo principal
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              // Ícone da categoria com efeito avançado
                              _buildCategoryIcon(tipoMovimentacao, transactionColor, isDarkMode),

                              const SizedBox(width: 16),

                              // Detalhes da transação
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Título
                                        Flexible(
                                          child: Text(
                                            widget.transaction.titulo,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              letterSpacing: 0.3,
                                              color: isDarkMode
                                                  ? Colors.white.withValues(alpha: 0.95)
                                                  : theme.textTheme.bodyLarge?.color,
                                              shadows: [
                                                Shadow(
                                                  color: transactionColor.withValues(
                                                    alpha: _pulseController.value * 0.3,
                                                  ),
                                                  blurRadius: 3.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        // Indicador de status animado
                                        widget.transaction.sugestao
                                            ? Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.orange.withValues(alpha: 0.2),
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: Colors.orange.withValues(alpha: 0.6),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'SUGESTAO',
                                                  style: TextStyle(
                                                    color: Colors.orange,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.8,
                                                  ),
                                                ),
                                              )
                                            : _buildStatusIndicator(widget.transaction.status, statusColor),
                                      ],
                                    ),

                                    const SizedBox(height: 6),

                                    // Categoria
                                    Row(
                                      children: [
                                        Container(
                                          height: 8,
                                          width: 8,
                                          decoration: BoxDecoration(
                                            color: transactionColor.withValues(
                                              alpha: 0.7 + _pulseController.value * 0.3,
                                            ),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: transactionColor.withValues(alpha: 0.5),
                                                blurRadius: 4,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          nomeCategoria,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isDarkMode ? Colors.white70 : Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 10),

                                    // Valor
                                    _buildValueDisplay(widget.transaction.valor.toDouble(), transactionColor),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Borda com gradiente dinâmico
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  width: 0,
                                  color: Colors.transparent,
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  stops: [
                                    0.0,
                                    0.2 + (_pulseController.value * 0.1),
                                    0.5 + (_pulseController.value * 0.1),
                                    1.0,
                                  ],
                                  colors: [
                                    transactionColor.withAlpha(
                                      (_isHovering ? 100 : 0) + (_glowAnimation.value * 70).toInt(),
                                    ),
                                    Colors.transparent,
                                    Colors.transparent,
                                    transactionColor.withAlpha(
                                      (_isHovering ? 80 : 0) + (_glowAnimation.value * 50).toInt(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Widget de ícone da categoria com efeitos
  Widget _buildCategoryIcon(
    TipoMovimentacaoEnum? tipoMovimentacao,
    Color transactionColor,
    bool isDarkMode,
  ) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDarkMode ? Colors.black.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.2),
        boxShadow: [
          BoxShadow(
            color: transactionColor.withAlpha(100 + (70 * _pulseController.value).toInt()),
            blurRadius: 10 + (_pulseController.value * 5),
          ),
        ],
        border: Border.all(
          color: transactionColor.withAlpha(150 + (50 * _glowAnimation.value).toInt()),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Efeito de halo para o ícone
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 30 + (_glowAnimation.value * 5),
              height: 30 + (_glowAnimation.value * 5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: transactionColor.withAlpha(150 * _glowAnimation.value.toInt()),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),

            // Ícone principal
            Transform.rotate(
              angle: _pulseController.value * 0.05, // Leve rotação
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.transparent,
                backgroundImage: tipoMovimentacao != null ? AssetImage('assets/icons/${tipoMovimentacao.icone}') : null,
              ),
            ),

            // Overlay de circuito
            if (_isHovering || _pressController.value > 0)
              Transform.rotate(
                angle: _pulseController.value * -0.1,
                child: CustomPaint(
                  size: const Size(40, 40),
                  painter: CircuitOverlayPainter(
                    color: transactionColor,
                    progress: _pulseController.value,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Widget do indicador de status
  Widget _buildStatusIndicator(bool isComplete, Color statusColor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: statusColor.withAlpha(100 + (100 * _pulseController.value).toInt()),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withAlpha(100 * _pulseController.value.toInt()),
            blurRadius: 6,
          ),
        ],
      ),
      child: Center(
        child: FaIcon(
          isComplete ? FontAwesomeIcons.check : FontAwesomeIcons.exclamation,
          size: 10,
          color: statusColor.withValues(alpha: 0.9 + (_pulseController.value * 0.1)),
        ),
      ),
    );
  }

  // Widget de exibição do valor
  Widget _buildValueDisplay(double value, Color transactionColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: transactionColor.withAlpha(20),
        border: Border.all(
          color: transactionColor.withAlpha(90 + (60 * _pulseController.value).toInt()),
        ),
        boxShadow: [
          BoxShadow(
            color: transactionColor.withAlpha((50 * _pulseController.value).toInt()),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Símbolo da moeda com efeito pulsante
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                transactionColor,
                transactionColor.withAlpha(150),
              ],
            ).createShader(bounds),
            child: const Text(
              'R\$',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 4),

          // Valor com fonte monoespaçada para efeito digital
          Text(
            Moeda.format(valor: value),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              letterSpacing: 0.7,
              fontFamily: 'monospace',
              color: transactionColor,
              shadows: [
                Shadow(
                  color: transactionColor.withValues(alpha: 0.6),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Pintores personalizados para efeitos visuais

// Pintor para o fundo do grid cyberpunk
class CyberpunkGridPainter extends CustomPainter {
  CyberpunkGridPainter({
    required this.color,
    this.intensity = 0.2,
  });
  final Color color;
  final double intensity;

  @override
  void paint(Canvas canvas, Size size) {
    // Linhas de grade principais
    final paint = Paint()
      ..color = color.withValues(alpha: 0.05 * intensity)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Linhas horizontais
    for (double y = 5; y < size.height; y += 10) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Linhas verticais mais sutis
    paint.color = color.withValues(alpha: 0.03 * intensity);
    for (double x = 5; x < size.width; x += 15) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Pontos brilhantes aleatórios (como nós de circuito)
    final pointPaint = Paint()
      ..color = color.withValues(alpha: 0.4 * intensity)
      ..style = PaintingStyle.fill;

    final random = math.Random(42);
    for (int i = 0; i < 5; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawCircle(
        Offset(x, y),
        0.7,
        pointPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CyberpunkGridPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.intensity != intensity;
}

// Pintor de overlay de circuito para o ícone
class CircuitOverlayPainter extends CustomPainter {
  CircuitOverlayPainter({
    required this.color,
    required this.progress,
  });
  final Color color;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);

    // Traçar linhas de circuito em padrão angular
    for (int i = 0; i < 6; i++) {
      final angle = (i / 6) * 2 * math.pi + (progress * math.pi * 2);
      final outerX = center.dx + math.cos(angle) * radius;
      final outerY = center.dy + math.sin(angle) * radius;
      final innerX = center.dx + math.cos(angle) * (radius * 0.5);
      final innerY = center.dy + math.sin(angle) * (radius * 0.5);

      canvas.drawLine(
        Offset(innerX, innerY),
        Offset(outerX, outerY),
        paint,
      );
    }

    // Círculo central pulsante
    final circlePaint = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5 + (progress * 0.5);

    canvas.drawCircle(
      center,
      radius * 0.5,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CircuitOverlayPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.progress != progress;
}
