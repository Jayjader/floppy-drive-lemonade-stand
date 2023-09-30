extends SpinBox

@onready var line_edit: LineEdit = get_line_edit()

# Called when the node enters the scene tree for the first time.
func _ready():
	line_edit.context_menu_enabled = false


func __on_written_count_changed(new_count: int):
	max_value = new_count
