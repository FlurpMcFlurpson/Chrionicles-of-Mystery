extends Item

class_name Health_item

@export var HealthRestored: int


func use(target) -> void:
	if HealthRestored != 0:
		target.heal(HealthRestored)
