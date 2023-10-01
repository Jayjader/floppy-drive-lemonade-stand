extends VBoxContainer


signal written_count_changed(new_count: int)
signal drives_erased(amount: int)

# array of { count: int, layout: Array[FileRs] }
var written: Array[Dictionary] = []

func _update_count():
	var count = written.reduce(func(accum, next_floppy): return accum + next_floppy.count, 0)
	$"count/written count".set_text("x %s" % count)
	written_count_changed.emit(count)

func _ready():
	_update_count()

func __on_floppy_drives_written(amount: int, loadout: Array[FileRs]):
	written.append({count=amount, layout=loadout})
	_update_count()


func __on_erase_pressed(count: int):
	var to_erase := count
	while to_erase > 0:
		var floppy = written.back()
		var left_over = floppy.count - to_erase
		if left_over > 0:
			to_erase = 0
			floppy.count = left_over
		else:
			to_erase -= floppy.count
			written.erase(floppy)
	_update_count()
	drives_erased.emit(count)
