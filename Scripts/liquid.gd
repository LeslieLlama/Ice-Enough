extends Area2D

class_name Liquid

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("liquid_entered"):
		body.liquid_entered(self, $CollisionShape2D)
