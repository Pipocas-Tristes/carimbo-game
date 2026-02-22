extends Node

enum {
	TELA_INICIAL,
	TELA_PAUSE,
	TELA_LOADING,
	TELA_CONFIG,
	TELA_CREDITOS,
	TELA_BATALHA,
	DESK,
}

enum {EVENT, TEXT, VALOR}
enum {
	PARA_CIMA,
	PARA_BAIXO,
	PARA_ESQUERDA,
	PARA_DIREITA,
	INTERAGIR,
}

const UID_SCENES = {
	TELA_INICIAL: "uid://dfup2bdf5sdnw",
	TELA_PAUSE: "uid://bwstta8psu4ph",
	TELA_LOADING: "uid://ck8l2lqfa2r4y",
	TELA_CONFIG: "uid://ds226ph62jpir",
	TELA_CREDITOS: "uid://bok2i3ulpkeq8",
	TELA_BATALHA: "uid://clk1ysjnbyd46",
	DESK: "uid://54vcmnecmgu8",
}

const ACOES_CUSTOM = {
	PARA_CIMA: {EVENT: "para_cima", TEXT: "Mover para cima"},
	PARA_BAIXO: {EVENT: "para_baixo", TEXT: "Mover para baixo"},
	PARA_ESQUERDA: {EVENT: "para_esquerda", TEXT: "Mover para esquerda"},
	PARA_DIREITA: {EVENT: "para_direita", TEXT: "Mover para direita"},
	INTERAGIR: {EVENT: "interagir", TEXT: "Interagir"},
}

const RESOLUCAO_DICT = {
	RES_640X320 = {VALOR: Vector2i(640, 320), TEXT: "640x320"},
	RES_1280X720 = {VALOR: Vector2i(1280, 720), TEXT: "1280x720"},
	RES_1920X1080 = {VALOR: Vector2i(1920, 1080), TEXT: "1920x1080"},
	RES_2560X1440 = {VALOR: Vector2i(2560, 1440), TEXT: "2560x1440"},
}

const MODO_DICT = {
	JANELA = {VALOR: Window.MODE_WINDOWED, TEXT: "Janela"},
	TELA_CHEIA = {VALOR: Window.MODE_EXCLUSIVE_FULLSCREEN, TEXT: "Tela cheia"},
}
