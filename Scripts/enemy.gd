extends CharacterBody2D


const SPEED = 100.0
const KNOCKBACK_FORCE = 50.0

var target = null
var health = 5
var is_alive = true

@onready var health_bar: Node2D = $HealthBar


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


func take_damage(amount: int, attacker_position: Vector2) -> void:
	health -= amount
	print(health)
	health_bar.update_health_bar(health)
	if health <= 0:
		_die()
	else:
		print(health)
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

func _on_wander_body_entered(body: Node2D) -> void:
	# target = body
	if body.name == "player":
		target = body
	

func _on_wander_body_exited(body: Node2D) -> void:
	if body.name == "player":
		target = null
