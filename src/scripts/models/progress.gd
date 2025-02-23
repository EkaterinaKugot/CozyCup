# progress.gd
extends Resource

@export var day: int = 1
@export var duration_day: int = 10
@export var rating: float = 5
@export var money: int = 100
@export var diamonds: int = 30

@export var opened_ingredients: Array[Recipe] = []
@export var opened_recipes: Array[Ingredient] = []

@export var music: int = 7
@export var sounds: int = 7
