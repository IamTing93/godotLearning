class_name ItemSlot extends MarginContainer

## 物品槽索引
var index: int = 0

@onready var item_tile: ItemTile = $ItemTile
@onready var background: NinePatchRect = $NinePatchRect
@onready var color_rect: ColorRect = $ColorRect
var current_item: Item

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
