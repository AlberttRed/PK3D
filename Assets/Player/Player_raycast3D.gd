extends RayCast

onready var body = get_parent()
var direction
var ray_direction
var result = null
var tile_result = null
var colliders = []
var pos
var Tile = load("res://Assets/Logics/tile.gd")
var tile

onready var ray_directions = {'RayCastRight': Vector3(3, -4, 0),
			 'RayCastLeft': Vector3(-3, -4, 0),
			 'RayCastUp': Vector3(0, -4, -3),
			 'RayCastDown': Vector3(0, -4, 3)}

onready var directions = {'RayCastRight': Vector3(CONST.GRID_SIZE, 0, 0),
			 'RayCastLeft': Vector3(-CONST.GRID_SIZE, 0, 0),
			 'RayCastUp': Vector3(0, 0, -CONST.GRID_SIZE),
			 'RayCastDown': Vector3(0, 0, CONST.GRID_SIZE)}
			
#Guardem el contrari del facing. Si el body interecciona miran cap adalt (up, = 12), li tornem l'invers, que seria cap avall (down, = 0)
var facing_inverse = {'right': 4,
				 'left': 8,
				 'up': 1,
				 'down': 12}
			
			
# Called when the node enters the scene tree for the first time.
func _ready():
	direction = directions[get_name()]# Replace with function body.
	ray_direction = ray_directions[get_name()]
# Actualitza l'intersact point per detectar si hi ha alguna colisió en la següent cel·la del mapa respecte a la posició actual del parent
func update(cells=1):
	if body.Through:
		result = null
	else:
		tile_result = intersect_tile(direction, cells)
		if(!tile_result.empty()):
			if tile_result.collider is GridMap:
				var posit = tile_result.collider.world_to_map(tile_result.position)
				var id = tile_result.collider.get_cell_item(posit.x, posit.y, posit.z)
				var tile_name = tile_result.collider.mesh_library.get_item_name(id)
				tile = get_tile(tile_name)

				print(str(tile.tipo))
		result = get_collider()# intersect_point(direction, cells)
		print(result)
	
func intersect_point(dir, cells=1):
	if weakref(GAME_DATA.ACTUAL_MAP).get_ref(): #Comprovem que l'Acual Map s'hagi actualitzat en el cas de canviar de mapa i aixi evitar que doni error
		
		#print(str(body.get_translation()+dir*cells))
		print("from: " + str(body.get_translation() + Vector3(0,1,0)))
		print("to: " + str(body.get_translation()  + Vector3(0,1,0) + (dir*cells)))
		return body.get_world().get_direct_space_state().intersect_ray(body.get_translation() + Vector3(0,1,0), body.get_translation()  + Vector3(0,1,0) + (dir*cells))#intersect_point(body.get_translation() + (dir*cells), CONST.GRID_SIZE, get_tree().get_root().get_node("World/CanvasModulate/MapArea_").get_children(), 2147483647, true, true)

func intersect_tile(dir, cells=1):
	if weakref(GAME_DATA.ACTUAL_MAP).get_ref(): #Comprovem que l'Acual Map s'hagi actualitzat en el cas de canviar de mapa i aixi evitar que doni error

		var pro = Vector3(0, 0, 0)
		
		#print(str(body.get_translation()+dir*cells))
		
		#print(str(body.get_translation()+Vector3(0, 2, 0)))
		return body.get_world().get_direct_space_state().intersect_ray(body.get_translation() + Vector3(0, 2, 0) + dir*cells, body.get_translation() + Vector3(0, -2, 0) +dir*cells)#body.get_translation(), body.get_translation() + (dir*cells) + pro)#intersect_point(body.get_translation() + (dir*cells), CONST.GRID_SIZE, get_tree().get_root().get_node("World/CanvasModulate/MapArea_").get_children(), 2147483647, true, true)

func is_colliding():
	#print("SURF: " + str(is_SurfingArea()) + " " + str(body.get_surfing()))
#	if result == null or result.empty() or !isnot_Pasable() or (is_SurfingArea() and body.surfing):
#		print_colliders()
#		return false
#	else:
#		print("COLLIDING")
#		print_colliders()
#		return true
	if  (is_SurfingArea() and !body.surfing):
			return true
	if is_ledge() and !body.jumping:
		return true
	if result == null or result.empty() or !isnot_Pasable():
		print_colliders()
		return false
	else:
		print("COLLIDING")
		print_colliders()
		return true
		
func is_SurfingArea():
#	if tile_result != null:
#		for c in get_tiles_prop_byProp("Tipo"):
	if tile_result.collider is GridMap:
		return tile.tipo == CONST.TILE_TYPE.SURF
	else:
		return false
	
func isnot_Pasable():
	for c in get_colliders():
		if c.is_in_group("Pasable"):
			#print(c.get_name() + " IS PASABLE")
			return false
		else:
			#print(c.get_name() + " is not pasable")
			return true
			
func is_PlayerTouch():
	for c in get_colliders():
		if c.get_name() != "Area2D_" and c.is_in_group("PlayerTouch"):
			print("true")
			return true
	print("false")		
	return false

func get_colliders():
	colliders = []
	#for r in result:
	print("dictioanry: " + str(result))
	if(!result.empty()):
		colliders.append(result.collider)
		if result.collider is GridMap:
#				print("GRIDMAP")
				var posit = result.collider.world_to_map(result.position)
				var tile_id = result.collider.get_cell_item(posit.x, posit.y, posit.z)
				var tile = result.collider.mesh_library.get_item_mesh(tile_id)
#				print(str(result.collider.mesh_library.get_item_name(tile_id)))
				#print(tile_id)
			#	var mi = result.collider.mesh_library.get_item_shapes(tile_id)
				print(tile.surface_get_material(0).get_script())
#				var properties = tile.get_property_list()
#				for i in range(properties.size()):
#					print(properties[i].name + ", type: " + str(properties[i].type))
	return colliders
	
func print_colliders():
	for c in colliders:
		print(c.get_name())

func interact():
	update()
	for c in get_colliders():
		print("INTERACT")
		if typeof(c) == TYPE_OBJECT and c.is_in_group("Interact"):
			if c.is_in_group("surf_area") and !body.surfing:
				body.surf()
			elif !c.is_in_group("surf_area"):
				c.eventTarget = self
				c.exec(facing_inverse[body.facing])

func interact_at_collide():
	if is_PlayerTouch() and isnot_Pasable() and body.can_interact:
		for c in get_colliders():
			print("INTERACT AT COLLIDE")
			print(c.get_name())
			if typeof(c) == TYPE_OBJECT and c.is_in_group("Evento") and !c.has_node("Boulder"):
				if !c.running and body.facing == body.get_direction():
					body.get_node("AnimationPlayer").stop()
					body.can_interact = c.current_page.Paralelo
					c.eventTarget = self
					c.exec()
					return true
					#EVENTS.add_event(dictionary.collider.get_parent(), self)
			elif typeof(c) == TYPE_OBJECT and c.is_in_group("ledge_area"):
				if c.direction == body.get_direction() and GLOBAL.is_last_move(body.get_direction()):
					body.jump(c.cells_jump)
					return true
			elif typeof(c) == TYPE_OBJECT and c.has_node("Boulder"):
					print("lmao")
					if body.facing == body.get_direction():
						print("BIMBA")
						body.push(c)
						return true
	return false
	
func collides_with(object):
	for c in colliders:
		if c == object:
			return true
	return false
	
func get_tile(name):
	if ! CONST.TILES.has(name):
		return CONST.TILES.get("unknown")
	else:
		return CONST.TILES.get(name)

func is_ledge():
	#for c in get_tiles_prop_byProp("Tipo"):
	if tile_result.collider is GridMap:
		return int(tile.tipo) == CONST.TILE_TYPE.LEDGE
	else:
		return false
#			return true
#	return false
#
func is_encounter_area():
	#for c in get_tiles_prop_byProp("Tipo"):#, intersect_tile(direction, 0)):
	if tile_result.collider is GridMap:
		if int(tile.tipo) == CONST.TILE_TYPE.ENCOUNTER:
			GAME_DATA.ACTUAL_MAP.calculate_encounter(int(tile.double))
			return true
		return false
	else:
		return false
#	func _physics_process(delta):# and !$MoveTween.is_active():
#		if is_colliding():
#			if(get_collider().is_in_group("Map_Area")):
#				if(get_collider().get_groups()[1] != ProjectSettings.get("Actual_Map").get_name()):
#					clear_exceptions()
#					add_exception(get_collider())
#
