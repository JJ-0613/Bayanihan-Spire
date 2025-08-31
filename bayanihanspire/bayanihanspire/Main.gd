extends Node2D

@onready var sprite = $AnimatedSprite2D
@onready var timer_bar_a = $Timer/CanvasLayer/TimerBarA
@onready var timer_bar_b = $Timer/CanvasLayer/TimerBarB
@onready var game_timer_a = $Timer/CanvasLayer/GameTimerA
@onready var game_timer_b = $Timer/CanvasLayer/GamerTimerB
@onready var return_button = $Timer/EndTurn

var total_time_a := 180.0
var total_time_b := 10.0
var switch_time := 10.0   # After 3 seconds, we switch from Timer A to B

func _ready():
	# Setup Timer A
	timer_bar_a.max_value = total_time_a
	timer_bar_a.value = total_time_a

	# Setup Timer B
	timer_bar_b.max_value = total_time_b
	timer_bar_b.value = total_time_b
	timer_bar_b.visible = false
	
	return_button.visible = false

	# Start Timer A automatically
	game_timer_a.wait_time = total_time_a
	game_timer_a.start()

	# Connect signals
	game_timer_a.timeout.connect(_on_game_timer_a_timeout)
	game_timer_b.timeout.connect(_on_game_timer_b_timeout)
	return_button.pressed.connect(_on_return_button_pressed)

	# Create a delayed call to switch to Timer B after `switch_time`
	await get_tree().create_timer(switch_time).timeout
	_switch_to_b()

func _process(delta):
	# Update Timer A's bar if active
	if not game_timer_a.is_stopped():
		timer_bar_a.value = game_timer_a.time_left

	# Update Timer B's bar if active
	if not game_timer_b.is_stopped():
		timer_bar_b.value = game_timer_b.time_left

# --- Switch from Timer A to Timer B ---
func _switch_to_b():
	if game_timer_a.is_stopped():
		return # If Timer A already ended, no need to switch

	# Pause Timer A and show Timer B
	game_timer_a.paused = true
	timer_bar_a.visible = false

	# Reset and start Timer B
	timer_bar_b.value = total_time_b
	timer_bar_b.visible = true
	game_timer_b.wait_time = total_time_b
	game_timer_b.start()

	# Show return button
	return_button.visible = true

# --- Switch Back to Timer A ---
func _switch_to_a():
	# Stop Timer B
	game_timer_b.stop()
	timer_bar_b.visible = false
	return_button.visible = false

	# Resume Timer A from where it left off
	timer_bar_a.visible = true
	game_timer_a.paused = false
	
	await get_tree().create_timer(switch_time).timeout
	_switch_to_b()


# --- When Timer B naturally ends ---
func _on_game_timer_b_timeout():
	_switch_to_a()

# --- When Player presses Return button ---
func _on_return_button_pressed():
	_switch_to_a()

# --- When Timer A fully finishes ---
func _on_game_timer_a_timeout():
	print("Game Over!")
	get_tree().paused = true


func _on_switch_button_pressed() -> void:
	pass # Replace with function body.
