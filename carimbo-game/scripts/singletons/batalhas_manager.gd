extends Node

enum INIMIGOS {SUPERVISOR, ELFO, ELFO_SUP, MAMA_NOEL, PAPA_NOEL}
const INIMIGOS_TEXT = {
	INIMIGOS.SUPERVISOR: "Supervisor",
	INIMIGOS.ELFO: "Elfo",
	INIMIGOS.ELFO_SUP: "Elfo Supervisor",
	INIMIGOS.MAMA_NOEL: "La Mama Noel",
	INIMIGOS.PAPA_NOEL: "El Papa Noel",
}

enum ATQ_INIMIGO {
	ESCALA_6x1, REDUCAO_SALARIAL, DEMISSAO_JUSTA_CAUSA,
	REDUCAO_INTERVALO_ALMOCO, REDUCAO_VA,
	TRABALHO_FERIADO, PEJOTIZACAO, ACUMULO_FUNCOES, ATRASO_PAGAMENTO,
	DECIMO_TERCEIRO_NEGADO, FGTS_ATRASADO,
}
const ATQ_INIMIGO_TEXT = {
	ATQ_INIMIGO.ESCALA_6x1: "Escala 6x1",
	ATQ_INIMIGO.REDUCAO_SALARIAL: "Redução salarial",
	ATQ_INIMIGO.DEMISSAO_JUSTA_CAUSA: "Ameaça de demissão por justa causa",
	ATQ_INIMIGO.REDUCAO_INTERVALO_ALMOCO: "Redução do intervalo de almoço",
	ATQ_INIMIGO.REDUCAO_VA: "Redução do vale alimentação",
	ATQ_INIMIGO.TRABALHO_FERIADO: "Trabalho no feriado",
	ATQ_INIMIGO.PEJOTIZACAO: "Contrato PJ com obrigações CLT (Pejotização)",
	ATQ_INIMIGO.ACUMULO_FUNCOES: "Acúmulo de funções para funcionários",
	ATQ_INIMIGO.ATRASO_PAGAMENTO: "Pagamento após 5 dia útil (atrasado)",
	ATQ_INIMIGO.DECIMO_TERCEIRO_NEGADO: "Revogação do décimo terceiro",
	ATQ_INIMIGO.FGTS_ATRASADO: "Atraso de 6 meses no FGTS",
}

enum CURAS_INIMIGO {
	BOMBOM, GREENWASHING, METAS_ABUSIVAS, REUNIAO_OBRIGATORIA,
	RECUSA_ATESTADOS, EMPRESA_FAMILIA
}
const CURAS_INIMIGO_TEXT = {
	CURAS_INIMIGO.BOMBOM: "Bombom para os funcionários após recorde de lucros",
	CURAS_INIMIGO.GREENWASHING: "Propaganda de sustentabilidade (greenwashing)",
	CURAS_INIMIGO.METAS_ABUSIVAS: "Cobrança de metas abusivas",
	CURAS_INIMIGO.REUNIAO_OBRIGATORIA: "Reunião obrigatória no horário de almoço",
	CURAS_INIMIGO.RECUSA_ATESTADOS: "Recusa de atestados médicos",
	CURAS_INIMIGO.EMPRESA_FAMILIA: "Ditado 'A empresa é uma família'",
}
