extends CharacterBody2D


var speed = GameController.game_speed_base * GameController.game_speed_multiplier
var game_block_width = GameController.game_block_current_width
var game_block_height
var placed = false
var scroll = false
var scroll_to_max = GameController.game_height + GameController.game_block_spawn_height


func _ready():
	game_block_height = $WhiteColorRect.size.y
	$RightRayCast2D.position.x = game_block_width
	var new_shape = RectangleShape2D.new()
	new_shape.size.x = game_block_width
	new_shape.size.y = game_block_height - 10
	$CollisionShape2D.shape = new_shape
	$CollisionShape2D.position.x = game_block_width / 2
	velocity.x = speed
	position.y = GameController.game_block_spawn_y
	if GameController.game_block_color == "white":
		$WhiteColorRect.visible = true
		$WhiteColorRect.size.x = game_block_width
	elif GameController.game_block_color == "black":
		$BlackColorRect.visible = true
		$BlackColorRect.size.x = game_block_width


func _physics_process(delta):
	if scroll == true:
		position.y += GameController.game_scroll_speed * delta
		if abs(position.y - scroll_to_max) < 1:
			scroll = false
			position.y = scroll_to_max
	
	if placed == false:
		# Handle click / placement
		if Input.is_action_just_pressed("ui_click"):
			place_block()
		else:
			if position.x >= GameController.game_width - game_block_width:
				velocity.x = -speed
			elif position.x <= 0:
				velocity.x = speed
			move_and_slide()
	
	if position.y >= GameController.game_height + GameController.game_block_spawn_height:
		self.queue_free()


func place_block():
	if not $LeftRayCast2D.is_colliding() and not $RightRayCast2D.is_colliding():
		GameController.game_over()
	else:
		GameController.player_score += 1
		var foundation_block
		if $LeftRayCast2D.is_colliding():
			foundation_block = $LeftRayCast2D.get_collider()
		elif $RightRayCast2D.is_colliding():
			foundation_block = $RightRayCast2D.get_collider()
		
		if abs(position.x - foundation_block.position.x) < GameController.game_snap_size:
			position.x = foundation_block.position.x
			if GameController.game_speed_multiplier > 2:
				GameController.game_speed_multiplier -= 0.05
		elif abs((position.x + game_block_width) - (foundation_block.position.x + foundation_block.game_block_width)) < GameController.game_snap_size:
			position.x = (foundation_block.position.x + foundation_block.game_block_width) - game_block_width
			if GameController.game_speed_multiplier > 2:
				GameController.game_speed_multiplier -= 0.05
		else:
			GameController.game_speed_multiplier += 0.2
			var new_game_block_min = max(position.x, foundation_block.position.x)
			var new_game_block_max = min(position.x + GameController.game_block_current_width, foundation_block.position.x + foundation_block.game_block_width)
			GameController.game_block_current_width = new_game_block_max - new_game_block_min
		
		GameController.game_block_spawn_y -= game_block_height
		
		if GameController.game_block_spawn_y < 0:
			create_additional_game_screen()
		else:
			var game_block = load("res://game/game_block/game_block.tscn")
			var new_game_block = game_block.instantiate()
			GameController.spawn_locations["right"] = GameController.game_width - GameController.game_block_current_width
			new_game_block.position.x = GameController.spawn_locations[GameController.spawn_side]
			GameController.switch_spawn_sides()
			get_parent().add_child(new_game_block)
	placed = true


func create_additional_game_screen():
	GameController.switch_colors()
	GameController.game_block_spawn_y += game_block_height
	GameController.game_block_current_width = self.position.x
	var game_block = load("res://game/game_block/game_block.tscn")
	var new_game_block = game_block.instantiate()
	new_game_block.placed = true
	new_game_block.position.x = 0
	new_game_block.scroll_to_max = GameController.game_height - GameController.game_block_spawn_height
	get_parent().add_child(new_game_block)
	
	GameController.game_block_current_width = GameController.game_width - (self.position.x + self.game_block_width)
	new_game_block = game_block.instantiate()
	new_game_block.placed = true
	new_game_block.position.x = (self.position.x + self.game_block_width)
	new_game_block.scroll_to_max = GameController.game_height - GameController.game_block_spawn_height
	get_parent().add_child(new_game_block)
	
	$CollisionShape2D.disabled = true
	self.scroll_to_max = GameController.game_height - GameController.game_block_spawn_height
	
	GameController.game_block_current_width = GameController.game_block_spawn_width
	GameController.game_block_spawn_y = GameController.game_height - (GameController.game_block_spawn_height * 2)
	
	var existing_game_screen = get_parent().find_child("*GameScreen*", true, false)
	existing_game_screen.scroll = true
	existing_game_screen.scroll_to_max = GameController.game_height
	
	var game_screen = load("res://game/game_screen/game_screen.tscn")
	var new_game_screen = game_screen.instantiate()
	new_game_screen.position.y = -GameController.game_height
	new_game_screen.scroll = true
	new_game_screen.scroll_to_max = 0
	get_parent().add_child(new_game_screen)
	
	var game_blocks = get_tree().get_nodes_in_group("game_block")
	for block in game_blocks:
		block.scroll = true
