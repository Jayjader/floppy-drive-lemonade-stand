extends Label

enum TimeOfDay {
	Morning,
	Evening
}

signal time_changed(new_time: TimeOfDay)

@export var time: TimeOfDay:
	set(data):
		time = data
		set_text(TimeOfDay.find_key(time))
		time_changed.emit(data)

func _ready():
	time = TimeOfDay.Morning
