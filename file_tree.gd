extends Tree

signal file_added_to_loadout(file: FileRs)

@onready var root: TreeItem = create_item()
var c_drive: TreeItem
var downloads: TreeItem
var downloads_file: FileRs

const HARD_DRIVE_CAPACITY = 20 * (2 ** 20) # 20 MiB
var space_left = HARD_DRIVE_CAPACITY

func reserve_for_download(request: int) -> int:
	var can_reserve = min(request, space_left)
	if can_reserve > 0:
		downloads_file.size += can_reserve
		downloads.set_visible(true)
		downloads.set_text(1, "%db" % downloads_file.size)
		_set_space_left(space_left - can_reserve)
	return can_reserve

func _set_space_left(value):
	space_left = value
	var occupied = HARD_DRIVE_CAPACITY - space_left
	if occupied == 0:
		c_drive.set_text(0, "C:// (empty)")
	elif occupied == HARD_DRIVE_CAPACITY:
		c_drive.set_text(0, "C:// (full)")
	else:
		c_drive.set_text(0, "C:// (%3d%% full)" % (occupied * 100 / HARD_DRIVE_CAPACITY))
	c_drive.set_text(1, "%db/%db" % [occupied, HARD_DRIVE_CAPACITY])
	if downloads_file != null:
		downloads.set_visible(downloads_file.size > 0)

func _ready():
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
	_set_space_left(HARD_DRIVE_CAPACITY)
	downloads_file = FileRs.new()
	downloads_file.name = "Space Reserved By Downloading Files"
	downloads_file.size = 0
	downloads = create_item(c_drive)
	downloads.set_metadata(0, downloads_file)
	downloads.set_text(0, downloads_file.name)
	downloads.set_text(1, "0b")
	downloads.set_text_alignment(1, HORIZONTAL_ALIGNMENT_RIGHT)
	downloads.set_selectable(0, false)
	downloads.set_selectable(1, false)
	downloads.set_visible(false)

func __on_file_downloaded(file):
	var item := create_item(c_drive)
	item.set_metadata(0, file)
	item.set_text(0, file.name)
	item.set_text(1, "%db" % file.size)
	item.set_text_alignment(1, HORIZONTAL_ALIGNMENT_RIGHT)
	downloads_file.size -= file.size
	_set_space_left(space_left)
	c_drive.set_text(1, "%db" % (HARD_DRIVE_CAPACITY - space_left))

func __on_delete_pressed():
	var tree_item: TreeItem = get_selected()
	var file: FileRs = tree_item.get_metadata(0)
	_set_space_left(space_left + file.size)
	tree_item.free()


func __on_add_to_loadout_pressed():
	var tree_item: TreeItem = get_selected()
	var file: FileRs = tree_item.get_metadata(0)
	file_added_to_loadout.emit(file)
