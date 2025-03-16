extends Area2D

class_name Liquid

var cubes = []
var cube_sizes = []
var shape_size
var starting_position : Vector2

func _ready() -> void:
	shape_size = $CollisionShape2D.shape.extents
	starting_position = position
	Signals.cube_deleted.connect(_remove_cube)
	Signals.cube_fuzed.connect(update_liquid)

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("liquid_entered"):
		body.liquid_entered(self, $CollisionShape2D)
		if cubes.has(body):
			return
		cubes.append(body)
		cube_sizes.append(body.ice_size)
		update_liquid()
		
		
func _remove_cube(cube):
	print("function active")
	var index = cubes.find(cube)
	cube_sizes.remove_at(index)
	cubes.remove_at(index)
	update_liquid()
	
func check_sizes():
	cube_sizes.clear()
	for c in cubes.size():
		cube_sizes.append(cubes[c].ice_size)
	
func update_liquid():
	check_sizes()
	var total_cube_sizes = 0
	for i in cube_sizes.size():
		total_cube_sizes += cube_sizes[i]
	print(cube_sizes)
	$CollisionShape2D.shape.extents = Vector2.ZERO
	$CollisionShape2D.shape.extents = Vector2(shape_size.x, shape_size.y+(total_cube_sizes*10))
	print(str("shape extents = ", $CollisionShape2D.shape.extents))
	position.y = starting_position.y - (total_cube_sizes*10)
	


#func _on_body_exited(body: Node2D) -> void:
	#if cubes.has(body):
		#await get_tree().create_timer(1).timeout #solid idea but doesnt scale well for each individual cube
		##we need to be able to cancel the timer if the cube re-enters the liquid which we can't do with a single timer, going to have to be built into the cube instead 
		#cubes.remove_at(cubes.find(body))
		#var shape_size = $CollisionShape2D.shape.extents
		#$CollisionShape2D.shape.extents = Vector2(shape_size.x, shape_size.y-20)
		
