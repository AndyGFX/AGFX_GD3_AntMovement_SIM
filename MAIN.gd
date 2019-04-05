extends Node2D

var itemList;
var item_tmp = preload("res://Prefabs/ItemTemplate/RuleItem.tscn")
var rules_loop = []
var move_vector = Vector2(0,-1)

var ant_pos = Vector2(128,128)
var paint:Image
var render:bool = false;
var sim_step:int = 0
var itex = ImageTexture.new()    

enum eDirection { TO_LEFT = -1, STOP = 0,TO_RIGHT=1 }
func _ready():
	
	self.itemList = get_node("Panel-control/ScrollContainer/ItemList")
	self.paint = Image.new()	
	self.paint.create(256,256,false,Image.FORMAT_RGBA8)
	
	get_node("Panel-control/ScrollContainer/ItemList/RuleItem 0/ColorPickerButton").color = Color.white
	get_node("Panel-control/ScrollContainer/ItemList/RuleItem 1/ColorPickerButton").color = Color.red

	get_node("Panel-control/ScrollContainer/ItemList/RuleItem 0/CheckBox-R").pressed = true
	get_node("Panel-control/ScrollContainer/ItemList/RuleItem 1/CheckBox-L").pressed = true
	
	$"Panel-control/Button-START".disabled = true
	$"Panel-control/Button-STOP".disabled = true
	$"Panel-control/Button-STEP".disabled = true
	
	
	self.ResetSim()
	self.UpdateTexture()
	
	pass
 
func _process(delta):
	if (self.render):
		
		self.UpdateTexture()
		self.SimStep()
	

	pass
func UpdateTexture():
	self.itex.create_from_image(self.paint,0)
	$Panel/AntArena.set_texture(itex)
		
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
	
	
func _on_ButtonBUILD_pressed():
	
	self.RenameItems()
	
	self.rules_loop.clear()
	
	for id in range(0,get_node("Panel-control/ScrollContainer/ItemList").get_child_count()):
		var item = get_node("Panel-control/ScrollContainer/ItemList/Item "+String(id))
		
		item.get_node("LabelUse").text = "0000000"
		
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
		rule["Call"] = 0
		rules_loop.append(rule)
		print(rule)
		
	$"Panel-control/Button-START".disabled = false
	$"Panel-control/Button-STEP".disabled = false
	
	self.ResetSim()
	
	pass # Replace with function body.


func _on_ButtonSTART_pressed():
	
	self.render = true
	$"Panel-control/Button-START".disabled = true
	$"Panel-control/Button-STOP".disabled = false
	$"Panel-control/Button-BUILD".disabled = true
	$"Panel-control/Button-ADD".disabled = true
	$"Panel-control/Button-STEP".disabled = true
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
	$"Panel-control/Button-STEP".disabled = false
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
		self.sim_step += 1	

		# get direction for current color
		var current_ant_pos = self.ant_pos
		self.paint.lock()
		var pixel_color = self.paint.get_pixel(current_ant_pos.x,current_ant_pos.y)
		self.paint.unlock()
		var rule = self.GetRuleID(pixel_color)
		rule["Call"] +=1
		get_node("Panel-control/ScrollContainer/ItemList/"+rule["Name"]+"/LabelUse").text = String(rule["Call"])
			
		match rule["Direction"]:
			eDirection.TO_LEFT: self.TurnLeft()
			eDirection.TO_RIGHT: self.TurnRight()

		self.ant_pos = self.ant_pos + self.move_vector
		
		# get new color to change current pixel position
		var idx = (rule["ID"]+1) % self.rules_loop.size()
		var new_color = self.rules_loop[idx]["Color"]
		
		# set new color on current ant position
		self.paint.lock()
		self.paint.set_pixel(current_ant_pos.x,current_ant_pos.y,new_color)
		self.paint.unlock()
		
	else:
		self.render = false
		
	

func _on_ButtonSTEP_pressed():
	self.UpdateTexture()
	self.SimStep()

func _on_ButtonP1_pressed():
	print("PPP")
	
	for id in range(2,8):
		var new_rule = item_tmp.instance()
		var new_itemName = "RuleItem "+String(get_node("Panel-control/ScrollContainer/ItemList").get_child_count()-1)
		new_rule.name = new_itemName
		get_node("Panel-control/ScrollContainer/ItemList").add_child(new_rule)	
	
	RenameItems()

	for id in range(0,get_node("Panel-control/ScrollContainer/ItemList").get_child_count()):
		var item = get_node("Panel-control/ScrollContainer/ItemList/Item "+String(id))
		
		item.get_node("LabelUse").text = "00"
		var color = 0.0625/8.0*float(id)
		item.get_node("ColorPickerButton").color = Color(color,color,color,1)
			
	pass # Replace with function body.
