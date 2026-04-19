class Strings {
  /// Nomes de menus, telas
  static const String APP_NAME = "Budgetopia";
  static const String LOCALE_PT = 'pt';
  static const String LOCALE_PT_BR = 'pt_BR';
  static const String DETALHES = 'Detalhes';
  static const String PERFIL = 'Perfil';
  static const String MOVIMENTACAO = 'Movimentação';
  static const String HOME = 'Home';
  static const String SOBRE = 'Sobre';
  static const String BACKUP = 'Backup';
  static const String GALERIA = 'Galeria';
  static const String CAMERA = 'Camera';

  // Labels
  static const String ENTRADA = "Entrada";
  static const String SAIDA = "Saída";
  static const String SALDO = "Saldo";
  static const String TODOS = "Todos";
  static const String ERRO = 'ERRO';
  static const String CARREGANDO = 'Carregando...';
  static const String RS = 'R\$';
  static const String VERSAO = 'Versão:';
  static const String NOME = 'Nome';
  static const String OBJETIVO_SALDO_MENSAL = 'Objetivo Saldo Mensal';
  static const String DATA_NASCIMENTO = 'Data de Nascimento';
  static const String TITULO = 'Título';
  static const String VALOR = 'Valor';
  static const String OBSERVACOES = 'Observações';
  static const String DATA = 'Data';
  static const String CATEGORIA = 'Categoria';
  static const String TIPO_TRANSACAO = 'Tipo de Transação';
  static const String TIPO_RECORRENCIA = 'Tipo de Recorrencia';
  static const String QUANTIDADE_PARCELAS = 'Quantidade de Parcelas';
  static const String INTERVALO_EM_DIAS = 'Intervalo em dias';
  static const String DATA_MAXIMA_SUGESTOES = 'Data maxima das sugestoes';
  static const String TRANSACAO_REALIZADA = 'Transação realizada: ';
  static const String VALOR_TOTAL = 'Valor total:';
  static const String NENHUMA_TRANSACAO_ENCONTRADA = 'Nenhuma transação encontrada';
  static const String NENHUM_MES_DISPONIVEL = 'Nenhum mês disponível';
  static const String CONFIRMAR_DATA = 'CONFIRMAR DATA';
  static const String DIA_HINT = 'DD';
  static const String MES_HINT = 'MM';
  static const String ANO_HINT = 'AAAA';
  static const String DIA = 'DIA';
  static const String MES = 'MES';
  static const String ANO = 'ANO';
  static const String SEPARADOR_DATA = '/';
  static const String SUGESTAO = 'SUGESTAO';

  // Ações
  static const String OK = 'OK';
  static const String FECHAR = 'FECHAR';
  static const String CANCELAR = 'CANCELAR';
  static const String SALVAR = 'SALVAR';
  static const String CONFIRMAR = 'Confirmar';
  static const String EDITAR_RECORRENCIA = 'Editar recorrência';
  static const String MESCLAR = 'Mesclar';
  static const String SUBSTITUIR_TUDO = 'Substituir tudo';

  // Mensagens
  static const String SELECIONAR_IMAGEM = 'Selecionar Imagem';
  static const String SALDO_OBJETIVO_MENSAL = 'Saldo objetivo mensal:';
  static const String SALDO_PERIODO = 'Saldo do período:';
  static const String TOTAL_SAIDAS = 'Total de saídas:';
  static const String TOTAL_ENTRADAS = 'Total de entradas:';
  static const String RESUMO_FINANCEIRO = 'RESUMO FINANCEIRO';
  static const String ANALISE_TEMPORAL = 'ANÁLISE TEMPORAL';
  static const String INFORME_NOME = 'Por favor, informe o seu nome';
  static const String INFORME_VALOR = 'Por favor, insira um valor';
  static const String INFORME_TITULO = 'Por favor, insira um título';
  static const String INFORME_O_VALOR = 'Informe o valor';
  static const String INFORME_AO_MENOS_DUAS_PARCELAS = 'Informe ao menos 2 parcelas';
  static const String INFORME_INTERVALO_VALIDO = 'Informe um intervalo válido';
  static const String QUANTIDADE_PARCELAS_PADRAO = '2';
  static const String INTERVALO_RECORRENCIA_PADRAO = '30';
  static const String DATA_FORMATO_PADRAO = 'dd/MM/yyyy';
  static const String VERIFIQUE_DADOS_INFORMADOS = 'Verifique os dados informados!';
  static const String DADOS_PERFIL_SALVOS = 'Dados de Perfil salvos com sucesso!';
  static const String TRANSACAO_REMOVIDA = 'Transação removida';
  static const String ERRO_REMOVER_TRANSACAO = 'Erro ao remover transação';
  static const String ERRO_SALVAR_TRANSACAO = 'Erro ao salvar transação';
  static const String TRANSACOES_PARCELADAS_SALVAS = 'transações parceladas salvas!';
  static const String RECORRENCIA_ATUALIZADA = 'Recorrência atualizada com sucesso!';
  static const String RECORRENCIA_CADASTRADA = 'Recorrência cadastrada com sucesso!';
  static const String TRANSACAO_SALVA = 'Transação salva!';
  static const String SUCESSO = 'Sucesso!!!';
  static const String ACAO_EXECUTADA_SUCESSO = 'Ação executada com sucesso';
  static const String SOLICITACAO_EXECUTADA = 'A solicitação foi executa';
  static const String OOPS_ALGO_DEU_ERRADO = 'Oops, algo deu errado!';
  static const String IMPORTAR_BACKUP_JSON = 'Importar backup JSON';
  static const String MENSAGEM_MODO_IMPORTACAO_BACKUP =
      'Substituir tudo: remove os dados atuais e restaura apenas o arquivo.\n\n'
      'Mesclar: preserva os dados atuais e adiciona apenas novos registros.';
  static const String DESCRICAO_BACKUP = 'Exporte suas movimentacoes em JSON para backup e restaure quando necessario.';
  static const String EXPORTAR_JSON_LOCAL = 'Exportar JSON (salvar local)';
  static const String EXPORTAR_E_COMPARTILHAR = 'Exportar e compartilhar';
  static const String IMPORTAR_JSON = 'Importar JSON';
  static const String SALVAR_BACKUP_JSON = 'Salvar backup JSON';
  static const String SALVAMENTO_CANCELADO = 'Salvamento cancelado.';
  static const String FALHA_EXPORTAR_BACKUP = 'Falha ao exportar backup.';
  static const String TEXTO_COMPARTILHAR_BACKUP = 'Backup de movimentacoes do Budgetopia';
  static const String BACKUP_COMPARTILHADO_SUCESSO = 'Backup criado e compartilhado com sucesso.';
  static const String COMPARTILHAMENTO_CANCELADO = 'Compartilhamento cancelado. O backup ficou salvo localmente.';
  static const String BACKUP_LOCAL_COMPARTILHAMENTO_INDEFINIDO =
      'Backup salvo localmente, mas nao foi possivel confirmar o compartilhamento.';
  static const String FALHA_EXPORTAR_COMPARTILHAR_BACKUP = 'Falha ao exportar/compartilhar backup.';
  static const String SELECIONE_ARQUIVO_JSON_BACKUP = 'Selecione um arquivo JSON de backup';
  static const String FALHA_IMPORTAR_BACKUP = 'Falha ao importar backup.';
  static const String BACKUP_ESTRUTURA_INVALIDA = 'Estrutura invalida para backup.';
  static const String BACKUP_CAMPO_MOVIMENTACOES_INVALIDO = 'Campo movimentacoes ausente ou invalido.';
  static const String BACKUP_ITEM_MOVIMENTACAO_INVALIDO = 'Item de movimentacao invalido.';
  static const String BACKUP_CAMPO_RECORRENCIAS_INVALIDO = 'Campo recorrencias ausente ou invalido.';
  static const String BACKUP_CAMPO_PERFIL_INVALIDO = 'Campo perfil invalido.';
  static const String BACKUP_ITEM_RECORRENCIA_INVALIDO = 'Item de recorrencia invalido.';
  static String backupSchemaNaoSuportado(int schemaVersion) => 'Versao de schema nao suportada: $schemaVersion';

  static String jsonInvalido(String message) => 'JSON invalido: $message';

  static String campoBackupInvalido(String fieldName) => 'Campo $fieldName invalido.';

  static const String CONFIRMAR_SUGESTAO = 'Confirmar sugestão';
  static const String SUGESTAO_CONFIRMADA_SALVA = 'Sugestão confirmada e salva!';
  static const String FALHA_CONFIRMAR_SUGESTAO = 'Não foi possível confirmar a sugestão';
  static String backupSalvo({required String arquivo, required int totalMovimentacoes}) =>
      'Backup salvo: $arquivo ($totalMovimentacoes itens).';

  static String importacaoBackupConcluida({required int totalImportadas, required int totalIgnoradas}) =>
      'Importacao concluida: $totalImportadas inseridas e $totalIgnoradas ignoradas.';

  static String confirmarSugestao({
    required String titulo,
    required String data,
    required String valor,
  }) => 'Deseja confirmar "$titulo" em $data por $valor?';

  static const String SOBRE_CHAMADA = 'Gerencie suas finanças com facilidade';
  static const String SOBRE_DESCRICAO =
      'Budgetopia permite que você acompanhe suas entradas e saídas financeiras de forma simples e eficaz. Com recursos práticos e uma interface amigável, você pode manter suas finanças sob controle, alcançando seus objetivos financeiros com mais tranquilidade.';
  static const String STATUS_OPERACIONAL = 'STATUS OPERACIONAL';
  static const String SOBRE_STATUS =
      'Mantenha-se no comando das suas finanças com Budgetopia - seu parceiro confiável para uma jornada financeira mais inteligente em um mundo cada vez mais complexo.';
  static const String VERSAO_APP = 'v 1.0.0';
  static const String INSTRUCAO_DATE_PICKER_SELECTOR =
      'Deslize horizontalmente para mudar o valor\nToque nos botões para mudar o campo';
  static const String INSTRUCAO_DATE_PICKER_INPUT = 'Digite a data no formato DD/MM/AAAA';

  // Perfil
  static const String DADOS_DO_USUARIO = 'DADOS DO USUÁRIO';
  static const String PREENCHA_DADOS_PERFIL = 'Preencha seus dados para personalizar seu perfil';

  // Movimentação
  static const String CADASTRO_UNICO = 'Unico';
  static const String CADASTRO_PARCELADO = 'Parcelado';
  static const String CADASTRO_RECORRENCIA = 'Recorrencia';

  // Recorrência
  static const String RECORRENCIA_DIARIA = 'Diaria';
  static const String RECORRENCIA_SEMANAL = 'Semanal';
  static const String RECORRENCIA_QUINZENAL = 'Quinzenal';
  static const String RECORRENCIA_MENSAL = 'Mensal';
  static const String RECORRENCIA_DIAS_FIXOS = 'Dias Fixos';

  // Datas
  static const List<String> MESES_ABREVIADOS = <String>[
    'JAN',
    'FEV',
    'MAR',
    'ABR',
    'MAI',
    'JUN',
    'JUL',
    'AGO',
    'SET',
    'OUT',
    'NOV',
    'DEZ',
  ];
  static const List<String> MESES_CURTOS = <String>[
    '',
    'Jan',
    'Fev',
    'Mar',
    'Abr',
    'Mai',
    'Jun',
    'Jul',
    'Ago',
    'Set',
    'Out',
    'Nov',
    'Dez',
  ];

  // Categorias
  static const Map<int, String> CATEGORIA_NOMES = <int, String>{
    1: 'Alimentacao',
    2: 'Aluguel',
    3: 'Animais',
    4: 'Bebidas',
    5: 'Beleza',
    6: 'Caridade',
    7: 'Compras',
    8: 'Contas',
    9: 'Cuidados Pessoais',
    10: 'Educacao',
    11: 'Eletronicos',
    12: 'Energia',
    13: 'Entretenimento',
    14: 'Esportes',
    15: 'Eventos',
    16: 'Festas',
    17: 'Filhos',
    18: 'Hobbies',
    19: 'Impostos',
    20: 'Imprevistos',
    21: 'Investimentos',
    22: 'Jogos',
    23: 'Lazer',
    24: 'Livros',
    25: 'Manutencao',
    26: 'Musica',
    27: 'Presentes',
    28: 'Roupas',
    29: 'Saude',
    30: 'Seguros',
    31: 'Tecnologia',
    32: 'Transporte',
    33: 'Viagem',
    34: 'Academia',
    35: 'Acessorios',
    36: 'Assinaturas',
    37: 'Banco',
    38: 'Casa',
    39: 'Combustivel',
    40: 'Comunicacao',
    41: 'Cursos',
    42: 'Delivery',
    43: 'Farmacia',
    44: 'Hotel',
    45: 'Internet',
    46: 'Moradia',
    47: 'Padaria',
    48: 'Papelaria',
    49: 'Restaurante',
    50: 'Salario',
    51: 'Servicos',
    52: 'Supermercado',
    53: 'Telefone',
    54: 'Taxas',
    55: 'Agua',
    56: 'Condominio',
    57: 'Creche',
    58: 'Dentista',
    59: 'Estacionamento',
    60: 'Freelance',
    61: 'Gift Cards',
    62: 'Higiene',
    63: 'Lavanderia',
    64: 'Licencas',
    65: 'Material Escolar',
    66: 'Mensalidade',
    67: 'Parcelas',
    68: 'Refeicoes Trabalho',
    69: 'Reparos',
    70: 'Streaming',
    71: 'Advogado',
    72: 'Alfandega',
    73: 'Aplicativos',
    74: 'Artesanato',
    75: 'Bares',
    76: 'Bicicleta',
    77: 'Bonificacao',
    78: 'Cashback',
    79: 'Cambio',
    80: 'Cartao Credito',
    81: 'Cinema e Teatro',
    82: 'Clinica Veterinaria',
    83: 'Corretagem',
    84: 'Decoracao',
    85: 'Dividendos',
    86: 'Eletrodomesticos',
    87: 'Exames',
    88: 'Feira',
    89: 'Ferramentas',
    90: 'Financiamento',
    91: 'Fotografia',
    92: 'Franquias',
    93: 'Juros',
    94: 'Limpeza',
    95: 'Marketing',
    96: 'Mobiliario',
    97: 'Previdencia Privada',
    98: 'Reembolso',
    99: 'Outros',
    100: 'Venda de Itens',
  };
}
