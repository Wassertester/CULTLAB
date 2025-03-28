extends Area2D
var in_dessert: bool = false
@onready var timer: Timer = $Timer
@onready var player: CharacterBody2D = $".."

func _process(delta: float) -> void:
	#print(player.modulate.s)
	if in_dessert:
		player.modulate.s += delta / 22
	elif player.modulate.s < 0.01:
		player.modulate.s = 0
	else:
		player.modulate.s -= delta

func _on_area_entered(area: Area2D) -> void:
	if area.name == "dessert":
		wüste(true)
	else:
		wüste(false)
		
func _on_area_exited(area: Area2D) -> void:
	if area.name == "dessert":
		wüste(false)
	else:
		wüste(true)
		
func _on_timer_timeout() -> void:
	while timer.is_stopped() and in_dessert:
		player.take_damage(1)
		await get_tree().create_timer(3.0).timeout
		
func wüste(hot: bool):
	#print(hot)
	in_dessert = hot
	if hot and timer.is_stopped():
		timer.start()
	else:
		timer.stop()

# ich habe in der tile map dem wasser collision auf layer 6 gegeben. 
# die tilemap wird als bosy erkannt, deswegen die extra Signale, die immer Wasser sind
func _on_body_entered(body: Node2D) -> void:
	wüste(false)
func _on_body_exited(body: Node2D) -> void:
	wüste(true)
