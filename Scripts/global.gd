extends Node

var levelScene = preload("res://Scenes/Levels/level1.tscn")
var playerScene = preload("res://Scenes/player.tscn")


func _ready():
	pass


func _process(delta):
	pass


func spawnPlayer():
	var level = levelScene.instantiate()
	var player = playerScene.instantiate()
	for child in level.get_children():
		if child.name == "spawnPoint":
			child.add_child(player)
			break
	
