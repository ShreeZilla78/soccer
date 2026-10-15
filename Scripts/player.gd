extends CharacterBody2D

const SPEED: int = 201
const max_health: int = 3

var health: int = max_health
var last_direction: Vector2 = Vector2.RIGHT
var is_attacking: bool = false
var hitbox_offset: Vector2
var strength: int = 8
var enemy = null

@onready var hitbox: Area2D = $Hitbox
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D





func _ready() -> void:
	hitbox_offset = hitbox.position



func _process(_delta: float) -> void:

	#hitbox.monitoring = false

	
	if Input.is_action_pressed("attack") and not is_attacking:
		attack()

	if is_attacking:
		velocity = Vector2.ZERO
		return

	_process_movement()
	process_animation()
	move_and_slide()



func _process_movement() -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	
	velocity = direction * SPEED
	

	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		last_direction = direction
	else:
		velocity = Vector2.ZERO

	
	update_hitbox_offset()


func process_animation() -> void:
	if is_attacking:
		animation("attack", last_direction)
		return
	if velocity != Vector2.ZERO:
		animation("walk", last_direction)
	else:
		animation("idle", last_direction)


func animation(prefix: String, dir: Vector2) -> void:
	if dir.x != 0:
		animated_sprite_2d.flip_h = dir.x < 0
		animated_sprite_2d.play(prefix + "-Right")
	elif dir.y != 0:
		animated_sprite_2d.play(prefix + "-North" if dir.y < 0 else prefix + "-South")

# ----------------------------------------------
# Attack functions
#-----------------------------------------------

func attack() -> void:
	is_attacking = true
	#hitbox.monitoring = true
	
	animation("Attack", last_direction)
	#put the name of the animation as attack


# Hitbox functions
func update_hitbox_offset() -> void:
	var x = hitbox_offset.x
	var y = hitbox_offset.y
		
	match last_direction:
		Vector2.LEFT:
			hitbox.position = Vector2(-x,y)
		Vector2.RIGHT:
			hitbox.position = Vector2(x,y)
		Vector2.UP:
			hitbox.position = Vector2(y,-x)
		Vector2.DOWN:
			hitbox.position = Vector2(-y,x)

func _on_hitbox_body_entered(body: Node2D) -> void:
	enemy = body
	#body.take_damage(strength, position)
	# if is_attacking and body.name.begins_with("Termite"):
	#     body.take_damage(strength, position)


func _on_animated_sprite_2d_animation_finished() -> void:
	if is_attacking:
		is_attacking = false
		enemy.take_damage(strength, position)
		#hitbox.monitoring = false
	else:
		return
	


func _on_hitbox_body_exited(body: Node2D) -> void:
	enemy = null
