class_name EquipmentSlotStub extends RefCounted
## 装备槽的逻辑表示

## 装备槽名称
var equitment_slot_name: String

## 装备槽类型
var equipment_slot_type: Equipment.EquipmentType

## 装备实体
var equipment: Equipment

func _init(slot_name: String, slot_type: Equipment.EquipmentType) -> void:
	equitment_slot_name = slot_name
	equipment_slot_type = slot_type
