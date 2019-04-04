extends Node2D

var itemList;
var item_tmp = preload("res://Prefabs/ItemTemplate/RuleItem.tscn")
func _ready():
	
	self.itemList = $Panel/ScrollContainer/ItemList
	
	pass
 
func _process(delta):
	pass


func _on_ButtonBUILD_pressed():
	pass # Replace with function body.


func _on_ButtonSTART_pressed():
	pass # Replace with function body.


func _on_ButtonADD_pressed():
	var new_rule = item_tmp.instance()
	get_node("Panel-control/ScrollContainer/ItemList").add_child(new_rule)
	pass # Replace with function body.


func _on_ButtonSTOP_pressed():
	pass # Replace with function body.
