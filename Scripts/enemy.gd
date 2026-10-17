extends CharacterBody2D


const SPEED = 100.0
const KNOCKBACK_FORCE = 100.0

var target = null
var health = 20
var is_alive = true

@onready var health_bar: Node2D = $Healthbar
# @onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	if is_alive and target:
		_attack(delta)
	elif target:
		var direction = (target.position - position).normalized()
		velocity = direction * SPEED
		move_and_slide()
	elif not is_alive:
		velocity = Vector2.ZERO
	move_and_slide()

func _attack(delta: float) -> void:
	var direction = (target.position - position).normalized()
	position += direction * SPEED * delta
	# if direction.x != 0:
	# 	animated_sprite_2d.flip_h = direction.x < 0
	# 	animated_sprite_2d.play("Run")
		


func take_damage(amount: int, attacker_position: Vector2) -> void:
	health -= amount
	health_bar.update_health_bar(health)
	if !is_alive:
		return
	elif health <= 0:
		_die()
	else:
		#knockback
		var knockback_direction = (position - attacker_position).normalized()
		var target_position = position + knockback_direction * KNOCKBACK_FORCE

		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "position", target_position, 0.1)

func _die() -> void:
	is_alive = false
	#disable collision
	$hitbox.set_deferred("disabled", true)
	$Wander/CollisionShape2D.set_deferred("disabled", true)
	
	queue_free()

func _on_wander_body_entered(body: Node2D) -> void:
	# target = body
	if body.name == "player":
		target = body
	

func _on_wander_body_exited(body: Node2D) -> void:
	if body.name == "player":
		target = null
		# animated_sprite_2d.play("Idle")


func _on_attack_box_body_entered(body: Node2D) -> void:
	print(body)
	#if body.name == "player":
		#body.take_damage(strength, position)
