class_name DialogLine
extends Resource

enum DialogLineType {
    SPEECH,
    CHOICE,
    QUEST,
}

@export var type: DialogLineType = DialogLineType.SPEECH
@export_multiline var name: String = ""
@export_multiline var text: String = ""