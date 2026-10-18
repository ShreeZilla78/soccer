extends Node

var level: int = 1
var current_map_root: Node = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_map_root = get_node("Soccer")
	#this sets the current map var to the Soccer scene that we connected

	var exit = current_map_root.get_node_or_null("Exit")
	if exit:
		exit.body_entered.connect(_on_exit_body_entered)


func _load_level(level_number: int) -> void:
	if current_map_root:
		current_map_root.queue_free()  # Remove the current map from the scene tree

	var new_map_scene = "res://Scenes/Maps/Map_%s.tscn" % level_number
	current_map_root = load(new_map_scene).instantiate()
	add_child(current_map_root)

	var exit = current_map_root.get_node_or_null("Exit")
	if exit:
		exit.body_entered.connect(_on_exit_body_entered)

func _on_exit_body_entered(body: Node2D) -> void:
	print(body.name)
	#check this 
	#if body.name == "player":
	#	level += 1
	# 	call_deferred("_load_level", level)


