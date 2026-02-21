extends Node

enum {
	TELA_INICIAL,
	TELA_PAUSE,
	TELA_LOADING,
	TELA_CONFIG,
	TELA_CREDITOS,
	DESK,
}
const UID_SCENES = {
	TELA_INICIAL: "uid://dfup2bdf5sdnw",
	TELA_PAUSE: "uid://bwstta8psu4ph",
	TELA_LOADING: "uid://ck8l2lqfa2r4y",
	TELA_CONFIG: "uid://ds226ph62jpir",
	TELA_CREDITOS: "uid://bok2i3ulpkeq8",
	DESK:"uid://54vcmnecmgu8",
}

enum {EVENT,TEXT}
enum {
	PARA_CIMA,
	PARA_BAIXO,
	PARA_ESQUERDA,
	PARA_DIREITA,
	INTERAGIR,
}
const ACOES_CUSTOM = {
	PARA_CIMA: {EVENT: "para_cima", TEXT: "Mover para cima"},
	PARA_BAIXO: {EVENT: "para_baixo", TEXT: "Mover para baixo"},
	PARA_ESQUERDA: {EVENT: "para_esquerda", TEXT: "Mover para esquerda"},
	PARA_DIREITA: {EVENT: "para_direita", TEXT: "Mover para direita"},
	INTERAGIR: {EVENT: "interagir", TEXT: "Interagir"},
}
