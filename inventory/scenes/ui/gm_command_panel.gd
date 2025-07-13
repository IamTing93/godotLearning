class_name GmCommandPanel extends MarginContainer

## 物品资源路径
const ITEM_RESOURCE_PATH = "res://resources/items/%s.tres"

## 库存逻辑对象
@export var inventory: Inventory

@onready var input: LineEdit = $HBoxContainer/Input


func _on_input_text_submitted(command: String) -> void:
	var parts = command.split(" ")
	if parts.size() == 0:
		return
	var cmd = parts[0]
	var args = parts.slice(1, parts.size())
	if has_method(cmd):
		callv(cmd, args)
	else:
		push_warning("Method not found: " + cmd)


## 添加物品
func add_item(item_name: String, quantity: String) -> void:
	if int(quantity) <= 0:
		return
	var item = create_item(item_name, quantity)
	if item == null:
		push_error("Can not found item by name: ", item_name)
		return
	inventory.add_item_to_empty_entity(item)


## 创建物品
func create_item(item_name: String, quantity: String) -> Item:
	var item_path = ITEM_RESOURCE_PATH % item_name
	if not ResourceLoader.exists(item_path):
		return null
	var item: Item = load(item_path).duplicate()
	item.quantity = int(quantity)
	return item


func _on_submit_btn_pressed() -> void:
	var command =  input.text
	_on_input_text_submitted(command)
