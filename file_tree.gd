extends Tree

@onready var root: TreeItem = create_item()
var c_drive: TreeItem

const HARD_DRIVE_CAPACITY = 20 * (2 ** 20) # 20 MiB
var space_left = HARD_DRIVE_CAPACITY

func _set_space_left(value):
	space_left = value
	c_drive.set_text(1, "%db" % (HARD_DRIVE_CAPACITY - space_left))

func _ready():
	space_left = HARD_DRIVE_CAPACITY
	set_column_title(0, "Name")
	set_column_title_alignment(0, HORIZONTAL_ALIGNMENT_LEFT)
	set_column_title(1, "Size")
	set_column_title_alignment(1, HORIZONTAL_ALIGNMENT_RIGHT)
	c_drive = create_item(root)
	c_drive.set_text(0, "C://")
	c_drive.set_text(1, "0b")
	c_drive.set_text_alignment(1, HORIZONTAL_ALIGNMENT_RIGHT)
	c_drive.set_selectable(0, false)
	c_drive.set_selectable(1, false)

	var test_file = FileRs.new()
	test_file.name = "foo.txt"
	test_file.size = 33*(2**10)
	__on_file_downloaded(test_file)
	var test_file2 = FileRs.new()
	test_file2.name = "bar.txt"
	test_file2.size = 11*(2**8)
	__on_file_downloaded(test_file2)
	var test_file3 = FileRs.new()
	test_file3.name = "warez.exe"
	test_file3.size = 64*(2**14)
	__on_file_downloaded(test_file3)

func __on_file_downloaded(file):
	var item := create_item(c_drive)
	item.set_metadata(0, file)
	item.set_text(0, file.name)
	item.set_text(1, "%db" % file.size)
	item.set_text_alignment(1, HORIZONTAL_ALIGNMENT_RIGHT)
	_set_space_left(space_left - file.size)
	c_drive.set_text(1, "%db" % (HARD_DRIVE_CAPACITY - space_left))

func __on_delete_pressed():
	var tree_item: TreeItem = get_selected()
	var file: FileRs = tree_item.get_metadata(0)
	_set_space_left(space_left + file.size)
	tree_item.free()
