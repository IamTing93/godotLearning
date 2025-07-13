class_name Item extends Resource

## 物品类型
enum ItemType {
	## 无类型
	NONE,
	## 装备
	EQUIPMENT,
	## 消耗品
	CONSUMABLE,
	## 材料
	MATERIAL,
}

## 物品名称
@export var item_name: String
## 物品纹理
@export var item_icon: Texture
## 物品描述
@export var description: String
## 最大堆叠数量
@export var max_stack: int = 1
## 物品数量
@export var quantity: int = 0 :
	set = set_quantity

## 物品类型
@export var item_type: ItemType = ItemType.NONE
## 物品属性
@export var attributes: Dictionary = {}

## 物品数量变化信号
signal quantity_changed(value: int)


## 设置物品数量
func set_quantity(value: int):
	quantity = clamp(value, 0, max_stack)
	quantity_changed.emit(quantity)


## 物品数量是否为空
func is_empty() -> bool:
	return quantity == 0


## 是否达到最大堆叠数量
func is_max_stack() -> bool:
	return quantity == max_stack


## 是否相同的物品
func is_same_item(other_item: Item) -> bool:
	return other_item != null and item_type == other_item.item_type and item_name == other_item.item_name

## 合并其他物品
func merge(other_item: Item) -> bool:
	if is_max_stack():
		return false
	if is_same_item(other_item):
		var total = quantity + other_item.quantity
		quantity += other_item.quantity
		other_item.quantity = total - quantity
		return true
	return false


## 减少物品
func minus(other_item: Item) -> bool:
	if is_same_item(other_item):
		if quantity >= other_item.quantity:
			quantity -= other_item.quantity
			other_item.quantity = 0
		else:
			other_item.quantity -= quantity
			quantity = 0
		return true
	return false
