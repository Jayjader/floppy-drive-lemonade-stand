extends VBoxContainer


signal written_count_changed(new_count: int)
signal drives_erased(amount: int)
signal drives_sold(sales: Array[int])

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

var _random = RandomNumberGenerator.new()

const PRICE_PER_BYTE = 1.5e-5
func _cost_for_floppy(files: Array[FileRs]) -> int:
	return roundi(files.reduce(func(accum, next_file): return accum + next_file.size, 0) * PRICE_PER_BYTE)

func __on_in_class_state_entered():
	var potential_buyers = 50
	var sales: Array[int] = []
	for b in range(potential_buyers):
		if _random.randf() > 0.5:
			var purchase_size = _random.randi_range(1, 3)
			while purchase_size > 0 and len(written) > 0:
				var floppy = written.back()
				var left_over = floppy.count - purchase_size
				if left_over > 0:
					for _p in range(purchase_size):
						sales.append(_cost_for_floppy(floppy.layout))
					purchase_size = 0
					floppy.count = left_over
				else:
					for _p in range(floppy.count):
						sales.append(_cost_for_floppy(floppy.layout))
					purchase_size -= floppy.count
					written.erase(floppy)
	if len(sales) > 0:
		_update_count()
		drives_sold.emit(sales)
