extends CharacterBody2D

const SPEED: int = 201
const max_health: int = 3

var health: int = max_health
var last_direction: Vector2 = Vector2.RIGHT
var is_attacking: bool = false
var hitbox_offset: Vector2
var strength: int = 8

@onready var hitbox: Area2D = $Hitbox

func _ready() -> void:
    hitbox_offset = hitbox.position

func _process(delta: float) -> void:

    hitbox.monitoring = false

    
    if Input.is_action_pressed("attack") and not is_attacking:
        attack()

    if is_attacking:
        velocity = Vector2.ZERO
        return

    _process_movement()
    move_and_slide()

# func animation():
#     if direction:
#         $AnimatedSptire2D.flip_h = direction.x > 0
#         #make sure that the animated sprite is the left 
#     if direction.x != 0:
#         $AnimatedSprite2D.animation = "left" if direction.x < 0 else "right"
#     if direction.y != 0:
#         $AnimatedSprite2D.animation = "up" if direction.y < 0 else "down"

# func animation(dir: Vector2) -> void:
#     if dir.x != 0:
#         animated_sprite_2d.flip_h = dir.x<0
#         animated_sprite_2d.animation = "left" if dir.x < 0 else "right"
#     elif dir.y != 0:
#         animated_sprite_2d.animation = "up" if dir.y < 0 else "down"

func _process_movement() -> void:
    var direction = Input.get_vector("left", "right", "up", "down")
    
    velocity = direction * SPEED
    last_direction = direction
    # if direction != Vector2.ZERO:
    #     velocity = direction * SPEED
    #     last_direction = direction
    # else:
    #     velocity = Vector2.ZERO
    
    update_hitbox_offset()

func attack() -> void:
    is_attacking = true
    hitbox.monitoring = true
    #play_animation("attack", last_direction)
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
    if is_attacking and body.name.begins_with("Termite"):
        body.take_damage(strength)
        
        