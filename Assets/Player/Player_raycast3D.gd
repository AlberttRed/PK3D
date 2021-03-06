extends RayCast

onready var body = get_parent()
var direction
#var ray_direction
var result = []
var tile_result = []
var object_result = []
var colliders = []
var stairs = false
var stairs_direction# = Vector3(0, 0, 0)
var stairs_facing = ""
var pos
var Tile = load("res://Assets/Logics/tile.gd")
var tile
var tiles = []

#onready var ray_directions = {'RayCastRight': Vector3(3, -4, 0),
#			 'RayCastLeft': Vector3(-3, -4, 0),
#			 'RayCastUp': Vector3(0, -4, -3),
#			 'RayCastDown': Vector3(0, -4, 3)}

onready var ray_directions = {'RayCastRight': Vector3(1, 2, 0),
			 'RayCastLeft': Vector3(-1, 2, 0),
			 'RayCastUp': Vector3(0, 2, -1),
			 'RayCastDown': Vector3(0, 2, 1)}

onready var directions = {'RayCastRight': Vector3(CONST.GRID_SIZE, 0, 0),
			 'RayCastLeft': Vector3(-CONST.GRID_SIZE, 0, 0),
			 'RayCastUp': Vector3(0, 0, -CONST.GRID_SIZE),
			 'RayCastDown': Vector3(0, 0, CONST.GRID_SIZE)}
			
#Guardem el contrari del facing. Si el body interecciona miran cap adalt (up, = 12), li tornem l'invers, que seria cap avall (down, = 0)
#var facing_inverse = {'right': 12,
#				 'left': 4,
#				 'up': 8,
#				 'down': 0}

var facing_inverse = {'right': 4,
				 'left': 8,
				 'up': 0,
				 'down': 12}
#var facing_idle = {'right': 4,
#				 'left': 12,
#				 'up': 0,
#				 'down': 8}
			
			
# Called when the node enters the scene tree for the first time.
func _ready():
	direction = directions[get_name()]# Replace with function body.
#	ray_direction = ray_directions[get_name()]
# Actualitza l'intersact point per detectar si hi ha alguna colisió en la següent cel·la del mapa respecte a la posició actual del parent
func update(cells=1):
	result = 0
	if body.Through:
		result = null
	else:
		clear_exceptions()
		tile_result = intersect_tile_new(direction, cells)
		object_result = intersect_point_new(direction, cells)
		
		result = tile_result + object_result
		print("tile_result: " + str(tile_result))
		for t in tile_result:
			print("tile: " + str(t.get_name()))
		print("object_result: " + str(object_result))
		for o in object_result:
			print("object: " + str(o.get_name()))
		print("result: " + str(result))
		for r in result:
			print("r: " + str(r.get_name()))

func intersect_point(dir, cells=1):
	if weakref(GAME_DATA.ACTUAL_MAP).get_ref(): #Comprovem que l'Acual Map s'hagi actualitzat en el cas de canviar de mapa i aixi evitar que doni error
		
		#print(str(body.get_translation()+dir*cells))
#		print("from: " + str(body.get_translation() + Vector3(0,1,0)))
#		print("to: " + str(body.get_translation()  + Vector3(0,1,0) + (dir*cells)))
			
		return body.get_world().get_direct_space_state().intersect_ray(body.get_translation() + Vector3(0,0.5,0), body.get_translation()  + Vector3(0,0.5,0) + (dir*cells+(dir*cells/4)),[body.get_node("StaticBody")])#intersect_point(body.get_translation() + (dir*cells), CONST.GRID_SIZE, get_tree().get_root().get_node("World/CanvasModulate/MapArea_").get_children(), 2147483647, true, true)

func intersect_tile(dir, cells=1, ignore = []):
	if weakref(GAME_DATA.ACTUAL_MAP).get_ref(): #Comprovem que l'Acual Map s'hagi actualitzat en el cas de canviar de mapa i aixi evitar que doni error
		
		#print(str(body.get_translation()+dir*cells))
		
		#print(str(body.get_translation()+Vector3(0, 2, 0)))
		return body.get_world().get_direct_space_state().intersect_ray(body.get_translation() + Vector3(0, 4, 0) + dir*cells, body.get_translation() + Vector3(0, -4, 0) +dir*cells,[body.get_node("StaticBody")] + ignore)#body.get_translation(), body.get_translation() + (dir*cells) + pro)#intersect_point(body.get_translation() + (dir*cells), CONST.GRID_SIZE, get_tree().get_root().get_node("World/CanvasModulate/MapArea_").get_children(), 2147483647, true, true)

func intersect_point_new(dir, cells=1):
	if weakref(GAME_DATA.ACTUAL_MAP).get_ref(): #Comprovem que l'Acual Map s'hagi actualitzat en el cas de canviar de mapa i aixi evitar que doni error
		var objects = []
		var exclude = []
#		print("player translation: " + str(body.get_translation()))
#
#		print("raycast translation: " + str(translation))
#
#		print("cast to translation: " + str(cast_to))		
#
#		print("total raycast: " + str(body.get_translation() +  translation))
#
#		print("total cast to: " + str(body.get_translation() + translation + cast_to))		
#
#		print("old total raycast: " + str(body.get_translation() + Vector3(0,0.5,0)))
#
#		print("old total cast to: " + str(body.get_translation()  + Vector3(0,0.5,0) + (dir*cells+(dir*cells/4))))		
		var object = body.get_world().get_direct_space_state().intersect_ray(body.get_translation() +  translation, body.get_translation() + translation + cast_to, [body.get_node("StaticBody")])
		#var object = body.get_world().get_direct_space_state().intersect_ray(body.get_translation() + Vector3(0,0.5,0), body.get_translation()  + Vector3(0,0.5,0) + (dir*cells+(dir*cells/4)),[body.get_node("StaticBody")])#intersect_point(body.get_translation() + (dir*cells), CONST.GRID_SIZE, get_tree().get_root().get_node("World/CanvasModulate/MapArea_").get_children(), 2147483647, true, true)
#		print("object: " + str(object))
#		exclude.append(object.rid)
#		object = body.get_world().get_direct_space_state().intersect_ray(body.get_translation() +  translation, body.get_translation() + translation + cast_to, exclude)
#		print("object: " + str(object))
		
		while !object.empty() && object != null:
#			print("adding object: " + object.collider.get_name())
#			print("adding height: " + str(object.position))
			print(object.collider.get_name())
			if !object.collider.is_in_group("TILES") and !object.collider.is_in_group("Player"):
				if object.collider is StaticBody:
					objects.append(Collider.new(object.collider.get_parent(), object.position.y, "Object"))
				else:
					objects.append(Collider.new(object.collider, object.position.y, "Object"))
		
			exclude.append(object.rid)
			object = body.get_world().get_direct_space_state().intersect_ray(body.get_translation() +  translation, body.get_translation() + translation + cast_to, [body.get_node("StaticBody")] + exclude)
			#object = body.get_world().get_direct_space_state().intersect_ray(body.get_translation() + Vector3(0,0.5,0), body.get_translation()  + Vector3(0,0.5,0) + (dir*cells+(dir*cells/4)),[body.get_node("StaticBody")] + exclude)#intersect_point(body.get_translation() + (dir*cells), CONST.GRID_SIZE, get_tree().get_root().get_node("World/CanvasModulate/MapArea_").get_children(), 2147483647, true, true)
		

		return objects
			
		#return body.get_world().get_direct_space_state().intersect_ray(body.get_translation() + Vector3(0,0.5,0), body.get_translation()  + Vector3(0,0.5,0) + (dir*cells+(dir*cells/4)),[body.get_node("StaticBody")])#intersect_point(body.get_translation() + (dir*cells), CONST.GRID_SIZE, get_tree().get_root().get_node("World/CanvasModulate/MapArea_").get_children(), 2147483647, true, true)



func intersect_tile_new(dir, cells=1, ignore = []):
	
	if weakref(GAME_DATA.ACTUAL_MAP).get_ref(): #Comprovem que l'Acual Map s'hagi actualitzat en el cas de canviar de mapa i aixi evitar que doni error
		var objects = []
		tiles = []
		var rayshape = body.get_node(body.rayshapes[body.facing])

		var s = PhysicsShapeQueryParameters.new()
		s.set_shape(rayshape.shape)
		s.transform.origin = GAME_DATA.PLAYER.transform.origin + rayshape.transform.origin# + dir*cells
		s.transform.basis = rayshape.transform.basis

		var collisions = body.get_world().get_direct_space_state().intersect_shape(s, 1000)
		#print(collisions)

		for c in collisions:
			var point = get_collision_point()
			#print("col " + c.collider.get_name())
			if c.collider is GridMap and c.collider.is_in_group("TILES"):
				#print("translation: " + str(body.translation + direction*cells))
				
				var posit = c.collider.world_to_map(point)#body.translation + dir*cells)
				var id = c.collider.get_cell_item(posit.x, posit.y, posit.z)
				var tile_name = c.collider.mesh_library.get_item_name(id)
				tile = get_tile(tile_name)
				if tile.nombre == "unknown":
					print("EL TILE NO EXISTEIX A CONST.gd")
					objects.append(Collider.new(tile, point.y, "Tile"))
				else:
					tiles.append(tile)
				#print("adding object: " + str(tile.nombre))
				#print("adding height: " + str(point.y))
					objects.append(Collider.new(tile, point.y, "Tile"))
			else:
				pass
				#objects.append(Collider.new(c.collider.get_parent(), point.y, "Object"))
				#print(str(tile.nombre))
		return objects


func is_colliding():
	#print("SURF: " + str(is_SurfingArea()) + " " + str(body.get_surfing()))
#	if result == null or result.empty() or !isnot_Pasable() or (is_SurfingArea() and body.surfing):
#		print_colliders()
#		return false
#	else: 
#		print("COLLIDING")
#		print_colliders()
#		return true
	
	#print("tiles: " + str(tiles))
	if  is_stairs():#): tiles.empty() and
		return false
#		print("1")
	if  (is_SurfingArea() and !body.surfing):
			return true
	if is_ledge() and !body.jumping:
		return true
	if result == null or result.empty() or !isnot_Pasable():
		print_colliders()
		print("4")
		return false
	else:
		print("COLLIDING")
		print_colliders()
		return true
		
func is_SurfingArea():
	for t in tiles:
		if t.tipo == CONST.TILE_TYPE.SURF:
			return true
	return false
	
func isnot_Pasable():
	for c in get_colliders():
		if c.is_in_group("Pasable"):
			return false
		else:
			return true
			
func is_PlayerTouch():
	for c in get_colliders():
		if c.get_name() != "Area2D_" and c.is_in_group("PlayerTouch"):
			print("true")
			return true
	print("false")		
	return false
	
func get_colliders():
#	colliders = []
#	#for r in result:
#	if(!result.empty()):
#		colliders.append(result.collider)
#		if result.collider is GridMap:
#				var posit = result.collider.world_to_map(result.position)
#				var tile_id = result.collider.get_cell_item(posit.x, posit.y, posit.z)
#				var tile = result.collider.mesh_library.get_item_mesh(tile_id)
#				print(tile.surface_get_material(0).get_script())
	return object_result
	
func print_colliders():
	for c in colliders:
		print("collider: " + c.get_name())

#func interact():
#	update()
#	for c in get_colliders():
#		print("INTERACT")
#		print(c.get_name())
#		if typeof(c) == TYPE_OBJECT and c.is_in_group("Interact"):
#			if c.is_in_group("surf_area") and !body.surfing:
#				body.surf()
#			elif !c.is_in_group("surf_area"):
#				c.eventTarget = self
#				c.exec(facing_inverse[body.facing])

func interact():
	#update()
#	result = intersect_point(direction, 1)
#	intersect_tile(direction, 1)
	for c in get_colliders():
		if !c.object is GridMap:
			print("INTERACT " + c.object.get_parent().get_name())
			c = c.get_parent()
			if typeof(c) == TYPE_OBJECT and c.is_in_group("Interact"):
				#c.add_child(c.event_pages)
				if c.is_in_group("surf_area") and !body.surfing:
					body.surf()
				elif !c.is_in_group("surf_area"):
					c.eventTarget = self
					c.exec(facing_inverse[body.facing])
	print("tile: " + str(tile.tipo))
	if tile.tipo == CONST.TILE_TYPE.SURF and !body.surfing:
		print("INTERACT")
		body.surf()


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
	for t in tiles:
		if t.tipo == CONST.TILE_TYPE.LEDGE:
			return true
	return false
	#for c in get_tiles_prop_byProp("Tipo"):
#	if tile_result != null and tile_result.collider is GridMap:
#		return int(tile.tipo) == CONST.TILE_TYPE.LEDGE
#	else:
#		return false
#			return true
#	return false
#
func is_encounter_area():
	#for c in get_tiles_prop_byProp("Tipo"):#, intersect_tile(direction, 0)):
	if tile_result != null and tile_result.collider is GridMap:
		if int(tile.tipo) == CONST.TILE_TYPE.ENCOUNTER:
			GAME_DATA.ACTUAL_MAP.calculate_encounter(int(tile.double))
			return true
		return false
	else:
		return false
		
func is_stairs_old():
	
	var point_lol = body.get_node(get_name()).get_collision_point()
	print("lol jeje" + str(point_lol))
	
	var front_tiles = intersect_tile_new(direction, 1)
	var stairs_detected
	print("dictionary: " + str(result))
	print_colliders()
	body.get_node(get_name()).force_raycast_update()
	var col = body.get_node(get_name()).get_collider()
	var point = body.get_node(get_name()).get_collision_normal()
	print("col")
	if(!col == null):
		print(col.get_parent().get_name())
	print("point")
	print(point)
	print("player pos: " + str(GAME_DATA.PLAYER.translation.y))
	if !body.is_pre_movement():
		if(!col == null):
			#if col is GridMap:;
				if(point.y*-1 > GAME_DATA.PLAYER.translation.y):
					body.stairs_on(Vector3(0, 1, 0))
					GAME_DATA.PLAYER.up = stairs_direction
				print("object pos: " + str(point.y-1))
				print("player pos: " + str(GAME_DATA.PLAYER.translation.y))
				#body.stairs_on(Vector3(0, 1, 0))
				#GAME_DATA.PLAYER.up = stairs_direction
		else:
			for c in front_tiles:
				if c is GridMap:
					print("tile")
					print(tiles)
	return true
	
func proves():
	var tile_result = intersect_tile_new(direction, 1)

	var point_lol = get_collision_point()
	var object_lol = get_collider()
	#print(get_name() + " lol jeje " + str(point_lol))
	
	
	
	for r in result:
		print("object: " + str(r.get_name()))
		print("altura: " + str(r.y))
#
#	if object_lol != null:
#		print(get_name() + " lol jeje " + str(object_lol.get_name()))
	for c in tile_result:
			if c is GridMap:
				print(c.world_to_map(point_lol))
	body.get_node(get_name()).force_raycast_update()
	
func is_stairs():
	print("player position: " + str(GAME_DATA.PLAYER.translation.y))
	var stairs = null
	#Comprovem que només hi ha les escales, o que no hi ha cap objecte a sota o sobre que  bloquegi el pas.
	for c in result:
		if !c.is_in_group("Player"):
			print(c.get_name())
			if c.is_in_group("STAIRS") or GAME_DATA.PLAYER.on_stairs and int(c.y) != GAME_DATA.PLAYER.translation.y:
				stairs = c
			else:
				if !GAME_DATA.PLAYER.on_stairs && c.tipo != "Tile":
					return false
		if stairs != null:
			if !GAME_DATA.PLAYER.on_stairs:		
					print(str(int(stairs.y)) + " > " + str(GAME_DATA.PLAYER.translation.y))
					if(int(stairs.y) > GAME_DATA.PLAYER.translation.y):
						body.stairs_on(Vector3(0, 1, 0))
						GAME_DATA.PLAYER.up = stairs_direction
						GAME_DATA.PLAYER.on_stairs = true
					elif(int(stairs.y) < GAME_DATA.PLAYER.translation.y):
						body.stairs_on(Vector3(0, -1, 0))
						GAME_DATA.PLAYER.up = stairs_direction
						GAME_DATA.PLAYER.on_stairs = true
					return true
			else:
				
				print(str(int(stairs.y)) + " > " + str(GAME_DATA.PLAYER.translation.y))
				if(int(stairs.y) > GAME_DATA.PLAYER.translation.y):
					if stairs.is_in_group("STAIRS"):
						body.stairs_on(Vector3(0, 2, 0))
					else:
						body.stairs_on(Vector3(0, 1, 0))
					GAME_DATA.PLAYER.up = stairs_direction
				elif(int(stairs.y) < GAME_DATA.PLAYER.translation.y):
					if stairs.is_in_group("STAIRS"):
						body.stairs_on(Vector3(0, -2, 0))
					else:
						body.stairs_on(Vector3(0, -1, 0))
					GAME_DATA.PLAYER.up = stairs_direction
				if stairs.is_in_group("STAIRS"):
					GAME_DATA.PLAYER.on_stairs = true
					body.stairs_on(Vector3(0, 0, 0))
				else:
					GAME_DATA.PLAYER.on_stairs = false
					body.stairs_on(Vector3(0, 0, 0))
				return true
	return false

	
func is_cliff():
	var front_tiles = intersect_tile_new(direction, 1)
#	for c in front_tiles:
#				if c is GridMap:
#					#var posit = tile_result.collider.world_to_map(c.position)
#					var id = tile_result.collider.get_cell_item(c.translation.x, c.translation.y, c.translation.z)
#					var tile_name = tile_result.collider.mesh_library.get_item_name(id)
#					if c.get_name().substr(0, 5) == "cliff" and c.translation.y < GAME_DATA.PLAYER.translation.y:
#						return true
	return false
	#var under_is_stairs = under_tile.get_parent().get_name().substr(0, 6) == "stairs"
#	print("front: " + str(front_tile))
#	print("under: " + str(under_tile))
#	print("ignore: " + str(get_tree().get_nodes_in_group("GRID")))
#	if !front_tile.collider is Dictionary and front_tile.collider.get_parent().get_name().substr(0, 6) == "stairs":
#		if front_tile.collider.translation.y >= GAME_DATA.PLAYER.translation.y:
#			GAME_DATA.PLAYER.up = Vector3(0, 1, 0)
#		return true
	#elif !under_tile.collider is Dictionary and under_tile.get_parent().get_name().substr(0, 6) == "stairs":
		#return true


	
#	func _physics_process(delta):# and !$MoveTween.is_active():
#		if is_colliding():
#			if(get_collider().is_in_group("Map_Area")):
#				if(get_collider().get_groups()[1] != ProjectSettings.get("Actual_Map").get_name()):
#					clear_exceptions()
#					add_exception(get_collider())
#
 
class Collider:
	var object
	var y
	var tipo
	
	func _init(_object, _y, _tipo):
		self.object = _object
		self.y = _y
		self.tipo = _tipo
		
	func get_name():
		if tipo == "Tile":
			return object.nombre
		else:
			return object.get_name()
			
	func is_in_group(name):
		if tipo != "Tile":
			return object.is_in_group(name)
		else:
			return false
	
