extends Button

signal erase_floppies(count: int)

var to_erase: int = 0:
	set(data):
		to_erase = data
		disabled = to_erase < 1

func _ready():
	self.pressed.connect(func(): erase_floppies.emit(to_erase))

func __on_to_erase_count_changed(value: int):
	to_erase = value

