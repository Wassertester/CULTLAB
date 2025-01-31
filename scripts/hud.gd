extends CanvasLayer
@onready var player: CharacterBody2D = $"../../player_script"
@onready var spr_HUD: Sprite2D = $Control/Sprite2D
@onready var spr_treffer_featback: Sprite2D = $"../heart"
var textures = ["res://sprites/heart/heart 05.png",
 				"res://sprites/heart/heart 04.png",
 				"res://sprites/heart/heart 02.png",
 				"res://sprites/heart/heart 00.png"]

func _ready() -> void:
	pass 

# just for testing!!!
"""func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		player.take_damage(1)"""

# if statements sind slow, deswegen hab ich hier was kreatives versucht
func _process(delta: float) -> void:
	spr_treffer_featback.modulate.a *= 0.3 / (delta + 0.3)
	spr_treffer_featback.modulate.a -= delta * 0.1

# signal das von player_script emitted wird
func _on_player_script_update_hud(health) -> void:
	spr_HUD.texture = load(textures[health])
	spr_treffer_featback.texture = load(textures[health])
	spr_treffer_featback.position = player.position + Vector2(0, -88)
	spr_treffer_featback.modulate.a = 1
