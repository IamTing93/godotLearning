extends CanvasLayer

@onready var save_game_button_2: Button = $MarginContainer/VBoxContainer/SaveGameButton2

func _ready() -> void:
	save_game_button_2.disabled = !SaveGameManager.allow_save_game
	save_game_button_2.focus_mode = SaveGameManager.allow_save_game if Control.FOCUS_ALL else Control.FOCUS_NONE

func _on_start_game_button_pressed() -> void:
	GameManager.start_game()
	await get_tree().process_frame
	queue_free()

func _on_save_game_button_2_pressed() -> void:
	SaveGameManager.save_game()

func _on_exit_game_button_3_pressed() -> void:
	GameManager.exit_game()
