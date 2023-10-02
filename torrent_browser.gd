extends VBoxContainer
const MONTHS = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
signal torrent_enqueued(torrent: TorrentRs)

@export var torrents: Array[TorrentRs] = []

@onready var to_insert := torrents.slice(0)

@onready var tree_view: Tree = $Tree

var root: TreeItem
var all: TreeItem
var docs: TreeItem
var software: TreeItem
var text: TreeItem
var pdf: TreeItem
var image: TreeItem
var audio: TreeItem
var video: TreeItem
var other_docs: TreeItem
var tools: TreeItem
var games: TreeItem
var other_soft: TreeItem

func _prepare_category(parent: TreeItem, cat_name: String) -> TreeItem:
	var item = tree_view.create_item(parent)
	item.set_text(0, cat_name)
	item.set_selectable(0, false)
	item.set_collapsed_recursive(true)
	return item

func _init_item(item: TreeItem, torrent: TorrentRs, file_size: String, tags: String):
	item.set_text(0, torrent.file.name)
	item.set_text(1, file_size)
	item.set_text(2, tags)
	item.set_metadata(0, torrent)
	
func _insert_torrent(torrent: TorrentRs) -> void:
	var file_size = "%d B" % torrent.file.size
	var joined_tags = ", ".join(torrent.tags)
	var all_item = tree_view.create_item(all)
	_init_item(all_item, torrent, file_size, joined_tags)
	
	var category: TreeItem
	if TorrentRs.DOCUMENT in torrent.tags:
		if TorrentRs.TEXT in torrent.tags:
			category = text
		elif TorrentRs.PDF in torrent.tags:
			category = pdf
		elif TorrentRs.AUDIO in torrent.tags:
			category = audio
		elif TorrentRs.VIDEO in torrent.tags:
			category = video
		else:
			category = other_docs
	elif TorrentRs.SOFTWARE in torrent.tags:
		if TorrentRs.TOOL in torrent.tags:
			category = tools
		elif TorrentRs.GAME in torrent.tags:
			category = games
		else:
			category = other_soft
	_init_item(tree_view.create_item(category), torrent, file_size, joined_tags)

func _ready():
	root = tree_view.create_item()
	all = _prepare_category(root, "All")
	
	docs = _prepare_category(root, TorrentRs.DOCUMENT)
	text = _prepare_category(docs, TorrentRs.TEXT)
	pdf = _prepare_category(docs, TorrentRs.PDF)
	image = _prepare_category(docs, TorrentRs.IMAGE)
	audio = _prepare_category(docs, TorrentRs.AUDIO)
	video = _prepare_category(docs, TorrentRs.VIDEO)
	other_docs = _prepare_category(docs, "Others")
	
	software = _prepare_category(root, TorrentRs.SOFTWARE)
	tools = _prepare_category(software, TorrentRs.TOOL)
	games = _prepare_category(software, TorrentRs.GAME)
	other_soft = _prepare_category(other_soft, "Others")

var selected: TorrentRs
func __on_tree_item_selected():
	var item = tree_view.get_selected()
	selected = item.get_metadata(0) as TorrentRs

func __on_add_to_queue_pressed():
	torrent_enqueued.emit(selected)
	tree_view.deselect_all()

func _is_before(torrent, day, month) -> bool:
	if torrent.creation_month == month:
		return torrent.creation_day < day
	else:
		# to compare month indices, use (idx - 8) % 12 == (idx + 4) % 12	
		# -8 because we want september (9th month, so index 8 counting from 0) to be first
		# %12 to wrap around the indices for "earlier" months in the year to be "after" december
		var month_compare_index = (MONTHS.find(month) + 4) % 12
		var creation_compare_index = (MONTHS.find(torrent.creation_month) + 4) % 12
		return creation_compare_index < month_compare_index

func __on_today_date_changed(day, month):
	for torrent in to_insert:
		if _is_before(torrent, day, month):
			_insert_torrent(torrent)
			to_insert.erase(torrent)
