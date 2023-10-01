extends Label

@export var month: String:
	set(data):
		month = data
		_update_text()

@export var day: int:
	set(data):
		day = data
		_update_text()

func _update_text():
	if day != null and month != null:
		set_text("%2d of %s" % [day, month])

func _ready():
	month = "September"
	day = 1
