extends Node2D

var CannonBall = preload("res://CannonBall.tscn")

@export var SHOOT_TIMEOUT  = .2               # случайная задержка выстрела
@export var SHOOT_PRECISSION = deg_to_rad(5) # случайное отклонение от оси при выстреле

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
