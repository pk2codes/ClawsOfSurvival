extends Navigation2D

func get_closest_item(items_to, position_from):
	var closest_path = null
	var closest_item = null
	for item in items_to:
		var path = get_simple_path(position_from, item.position, true)
		if closest_path == null:
			closest_path = path
			closest_item = item
		else:
			if path.size() < closest_path.size():
				closest_path = path
				closest_item = item
				
	return closest_item
