extends Node2D

@export var liquid : PackedScene

var inital_position : Vector2
func _ready() -> void:
	Signals.glass_filled.connect(move_glass_left)
	Signals.time_up.connect(game_over)
	inital_position = global_position

func game_over():
	move_glass_left()
	

func move_glass_left():
	var tween = get_tree().create_tween()
	tween.tween_property($".", "global_position:x", -500, 2)
	tween.tween_callback(emit_reset_cup)
	tween.tween_property($".", "global_position:y", -1500, 0.1)
	tween.tween_property($".", "global_position:x", 1500, 0.1)
	tween.tween_property($".", "global_position:y", inital_position.y, 0.1)
	tween.tween_property($".", "global_position:x", inital_position.x, 2)
	tween.tween_callback(emit_fresh_cup)
	
func emit_reset_cup():
	Signals.emit_signal("reset_cup")
	#$Liquid.queue_free()
	#var new_liquid = liquid.instantiate()
	#new_liquid.position = Vector2(-8, 113)
	#add_child(new_liquid)
	
func emit_fresh_cup():
	Signals.emit_signal("fresh_cup")
