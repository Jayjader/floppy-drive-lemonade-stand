extends VBoxContainer

signal choice_made(volume: int)

# Called when the node enters the scene tree for the first time.
func _ready():
	get_child(0).get_button_group().pressed.connect(func(button): choice_made.emit(int(str(button.name))))

