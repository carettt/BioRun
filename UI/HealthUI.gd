extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts
var oxygen = 10 setget set_oxygen
var max_oxygen = 10 setget set_max_oxygen
var glucose = 0 setget set_glucose
var lipids = 0 setget set_lipids
var proteins = 0 setget set_proteins

onready var heartUIEmpty = $Hearts/HeartUIEmpty
onready var heartUIFull = $Hearts/HeartUIFull
onready var oxygenUIEmpty = $Oxygen/OxygenUIEmpty
onready var oxygenUIFull = $Oxygen/OxygenUIFull
onready var glucoseCount = $Food/Glucose/GlucoseCount
onready var lipidCount = $Food/Lipid/LipidCount
onready var proteinCount = $Food/Protein/ProteinCount

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heartUIFull != null:
		heartUIFull.rect_size.x = hearts * 15
	
func set_max_hearts(value):
	max_hearts = max(value, 1)
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = max_hearts * 15
		
func set_oxygen(value):
	oxygen = clamp(value, 0, max_oxygen)
	if oxygenUIFull != null:
		oxygenUIFull.rect_size.x = oxygen * 15
		
func set_max_oxygen(value):
	max_oxygen = max(value, 1)
	if oxygenUIEmpty != null:
		oxygenUIEmpty.rect_size.x = oxygen * 15
		
func set_glucose(value):
	glucose = max(value, 0)
	glucoseCount.text = ":" + str(glucose)
	
func set_lipids(value):
	lipids = max(value, 0)
	lipidCount.text = ":" + str(lipids)
	
func set_proteins(value):
	proteins = max(value, 0)
	proteinCount.text = ":" + str(proteins)
	
func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	self.max_oxygen = PlayerStats.max_oxygen
	self.oxygen = PlayerStats.max_oxygen
# warning-ignore:return_value_discarded
	PlayerStats.connect("health_changed", self, "set_hearts")
# warning-ignore:return_value_discarded
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")
# warning-ignore:return_value_discarded
	PlayerStats.connect("oxygen_changed", self, "set_oxygen")
# warning-ignore:return_value_discarded
	PlayerStats.connect("max_oxygen_changed", self, "set_max_oxygen")
# warning-ignore:return_value_discarded
	PlayerStats.connect("glucose_changed", self, "set_glucose")
# warning-ignore:return_value_discarded
	PlayerStats.connect("lipids_changed", self, "set_lipids")
# warning-ignore:return_value_discarded
	PlayerStats.connect("proteins_changed", self, "set_proteins")
