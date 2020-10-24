extends Node
#export(String, FILE, "*.tres") var animation
export(bool) var state = false
export(String) var Gvariable_name
var parentEvent = null
var parentPage = null
var i = 0
var count = false


func _init():
	add_user_signal("finished")
	
func _ready():
	add_to_group("CMD")

func _process(delta):
	print("process1 " + self.get_name())
	if count:
		i += 1

func run():
	#ProjectSettings.get("Player").can_interact = false
	print("set Gvariable started")
	if Gvariable_name != null:
		GLOBAL.get_node(Gvariable_name).state = state
		#GLOBAL.reload_events()
		print(GLOBAL.get_node(Gvariable_name).get_name() + " " + str(state))
	while i < 1:
		count = true
		yield(get_tree(), "idle_frame")
	count = false
	print("set Gvariable finished")
	parentPage.finished_command()
	emit_signal("finished")
