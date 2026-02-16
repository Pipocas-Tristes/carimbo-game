extends Control

signal continuar_opened
signal configurar_opened
signal salvar_e_sair_opened

func _on_continuar_btn_button_up() -> void:
	continuar_opened.emit()


func _on_configurar_btn_button_up() -> void:
	configurar_opened.emit()


func _on_salvar_e_sair_btn_button_up() -> void:
	salvar_e_sair_opened.emit()
