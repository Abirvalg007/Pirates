extends CharacterBody2D

@export var speed = 150
@export var live_time = 3
var direction : Vector2 = Vector2.LEFT

var Explosion = preload("res://Explosion.tscn")
var BulkBulk = preload("res://bulk_bulk.tscn")
var destroing = null

func _ready():
	$Timer.wait_time = live_time
	$Timer.start()
	
	
func _physics_process(delta):
	velocity = direction * speed
	#move_and_slide()
	var collision_info = move_and_collide(direction * speed * delta)

	if collision_info:
		var collision_point = collision_info.get_position()
		
		var collider = collision_info.get_collider()
		var pos = collision_info.get_position()
		
		var lpos = collider.to_local(pos)
		#var tpos =  collider.local_to_map(lpos)
		#print(collider.get_cell_tile_data(2,tpos))
		#collider.set_cell(2,tpos,-1)
		
		
		cannon_ball_explose()

		#print('ball: ',self.name, ' - ' , collision_info.get_collider().name)

func _on_timer_timeout():
	# где упало?
	var tile_map = get_tree().current_scene.find_child('TileMap3')
	var map_pos = tile_map.local_to_map(self.position)
	
	#print(tile_map.get_cell_tile_data(0,map_pos))
	#print(tile_map.get_cell_tile_data(1,map_pos))
	#print(tile_map.get_cell_tile_data(2,map_pos))
	
	if tile_map.get_cell_tile_data(1,map_pos) == null:
		cannon_ball_drowned()
	else:
		cannon_ball_explose()

func cannon_ball_drowned():
	destroing = BulkBulk
	cannon_ball_destroy()
	
func cannon_ball_explose():
	destroing = Explosion
	cannon_ball_destroy()


func cannon_ball_destroy():
	var explosion = destroing.instantiate()
	explosion.position =self.position
	get_parent().add_child(explosion)
	queue_free()
