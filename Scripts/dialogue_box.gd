extends CanvasLayer

## Linee di dialogo
@export var dialog: Dialog

var currentIndex: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$"Control/TextureRect".texture = $"../Sprite2D".texture
	$"Control/Control/Label".text = lines[currentIndex]

func _input(event):
	if event.is_action_pressed("ui_accept"):
		print(str(lines.size()) + " - " + str(currentIndex))
		if currentIndex < lines.size() - 1:
			currentIndex += 1
			$"Control/Control/Label".text = lines[currentIndex]
		else:
			# chiudi label e fai cose
			pass
