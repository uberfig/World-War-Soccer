extends Control


func scored_goal(net_team):
	if net_team == GameFlow.my_team:
		$PopupScorePanel/Label.text = "the enemy scored!"
	elif net_team == GameFlow.enemy_team:
		$PopupScorePanel/Label.text = "Your team scored!"
	else:
		print("something went wrong with popup")
	$PopupScorePanel.show()
	$ScoreDisplay.start()


func _on_ScoreDisplay_timeout():
	$PopupScorePanel.hide()


func update_score_display():
	$ScorePanel/HBox/Friendly.text = str(GameFlow.score[GameFlow.my_team])
	$ScorePanel/HBox/Opponent.text = str(GameFlow.score[GameFlow.enemy_team])
