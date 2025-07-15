class_name TooltipPanel extends MarginContainer

@onready var item_name: Label = %ItemName
@onready var description: Label = %Description
@onready var attribute_set_container: VBoxContainer = %AttributeSetContainer

## 属性页面
var attribute_panel = preload("res://scenes/ui/attribute_panel.tscn")

func display_tooltip(item: Item) -> void:
	await ready
	item_name.text = item.item_name
	description.text = item.description
	for attribute in attribute_set_container.get_children():
		attribute.queue_free()
	for key in item.attributes.keys():
		var value: String = str(item.attributes.get(key))
		var panel: AttributePanel = attribute_panel.instantiate()
		panel.display_attribute(key, value)
		attribute_set_container.add_child(panel)
