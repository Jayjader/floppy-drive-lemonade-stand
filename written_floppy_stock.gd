extends Label

signal written_count_changed(new_count: int)

@export var count: int = 0:
	set(data):
		count = data
		set_text("x %s" % count)
		written_count_changed.emit(count)
