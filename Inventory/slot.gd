extends PanelContainer
@onready var texture_rect = $MarginContainer/TextureRect
@onready var quanitity_label = $QuanitityLabel
signal slot_click(index:int, button:int)

func  get_slot_data(slot_data: SlotData) -> void:
	var item_data = slot_data.item_data
	texture_rect.texture = item_data.Item_texture
	tooltip_text = "%s\n%s" % [item_data.Item_name, item_data.Item_text]
	
	if slot_data.quantity > 1:
		quanitity_label.text = "x%s" % slot_data.quantity
		quanitity_label.show()
	else:
		quanitity_label.hide()
		


func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton \
			and (event.button_index == MOUSE_BUTTON_LEFT\
			or event.button_index == MOUSE_BUTTON_RIGHT) \
			and event.is_pressed():
		slot_click.emit(get_index(), event.button_index)
