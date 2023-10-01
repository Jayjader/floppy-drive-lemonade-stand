extends Button

@export var state_chart: StateChart

func __on_time_of_day_changed(new_time):
	set_text("Go to %s" % ("Class" if new_time == 0 else "Sleep"))
	pressed.connect(state_chart.send_event.bind("go to class" if new_time == 0 else "go to sleep"), CONNECT_ONE_SHOT)
