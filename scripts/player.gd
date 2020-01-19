extends KinematicBody2D


export (int) var speed = 200

const DIRECTION_LEFT = -1
const DIRECTION_RIGHT = 1
var direction = Vector2(DIRECTION_RIGHT, 1)

func set_direction(player_direction):
	var modifier = player_direction / abs(player_direction)
	apply_scale(Vector2(modifier * direction.x, 1))
	direction = Vector2(modifier, direction.y)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_pressed("right") or Input.is_action_pressed("left") or Input.is_action_pressed("up") or Input.is_action_pressed("down"):
		$AnimatedSprite.play("Run")
	else:
		$AnimatedSprite.play("Idle")

var velocity = Vector2()

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('right'):
		velocity.x += 1
		set_direction(DIRECTION_RIGHT)
	if Input.is_action_pressed('left'):
		velocity.x -= 1
		set_direction(DIRECTION_LEFT)
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
    
	velocity = velocity.normalized() * speed

func _physics_process(delta):
    get_input()
    velocity = move_and_slide(velocity)