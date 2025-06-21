extends Node2D


var scroll = false
var scroll_to_max


# Called when the node enters the scene tree for the first time.
func _ready():
	GameController.load_game()


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
		remove()


func remove():
	if get_parent().find_child("*GameScreen*", true, false):
		GameController.game_block_current_width = GameController.game_width
		GameController.game_block_spawn_y = GameController.game_height
		GameController.player_score = 0
		GameController.game_speed_multiplier = 1
		var game_block = load("res://game/game_block/game_block.tscn")
		var new_game_block = game_block.instantiate()
		new_game_block.placed = true
		get_parent().add_child(new_game_block)
		GameController.game_block_current_width = GameController.game_block_spawn_width
		GameController.game_block_spawn_y = GameController.game_height - GameController.game_block_spawn_height
		GameController.spawn_locations["right"] = GameController.game_width - GameController.game_block_spawn_width
		
		new_game_block = game_block.instantiate()
		GameController.switch_spawn_sides()
		get_parent().add_child(new_game_block)
		
		var score_display = load("res://game/score_display/score.tscn")
		var new_score_display = score_display.instantiate()
		get_parent().add_child(new_score_display)
	self.queue_free()


func _on_play_button_pressed():
	if scroll == false:
		var game_screen = load("res://game/game_screen/game_screen.tscn")
		var new_game_screen = game_screen.instantiate()
		new_game_screen.position.y = -GameController.game_height
		new_game_screen.scroll = true
		new_game_screen.scroll_to_max = 0
		get_parent().add_child(new_game_screen)
		scroll = true
		scroll_to_max = GameController.game_height


func _on_high_scores_button_pressed():
	if scroll == false:
		var high_scores = load("res://menus/high_scores/high_scores.tscn")
		var new_high_scores_menu = high_scores.instantiate()
		new_high_scores_menu.position.y = -GameController.game_height
		new_high_scores_menu.scroll = true
		new_high_scores_menu.scroll_to_max = 0
		get_parent().add_child(new_high_scores_menu)
		scroll = true
		scroll_to_max = GameController.game_height


func _on_tutorial_button_pressed():
	if scroll == false:
		var tutorial = load("res://menus/tutorial/tutorial.tscn")
		var new_tutorial = tutorial.instantiate()
		new_tutorial.position.y = -GameController.game_height
		new_tutorial.scroll = true
		new_tutorial.scroll_to_max = 0
		get_parent().add_child(new_tutorial)
		scroll = true
		scroll_to_max = GameController.game_height
