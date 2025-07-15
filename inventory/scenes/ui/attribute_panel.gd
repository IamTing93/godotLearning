class_name AttributePanel extends MarginContainer

@onready var attribute_label: Label = %AttributeLabel

func display_attribute(key: String, value: String) -> void:
	await ready
	attribute_label.text = "{0}: {1}".format([key, value])
