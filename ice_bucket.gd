extends Node2D

@export var ice_cube : PackedScene

var iceCubeCount = 0
		
func _input(event):
	if Signals.gameStarted == false:
		return
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT :
			spawn_cube()
		#if event.button_index == MOUSE_BUTTON_WHEEL_UP :
			#print("Scroll wheel up")
		#if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			#print("Scroll wheel down")


func spawn_cube():
	iceCubeCount += 1
	var new_cube = ice_cube.instantiate()
	new_cube._assign_index(iceCubeCount)
	new_cube.global_position = get_viewport().get_mouse_position()
	add_child(new_cube)
