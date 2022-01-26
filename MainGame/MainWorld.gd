extends Spatial




# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	new_game()


func new_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	for child in self.get_children():
		if child.name != "BombSpawner":
			child.queue_free()
	
	var map = load(GameFlow.maps["battlefeild"])
	var map_instance = map.instance()
	add_child(map_instance)
	print("instanced map")
	
	get_tree().call_group("TeamSpawn", "spawn", GameFlow.my_team)
	
	spawn_enemy()
	spawn_teammate()
	
	delete_and_respawn_bomb()


func _input(event):
	if event.is_action_pressed("ui_escape"): 
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().call_group("HUD", "change_pause_menu_visibility", true)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_tree().call_group("HUD", "change_pause_menu_visibility", false)


func scored_goal(net_team):
	delete_and_respawn_bomb()
	print("friendly = ", net_team)
	if net_team == GameFlow.my_team:
		GameFlow.score[GameFlow.enemy_team] += 1
		print("enemy scored goal! score is: ", GameFlow.score[GameFlow.enemy_team])
	elif net_team == GameFlow.enemy_team:
		GameFlow.score[GameFlow.my_team] += 1
		print("friendly scored goal! score is: ", GameFlow.score[GameFlow.my_team])
	else:
		print("something went wrong with friendly in the mainworld scored goal func")
	print("gameflow score is: ", GameFlow.score)
	get_tree().call_group("HUD", "update_score_display")


func delete_and_respawn_bomb():
	if $BombSpawner.get_child_count() != 0:
		for child in $BombSpawner.get_children():
			print("deleted", child)
			child.queue_free()
	instance_bomb()


func instance_bomb():
	var bomb = preload("res://InteractableItems/Bomb.tscn")
	var bomb_instance = bomb.instance()
	$BombSpawner.add_child(bomb_instance)
	print("instanced bomb")


func spawn_player(location: Vector3):
	var player = preload("res://Player/Player.tscn")
	var player_instance = player.instance()
	
	player_instance.set_translation(location)
	
	add_child(player_instance)
	print("instanced player")


func spawn_enemy(location: Vector3 = Vector3(-26, 2.5, 0)):
	var enemy = preload("res://TeamAndOpp/EnemyPlayer.tscn")
	var enemy_instance = enemy.instance()
	
	enemy_instance.set_translation(location)
	
	add_child(enemy_instance)
	print("instanced enemy")


func spawn_teammate(location: Vector3 = Vector3(26, 2.5, 0)):
	var teammate = preload("res://TeamAndOpp/TeamMate.tscn")
	var teammate_instance = teammate.instance()
	
	teammate_instance.set_translation(location)
	
	add_child(teammate_instance)
	print("instanced teammate")
