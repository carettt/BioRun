extends "res://Overlap/Hitbox.gd"

var knockback_vector = Vector2.ZERO

# warning-ignore:unused_argument
func _on_AntibodyGrab_area_entered(area: Area2D) -> void:
	self.damage += 1
