extends Node

var score = 0
@onready var score_label: Label = $scoreLabel

func add_point() -> void:
	score += 1
	score_label.text = "You collected " + str(score) + " coins."
