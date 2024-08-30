class_name DialogueBox
extends CanvasLayer

## Linee di dialogo
@export_file("*.json") var dialogPath

var currentDialog = null
var currentIndex: int = 0

@onready var textLabel: Label = %Text
@onready var answers: CanvasItem = $"Control/Answers"
@onready var panelButton: Button = $"Control/Button"
@onready var option1: Button = %Option1
@onready var option2: Button = %Option2
@onready var option3: Button = %Option3

# Called when the node enters the scene tree for the first time.
func _ready():
	loadDialogData()

	# Connect the pressed signal of the buttons to the corresponding functions
	option1.pressed.connect(_on_Option1_pressed)
	option2.pressed.connect(_on_Option2_pressed)
	option3.pressed.connect(_on_Option3_pressed)

	panelButton.pressed.connect(updateDialog)

	# Set the icon as the sprite of the NPC
	%Icon.texture = $"../Sprite2D".texture
	# Set the name of the NPC
	%Name.text = currentDialog["Name"]
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
	# Se il dialogo è finito
	if currentIndex == -1:
		visible = false
		currentIndex = 0
		return
	# Se il dialogo ha delle opzioni
	if currentDialog["Dialogs"][currentIndex].has("Options"):
		# mostra il testo
		textLabel.text = currentDialog["Dialogs"][currentIndex]["Text"]

		# Se l'opzione ha un CheckQuestID, controlla se la quest è stata completata
		# Nota: l'opzione 0 è sempre quella che controlla la quest
		if currentDialog["Dialogs"][currentIndex]["Options"][0].has("CheckQuestID"):
			var questID = currentDialog["Dialogs"][currentIndex]["Options"][0]["CheckQuestID"]
			# Se la quest non è stata consegnata, nascondi le opzioni
			if !Quest_Manager.is_completed(questID):
				answers.visible = false
				return
		# La quest è stata consegnata

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
	pressOption(0)

func _on_Option2_pressed():
	pressOption(1)

func _on_Option3_pressed():
	pressOption(2)

func pressOption(index: int):
	# Se l'opzione ha un QuestID, accetta la quest
	if currentDialog["Dialogs"][currentIndex]["Options"][index].has("StartQuestID"):
		Quest_Manager.accept_quest(currentDialog["Dialogs"][currentIndex]["Options"][index]["StartQuestID"])

	if currentDialog["Dialogs"][currentIndex]["Options"][index].has("DeliverQuestID"):
		Quest_Manager.deliver_quest(currentDialog["Dialogs"][currentIndex]["Options"][index]["DeliverQuestID"])

	# Se l'opzione ha un CloseDialog, chiudi il dialogo
	if currentDialog["Dialogs"][currentIndex]["Options"][index].has("CloseDialog"):
		visible = false

	# Muovi l'indice al prossimo dialogo
	currentIndex = currentDialog["Dialogs"][currentIndex]["Options"][index]["NextDialogId"] - 1

	# Aggiorna il dialogo
	updateDialog()
