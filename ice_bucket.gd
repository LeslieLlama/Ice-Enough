extends Node2D

@export var ice_cube : PackedScene

func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var new_cube = ice_cube.instantiate()
		new_cube.position = get_viewport().get_mouse_position()
		add_child(new_cube)
		
