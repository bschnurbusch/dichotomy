extends Node2D


var scroll = false
var scroll_to_max


# Called when the node enters the scene tree for the first time.
func _ready():
	$HighScore1/Label.text = str(GameController.high_scores[0])
	$HighScore2/Label2.text = str(GameController.high_scores[1])
	$HighScore3/Label3.text = str(GameController.high_scores[2])
	$HighScore4/Label4.text = str(GameController.high_scores[3])
	$HighScore5/Label5.text = str(GameController.high_scores[4])
	$HighScore6/Label6.text = str(GameController.high_scores[5])
	$HighScore7/Label7.text = str(GameController.high_scores[6])
	$HighScore8/Label8.text = str(GameController.high_scores[7])
	$HighScore9/Label9.text = str(GameController.high_scores[8])
	$HighScore10/Label10.text = str(GameController.high_scores[9])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _physics_process(delta):
	if scroll == true:
		position.y += GameController.game_scroll_speed * delta
		if abs(position.y - scroll_to_max) < 1:
			scroll = false
			position.y = scroll_to_max
	
	if position.y >= GameController.game_height:
		self.queue_free()


func _on_button_pressed():
	if scroll == false:
		var main_menu = load("res://menus/main_menu/main_menu.tscn")
		var new_main_menu = main_menu.instantiate()
		new_main_menu.position.y = -GameController.game_height
		new_main_menu.scroll = true
		new_main_menu.scroll_to_max = 0
		get_parent().add_child(new_main_menu)
		
		self.scroll_to_max = GameController.game_height
		self.scroll = true
