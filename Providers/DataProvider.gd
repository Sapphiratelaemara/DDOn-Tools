extends Node

export (String, FILE, "*.json") var stage_map_json := "res://resources/StageMap.json"
export (String, FILE, "*.json") var stage_room_csv := "res://resources/StageRoom.csv"
export (String, FILE, "*.json") var stage_list_json := "res://resources/StageList.json"
export (String, FILE, "*.json") var repo_json := "res://resources/repo.json"
export (String, FILE, "*.json") var gathering_spots_json := "res://resources/gatheringSpots.json"

var stage_map: Array
var stage_room: Dictionary
var stage_list: Array
var repo: Dictionary
var gathering_spots: Dictionary

func _ready():
	stage_map = Common.load_json_file(stage_map_json)
	stage_list = Common.load_json_file(stage_list_json)
	repo = Common.load_json_file(repo_json)
	gathering_spots = Common.load_json_file(gathering_spots_json)

	stage_room = {}
	var file := File.new()
	file.open(stage_room_csv, File.READ)
	file.get_csv_line() # Ignore header line
	while !file.eof_reached():
		var csv_line := file.get_csv_line()
		if csv_line.size() >= 2:
			stage_room[int(csv_line[0])] = RoomMap.new(csv_line[1], Vector2(float(csv_line[2]), float(csv_line[3])))
	file.close()

func stage_no_to_stage_map(stage_no: int) -> Dictionary:
	for stage in stage_map:
		if stage["StageNo"] == stage_no:
			return stage
			
	push_warning("No stage map found for StageNo %s" % stage_no)
	return {}

func stage_no_to_stage_room(stage_no: int) -> RoomMap:
	return stage_room.get(stage_no)

func stage_no_to_stage_id(stage_no: int) -> int:
	for stage in stage_list:
		if stage["StageNo"] == stage_no:
			return stage["ID"]
			
	push_warning("No stage found with StageNo %s" % stage_no)
	return -1

## Returns -1 if it doesn't belong to a field
func stage_no_to_belonging_field_id(stage_no: int) -> int:
	for field_area_info in repo["FieldAreaList"]["FieldAreaInfos"]:
		if field_area_info["StageNoList"].has(float(stage_no)):
			return int(field_area_info["FieldAreaId"])
	return -1
