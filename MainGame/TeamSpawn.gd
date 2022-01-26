extends Spatial


var depth: int = 14
var width: int = 1

var spawner_team: int
var friendly_mat = load("res://Maps/friendlyGoal.tres")
var enemy_mat = load("res://Maps/enemyGoal.tres")


func _ready():
	$CSGBox.depth = depth
	if self.name == "1":
		spawner_team = GameFlow.my_team
		$CSGBox.material = friendly_mat
		print("friendly spawn ok if true: ", spawner_team)
	elif self.name == "0":
		spawner_team = GameFlow.enemy_team
		$CSGBox.material = enemy_mat
		print("enemy spawn ok if false: ", spawner_team)
	else:
		print("something bad happened with the spawn ", self.name)


func spawn(team):
	if team == spawner_team && spawner_team == GameFlow.my_team:
		randomize()
		var spawn_location = Vector3(0,5,0)
		var my_location = self.get_translation()
		spawn_location.z = my_location.z + lerp(-1 * depth, depth, randf())
		spawn_location.x = my_location.x
		get_tree().call_group("MainWorld", "spawn_player", spawn_location)
