extends Label

@export var count: int = 0:
	set(data):
		count = data
		set_text("x %s" % count)
