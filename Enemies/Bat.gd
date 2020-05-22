extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const Lipid = preload("res://Items/Lipid.tscn")
const Glucose = preload("res://Items/Glucose.tscn")
const DNA = preload("res://Items/DNA.tscn")
const Oxygen = preload("res://Items/Oxygen.tscn")
const Protein = preload("res://Protein.tscn")

export(int) var ACCELERATION = 300
export(int) var MAX_SPEED = 50
export(int) var FRICTION = 100
export(int) var WANDER_BUFFER = 3

enum {
	IDLE,
	WANDER,
	CHASE
}

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO

var state = CHASE

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var animationPlayer = $AnimationPlayer

func _ready():
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			
			if wanderController.get_time_left() == 0:
				reset_wander()
		WANDER:
			seek_player()
			
			if wanderController.get_time_left() == 0:
				reset_wander()
			
			accelerate_towards_point(wanderController.target_position, delta)
			
			if global_position.distance_to(wanderController.target_position) <= WANDER_BUFFER:
				reset_wander()
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)
	
func reset_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
		
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
func spawn_drop():
	var drops = ["Protein", "Protein", "DNA", "DNA", "Glucose","Glucose", "Oxygen","Oxygen" ,"Lipid" ,"Lipid" , "none"]
	drops.shuffle()
	var drop = drops.pop_front()
	match drop:
		"none":
			pass
		"Protein":
			var protein = Protein.instance()
			spawn_item(protein)
			protein.global_position = global_position
		"DNA":
			var dna = DNA.instance()
			spawn_item(dna)
			dna.global_position = global_position
		"Glucose":
			var glucose = Glucose.instance()
			spawn_item(glucose)
			glucose.global_position = global_position
		"Oxygen":
			var oxygen = Oxygen.instance()
			spawn_item(oxygen)
			oxygen.global_position = global_position
		"Lipid":
			var lipid = Lipid.instance()
			spawn_item(lipid)
			lipid.global_position = global_position
			
func spawn_item(item):
	var world = get_parent()
	world.add_child(item)

func _on_Hurtbox_area_entered(area: Area2D) -> void:
	stats.health -= area.damage
	knockback = area.knockback_vector * 120
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)

func _on_Stats_no_health() -> void:
	queue_free()
	spawn_drop()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position


func _on_Hurtbox_invincibility_ended() -> void:
	animationPlayer.play("Stop")

func _on_Hurtbox_invincibility_started() -> void:
	animationPlayer.play("Start")
