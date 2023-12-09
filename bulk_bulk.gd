extends Node2D

@export var bulk_time = 2

func _ready():
	$Timer.start(bulk_time)
	$AnimatedSprite2D.play("default")
	
func _on_timer_timeout():
	queue_free()

