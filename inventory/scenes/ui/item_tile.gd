class_name ItemTile extends MarginContainer

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

## 当前物品
var current_item: Item = null :
	set = set_item

## 设置当前物品
func set_item(item: Item) -> void: 
	current_item = item
	if !current_item:
		texture_rect.texture = null
		label.text = ""
		return
	texture_rect.texture = current_item.item_icon
	label.text = str(current_item.quantity)
	
	if current_item.max_stack == 1:
		label.hide()
	else:
		label.show()
