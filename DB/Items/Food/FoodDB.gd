extends Node

var placed_food = []
var placed_drinks = []
enum FoodType {
	DRINK, FOOD
}

class Food:
	var name # must match folder name
	var description: String
	var folder: String
	var image
	var type
	func _init(name, description, type):
		self.name = name
		self.description = description
		self.type = type
		self.folder = "res://GameObjects/Items/Food/" + name + "/"
		self.image = load(self.folder + name +".png")
		
	
	func create_instance() -> Node2D:
		var base_item: PackedScene = load("res://GameObjects/Items/BaseItem/BaseItem.tscn")
		var instance = base_item.instance().duplicate()
		instance.find_node("TextureRect").texture = self.image
		instance.set_info({
			"id": instance.name,
			"name": self.name,
			"description": self.description
		})
		if self.type == FoodType.DRINK:
			pass
		return instance
	
	func create_icon() -> TextureButton:
		var base_icon: PackedScene = load("res://GameObjects/Items/BaseIcon/BaseIcon.tscn")
		var icon = base_icon.instance().duplicate()
		icon.texture_normal = self.image
		return icon

func get_all_foods():
	return [Food.new("Waterbag", "A leatherbag filled with water", FoodType.DRINK), 
			Food.new("Apple", "A juicy apple", FoodType.FOOD)]

func get_registered_drinks():
	return placed_drinks

func get_registered_food():
	return placed_food

func register_placed_drink(drink_resource):
	placed_drinks.append(drink_resource)
	
func register_placed_food(food_resource):
	placed_food.append(food_resource)
