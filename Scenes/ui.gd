extends Control

var current_score = 0
var highest_score = 0

func _ready() -> void:
	Signals.glass_filled.connect(_glass_cleared)
	Signals.fresh_cup.connect(_fresh_cup)

func _process(delta: float) -> void:
	$TimerText.text = str("Time: ", int($RoundTimer.time_left))


func _on_start_button_button_up() -> void:
	$RoundTimer.start()
	$StartButton.hide()
	Signals.gameStarted = true
	var tween = get_tree().create_tween()
	tween.tween_property($Title, "global_position:y", -500, 3).set_trans(Tween.TRANS_SINE)
	
func _glass_cleared():
	$GlassCleared_label.show()
	current_score += 1
	_update_score()
	$RoundTimer.paused = true
	
func _fresh_cup():
	$GlassCleared_label.hide()
	$RoundTimer.paused = false
func _update_score():
	$ScoreText.text = str("Score: ",current_score)
	
func _time_up():
	Signals.emit_signal("time_up")
	$TimeUpLabel.show()
	Signals.gameStarted = false
	if current_score > highest_score:
		highest_score = current_score
	$HighScoreText.text = str("High Score: ", highest_score)
	await get_tree().create_timer(6).timeout
	$TimeUpLabel.hide()
	var tween = get_tree().create_tween()
	tween.tween_property($Title, "global_position:y", 0, 2).set_trans(Tween.TRANS_SINE)
	$StartButton.show()
