extends Resource

class_name Item

@export var Item_name: String
@export var Item_texture: AtlasTexture
@export_multiline var Item_text: String
@export var stackable: bool = false

func getTexture() -> Texture:
	return Item_texture
	
func getName() -> String:
	return Item_name
	
func getDescription() -> String:
	return Item_text


