extends StaticBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var interactable_componet: InteractableComponent = $InteractableComponet

var player_entered: bool = false

func _ready() -> void:
	interactable_componet.interactable_activated.connect(on_interactable_activated)
	interactable_componet.interactable_deactivated.connect(on_interactable_deactivated)
	collision_layer = 1


func on_interactable_activated() -> void:
	animated_sprite_2d.play("open_door")
	player_entered = true
	print("player_entered:" + str(player_entered))


func on_interactable_deactivated() -> void:
	animated_sprite_2d.play("close_door")
	player_entered = false
	print("player_entered:" + str(player_entered))


func _on_animated_sprite_2d_animation_finished() -> void:
	print("animation finished")
	if player_entered:
		collision_layer = 2
	else:
		collision_layer = 1
