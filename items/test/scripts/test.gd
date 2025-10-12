extends Item

func on_equip():
	print("Item " + item_name + " successfully equipped!")

func on_unequip():
	print("Item " + item_name + " successfully unequipped!")
