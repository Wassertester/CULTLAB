extends Area2D
@onready var body: CharacterBody2D = $CharacterBody2D
@onready var player: Node2D = $"../player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_body_entered(body: Node2D) -> void:
	player.position.x = -800
	player.position.y = 2
	body.stop()
	print ("teleport")  # Replace with function body.
	
