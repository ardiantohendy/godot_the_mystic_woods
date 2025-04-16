extends CanvasLayer

@onready var health_bar: ProgressBar = $HealthBar
@onready var area_name: Label = $AreaName

#HEALTH PLAYER PROCESSING

func _on_ready() -> void:
	update_health(GameState.player_max_health ,GameState.player_health)
	update_current_area_name()
	
	
func update_health(max_health: int, current_health: int):
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = current_health
	else:
		print("❗ Health bar belum ditemukan!")

#FOR AREA NAME
func update_current_area_name():
	area_name.text = GameState.area_name
	
