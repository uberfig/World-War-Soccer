extends Node


var my_team: int = 0
var enemy_team: int = 1


var maps = {
	"battlefeild": "res://Maps/BattleFeild/BattleFeild.tscn"
}

var gamemodes = {
	
}

var selected_map = []

var selected_mode = []

var score = [0, 0]

func start_game():
	# open the chatroom and hide the lobby
	var game = load("res://MainGame/MainWorld.tscn").instance()
	get_tree().get_root().add_child(game)

	get_tree().get_root().get_node("Main").hide()

func end_game():
	if has_node("/root/MainWorld"): # game is in progress.
		
		get_node("/root/MainWorld").queue_free() #game node is cleared and user is returned to the lobby
	get_tree().get_root().get_node("Main").show()



