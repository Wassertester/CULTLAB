extends Node2D
@onready var checkpoint_1: Area2D = $checkpoint1
signal checkpoint_reached(Position: Vector2)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_checkpoint_1_body_entered(body: Node2D) -> void:
	checkpoint_reached.emit(Vector2 (checkpoint_1.position.x, checkpoint_1.position.y + 50))
