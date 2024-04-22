extends GenericPlacemark
class_name EnemyPlacemark

const COLOR_BLOOD_ORB = Color.rebeccapurple
const COLOR_HIGH_ORB = Color.darkred
const COLOR_DEFAULT = Color.white

export (Resource) var enemy: Resource setget set_enemy

onready var _detailsPanel: DetailsPanel = DetailsPanel.get_instance(get_tree())

func _ready():
	# Connect to the custom signal emitted by SetProvider
	var set_provider = get_node("../../../../../../SetProvider")
	if set_provider:
		set_provider.connect("day_night_selected", self, "_on_day_night_selected")

func _on_day_night_selected(index):
	var timeType = index
	if enemy != null:
		_update_placemark_visibility(timeType)

func _update_placemark_visibility(timeType):
	if enemy != null:
		var enemyTimeType = enemy.time_type
		if timeType == 0 or enemyTimeType == 0 or enemyTimeType == timeType:
			show()
		else:
			hide()

func _on_EnemyPlacemark_pressed():
	# Left Click
	_detailsPanel.show_details_of(enemy)
	
func set_enemy(em: Enemy) -> void:
	if enemy != null and enemy.is_connected("changed", self, "_on_enemy_changed"):
		enemy.disconnect("changed", self, "_on_enemy_changed")
		
	enemy = em
		
	if em != null:
		em.connect("changed", self, "_on_enemy_changed")
		_on_enemy_changed()
	
	if enemy != null and enemy.has_method("_time_type"):
		var time_type = enemy.get_time_type()
		print("testing")
	
func _on_enemy_changed():
	text = enemy.get_display_name()
	
	if enemy.is_blood_enemy:
		modulate = COLOR_BLOOD_ORB
	elif enemy.is_highorb_enemy:
		modulate = COLOR_HIGH_ORB
	else: 
		modulate = COLOR_DEFAULT
