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


func __on_in_class_state_exited():
	time = TimeOfDay.Evening


func __on_sleeping_state_exited():
	time = TimeOfDay.Morning
