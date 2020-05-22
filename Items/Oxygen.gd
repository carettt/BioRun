extends AnimatedSprite

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

# warning-ignore:unused_argument
func _on_Area2D_area_entered(area: Area2D) -> void:
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
