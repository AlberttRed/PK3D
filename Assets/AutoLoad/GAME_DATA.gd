
extends Node

const Pokemon = preload('res://Assets/DB/pokemon.gd')
const Trainer = preload('res://Assets/Event/Trainer.gd')
#C://Users//aquer//Documents//G//    C://Users//alber//Documents//
const Save_Directory = ""

var player_name = "RED"
var trainer: Trainer
var medals = []
var player_id = randi() % 999999 + 1
var actual_position
var ITEMS = []

var WORLD
var ACTUAL_MAP
var PREVIOUS_MAP
var PLAYER
var EVENTS_LOADED #Només fa referencia al node World/Canvas/Eventos_, falta fer el get_children()

#const NAMES_MAPS = ['Pueblo_Paleta', 'Ruta_1','Ciudad_Verde','Ruta_2','Ruta_22']

#var MAPS = {'Pueblo_Paleta': load("res://Maps/Pueblo Paleta/Pueblo_Paleta.tscn").instance(),
#					'Ruta_1': load("res://Maps/Ruta 01/Ruta_1.tscn").instance(),
#					'Ciudad_Verde': load("res://Maps/Ciudad Verde/Ciudad_Verde.tscn").instance(),
#					'Ruta_2': load("res://Maps/Ruta 02/Ruta_2.tscn").instance(),
#					'Ruta_22': load("res://Maps/Ruta 22/Ruta_22.tscn").instance()}

const NAMES_MAPS = ['Map']
var MAPS = {'Map': load("res://Map.tscn").instance()}

const lol = 1
var party = []
var box1 = []
var box2 = []
var box3 = []
var box4 = []
var box5 = []
var box6 = []
var box7 = []
var box8 = []
var box9 = []
var box10 = []
var box11 = []
var box12 = []
var box13 = []
var box14 = []
var box15 = []
var box16 = []
var box17 = []
var box18 = []
var box19 = []
var box20 = []

var battle_front_sprite = preload("res://Assets/Sprites/Characters/trainer000.png")
var battle_back_sprite = preload("res://Assets/Sprites/Characters/trback000.png")

var player_surf_sprite = preload("res://Assets/Sprites/Characters/boy_dive_offset.png")
var player_run_sprite = preload("res://Assets/Sprites/Characters/boy_run.png")
var player_default_sprite = preload("res://Assets/Sprites/trchar000.png")

func _ready():
#	party.push_back(DB.pokemons[7].make_wild(7))
#	party.push_back(DB.pokemons[4].make_wild(16))
	add_user_signal("start")
	medals.push_back(CONST.MEDALS.ROCA)
	medals.push_back(CONST.MEDALS.CASCADA)
	medals.push_back(CONST.MEDALS.TRUENO)
	medals.push_back(CONST.MEDALS.ARCOIRIS)
	medals.push_back(CONST.MEDALS.ALMA)
	medals.push_back(CONST.MEDALS.PANTANO)
	medals.push_back(CONST.MEDALS.VOLCAN)
	medals.push_back(CONST.MEDALS.TIERRA)
	for p in party:
		p.dni = player_id
		p.original_trainer = player_name

# Note: This can be called from anywhere inside the tree. This function is
# path independent.
# Go through everything in the persist category and ask them to return a
# dict of relevant variables
func save_game():
	var save_game = File.new()
	var events_tosave = []
	save_game.open(Save_Directory + "savegame.save", File.WRITE) #C:\Users\aquer\Documents\G\savegame.save

	for e in EVENTS_LOADED.get_children():
		if e.get_name() != "Player": #and e.is_in_group(ACTUAL_MAP.get_name()):
			print(e.get_name() + ": " + str(e.get_groups()))
			events_tosave.append(e.call("save"))

	var game_data = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"player_id" : player_id, # Vector2 is not supported by JSON
		"player_name" : player_name,
		'Player' : PLAYER.call("save"),
		'ACTUAL_MAP' : ACTUAL_MAP.call("save"),
		"EVENTS_LOADED" : events_tosave
	}
	save_game.store_line(to_json(game_data))

#	var save_nodes = get_tree().get_nodes_in_group("Persist")
#	for i in save_nodes:
#		var node_data = i.call("save");
#		save_game.store_line(to_json(node_data))
	save_game.close()

func save_exists():
	var save_game = File.new()
	if save_game.file_exists(Save_Directory + "savegame.save"):
		return true
	return false

# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_game():
	var save_game = File.new()
	#"C://Users//aquer//Documents//G//savegame.save"
	#"user://savegame.save"
	if not save_game.file_exists(Save_Directory + "savegame.save"):
		print("LOADING ERROR: No existex el fitxer.")
		return # Error! We don't have a save to load.
	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
#	var save_nodes = get_tree().get_nodes_in_group("Persist")
#	for i in save_nodes:
#		i.queue_free()
#	if not save_game.eof_reached():
#		var data = save_game.get_as_text()
		#var current_line = parse_json(save_game.get_line())
		#ACTUAL_MAP = load(current_line["filename"]).instance()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.

	save_game.open(Save_Directory + "savegame.save", File.READ)
	if not save_game.eof_reached():
		var data = parse_json(save_game.get_as_text())
		PLAYER = load(data["Player"]["filename"]).instance()
		PLAYER.position = Vector2(float(data["Player"]["x_position"]), float(data["Player"]["y_position"]))
		ACTUAL_MAP = load(data["ACTUAL_MAP"]["filename"]).instance()
		ACTUAL_MAP.load_map(false)
		yield(ACTUAL_MAP, "loaded")
		ACTUAL_MAP.strength_on = bool(data["ACTUAL_MAP"]["strength_on"])
		EVENTS_LOADED = ProjectSettings.get("Global_World").get_node("CanvasModulate/Eventos_")

		var i = 0
		if EVENTS_LOADED.get_children() != []:
			for e in EVENTS_LOADED.get_children():
				if e.get_name() != "Player" and e.is_in_group(ACTUAL_MAP.get_name()):
					e.position = Vector2(float(data["EVENTS_LOADED"][i]["x_position"]), float(data["EVENTS_LOADED"][i]["y_position"]))
					print(EVENTS_LOADED.get_children().size())
					print("Evento actual:")
					print(e.get_name())
					print("Evento cargado:")
					print(data["EVENTS_LOADED"][i]["name"])
					i=i+1
		else:
			print("No hi ha events guardats en el save.")
		
#	while not save_game.eof_reached():
#
#		var current_line = parse_json(save_game.get_line())
#		# Firstly, we need to create the object and add it to the tree and set its position.
#		var new_object = load(current_line["filename"]).instance()
#		get_node(current_line["parent"]).add_child(new_object)
#		new_object.position = Vector2(current_line["pos_x"], current_line["pos_y"])
#		# Now we set the remaining variables.
#		for i in current_line.keys():
#			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
#				continue
#			new_object.set(i, current_line[i])
	save_game.close()
	emit_signal("start")
	
func new_game():
	print("NEW GAME")
	#var scene = load(WORLD.actual_scene).instance()
	var scene = MAPS[WORLD.actual_scene]# WORLD.actual_scene.instance()
	#ProjectSettings.set("Actual_Map", load(actual_scene).instance())
	#print(ACTUAL_MAP.get_node("MapArea_").get_name())
	#print(ProjectSettings.get("Actual_Map").get_node("Area2D_").get_name())
	PLAYER.set_translation(WORLD.initial_position)
	#ACTUAL_MAP.load_map(false)
	if GAME_DATA.PLAYER.get_parent() != GAME_DATA.WORLD.EVENTOS:
		#GAME_DATA.PLAYER.get_parent().remove_child(GAME_DATA.PLAYER)
		GAME_DATA.WORLD.EVENTOS.add_child(GAME_DATA.PLAYER)
	#WORLD.load_map(scene, false)
	WORLD.load_maps()
#	if GAME_DATA.PLAYER.get_parent() != null:
#		GAME_DATA.PLAYER.get_parent().remove_child(GAME_DATA.PLAYER)
#	GAME_DATA.WORLD.EVENTOS.add_child(GAME_DATA.PLAYER)
	#GLOBAL.load_map(false, ACTUAL_MAP)
	#GLOBAL.start(false, ACTUAL_MAP)
	
	#ProjectSettings.get("Actual_Map").load_map(false)
	#yield(ACTUAL_MAP, "loaded")
	#yield(ProjectSettings.get("Actual_Map"), "loaded")
	WORLD.get_node("AudioStreamPlayer2D").play_music(scene.music)
	emit_signal("start")
	
