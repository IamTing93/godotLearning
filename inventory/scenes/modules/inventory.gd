class_name Inventory extends Node
## 背包库存逻辑代码

## 存库容量
@export var capacity: int = 20
## 库存大小
var item_size: int = 0

## 库存物品
@export var items: Array[Item] = []

## 装备槽映射
@export var equitment_slot_stubs: Dictionary = {
	"HeadSlot": EquipmentSlotStub.new("HeadSlot", Equipment.EquipmentType.HEAD),
	"ChestSlot": EquipmentSlotStub.new("ChestSlot", Equipment.EquipmentType.CHEST),
	"LegsSlot": EquipmentSlotStub.new("LegsSlot", Equipment.EquipmentType.LEGS),
	"FeetSlot": EquipmentSlotStub.new("FeetSlot", Equipment.EquipmentType.FEET),
	"NecklaceSlot": EquipmentSlotStub.new("NecklaceSlot", Equipment.EquipmentType.NECKLACE),
	"WeaponSlot": EquipmentSlotStub.new("WeaponSlot", Equipment.EquipmentType.WEAPON),
	"RingSlot1": EquipmentSlotStub.new("RingSlot1", Equipment.EquipmentType.RING),
	"RingSlot2": EquipmentSlotStub.new("RingSlot2", Equipment.EquipmentType.RING),
	"RingSlot3": EquipmentSlotStub.new("RingSlot3", Equipment.EquipmentType.RING),
}


## 物品变化信号
signal item_changed

## 装备变化信号
signal equipment_changed

func _ready() -> void:
	items.resize(capacity)

## 添加物品
func add_item(item: Item) -> bool:
	if is_reached_capacity():
		push_warning("Up to capacity when add item: %s, quantity: %d", item.item_name, item.quantity)
		return false
	## 库存中所有物品都尝试合并一下
	var has_merged: bool = false
	for cur_item in items:
		if cur_item.merge(item):
			has_merged = true
			if item.is_empty():
				return true
	## 遍历完毕后还有剩余，添加到空位置
	return add_item_to_empty_entity(item) or has_merged


## 添加物品到空位置
func add_item_to_empty_entity(item: Item) -> bool:
	if is_reached_capacity():
		push_warning("Up to capacity when add item: {0}, quantity: {1}".format([item.item_name, item.quantity]))
		return false
	var idx = find_empty_entity_index()
	items[idx] = item
	item_size += 1
	item_changed.emit()
	return true


## 查找空单元的索引
func find_empty_entity_index() -> int:
	var idx: int = -1
	if is_reached_capacity():
		return idx
	for i in capacity:
		if items[i] == null:
			idx = i
			break
	return idx


## 移除物品
func remove_item(idx: int) -> Item:
	if idx < 0 || idx >= capacity:
		push_error("Invalid parameter: " + str(idx))
		return
	var item = items[idx]
	items[idx] = null
	if item:
		item_size -= 1
		item_changed.emit()
	return item


## 减少物品
func minus_item(item: Item) -> void:
	var is_size_changed: bool = false
	for i in capacity:
		var cur_item = items[i]
		if cur_item.minus(item):
			if cur_item.is_empty():
				items[i] = null
				item_size -= 1
				is_size_changed = true
			if item.is_empty():
				break
	if is_size_changed:
		item.emit()


## 是否能增加物品
func is_reached_capacity() -> bool:
	return item_size >= capacity
	

## 合并同类物品
func merge_same_items() -> void:
	# 合并同类物品
	for i in range(items.size()):
		if items[i] == null or items[i].is_max_stack():
			continue
		for j in range(i + 1, items.size()):
			if items[j] == null:
				continue
			if items[i].merge(items[j]):
				if items[j].is_empty():
					items[j] = null
					item_size -= 1
	items.resize(capacity)


## 排列物品
func sort_items() -> void:
	var filter_items = items.filter(func(item): return item != null)
	# 排列物品
	filter_items.sort_custom(
		func(item1: Item, item2: Item):
			return (item1.item_type < item2.item_type) or (item1.item_type == item2.item_type and item1.item_name < item2.item_name) 
	)
	items = filter_items
	items.resize(capacity)
	
	
## 整理物品
func pack_items() -> void:
	merge_same_items()
	sort_items()
	item_changed.emit()

## 使用物品
func use_item(item: Item):
	match item.item_type:
		Item.ItemType.EQUIPMENT: equip_item(item)
		

## 装备道具
func equip_item(equipment: Equipment) -> bool:
	var slot = get_equipment_slot(equipment.equipment_type)
	return equip_item_to_slot(equipment, slot.equitment_slot_name)


## 装备道具到指定的装备槽
func equip_item_to_slot(equipment: Equipment, equipment_slot_name: String) -> bool:
	# 从物品槽中移除道具
	remove_item(items.find(equipment))
	var slot: EquipmentSlotStub = equitment_slot_stubs.get(equipment_slot_name)
	if slot != null and slot.equipment != null and !add_item_to_empty_entity(slot.equipment):
		return false
	slot.equipment = equipment
	equipment_changed.emit(slot.equitment_slot_name)
	return true


## 卸载装备
func unequip_item(equipment_slot_name: String) -> bool:
	var slot: EquipmentSlotStub = equitment_slot_stubs.get(equipment_slot_name)
	if slot != null and slot.equipment != null and !add_item_to_empty_entity(slot.equipment):
		return false
	slot.equipment = null
	equipment_changed.emit(slot.equitment_slot_name)
	return true


## 根据类型获取装备槽。有空的装备槽就返回空的，没有就返回第一个
func get_equipment_slot(type: Equipment.EquipmentType) -> EquipmentSlotStub:
	var stubs = equitment_slot_stubs.values().filter(
		func(equipment):
			return equipment.equipment_slot_type == type
	)
	for stub in stubs:
		if stub.equipment == null:
			return stub
	return stubs[0]


## 根据名称获取指定装备槽上的道具
func get_equipment(slot_name: String) -> Equipment:
	var stub: EquipmentSlotStub = equitment_slot_stubs.get(slot_name)
	if stub == null:
		return null
	return stub.equipment
