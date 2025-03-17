extends RigidBody2D

class_name IceCube

@export var float_force = 0.5;

@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var index = 0
var depth
var water_height := 1000.0;
var submerged = false;

var _liquid : Liquid
var _liquid_shape : CollisionShape2D
var is_fuze = false;
var is_breaker = false;

@export var ice_size = 2
func _ready() -> void:
	is_fuze = true
	await get_tree().create_timer(2).timeout
	is_fuze = false
	$Label.text = str(ice_size)

func _assign_index(num : int):
	index = num

#func _process(delta: float) -> void:
	#if is_fuze == true:
		#$Sprite2D.modulate = Color.RED
	#elif is_fuze == false and submerged == true:
		#$Sprite2D.modulate = Color.BLUE
	#else: 
		#$Sprite2D.modulate = Color.WHITE
func _physics_process(delta: float) -> void:
	depth = water_height - global_position.y;
	submerged = false
	if depth < 0: 
		submerged = true
		apply_central_force(Vector2.DOWN * float_force * (gravity/10) * depth)
		
func liquid_entered(l : Liquid, s : CollisionShape2D):
	_liquid = l;
	_liquid_shape = s;
	_check_water_height()
	
#timer triggers once every second to check the water height if applicable
func _check_water_height(): 
	if _liquid == null or _liquid_shape == null:
		return
	var shape_size = _liquid_shape.get_shape().get_rect().size.y
	water_height = _liquid.global_position.y - shape_size/2
	
func _on_body_entered(body: Node) -> void:
	if body.get_class() == self.get_class():
		if body.ice_size != ice_size:
			return
		if submerged == false:
			return
		if index > body.index:
			Signals.emit_signal("cube_deleted", body)
			Signals.emit_signal("cube_fuzed")
			body.queue_free()
			$CollisionShape2D.scale *= 1.5
			$Sprite2D.scale *= 1.5
			ice_size *= 2
			$Label.text = str(ice_size)
