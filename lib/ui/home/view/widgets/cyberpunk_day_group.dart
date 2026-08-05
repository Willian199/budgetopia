import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:budgetopia/common/utils/moeda.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:budgetopia/ui/home/view/widgets/cyber_transaction_card.dart';
import 'package:flutter/material.dart';

class CyberpunkDayGroup extends StatefulWidget {
  const CyberpunkDayGroup({
    required this.day,
    required this.month,
    required this.transactions,
    required this.isLast,
    this.onRefresh,
    this.onConfirmSuggestion,
    super.key,
  });
  final int day;
  final String month;
  final List<MovimentacaoModel> transactions;
  final bool isLast;
  final VoidCallback? onRefresh;
  final Future<bool> Function(MovimentacaoModel sugestao)? onConfirmSuggestion;

  @override
  State<CyberpunkDayGroup> createState() => _CyberpunkDayGroupState();
}

class _CyberpunkDayGroupState extends State<CyberpunkDayGroup> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _slideAnimation;
  bool _isExpanded = true;

  // Adicione um controlador de animação dedicado para o efeito pulsante
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 0.2, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );
    // Configuração da animação pulsante que vai aumentar e diminuir
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Usando curva de seno para o efeito de aumentar e diminuir
    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );

    // Iniciar animações
    _controller.forward();
    _pulseController.repeat(reverse: true); // Isso cria o efeito de loop contínuo
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  double _calcularTotalDoDia() {
    double total = 0;
    for (var transaction in widget.transactions) {
      if (transaction.sugestao) {
        continue;
      }
      if (transaction.tipoMovimentacao == 1) {
        // Entrada
        total += transaction.valor.toDouble();
      } else {
        // Saída
        total -= transaction.valor.toDouble();
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;
    final tertiaryColor = theme.colorScheme.tertiary;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeInAnimation.value,
          child: Transform.translate(
            offset: Offset(0, 20 * _slideAnimation.value),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cabeçalho do dia com opção de expandir/colapsar
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Row(
                      children: [
                        // Caixa da data com efeito de brilho
                        Container(
                          width: 60,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isDarkMode ? tertiaryColor.withAlpha(40) : tertiaryColor.withAlpha(20),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: tertiaryColor.withAlpha(100),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: tertiaryColor.withAlpha(60),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                widget.day.toString(),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: tertiaryColor,
                                ),
                              ),
                              Text(
                                widget.month,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: tertiaryColor.withAlpha(200),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Linha horizontal animada
                        Expanded(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Linha de base
                              Container(
                                height: 1,
                                color: tertiaryColor.withAlpha(100),
                              ),

                              // Efeito de pulso na linha (apenas visível se expandido)
                              if (_isExpanded)
                                AnimatedBuilder(
                                  animation: _pulseAnimation,
                                  builder: (context, child) {
                                    // Calcular valor para expansão e contração suave
                                    // Usando 0.2 a 0.8 para que nunca desapareça completamente
                                    final pulseValue = 0.2 + (_pulseAnimation.value * 0.6);

                                    return Center(
                                      child: Container(
                                        height: 2 + (_pulseAnimation.value * 1), // Altura também pulsa um pouco
                                        width: MediaQuery.of(context).size.width * pulseValue,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              tertiaryColor.withAlpha(0),
                                              tertiaryColor.withAlpha(180),
                                              tertiaryColor.withAlpha(0),
                                            ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: tertiaryColor.withAlpha((100 * _pulseAnimation.value).toInt()),
                                              blurRadius: 4 + (_pulseAnimation.value * 3),
                                              spreadRadius: _pulseAnimation.value * 0.5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Total do dia com efeito de brilho
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDarkMode ? primaryColor.withAlpha(40) : primaryColor.withAlpha(20),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: primaryColor.withAlpha(100),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withAlpha(30),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Text(
                                'R\$ ${Moeda.format(valor: _calcularTotalDoDia())}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              const SizedBox(width: 4),
                              AnimatedRotation(
                                turns: _isExpanded ? 0 : 0.25,
                                duration: const Duration(milliseconds: 300),
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 18,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Lista de transações do dia com animação
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: _isExpanded
                        ? Column(
                            children: widget.transactions
                                .map(
                                  (transaction) => Padding(
                                    padding: const EdgeInsets.only(left: 30, bottom: 8),
                                    child: CyberpunkTransactionCard(
                                      transaction: transaction,
                                      onRefresh: widget.onRefresh,
                                      onConfirmSuggestion: widget.onConfirmSuggestion,
                                    ),
                                  ),
                                )
                                .toList(),
                          )
                        : const SizedBox.shrink(),
                  ),

                  // Linha do tempo
                  if (!widget.isLast && _isExpanded)
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Container(
                        width: 1,
                        height: 20,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              tertiaryColor.withAlpha(150),
                              tertiaryColor.withAlpha(0),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
