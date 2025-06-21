extends Node2D


var scroll = false
var scroll_to_max


# Called when the node enters the scene tree for the first time.
func _ready():
	if GameController.game_screen_color == "white":
		$WhiteColorRect.visible = true
		$BackArrow/BackArrowBlack.visible = true
	elif GameController.game_screen_color == "black":
		$BlackColorRect.visible = true
		$BackArrow/BackArrowWhite.visible = true
	
	$ScoreText.text = "Score: \n" + str(GameController.player_score)


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
		
		self.scroll = true
		self.scroll_to_max = GameController.game_height
