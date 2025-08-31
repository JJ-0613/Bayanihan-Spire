extends Node2D

var card_in_slot = false
var is_dragging := false

func _ready() -> void:
	print($Area2D.collision_mask)
