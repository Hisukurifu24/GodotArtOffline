class_name DialogueBox
extends CanvasLayer

## Linee di dialogo
@export_file("*.json") var dialogPath

var currentDialog = null
var currentIndex: int = 0

@onready var textLabel: Label = $"Control/Content/Text"
@onready var answers: CanvasItem = $"Answers"
@onready var option1: Button = $"Answers/Option1"
@onready var option2: Button = $"Answers/Option2"
@onready var option3: Button = $"Answers/Option3"

# Called when the node enters the scene tree for the first time.
func _ready():
	loadDialogData()

	# Connect the pressed signal of the buttons to the corresponding functions
	option1.pressed.connect(_on_Option1_pressed)
	option2.pressed.connect(_on_Option2_pressed)
	option3.pressed.connect(_on_Option3_pressed)

	# Set the icon as the sprite of the NPC
	$"Control/TextureRect".texture = $"../Sprite2D".texture
	# Set the name of the NPC
	$"Control/Content/Name".text = currentDialog["Name"]
	# Set the first line of the dialog
	updateDialog()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		print("Accept")
		# Avanza il dialogo
		updateDialog()
		pass

func loadDialogData():
	var file = FileAccess.open(dialogPath, FileAccess.READ)
	currentDialog = JSON.parse_string(file.get_as_text())
	# print(currentDialog["Dialogs"][currentIndex]["Text"])

func updateDialog():
	print(currentIndex)
	# Se il dialogo è finito
	if currentIndex == - 1:
		visible = false
		currentIndex = 0
		return
	# Se il dialogo ha delle opzioni
	if currentDialog["Dialogs"][currentIndex].has("Options"):
		# mostra il testo
		textLabel.text = currentDialog["Dialogs"][currentIndex]["Text"]
		# mostra opzioni
		answers.visible = true

		# (default) mostra opzione 1 e nascondi le altre
		answers.get_node("Option1").visible = true
		answers.get_node("Option2").visible = false
		answers.get_node("Option3").visible = false

		# mostra testo dell'opzione 1
		answers.get_node("Option1/Label").text = currentDialog["Dialogs"][currentIndex]["Options"][0]["Text"]

		# se ci sono altre opzioni, mostrale
		if currentDialog["Dialogs"][currentIndex]["Options"].size() > 1:
			answers.get_node("Option2").visible = true
			answers.get_node("Option2/Label").text = currentDialog["Dialogs"][currentIndex]["Options"][1]["Text"]
		if currentDialog["Dialogs"][currentIndex]["Options"].size() > 2:
			answers.get_node("Option3").visible = true
			answers.get_node("Option3/Label").text = currentDialog["Dialogs"][currentIndex]["Options"][2]["Text"]
	else:
		answers.visible = false
		
		# mostra il testo
		textLabel.text = currentDialog["Dialogs"][currentIndex]["Text"]
		# muovi l'indice
		currentIndex = currentDialog["Dialogs"][currentIndex]["NextDialogId"] - 1

func _on_Option1_pressed():
	currentIndex = currentDialog["Dialogs"][currentIndex]["Options"][0]["NextDialogId"] - 1
	updateDialog()

func _on_Option2_pressed():
	currentIndex = currentDialog["Dialogs"][currentIndex]["Options"][1]["NextDialogId"] - 1
	updateDialog()

func _on_Option3_pressed():
	currentIndex = currentDialog["Dialogs"][currentIndex]["Options"][2]["NextDialogId"] - 1
	updateDialog()
