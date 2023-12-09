extends Node2D

@export var explose_time = 1

func _ready():
	#$AnimatedSprite2D.play("explosion")
	#$Timer.wait_time = explose_time
	#$Timer.start(explose_time)
	$AnimationPlayer.play("explore")
	pass

func _on_timer_timeout():
	queue_free()




func _on_area_2d_body_entered(body):
	print('explosion: ',self.name,' - ',body.name)
	if body.has_method('get_damage'):
		body.get_damage(100)
