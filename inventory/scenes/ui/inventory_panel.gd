class_name InventoryPanel extends MarginContainer

const ITEM_SLOT_TSCN = preload("res://scenes/ui/item_slot.tscn")

## 库存逻辑实体
@export var inventory: Inventory

## 当前选中的类型
var current_category: int = Item.ItemType.NONE

## 当前选中的物品槽索引
var selected_item_slot_index: int = 0:
	set(index):
		get_item_slot(selected_item_slot_index).disselected()
		selected_item_slot_index  = index
		get_item_slot(selected_item_slot_index).selected()


## 物品槽数组
var item_slots: Array[ItemSlot] = []

## 装备槽数组
var equipment_slots: Array[EquipmentSlot] = []


func _ready() -> void:
	init()


## 获取指定索引位置的物品槽
func get_item_slot(index: int) -> ItemSlot:
	return get_item_slots()[index]


## 初始化函数
func init() -> void:
	inventory.item_changed.connect(update_item_slots_display)
	inventory.equipment_changed.connect(update_equipment_slot_display)
	
	# 初始化物品槽
	var current_item_slots: Array[ItemSlot] = get_item_slots()
	var index: int = 0
	for slot in current_item_slots:
		slot.index = index
		slot.mouse_button_left_clicked.connect(on_item_slot_selected.bind(index))
		slot.mouse_button_right_clicked.connect(on_use_item.bind(slot))
		slot.mouse_button_right_clicked.connect(on_item_slot_selected.bind(index))
		index += 1
	selected_item_slot_index = 0
	update_item_slots_display()
	
	# 初始化装备槽
	index = 0
	var current_equipment_slots: Array[EquipmentSlot] = get_equipment_slots()
	for slot in current_equipment_slots:
		slot.index = index
		slot.mouse_button_right_clicked.connect(on_unequip_item.bind(slot))
		index += 1
	update_equipment_slots_display()


## 获取道具槽
func get_item_slots() -> Array[ItemSlot]:
	if !item_slots.is_empty():
		return item_slots
	var slots = get_tree().get_nodes_in_group("item_slots")
	var filter_slots: Array[ItemSlot] = []
	var index: int = 0
	for slot in slots:
		if not slot.is_in_group("equitment_slots"):
			filter_slots.append(slot)
			slot.index = index
			index += 1
	filter_slots.sort_custom(
		func(slot1: ItemSlot, slot2: ItemSlot):
			return slot1.index < slot2.index
	)
	item_slots = filter_slots
	return item_slots


## 获取装备槽
func get_equipment_slots() -> Array[EquipmentSlot]:
	if !equipment_slots.is_empty():
		return equipment_slots
	var slots = get_tree().get_nodes_in_group("equitment_slots")
	for slot in slots:
		equipment_slots.append(slot)
	return equipment_slots
	

## 根据名称获取指定的装备槽
func get_equipment_slot(slot_name: String) -> EquipmentSlot:
	var slots: Array[EquipmentSlot] = get_equipment_slots()
	for slot in slots:
		if slot.equipment_slot_name == slot_name:
			return slot
	return null


## 根据名称更新装备槽展示
func update_equipment_slot_display(slot_name: String) -> void: 
	var slot = get_equipment_slot(slot_name)
	var equipment = inventory.get_equipment(slot_name)
	if slot == null:
		return
	slot.set_item(equipment)


## 更新装备槽展示
func update_equipment_slots_display() -> void:
	var slots: Array[EquipmentSlot] = get_equipment_slots()
	for slot in slots:
		update_equipment_slot_display(slot.equipment_slot_name)


## 获取当前分类的物品
func get_category_items() -> Array[Item]:
	var items: Array[Item] = inventory.items
	if current_category == Item.ItemType.NONE:
		return items
	var filter_items: Array[Item] = items.filter(
		func(item: Item):
			if item == null:
				return false
			return current_category == item.item_type
	)
	filter_items.resize(inventory.capacity)
	return filter_items


## 更新显示
func update_item_slots_display() -> void:
	var items : Array[Item] = get_category_items()
	var slots: Array[ItemSlot] = get_item_slots()
	for index in range(min(slots.size(), inventory.capacity)):
		slots[index].set_item(items[index])


func _on_tab_bar_tab_changed(tab: int) -> void:
	current_category = tab
	selected_item_slot_index = 0
	update_item_slots_display()


func on_item_slot_selected(index: int) -> void:
	selected_item_slot_index = index


func on_use_item(slot: ItemSlot) -> void:
	if slot.current_item == null:
		return
	inventory.use_item(slot.current_item)


func on_unequip_item(slot: EquipmentSlot) -> void:
	inventory.unequip_item(slot.equipment_slot_name)


func _on_decomposing_button_pressed() -> void:
	inventory.remove_item(selected_item_slot_index)


func _on_packing_button_pressed() -> void:
	inventory.pack_items()
