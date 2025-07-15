class_name ItemTile extends MarginContainer

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

var tooltip_scn = preload("res://scenes/ui/tooltip_panel.tscn")

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

func _make_custom_tooltip(_for_text: String) -> Object:
	if current_item != null:
		var tooltip: TooltipPanel = tooltip_scn.instantiate()
		tooltip.display_tooltip(current_item)
		return tooltip
	return null
