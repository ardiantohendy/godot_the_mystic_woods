extends CanvasLayer

@onready var health_bar: ProgressBar = $HealthBar

#HEALTH PLAYER PROCESSING

func update_health(current_health: int):
	health_bar.value = current_health
