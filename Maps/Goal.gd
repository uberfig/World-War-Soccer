extends Area


var team: int

var friendly_mat = load("res://Maps/friendlyGoal.tres")
var enemy_mat = load("res://Maps/enemyGoal.tres")


func _ready():
	if self.name == "1":
		team = GameFlow.my_team
		$CSGBox.material = friendly_mat
		print("friendly net ok if true: ", team)
	elif self.name == "0":
		team = GameFlow.enemy_team
		$CSGBox.material = enemy_mat
		print("enemy net ok if false: ", team)
	else:
		print("something bad happened with the goal ", self.name)


func _on_Goal_body_entered(body):
	print("goal ", self.name, " entered by: ", body)
	print("is friendly: ", team)
	if(body is RigidBody):
		print("a goal is scored with: ", body.name)
		get_tree().call_group("HUD", "scored_goal", team)
		get_tree().call_group("MainWorld", "scored_goal", team)
