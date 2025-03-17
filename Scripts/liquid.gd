extends Area2D

class_name Liquid
var rng = RandomNumberGenerator.new()
var cubes = []
var cube_sizes = []
var shape_size
var starting_position : Vector2
var glass_filled : bool
@export var fill_ammount = 200 #fill ammount is roughly half of the y shape extant

func _ready() -> void:
	shape_size = $CollisionShape2D.shape.extents
	starting_position = position
	Signals.cube_deleted.connect(_remove_cube)
	Signals.cube_fuzed.connect(update_liquid)
	Signals.reset_cup.connect(_reset_liquid)
	$MarkerLine.scale.x = $Sprite2D.scale.x
	$MarkerLine.position.y = -fill_ammount

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("liquid_entered"):
		body.liquid_entered(self, $CollisionShape2D)
		if cubes.has(body):
			return
		cubes.append(body)
		cube_sizes.append(body.ice_size)
		
		body.call_deferred("reparent", self, true)
		update_liquid()
		
		
func _remove_cube(cube):
	print("function active")
	var index = cubes.find(cube)
	cube_sizes.remove_at(index)
	cubes.remove_at(index)
	update_liquid()
	
func _remove_all_cubes():
	for c in cubes:
		c.queue_free()
	cubes.clear()
	cube_sizes.clear()
	
func check_sizes():
	cube_sizes.clear()
	if cubes.size() == 0:
		return
	for c in cubes.size():
		cube_sizes.append(cubes[c].ice_size)
	
func update_liquid():
	if glass_filled == false:
		check_sizes()
	var total_cube_sizes = 0
	for i in cube_sizes.size():
		total_cube_sizes += cube_sizes[i]
	print(cube_sizes)
	$CollisionShape2D.shape.extents = Vector2.ZERO
	$CollisionShape2D.shape.extents = Vector2(shape_size.x, shape_size.y+(total_cube_sizes*5))
	print(str("shape extents = ", $CollisionShape2D.shape.extents))
	position.y = starting_position.y - (total_cube_sizes*5)
	#update the sprites scale
	$Sprite2D.scale.y = $CollisionShape2D.shape.extents.y/43
	
	#update the marker line position
	$MarkerLine.position.y = (-fill_ammount+(total_cube_sizes*5))+25
	if glass_filled == true:
		return
	if (fill_ammount/2) == $CollisionShape2D.shape.extents.y:
		glass_filled = true
		Signals.emit_signal("glass_filled")
		
func _reset_liquid():
	glass_filled = false
	_remove_all_cubes()
	fill_ammount = rng.randi_range(5, 15)*20
