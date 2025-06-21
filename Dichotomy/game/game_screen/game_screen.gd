extends Node2D


var scroll = false
var scroll_to_max


# Called when the node enters the scene tree for the first time.
func _ready():
	if GameController.game_screen_color == "white":
		$WhiteColorRect.visible = true
	elif GameController.game_screen_color == "black":
		$BlackColorRect.visible = true


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
		if not get_parent().find_child("*GameOver*", true, false):
			var game_block = load("res://game/game_block/game_block.tscn")
			var new_game_block = game_block.instantiate()
			GameController.spawn_locations["right"] = GameController.game_width - GameController.game_block_current_width
			new_game_block.position.x = GameController.spawn_locations[GameController.spawn_side]
			GameController.switch_spawn_sides()
			get_parent().add_child(new_game_block)
		self.queue_free()
