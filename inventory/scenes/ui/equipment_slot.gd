@tool
class_name EquipmentSlot extends ItemSlot

## 默认图标字典
const DEFAULT_ICON_DICT: Dictionary = {
	Equipment.EquipmentType.HEAD: preload("res://resources/equipment_slots/head_slot.tres"),
	Equipment.EquipmentType.CHEST: preload("res://resources/equipment_slots/chest_slot.tres"),
	Equipment.EquipmentType.LEGS: preload("res://resources/equipment_slots/legs_slot.tres"),
	Equipment.EquipmentType.FEET: preload("res://resources/equipment_slots/feet_slot.tres"),
	Equipment.EquipmentType.NECKLACE: preload("res://resources/equipment_slots/necklace_slot.tres"),
	Equipment.EquipmentType.RING: preload("res://resources/equipment_slots/ring_slot.tres"),
	Equipment.EquipmentType.WEAPON: preload("res://resources/equipment_slots/weapon_slot.tres"),
}

## 装备槽名称
@export var equipment_slot_name: String

## 默认装备槽图标
@onready var default_icon: TextureRect = %DefaultIcon

## 装备槽类型
@export var equipment_slot_type: Equipment.EquipmentType = Equipment.EquipmentType.NONE :
	set(type):
		equipment_slot_type = type
		if default_icon:
			display_default_icon()
			
func _ready() -> void:
	display_default_icon()


## 展示默认装备槽图标
func display_default_icon() -> void:
	if DEFAULT_ICON_DICT.has(equipment_slot_type):
		default_icon.texture = DEFAULT_ICON_DICT[equipment_slot_type]
	else:
		push_warning("Unkonwn default equipment icon index: ", equipment_slot_type)


## 设置当前物品
func set_item(item: Item) -> void:
	super(item)
	if item == null:
		default_icon.show()
	else:
		default_icon.hide()
