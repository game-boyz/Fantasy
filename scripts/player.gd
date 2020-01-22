extends KinematicBody2D

enum STATES {IDLE, RUN, JUMP, ATTACK_1, ATTACK_2, ATTACK_3}
var state = null

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

var ANIMS = {
	Idle = STATES.IDLE,
	Run = STATES.RUN,
	Attack1 = STATES.ATTACK_1,
	Attack2 = STATES.ATTACK_2,
	Attack3 = STATES.ATTACK_3,
}

func change_animation():
	var next = null
	for animation in $Animations.get_children():
		var a = ANIMS.get(animation.name)
		if a != null and state == a:
			next = animation
		else:
			animation.hide()
	if next != null:
		next.show()
		$AnimationPlayer.play(next.name)

func get_next_attack():
	var curr = $AnimationPlayer.current_animation

	if curr == ANIMS.attack_1:
		return ANIMS.attack_2
	if curr == ANIMS.attack_2:
		return ANIMS.attack_3

	return ANIMS.attack_1

func end_attack():
	if Input.is_action_pressed("attack"):
		state = get_next_attack()
	else:
		state = STATES.IDLE

func attack():
	if state != STATES.ATTACK_1:
		state = STATES.ATTACK_1

func change_state(next_state):
	if state != next_state and state != STATES.ATTACK_1 and state != STATES.ATTACK_2 and state != STATES.ATTACK_3:
		state = next_state

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("attack"):
		attack()
	elif Input.is_action_pressed("right") or Input.is_action_pressed("left") or Input.is_action_pressed("up") or Input.is_action_pressed("down"):
		change_state(STATES.RUN)
	else:
		change_state(STATES.IDLE)

	change_animation()

var velocity = Vector2()

func get_input():
	velocity = Vector2()
	if state != STATES.ATTACK_1:
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