extends CharacterBody2D

var direction: Vector2 = Vector2(1, 1)
var speed: int = 201

func _process(delta: float) -> void:
    direction = Input.get_vector("left", "right", "up", "down")
    velocity = direction * speed

    move_and_slide()

func animation():
    if direction:
        $AnimatedSptire2D.flip_h = direction.x > 0
        #make sure that the animated sprite is the left 
    if direction.x != 0:
        $AnimatedSprite2D.animation = "left" if direction.x < 0 else "right"
    if direction.y != 0:
        $AnimatedSprite2D.animation = "up" if direction.y < 0 else "down"