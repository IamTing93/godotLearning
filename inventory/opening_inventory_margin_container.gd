class_name OpeningInventoryMarginContainer extends MarginContainer

## 背包UI
@export var inventory_panel: InventoryPanel


func _on_opening_inventory_button_pressed() -> void:
	if inventory_panel == null:
		return
	inventory_panel.show()
	self.hide()
