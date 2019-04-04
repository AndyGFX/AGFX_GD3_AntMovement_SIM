extends Panel

var chk_L;
var chk_R;

func _ready():
	self.chk_L = get_node("CheckBox-L")
	self.chk_R = get_node("CheckBox-R")
	self.UncheckCheckbox()


func UncheckCheckbox():
	self.chk_L.pressed = false
	self.chk_R.pressed = false
	
	self.chk_L.modulate = Color.black
	self.chk_R.modulate = Color.black
	
	
func _on_Button_pressed():
	var items_count = get_parent().get_child_count()
	if items_count>2:
		queue_free()
		
	var id = 0
	for item in get_parent().get_children():
		print(item.name)
		item.name = "Item "+String(id)
		id=id+1
		
	pass


func _on_CheckBoxL_pressed():
	self.UncheckCheckbox()
	self.chk_L.pressed = true
	self.chk_L.modulate = Color.white


func _on_CheckBoxR_pressed():
	self.UncheckCheckbox()
	self.chk_R.pressed = true
	self.chk_R.modulate = Color.white

