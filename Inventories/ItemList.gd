extends Node

enum items {
	STONE,
	BRICK,
	IRON_ORE,
	MELTED_IRON,
	IRON_SHEET,
	ANTIMATTER,
	CARBON,
	CRUDE_OIL,
	GOLD_WIRE,
	MELTED_GOLD,
	GOLD_ORE,
	REFINED_OIL,
	STEEL_SHEET,
	HEATSINK
}

var item_data = {
	items.STONE: {
		"texture": preload("res://World/Tower/Item/stone.png"),
		"name": "Stone"
	},
	items.BRICK: {
		"texture": preload("res://World/Tower/Item/bricks.png"),
		"name": "Bricks"
	},
	items.IRON_ORE: {
		"texture": preload("res://World/Tower/Item/raw-iron.png"),
		"name": "Raw Iron"
	},
	items.MELTED_IRON: {
		"texture": preload("res://World/Tower/Item/molten-iron.png"),
		"name": "Pure Iron"
	},
	items.IRON_SHEET: {
		"texture": preload("res://World/Tower/Item/iron-sheet.png"),
		"name": "Iron Sheet"
	},
	items.ANTIMATTER: {
		"texture": preload("res://World/Tower/Item/antimatter.png"),
		"name": "Anti-matter"
	},
	items.CARBON: {
		"texture": preload("res://World/Tower/Item/carbon.png"),
		"name": "Carbon"
	},
	items.CRUDE_OIL: {
		"texture": preload("res://World/Tower/Item/crude-oil.png"),
		"name": "Crude Oil"
	},
	items.GOLD_WIRE: {
		"texture": preload("res://World/Tower/Item/gold-wire.png"),
		"name": "Gold Wire"
	},
	items.MELTED_GOLD: {
		"texture": preload("res://World/Tower/Item/molten-gold.png"),
		"name": "Pure Gold"
	},
	items.GOLD_ORE: {
		"texture": preload("res://World/Tower/Item/raw-gold.png"),
		"name": "Raw Gold"
	},
	items.REFINED_OIL: {
		"texture": preload("res://World/Tower/Item/refined-oil.png"),
		"name": "Refined Oil"
	},
	items.STEEL_SHEET: {
		"texture": preload("res://World/Tower/Item/steel-sheet.png"),
		"name": "Steel Sheet"
	},
	items.HEATSINK: {
		"texture": preload("res://World/Tower/Item/heatsink/heatsink.png"),
		"name": "Heatsink"
	},
}
