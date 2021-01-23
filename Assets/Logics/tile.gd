extends SpatialMaterial

var id = null
var nombre = ""
var tipo = 0

var double = false
var MySpriteClass = get_script()
var m = load("res://Assets/Logics/tile.gd")

func get_tipo():
	return tipo

func _init(dict = null):
#	if(!result.empty()):
#		if result.collider is GridMap:
#				var posit = result.collider.world_to_map(result.position)
#				self.id = result.collider.get_cell_item(posit.x, posit.y, posit.z)
				if dict != null:
						
						for i in dict:
							var variable = self.get(str(i))
							if variable != null:
								print(str(i) + ": " + str(dict.get(i)))
								self.set(str(i), dict.get(i))
							else:
								print("La variable '" + str(i) + "' no existeix!!!!!!!!")
				
#					var tile = result.collider.mesh_library.get_item_mesh(id)
#					self.name = result.collider.mesh_library.get_item_name(id)
#
#					#var a = tile.surface_get_material(0) extends MySpriteClass
#					print(tile.surface_get_name(0))
#					print(tile.surface_get_material(0))
#					if tile.surface_get_material(0).get_script() == m:	
#						self.tipo = tile.surface_get_material(0).tipo
				#print(str(result.collider.mesh_library.get_item_name(tile_id)))
				
				
# Called when the node enters the scene tree for the first time.


func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
