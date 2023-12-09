extends StaticBody2D

var CannonBall = preload("res://CannonBall.tscn")
var DestroyedCannon = preload("res://cannon_destroyed.tscn")

@export var SHOOT_TIMEOUT  = .2              # случайная задержка выстрела
@export var SHOOT_PRECISSION = deg_to_rad(5) # случайное отклонение от оси при выстреле
@export var SHOOT_DISTANCE = 210             # дальность стрельбы
@export var HEALT = 50                      # прочность

var primary_target = null
var SPEER_ROTATION = deg_to_rad(40)
var RELOAD_TIME = 5
@onready var new_angle = self.global_rotation
@onready var armed = true
@onready var fire_accept = false
@onready var parent = self.get_parent()

func _ready():
	$RayCast2D.position = $Marker2D.position
	$RayCast2D.target_position = Vector2(0,SHOOT_DISTANCE)

func _physics_process(delta):
	if primary_target != null:
		new_angle = Vector2.RIGHT.angle_to(primary_target.global_position - self.global_position)
		
		var d = self.global_rotation - new_angle
		
		if d > -SPEER_ROTATION * delta and d < SPEER_ROTATION * delta:
			self.global_rotation = new_angle
		else:
			var k1 = 0
			if d < 0 and d > deg_to_rad(-180):
				k1 = 1
			elif d <= deg_to_rad(-180):
				k1 = -1
			elif d > 0 and d < deg_to_rad(180):
				k1 = -1
			elif d>= deg_to_rad(180):
				k1 = 1
			self.global_rotation += k1 * SPEER_ROTATION * delta

	if $RayCast2D.is_colliding():
		fire_accept = $RayCast2D.get_collider() == primary_target
	else:
		fire_accept = false
		
	if fire_accept and armed:
		fire()

func fire():
	$Timer_Shoot.wait_time = randf_range(0,SHOOT_TIMEOUT)
	$Timer_Shoot.start()

func _on_timer_shoot_timeout():
	var cannon_ball = CannonBall.instantiate()
	cannon_ball.position = $Marker2D.global_position
	var precission =  randf_range(-SHOOT_PRECISSION,SHOOT_PRECISSION)
	cannon_ball.direction = (Vector2.RIGHT).rotated(self.global_rotation + precission)
	get_tree ().current_scene.add_child(cannon_ball)
	$Timer_Shoot.stop()
	
	$Timer_reload.wait_time = RELOAD_TIME
	$Timer_reload.start()
	armed = false
	
	

func _on_area_2d_body_entered(body):
	primary_target = body
	print(self.name, ' ', primary_target.name)

func _on_area_2d_body_exited(body):
	primary_target = null


func _on_timer_reload_timeout():
	armed = true


func get_damage (value):
	HEALT -= value
	print(self.name,'get_damage',str(HEALT))
	if HEALT <= 0:
		destroy()
		
func destroy():
	var destroyed_cannon = DestroyedCannon.instantiate()
	#destroyed_cannon.global_position = self.global_position
	#destroyed_cannon.global_rotation = self.global_rotation
	#get_tree ().current_scene.add_child(destroyed_cannon)
	destroyed_cannon.position = self.position
	destroyed_cannon.rotation = self.rotation
	parent.add_child(destroyed_cannon)
	
	queue_free()
