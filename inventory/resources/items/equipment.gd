class_name Equipment extends Item

## 装备类型
enum EquipmentType {
	## 无类型
	NONE,
	## 头盔
	HEAD,
	## 胸甲
	CHEST,
	## 腿部
	LEGS,
	## 脚部
	FEET,
	## 项链
	NECKLACE,
	## 武器
	WEAPON,
	## 戒指
	RING,
}

## 装备类型
@export var equipment_type: EquipmentType = EquipmentType.NONE
