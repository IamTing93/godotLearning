class_name ItemSlot extends MarginContainer

## 物品槽索引
var index: int = 0

@onready var item_tile: ItemTile = $ItemTile
@onready var background: NinePatchRect = $NinePatchRect
@onready var color_rect: ColorRect = $ColorRect
var current_item: Item
var inventory: Inventory

signal mouse_button_left_clicked
signal mouse_button_right_clicked

func _ready() -> void:
	color_rect.color = Color(0, 0, 0, 0.5)
	disselected()

## 设置当前物品
func set_item(item: Item) -> void:
	current_item = item
	item_tile.current_item = item
	if item == null:
		item_tile.hide()
	else:
		item_tile.show()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() :
		if event.button_index == MOUSE_BUTTON_LEFT:
			mouse_button_left_clicked.emit()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			mouse_button_right_clicked.emit()


## 物品槽被选择
func selected() -> void:
	color_rect.visible = true


## 物品槽取消选择
func disselected() -> void:
	color_rect.visible = false
	

func _get_drag_data(_at_position: Vector2) -> Item:
	var dragging_item = current_item
	var preview = item_tile.duplicate() 
	inventory.remove_item(index)
	set_drag_preview(preview)
	return dragging_item


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	var item = data as Item
	if self is EquipmentSlot:
		return inventory.can_equip(item, self.equipment_slot_name)
	return inventory.can_add_item_to_slot(item, index)


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var item = data as Item
	inventory.add_item_to_slot(item, index)
