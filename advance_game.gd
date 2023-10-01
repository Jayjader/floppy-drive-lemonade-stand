extends Button


func __on_time_of_day_changed(new_time):
	set_text("Go to %s" % ("Class" if new_time == 0 else "Sleep"))
