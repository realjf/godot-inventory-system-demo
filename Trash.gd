extends Node2D

onready var animPlayer = $AnimationPlayer
var inTrashArea = false

func _ready():
	animPlayer.play("Close")
	

func _process(delta):
	if find_parent("UserInterface").holding_item != null:
		show()
		if inTrashArea and Input.is_mouse_button_pressed(BUTTON_LEFT):
			find_parent("UserInterface").holding_item.queue_free()
			find_parent("UserInterface").holding_item = null
	else:
#		yield(get_tree().create_timer(1.0), "timeout")
		hide()


func _on_Area2D_area_entered(area):
	animPlayer.play("Open")
	inTrashArea = true


func _on_Area2D_area_exited(area):
	animPlayer.play("Close")
	inTrashArea = false
