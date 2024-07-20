extends CanvasLayer

## Linee di dialogo
@export_file("*.json") var dialogPath

var currentDialog = null
var currentIndex: int = 0

@onready var textLabel: Label = $"Control/Control/Label"

# Called when the node enters the scene tree for the first time.
func _ready():
	loadDialogData()
	# Set the icon as the sprite of the NPC
	$"Control/TextureRect".texture = $"../Sprite2D".texture
	pass

	textLabel.text = currentDialog["Dialogs"][currentIndex]["Text"]

# func _input(event):
# 	if event.is_action_pressed("ui_accept"):
# 		print(str(lines.size()) + " - " + str(currentIndex))
# 		if currentIndex < lines.size() - 1:
# 			currentIndex += 1
# 			$"Control/Control/Label".text = lines[currentIndex]
# 		else:
# 			# chiudi label e fai cose
# 			pass

func loadDialogData():
	var file = FileAccess.open(dialogPath, FileAccess.READ)
	currentDialog = JSON.parse_string(file.get_as_text())
	# print(currentDialog["Dialogs"][currentIndex]["Text"])
