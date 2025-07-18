extends NodeState

@export var player : Player
@export var animated_sprite_2d : AnimatedSprite2D

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	var direction = player.player_direction
	
	if direction == Vector2.UP: 
		animated_sprite_2d.play("idle_back")
	elif direction == Vector2.DOWN:
		animated_sprite_2d.play("idle_front")
	elif direction == Vector2.LEFT:
		animated_sprite_2d.play("idle_left")
	elif direction == Vector2.RIGHT:
		animated_sprite_2d.play("idle_right")
	else:
		animated_sprite_2d.play("idle_front")


func _on_next_transitions() -> void:
	GameInputEvents.movement_input()
	if GameInputEvents.is_movement_input():
		transition.emit("Walk")
	var used_tool = GameInputEvents.use_tool()
	if player.current_tool == DataTypes.Tools.AxeWood && used_tool:
		transition.emit("Chopping")
	if player.current_tool == DataTypes.Tools.TillGround && used_tool:
		transition.emit("Tilling")
	if player.current_tool == DataTypes.Tools.WaterCrops && used_tool:
		transition.emit("Watering")


func _on_enter() -> void:
	pass


func _on_exit() -> void:
	animated_sprite_2d.stop()
