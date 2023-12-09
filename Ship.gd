extends CharacterBody2D

const SMALL_SPEED = 5 # минимальная скорость получения повреждений при столкновении с берегом

var ship_dir = Vector2.RIGHT
@onready var sail_large = get_node("Node2D/SailLarge")
@onready var sail_small = get_node("Node2D/SailSmall")

@export var speed = 5000
@export var rotation_speed = 1.5
@export var HEALT = 10000                     # прочность

var rotation_direction = 0
var max_rotation_sail = deg_to_rad(45)
var sail_rotation_speed = deg_to_rad(2)
var new_sail_angle

var angle_to_course


#onready var sail_large = $Marker2D

func get_input():
	rotation_direction = Input.get_axis("ui_left", "ui_right")

	
#    velocity = transform.x * Input.get_axis("down", "up") * speed
func _physics_process(delta):
	get_input()
	self.rotation += rotation_direction * rotation_speed * delta

	# --------------
	# ветер в спину
	# --------------
	#GlobalVars.wind_angle = self.global_rotation

	angle_to_course = Vector2.RIGHT.rotated(GlobalVars.wind_angle).angle_to(Vector2.RIGHT.rotated(self.global_rotation))
	
	if angle_to_course > 180:
		angle_to_course -= 360
	if angle_to_course < -180:
		angle_to_course += 360
	
		
	if  angle_to_course < max_rotation_sail and   angle_to_course > -max_rotation_sail :
		sail_large.global_rotation = GlobalVars.wind_angle - deg_to_rad(90)
		sail_small.global_rotation = GlobalVars.wind_angle - deg_to_rad(90)
		new_sail_angle  = sail_large.global_rotation #GlobalVars.wind_angle - deg_to_rad(90) # pfnsxrf!!!!!!!

	elif angle_to_course >= max_rotation_sail:
		new_sail_angle = - deg_to_rad(90) - max_rotation_sail
	elif angle_to_course <= -max_rotation_sail:
		new_sail_angle = -(max_rotation_sail)# - deg_to_rad(90)#

	# понижающий коэффциент скорости через скалярное произведение направлений ветра и парусов
	var k = (Vector2.RIGHT.rotated(GlobalVars.wind_angle)).dot(Vector2.RIGHT.rotated(self.sail_large.global_rotation + deg_to_rad(90)))
	# понижающий коэффциент скорости через скалярное произведение направлений корпуса и парусов
	var k2 =(Vector2.RIGHT.rotated(self.global_rotation)).dot(Vector2.RIGHT.rotated(self.sail_large.global_rotation + deg_to_rad(90)))

	var k3 = k * k2
	if k3<0:
		k3 = 0 

	if sail_large.rotation != new_sail_angle and abs(sail_large.rotation - new_sail_angle) > sail_rotation_speed:
		sail_large.rotation -= sail_rotation_speed * ((sail_large.rotation - new_sail_angle)/abs(sail_large.rotation - new_sail_angle))
		sail_small.rotation -= sail_rotation_speed * ((sail_small.rotation - new_sail_angle)/abs(sail_small.rotation - new_sail_angle))
	else:
		sail_large.rotation = new_sail_angle
		sail_small.rotation = new_sail_angle



	velocity = ship_dir.rotated(self.rotation) * k3 * speed * delta
	
	move_and_slide()
	
	
	
	

func _process(delta):
	queue_redraw()	

func _input(event):
	if event.is_action_pressed("ui_fire"):
		get_tree().call_group("ship_cannons",'fire')
		
		


func _on_timer_dmg_timeout():
	# damaging
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)

		var dmg = get_real_velocity().length() * 1.0
#		print(dmg)
#		print(get_slide_collision_count())
#		print('-----')
		get_damage (dmg)


func get_damage (value):
	HEALT -= value
	set_view(HEALT)
	if HEALT <= 0:
		destroy()
		
func destroy():
	#queue_free()
	pass


func set_view(healt):
		if HEALT > 7000:
			($Node2D/AnimatedSprite2D).frame = 0
			($Node2D/SailLarge).frame = 0
		elif HEALT > 5000:
			($Node2D/AnimatedSprite2D).frame = 1
			($Node2D/SailLarge).frame = 1
		elif HEALT > 3000:
			($Node2D/AnimatedSprite2D).frame = 2
			($Node2D/SailLarge).frame = 2
		else:
			($Node2D/AnimatedSprite2D).frame = 3
			($Node2D/SailLarge).frame = 3
