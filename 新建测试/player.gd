extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree

@export var speed: int = 100
var is_moving: bool = false

func _physics_process(delta: float) -> void:
	move()

func move() -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()
	if direction != Vector2.ZERO:
		is_moving = true
		animation_tree["parameters/Idle/blend_position"] = direction
		animation_tree["parameters/Move/blend_position"] = direction
	else:
		is_moving = false
