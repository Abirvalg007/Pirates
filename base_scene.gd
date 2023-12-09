extends Node2D

var wind_new_angle = GlobalVars.wind_angle
var wind_change_speed = deg_to_rad(2)

@onready var player = $Ship

func _input(event):
	if event.is_action_pressed("ui_fire"):
#		print('')
#		print('angle_wind      : ', rad_to_deg(GlobalVars.wind_angle),'->',rad_to_deg(wind_new_angle))
#		print('angle_ship      : ',rad_to_deg($Ship.global_rotation))
#		print('angle_to_course : ',rad_to_deg($Ship.angle_to_course))
#
#		print('angle_sail      : ',rad_to_deg($Ship.sail_large.global_rotation),'(',rad_to_deg($Ship.sail_large.rotation),')','->',rad_to_deg($Ship.new_sail_angle))
#		print('k               : ',(Vector2.RIGHT.rotated(GlobalVars.wind_angle)).dot(Vector2.RIGHT.rotated($Ship.sail_large.global_rotation + deg_to_rad(90))))
#		print('k2              : ',(Vector2.RIGHT.rotated($Ship.global_rotation)).dot(Vector2.RIGHT.rotated($Ship.sail_large.global_rotation + deg_to_rad(90))))
#		print('k3              : ',(Vector2.RIGHT.rotated($Ship.global_rotation)).dot(Vector2.RIGHT.rotated($Ship.sail_large.global_rotation + deg_to_rad(90))) * (Vector2.RIGHT.rotated(GlobalVars.wind_angle)).dot(Vector2.RIGHT.rotated($Ship.sail_large.global_rotation + deg_to_rad(90))))
#		print('speed           : ',$Ship.velocity.length())
		pass
		
func _draw():
	#wind dir
	#draw_line($Ship.position, $Ship.position + Vector2.RIGHT.rotated(GlobalVars.wind_angle) * 100, Color.RED, 5.0)
	#course
	#draw_line($Ship.position, $Ship.position + $Ship.ship_dir.rotated($Ship.global_rotation) * 100, Color.YELLOW, 1.0)
	pass
	
func _process(delta):
	queue_redraw()
	($CanvasLayer/Label).text = str(player.HEALT)
		
func _physics_process(delta):
	if GlobalVars.wind_angle != wind_new_angle and abs(GlobalVars.wind_angle - wind_new_angle) > wind_change_speed:
		GlobalVars.wind_angle -= wind_change_speed * ((GlobalVars.wind_angle - wind_new_angle)/abs(GlobalVars.wind_angle - wind_new_angle))
	else:
		GlobalVars.wind_angle = wind_new_angle
		
	$CanvasLayer/wind_arrow.global_rotation = GlobalVars.wind_angle 
	
func _ready():
	_on_wind_timer_timeout()
	
	pass
	

func _on_wind_timer_timeout():
	wind_new_angle = randf_range(deg_to_rad(-180),deg_to_rad(180))
	#print(wind_new_angle)
	var w =  randi_range(10,20)
	#print(w)
	$Wind_timer.wait_time = w
	$Wind_timer.start()
	
	
	
