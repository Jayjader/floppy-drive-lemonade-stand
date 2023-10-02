extends Label

signal date_changed(day: int, month: String)
signal rent_needed

const MONTHS = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

@export var month: String:
	set(data):
		month = data
		_update_text()

@export var day: int:
	set(data):
		day = data
		_update_text()

@export var state_chart: StateChart

func _update_text():
	if day != null and month != null:
		set_text("%2d of %s" % [day, month])

func _ready():
	month = "September"
	day = 1


func __on_day_change_upkeeping_state_entered():
	if day == 30:
		rent_needed.emit()
	else:
		state_chart.send_event.call_deferred("new day started")


func __on_sleeping_state_exited():
	day += 1
	if day > 30:
		day -= 30
		month = MONTHS[(MONTHS.find(month) + 1) % 12]
	date_changed.emit(day, month)


func __on_rent_payment_attempted(success):
	state_chart.send_event.call_deferred("new day started" if success else "game over")
