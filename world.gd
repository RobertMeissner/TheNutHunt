extends Node2D

@onready var glass_particle = %GlassParticle
@onready var nuts = %Nuts
@onready var party_fx = $PartyFX

func _ready() -> void:
	Events.can_search_swimming_googles.connect(_can_search_swimming_googles)
	Events.has_searched_swimming_googles.connect(_has_searched_swimming_googles)
	Events.can_make_party.connect(_can_make_party)
	Events.can_find_nuts.connect(_can_find_nuts)
	glass_particle.visible = false
	nuts.visible = false
	nuts.process_mode = Node.PROCESS_MODE_DISABLED
	party_fx.visible = false

func _can_search_swimming_googles() -> void:
	glass_particle.visible = true

func _has_searched_swimming_googles() -> void:
	glass_particle.visible = false

func _can_find_nuts() -> void:
	nuts.visible = true
	nuts.process_mode = Node.PROCESS_MODE_ALWAYS

func _can_make_party() -> void:
	party_fx.visible = true
	nuts.visible = false
	nuts.process_mode = Node.PROCESS_MODE_DISABLED
	
func get_start() -> Area2D:
	return %Start

func get_party() -> Area2D:
	return %Party
