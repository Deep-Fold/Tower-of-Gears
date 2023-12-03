extends Node

onready var item_list = get_node("/root/GlobalItemList")

enum pieces {
	EJECTOR,
	TRANSPORTER_STRAIGHT,
	TRANSPORTER_LEFT,
	TRANSPORTER_RIGHT,
	HEAT_SINK_HOLDER,
	HEAT_SINK_PRODUCER,
	IRON_PRESS,
	GOLD_PRESS,
	STEEL_PRESS,
	REACTOR,
	IRON_SMELTER,
	GOLD_SMELTER
	SPLITTER,
	JOINER,
	STONE_CUTTER,
	REFINER,
	CARBON_EXTRACTOR,
	STRUCTURE,
	SELECTIVE_STONE,
	SELECTIVE_IRON,
	SELECTIVE_OIL,
	SELECTIVE_GOLD
}

var piece_data = {}

func _ready():
	piece_data = {
		pieces.EJECTOR: {
			"scene": preload("res://World/Tower/Pieces/Ejector/Ejector.tscn"),
			"unlocked": true,
			"unlocks": 0,
			"cost": {},
			"name": "Ejector",
			"description": "Ejects items for collection."
		},
		pieces.STONE_CUTTER: {
			"scene": preload("res://World/Tower/Pieces/StoneCutter/StoneCutter.tscn"),
			"unlocked": true,
			"unlocks": 0, # what export phase this piece gets unlocked at
			"cost": {
				item_list.items.STONE: 5
			},
			"name": "Brick maker",
			"description": "Cuts stone into bricks."
		},
		pieces.TRANSPORTER_STRAIGHT: {
			"scene": preload("res://World/Tower/Pieces/Transporter/TransporterStraight.tscn"),
			"unlocked": true,
			"unlocks": 0,
			"cost": {
				item_list.items.STONE: 2
			},
			"name": "Transporter",
			"description": "Transports item."
		},
		pieces.TRANSPORTER_LEFT: {
			"scene": preload("res://World/Tower/Pieces/Transporter/TransporterCornerLeft.tscn"),
			"unlocked": true,
			"unlocks": 0,
			"cost": {
				item_list.items.STONE: 2
			},
			"name": "Corner Left",
			"description": "Transports item."
		},
		pieces.TRANSPORTER_RIGHT: {
			"scene": preload("res://World/Tower/Pieces/Transporter/TransporterCornerRight.tscn"),
			"unlocked": true,
			"unlocks": 0,
			"cost": {
				item_list.items.STONE: 2
			},
			"name": "Corner Right",
			"description": "Transports item."
		},
		pieces.SELECTIVE_STONE: {
			"scene": preload("res://World/Tower/Pieces/Selective/SelectiveStone.tscn"),
			"unlocked": true,
			"unlocks": 0,
			"cost": {
				item_list.items.STONE: 5,
			},
			"name": "Stone transporter",
			"description": "Only transports stone."
		},
		pieces.SPLITTER: {
			"scene": preload("res://World/Tower/Pieces/Splitter/Splitter.tscn"),
			"unlocked": true,
			"unlocks": 0,
			"cost": {
				item_list.items.STONE: 5,
				item_list.items.BRICK: 1,
			},
			"name": "Splitter",
			"description": "Splits item stream into 3."
		},
		pieces.JOINER: {
			"scene": preload("res://World/Tower/Pieces/Joiner/Joiner.tscn"),
			"unlocked": true,
			"unlocks": 0,
			"cost": {
				item_list.items.STONE: 5,
				item_list.items.BRICK: 1,
			},
			"name": "Joiner",
			"description": "Joins item streams into 1."
		},
		pieces.STRUCTURE: {
			"scene": preload("res://World/Tower/Pieces/Structure/Structure.tscn"),
			"unlocked": true,
			"unlocks": 0, # what export phase this piece gets unlocked at
			"cost": {
				item_list.items.STONE: 1
			},
			"name": "Structure",
			"description": "Structural, does nothing."
		},
		
		
		
		#### phase 1
		pieces.SELECTIVE_IRON: {
			"scene": preload("res://World/Tower/Pieces/Selective/SelectiveIron.tscn"),
			"unlocked": false,
			"unlocks": 1,
			"cost": {
				item_list.items.STONE: 5,
			},
			"name": "Iron Transporter",
			"description": "Only transports iron ore."
		},
		pieces.IRON_SMELTER: {
			"scene": preload("res://World/Tower/Pieces/Smelter/Smelter.tscn"),
			"unlocked": false,
			"unlocks": 1,
			"cost": {
				item_list.items.STONE: 5,
				item_list.items.BRICK: 3,
				item_list.items.IRON_ORE: 1,
			},
			"name": "Iron Smelter",
			"description": "Melts iron ore into pure iron."
		},
		pieces.IRON_PRESS: {
			"scene": preload("res://World/Tower/Pieces/MetalPress/IronPress.tscn"),
			"unlocked": false,
			"unlocks": 1,
			"cost": {
				item_list.items.MELTED_IRON: 3,
				item_list.items.BRICK: 1,
			},
			"name": "Iron Press",
			"description": "Presses pure iron into sheets."
		},
		pieces.HEAT_SINK_PRODUCER: {
			"scene": preload("res://World/Tower/Pieces/HeatSinkProducer/HeatSinkProducer.tscn"),
			"unlocked": false,
			"unlocks": 1,
			"cost": {
				item_list.items.IRON_SHEET: 5,
			},
			"name": "Heat Sink Producer",
			"description": "Creates heatsinks for free."
		},
		pieces.HEAT_SINK_HOLDER: {
			"scene": preload("res://World/Tower/Pieces/HeatSinkHolder/HeatsinkHolder.tscn"),
			"unlocked": false,
			"unlocks": 1,
			"cost": {
				item_list.items.BRICK: 1,
				item_list.items.IRON_SHEET: 1,
			},
			"name": "Heat Ejector",
			"description": "Holds heat sink and Ejects when hot."
		},
		
		#### phase 2:
		pieces.SELECTIVE_OIL: {
			"scene": preload("res://World/Tower/Pieces/Selective/SelectiveOil.tscn"),
			"unlocked": false,
			"unlocks": 2,
			"cost": {
				item_list.items.STONE: 5,
			},
			"name": "Oil Transporter",
			"description": "Only transports crude oil."
		},
		pieces.REFINER: {
			"scene": preload("res://World/Tower/Pieces/Refiner/Refiner.tscn"),
			"unlocked": false,
			"unlocks": 2,
			"cost": {
				item_list.items.IRON_SHEET: 4,
				item_list.items.MELTED_IRON: 8,
			},
			"name": "Refinery",
			"description": "Refines Crude oil into refined oil."
		},
		pieces.CARBON_EXTRACTOR: {
			"scene": preload("res://World/Tower/Pieces/CarbonExtractor/CarbonExtractor.tscn"),
			"unlocked": false,
			"unlocks": 2,
			"cost": {
				item_list.items.IRON_SHEET: 2,
				item_list.items.CRUDE_OIL: 10,
			},
			"name": "De-Carbonizer",
			"description": "Extracts carbon from refined oil."
		},
		pieces.STEEL_PRESS: {
			"scene": preload("res://World/Tower/Pieces/MetalPress/SteelPress.tscn"),
			"unlocked": false,
			"unlocks": 2,
			"cost": {
				item_list.items.REFINED_OIL: 5,
				item_list.items.CARBON: 5,
				item_list.items.IRON_SHEET: 5,
			},
			"name": "Steel Press",
			"description": "Makes steel sheets from iron sheets."
		},
		
		#### phase 4
		pieces.SELECTIVE_GOLD: {
			"scene": preload("res://World/Tower/Pieces/Selective/SelectiveGold.tscn"),
			"unlocked": false,
			"unlocks": 3,
			"cost": {
				item_list.items.STONE: 5,
			},
			"name": "Gold Transporter",
			"description": "Only transports gold ore."
		},
		pieces.GOLD_SMELTER: {
			"scene": preload("res://World/Tower/Pieces/Smelter/GoldSmelter.tscn"),
			"unlocked": false,
			"unlocks": 3,
			"cost": {
				item_list.items.BRICK: 5,
				item_list.items.STEEL_SHEET: 1,
				item_list.items.GOLD_ORE: 1,
			},
			"name": "Gold Smelter",
			"description": "Melts gold ore into pure gold."
		},
		pieces.GOLD_PRESS: {
			"scene": preload("res://World/Tower/Pieces/MetalPress/GoldPress.tscn"),
			"unlocked": false,
			"unlocks": 3,
			"cost": {
				item_list.items.BRICK: 10,
				item_list.items.STEEL_SHEET: 5,
				item_list.items.MELTED_GOLD: 2,
			},
			"name": "Gold Press",
			"description": "Makes gold wire from pure gold."
		},
		
		
		### phase 5
		pieces.REACTOR: {
			"scene": preload("res://World/Tower/Pieces/Reactor/Reactor.tscn"),
			"unlocked": false,
			"unlocks": 4,
			"cost": {
				item_list.items.BRICK: 30,
				item_list.items.STEEL_SHEET: 25,
				item_list.items.CARBON: 25,
				item_list.items.GOLD_WIRE: 20,
			},
			"name": "Reactor",
			"description": "Makes antimatter from gold wire"
		},
	}

func unlock_for_export_phase(phase):
	var keys = piece_data.keys()
	for k in keys:
		if piece_data[k].unlocks <= phase:
			piece_data[k].unlocked = true
