extends Node

var playerScene = preload("res://Scenes/player.tscn")



func _enter_tree():
	var player = playerScene.instantiate()
	for child in get_parent().get_children():
		if child.name == "spawnPoint":
			child.add_child(player)
			print(child.name)
			break



func _process(delta):
	pass
