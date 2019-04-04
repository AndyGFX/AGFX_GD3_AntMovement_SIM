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
	var new_itemName = "RuleItem "+String(get_node("Panel-control/ScrollContainer/ItemList").get_child_count()-1)
	new_rule.name = new_itemName
	get_node("Panel-control/ScrollContainer/ItemList").add_child(new_rule)
	
	var id = 0
	for item in get_node("Panel-control/ScrollContainer/ItemList").get_children():
		item.name = "Item "+String(id)
		id=id+1
		
	pass # Replace with function body.


func _on_ButtonSTOP_pressed():
	pass # Replace with function body.
