extends Panel

var chk_L;
var chk_R;
var chk_U;
var chk_D;

func _ready():
	self.chk_L = get_node("CheckBox-L")
	self.chk_R = get_node("CheckBox-R")
	self.chk_U = get_node("CheckBox-U")
	self.chk_D = get_node("CheckBox-D")
	self.UncheckCheckbox()


func UncheckCheckbox():
	self.chk_D.pressed = false
	self.chk_U.pressed = false
	self.chk_L.pressed = false
	self.chk_R.pressed = false
	
	self.chk_D.modulate = Color.black
	self.chk_U.modulate = Color.black
	self.chk_L.modulate = Color.black
	self.chk_R.modulate = Color.black
	
	
func _on_Button_pressed():
	var items_count = get_parent().get_child_count()
	if items_count>2:
		queue_free()
	pass


func _on_CheckBoxL_pressed():
	self.UncheckCheckbox()
	self.chk_L.pressed = true
	self.chk_L.modulate = Color.white


func _on_CheckBoxR_pressed():
	self.UncheckCheckbox()
	self.chk_R.pressed = true
	self.chk_R.modulate = Color.white


func _on_CheckBoxU_pressed():
	self.UncheckCheckbox()
	self.chk_U.pressed = true
	self.chk_U.modulate = Color.white


func _on_CheckBoxD_pressed():
	self.UncheckCheckbox()
	self.chk_D.pressed = true
	self.chk_D.modulate = Color.white
