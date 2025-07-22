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
	

func _get_drag_data(_at_position: Vector2) -> ItemSlot:
	if current_item == null:
		return null
	var preview = item_tile.duplicate() 
	set_drag_preview(preview)
	return self


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	var slot = data as ItemSlot
	if self is EquipmentSlot:
		return inventory.can_equip(slot.current_item, self.equipment_slot_name)
	return true


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var source_slot = data as ItemSlot
	var source_item = null
	var target_item = null
	if source_slot is EquipmentSlot:
		source_item = inventory.unequip_item(source_slot.equipment_slot_name)
	else:
		source_item = inventory.remove_item(source_slot.index)
	if self is EquipmentSlot:
		target_item = inventory.unequip_item(self.equipment_slot_name)
		inventory.equip_item_to_slot(source_item, self.equipment_slot_name)
	else:
		target_item = inventory.remove_item(index)
		inventory.add_item_to_slot(source_item, index)
	if source_slot is EquipmentSlot:
		inventory.equip_item_to_slot(target_item, source_slot.equipment_slot_name)
	else:
		inventory.add_item_to_slot(target_item, source_slot.index)
	
