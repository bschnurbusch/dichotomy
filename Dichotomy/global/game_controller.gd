extends Node

var save_location = "res://savegame.txt"
var high_scores = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

var game_width = 320
var game_height = 480
var game_scroll_speed = 960
var game_snap_size = 5

var game_block_color = "white"
var game_block_spawn_y
var game_block_spawn_height = 48
var game_block_spawn_width = 105
var spawn_locations = {
	"left": 0,
	"right": game_width - game_block_spawn_width,
}
var spawn_side = "left"
var game_screen_color = "black"
var game_speed_base = 50
var game_speed_multiplier = 1.000

var game_block_current_width
var game_block_min_width = 5
var game_block_min_pos
var game_block_max_pos

var player_score = 0


func load_game():
	if OS.get_name() == "Android":
		save_location = "user://savegame.txt"
	if FileAccess.file_exists(save_location) == true:
		var file = FileAccess.open(save_location, FileAccess.READ)
		high_scores = file.get_var()


func game_over():
	if OS.get_name() == "Android":
		save_location = "user://savegame.txt"
	high_scores.append(player_score)
	high_scores.sort()
	high_scores.reverse()
	high_scores.resize(10)
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(high_scores)
	
	var game_over_screen = load("res://menus/game_over/game_over.tscn")
	var new_game_over_screen = game_over_screen.instantiate()
	new_game_over_screen.position.y = -game_height
	new_game_over_screen.scroll = true
	new_game_over_screen.scroll_to_max = 0
	get_parent().add_child(new_game_over_screen)
	
	var existing_game_screen = get_parent().find_child("*GameScreen*", true, false)
	existing_game_screen.scroll = true
	existing_game_screen.scroll_to_max = game_height
	
	var existing_score = get_parent().find_child("*Score*", true, false)
	existing_score.scroll = true
	existing_score.scroll_to_max = game_height
	
	var existing_game_blocks = get_tree().get_nodes_in_group("game_block")
	for block in existing_game_blocks:
		block.scroll = true
		block.scroll_to_max = GameController.game_height + GameController.game_block_spawn_height


func switch_colors():
	if game_block_color == "white":
		game_block_color = "black"
	else:
		game_block_color = "white"
	
	if game_screen_color == "black":
		game_screen_color = "white"
	else:
		game_screen_color = "black"


func switch_spawn_sides():
	if spawn_side == "left":
		spawn_side = "right"
	else:
		spawn_side = "left"
