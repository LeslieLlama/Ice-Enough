extends RigidBody2D

@export var float_force = 0.5;

@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var depth
const water_height := 580.0;
var submerged = false;

func _process(delta: float) -> void:
	if submerged == true:
		$Sprite2D.modulate = Color.BLUE
	else: 
		$Sprite2D.modulate = Color.WHITE
func _physics_process(delta: float) -> void:
	depth = water_height - global_position.y;
	submerged = false
	if depth < 0: 
		submerged = true
		apply_central_force(Vector2.DOWN * float_force * (gravity/10) * depth)
