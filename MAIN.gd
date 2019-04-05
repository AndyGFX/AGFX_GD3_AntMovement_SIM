extends Node2D

var itemList;
var item_tmp = preload("res://Prefabs/ItemTemplate/RuleItem.tscn")
var rules_loop = []
var move_vector = Vector2(0,-1)

var ant_pos = Vector2(128,128)
var paint:Image
var render:bool = false;
var sim_step:int = 0

enum eDirection { TO_LEFT = -1, STOP = 0,TO_RIGHT=1 }
func _ready():
	
	self.itemList = $Panel/ScrollContainer/ItemList
	self.paint = Image.new()	
	self.paint.create(256,256,false,Image.FORMAT_RGBA8)
	
	$"Panel-control/Button-START".disabled = true
	$"Panel-control/Button-STOP".disabled = true
	
	self.ResetSim()
	
	pass
 
func _process(delta):
	if (self.render):
		self.SimStep()
		var itex = ImageTexture.new()    
		itex.create_from_image(self.paint,0)
		$Panel/AntArena.set_texture(itex)
	

	pass

func RenameItems():
	var id = 0
	for item in get_node("Panel-control/ScrollContainer/ItemList").get_children():
		item.name = "Item "+String(id)
		id=id+1

func TurnLeft():
	var tmp = self.move_vector.x
	self.move_vector.x = self.move_vector.y
	self.move_vector.y = -tmp
	

func TurnRight():
	var tmp = self.move_vector.x
	self.move_vector.x = -self.move_vector.y
	self.move_vector.y = tmp
	print(self.move_vector)
	
func _on_ButtonBUILD_pressed():
	
	self.RenameItems()
	
	self.rules_loop.clear()
	
	for id in range(0,get_node("Panel-control/ScrollContainer/ItemList").get_child_count()):
		var item = get_node("Panel-control/ScrollContainer/ItemList/Item "+String(id))
		var color = item.get_node("ColorPickerButton").get_pick_color()
		var direction = eDirection.STOP
		var dir_L = item.get_node("CheckBox-L").pressed
		var dir_R = item.get_node("CheckBox-R").pressed
		
		if (dir_L):
			direction = eDirection.TO_LEFT
		if (dir_R):
			direction = eDirection.TO_RIGHT
		
		var rule = {}
		rule["Name"] = item.get_name()
		rule["ID"] = id
		rule["Color"] = color
		rule["Direction"] = direction
		rules_loop.append(rule)
		print(rule)
		
	$"Panel-control/Button-START".disabled = false
	pass # Replace with function body.


func _on_ButtonSTART_pressed():
	self.ResetSim()
	self.render = true
	$"Panel-control/Button-START".disabled = true
	$"Panel-control/Button-STOP".disabled = false
	$"Panel-control/Button-BUILD".disabled = true
	$"Panel-control/Button-ADD".disabled = true
	pass # Replace with function body.

func _on_ButtonADD_pressed():
	var new_rule = item_tmp.instance()
	var new_itemName = "RuleItem "+String(get_node("Panel-control/ScrollContainer/ItemList").get_child_count()-1)
	new_rule.name = new_itemName
	get_node("Panel-control/ScrollContainer/ItemList").add_child(new_rule)	
	RenameItems()
	$"Panel-control/Button-START".disabled = true
	$"Panel-control/Button-STOP".disabled = true


func _on_ButtonSTOP_pressed():
	$"Panel-control/Button-START".disabled = false
	$"Panel-control/Button-STOP".disabled = true
	$"Panel-control/Button-BUILD".disabled = false
	$"Panel-control/Button-ADD".disabled = false
	self.render = false
	pass # Replace with function body.

func ResetSim():
	self.sim_step = 0
	self.ant_pos = Vector2(128,128)
	self.paint.lock()
	for x in range(256):
		for y in range(256):
			self.paint.set_pixel(x,y,Color(1,1,1,1))
	self.paint.unlock()
	pass

func GetRuleID(c):
	for rule in self.rules_loop:
		if rule["Color"]==c:
			return rule

func SimStep():
	
	if (ant_pos.x>0 and ant_pos.x<256 and ant_pos.y>0 and ant_pos.y<256): 
	
#		var idx = self.sim_step % self.rules_loop.size()
#		self.sim_step += 1	

		# get direction for current color
		var current_ant_pos = self.ant_pos
		var pixel_color = self.paint.get_pixel(current_ant_pos.x,current_ant_pos.y)
		var rule = self.GetRuleID(pixel_color)
		
		match rule["Direction"]:
			eDirection.TO_LEFT: self.TurnLeft()
			eDirection.TO_RIGHT: self.TurnRight()

		self.ant_pos = self.ant_pos + self.move_vector
		
		# get color to change current pixel position
		var idx = (rule["ID"]+1) % self.rules_loop.size()
		var new_color = self.rules_loop[idx]["Color"]
		
		self.paint.lock()
		self.paint.set_pixel(self.ant_pos.x,self.ant_pos.y,new_color)
		self.paint.unlock()
		
	else:
		
		self.render = false
		
	