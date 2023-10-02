extends VBoxContainer


@export var torrents: Array[TorrentRs] = []

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

func _prepare_category(parent: TreeItem, name: String) -> TreeItem:
	var item = tree_view.create_item(parent)
	item.set_text(0, name)
	item.set_selectable(0, false)
	item.set_collapsed_recursive(true)
	return item

func _init_item(item: TreeItem, name: String, size: String, tags: String):
	item.set_text(0, name)
	item.set_text(1, size)
	item.set_text(2, tags)
	
func _insert_torrent(torrent: TorrentRs) -> void:
	var file_size = "%d B" % torrent.file.size
	var joined_tags = ", ".join(torrent.tags)
	var all_item = tree_view.create_item(all)
	_init_item(all_item, torrent.file.name, file_size, joined_tags)
	
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
	_init_item(tree_view.create_item(category), torrent.file.name, file_size, joined_tags)

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
	
	for t in torrents:
		_insert_torrent(t)
