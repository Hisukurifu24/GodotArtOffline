extends CanvasLayer
class_name CombatGUI

@onready var startOptionsUI: Control = % "Start Options"
@onready var combatOptionsUI: Control = % "Combat Options"
@onready var dialogsUI: Control = % "Dialogs"

@onready var ability1Button: Button = %Ability1Button
@onready var ability2Button: Button = %Ability2Button
@onready var ability3Button: Button = %Ability3Button
@onready var ability4Button: Button = %Ability4Button

@onready var player: Character = get_tree().get_first_node_in_group("Player")


signal trying_to_run();
signal used_ability(int);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	showUI("startOptions")

	ability1Button.pressed.connect(_on_ability1_pressed)
	ability2Button.pressed.connect(_on_ability2_pressed)
	ability3Button.pressed.connect(_on_ability3_pressed)
	ability4Button.pressed.connect(_on_ability4_pressed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and combatOptionsUI.visible:
		showUI("startOptions")

func _update_button(button: Button, ability: Ability):
	button.text = ability.name
	button.get_node("../VBoxContainer/Descrizione").text = str(ability.description)
	button.get_node("../VBoxContainer/Costo").text = "MP: " + str(ability.manaCost)

func _update_abilities() -> void:
	for i in range(4):
		var ability: Ability = player.abilities[i]
		if ability != null:
			match i:
				0:
					_update_button(ability1Button, ability)
				1:
					_update_button(ability2Button, ability)
				2:
					_update_button(ability3Button, ability)
				3:
					_update_button(ability4Button, ability)

func showUI(ui_name: String) -> void:
	match ui_name:
		"startOptions":
			startOptionsUI.visible = true;
			combatOptionsUI.visible = false;
			dialogsUI.visible = false;
		"combatOptions":
			startOptionsUI.visible = false;
			combatOptionsUI.visible = true;
			dialogsUI.visible = false;
			_update_abilities()
		"dialogs":
			startOptionsUI.visible = false;
			combatOptionsUI.visible = false;
			dialogsUI.visible = true;
		_:
			startOptionsUI.visible = false;
			combatOptionsUI.visible = false;
			dialogsUI.visible = false;
			print("UI not found: ", ui_name)

func _on_fight_button_pressed() -> void:
	showUI("combatOptions")

func showText(text: String) -> void:
	showUI("dialogs")
	dialogsUI.get_node("Label").text = text


func _on_run_button_pressed() -> void:
	showUI("dialogs")
	trying_to_run.emit()

func _on_ability1_pressed() -> void:
	used_ability.emit(1)

func _on_ability2_pressed() -> void:
	used_ability.emit(2)

func _on_ability3_pressed() -> void:
	used_ability.emit(3)

func _on_ability4_pressed() -> void:
	used_ability.emit(4)
