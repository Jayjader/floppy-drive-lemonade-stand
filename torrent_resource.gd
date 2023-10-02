class_name TorrentRs
extends Resource

@export var file: FileRs
@export var creation_day: int
@export var creation_month: StringName
@export var tags: Array[StringName]

const DOCUMENT = &"DOCUMENT"
const SOFTWARE = &"SOFTWARE"
const TEXT = &"TEXT"
const PDF = &"PDF"
const IMAGE = &"IMAGE"
const AUDIO = &"AUDIO"
const VIDEO = &"VIDEO"
const TOOL = &"TOOL"
const GAME = &"GAME"
