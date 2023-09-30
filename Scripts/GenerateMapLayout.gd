extends Node2D

@export var floor_Scene: PackedScene
@export var gap_Scene: PackedScene
@export var wall_Scene: PackedScene

@export var LayoutFileName = "res://Maps/Layouts/Level_01.txt"

var LevelArray : PackedStringArray
var MapCellSize : int = 40

# Called when the node enters the scene tree for the first time.
func _ready():
	load_file(LayoutFileName)
	ProcessData()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func load_file(file):
	if not FileAccess.file_exists(file):
		return # Error! We don't have a save to load.
		
	var LevelLayout = FileAccess.open(file, FileAccess.READ)
	var index = 1
	
	while not LevelLayout.eof_reached(): # iterate through all lines until the end of file is reached
		var line = LevelLayout.get_line()
		line += " "
		print(line + str(index))
		LevelArray.append(line)
		index += 1
		
	LevelLayout.close()
	return

func ProcessData():
	
	var row_int : int = -1

	for row in LevelArray: 
		
		var Column_int : int = 0
		row_int += 1
		
		for cell in row:		
			
			var CellPos_X = Column_int * MapCellSize
			var CellPos_Y = row_int * MapCellSize
				
			if cell == "-":
				var gap_cell = gap_Scene.instantiate()
				gap_cell.set_position(Vector2(CellPos_X, CellPos_Y))
				add_child(gap_cell)
			elif cell == " ":
				var floor_cell = floor_Scene.instantiate()
				floor_cell.set_position(Vector2(CellPos_X, CellPos_Y))
				add_child(floor_cell)
			elif cell == "/":
				var wall_cell = wall_Scene.instantiate()
				wall_cell.set_position(Vector2(CellPos_X, CellPos_Y))
				add_child(wall_cell)
				
			Column_int += 1
