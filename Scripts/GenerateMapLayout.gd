extends Node2D

@export var floor_Scene: PackedScene
@export var gap_Scene: PackedScene
@export var wall_Scene: PackedScene
@export var Grave_Scene: PackedScene
@export var DebugPath_Scene: PackedScene

@export var LayoutFileName = "res://Maps/Layouts/Level_01.txt"
@export var GraveTextFileName = "res://Maps/Layouts/GraveWritings.txt"

var LevelArray : PackedStringArray
var GraveTextArray : PackedStringArray
var MapCellSize : int = 40
var astarGrid : AStarGrid2D
var GraveLocation : Vector2i
var CharacterStartLocation : Vector2i
var PathStartLoc : Vector2i

var CurrentGraveToFind

var EnablePathDebug : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_path()
	pass
	
func _on_draw():	
	if EnablePathDebug:		
		for x in LevelArray[0].length() + 1:
			draw_line(Vector2(x * MapCellSize, 0),
				Vector2(x * MapCellSize, LevelArray.size() * MapCellSize),
				Color.DARK_GRAY, 2.0)
			
		for y in LevelArray.size() + 1:
			draw_line(Vector2(0, y * MapCellSize),
				Vector2(LevelArray[0].length() * MapCellSize, y * MapCellSize),
				Color.DARK_GRAY, 2.0)
			
		draw_rect(Rect2(PathStartLoc * MapCellSize, Vector2(MapCellSize,MapCellSize)), Color.GREEN_YELLOW)
		draw_rect(Rect2(GraveLocation * MapCellSize, Vector2(MapCellSize,MapCellSize)), Color.ORANGE_RED)
	
	
		for x in LevelArray[0].length():
			for y in LevelArray.size():
				if astarGrid.is_point_solid(Vector2i(x,y)):
					var BlockedLoc = Vector2(x,y)
					draw_rect(Rect2(BlockedLoc * MapCellSize, Vector2(MapCellSize,MapCellSize)), Color.DARK_RED)
			
	pass # Replace with function body.

#=============================================
# Map Generation
#=============================================	

func InitMap(InLevel):
	LayoutFileName = InLevel
	load_file(LayoutFileName)
	InitAStarPath()
	ProcessData()

func load_file(file):

	# This is to load in the level data for the cell
	# =================================================
	if not FileAccess.file_exists(file):
		return # Error! We don't have a save to load.
		
	var LevelLayout = FileAccess.open(file, FileAccess.READ)
	var index = 1
	
	while not LevelLayout.eof_reached(): # iterate through all lines until the end of file is reached
		var line = LevelLayout.get_line()
		LevelArray.append(line)
		line += " "
		#print(line + str(index))
		index += 1
		
	LevelLayout.close()
	
	# This is to load in the grave texts
	# =================================================
	if not FileAccess.file_exists(GraveTextFileName):
		return # Error! We don't have a save to load.
		
	var GraveTexts = FileAccess.open(GraveTextFileName, FileAccess.READ)
	index = 1
	
	while not GraveTexts.eof_reached(): # iterate through all lines until the end of file is reached
		var line = GraveTexts.get_line()
		GraveTextArray.append(line)
		line += " "
		#print(line + str(index))
		index += 1
		
	GraveTexts.close()
	
	return

func ProcessData():
	
	var row_int : int = -1
	var Column_int : int = 0

	for row in LevelArray: 
		
		Column_int = 0
		row_int += 1
		
		for cell in row:		
			
			var CellPos_X = Column_int * MapCellSize
			var CellPos_Y = row_int * MapCellSize
				
			if cell == "-":
				astarGrid.set_point_solid(Vector2i(Column_int, row_int), true)				
				var gap_cell = gap_Scene.instantiate()
				gap_cell.set_position(Vector2i(CellPos_X, CellPos_Y))
				gap_cell.add_to_group("Gap")
				add_child(gap_cell)
			elif cell == " ":
				astarGrid.set_point_solid(Vector2i(Column_int, row_int), false)	
				var floor_cell = floor_Scene.instantiate()
				floor_cell.set_position(Vector2i(CellPos_X, CellPos_Y))
				floor_cell.add_to_group("Floor")
				add_child(floor_cell)
			elif cell == "/":
				astarGrid.set_point_solid(Vector2i(Column_int, row_int), true)
				var wall_cell = wall_Scene.instantiate()
				wall_cell.set_position(Vector2i(CellPos_X, CellPos_Y))
				wall_cell.add_to_group("Wall")
				add_child(wall_cell)
			elif cell == "n":
				astarGrid.set_point_solid(Vector2i(Column_int, row_int), false)	
				GraveLocation = Vector2i(CellPos_X, CellPos_Y)
				var Grave_cell = Grave_Scene.instantiate()
				Grave_cell.set_position(Vector2i(CellPos_X, CellPos_Y))
				Grave_cell.add_to_group("Graves")
				add_child(Grave_cell)
			elif cell == "o":
				CharacterStartLocation = Vector2i(CellPos_X, CellPos_Y)
				astarGrid.set_point_solid(Vector2i(Column_int, row_int), false)	
				var floor_cell = floor_Scene.instantiate()
				floor_cell.set_position(Vector2i(CellPos_X, CellPos_Y))
				floor_cell.add_to_group("PlayerSpawn")
				add_child(floor_cell)
				
			Column_int += 1

func UpdateAllGraveTexts():
	
	var desired_children = []
	desired_children = get_tree().get_nodes_in_group("Graves")
	
	var GraveName : String
	var GraveRiddle : PackedStringArray
	var GraveStone : String	
	
	var TextPartIndex = 1;
	var CurrentGraveText : int = 0
	var UsedGraves : String = ""
	
	for Child in desired_children:
		
		var GraveToUse : int = randi_range(0,6)
		
		while UsedGraves.contains(str(GraveToUse)):
			GraveToUse = randi_range(0,6)
		
		UsedGraves += str(GraveToUse)
		#print(UsedGraves)
		CurrentGraveText = 0
		TextPartIndex = 1
		GraveName = ""
		GraveRiddle.clear()
		GraveStone = ""
		
		var isFound : bool = false
	
		for line in GraveTextArray:
			
			if isFound:
				continue
			
			if line == ";":
				TextPartIndex += 1
				
				if TextPartIndex == 4:
									
					if CurrentGraveText == GraveToUse:
						Child.SetGraveWritting(GraveName, GraveRiddle.duplicate(), GraveStone)
						isFound = true
						continue
						
					TextPartIndex = 1
					GraveName = ""
					GraveRiddle.clear()
					GraveStone = ""
					CurrentGraveText += 1
				
			else:
				if TextPartIndex == 1:
					GraveName = line
				elif TextPartIndex == 2:
					GraveRiddle.append(line)
				else:
					GraveStone = line
				
	var FindGraveIndex : int = randi_range(0, (desired_children.size() - 1))
	CurrentGraveToFind = desired_children[FindGraveIndex]
	
	#for Child in desired_children:
		#print(Child.GraveName)
		#print(Child.GraveRiddle)
		#print(Child.GraveStone)

#=============================================
# A Star Pathing setup
#=============================================	

func InitAStarPath():	
	astarGrid = AStarGrid2D.new()
	astarGrid.region = Rect2i(0,0, LevelArray[0].length(), LevelArray.size())
	#astarGrid.size = Vector2i(LevelArray[0].length(), LevelArray.size())
	astarGrid.cell_size = Vector2i(MapCellSize, MapCellSize)
	astarGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astarGrid.set_default_compute_heuristic(AStarGrid2D.HEURISTIC_MANHATTAN)
	astarGrid.set_default_estimate_heuristic(AStarGrid2D.HEURISTIC_MANHATTAN)
	astarGrid.jumping_enabled = false
	astarGrid.update()

func GetMinimalPathAmount(StartLocation):
		PathStartLoc = StartLocation
		
		var desired_children = get_tree().get_nodes_in_group("Floor")
		return desired_children.size() / 4.0
		#return (astarGrid.size.x * astarGrid.size.y ) / 2.0
		
		var StartId : Vector2i = PathStartLoc / MapCellSize
		var endId : Vector2i = GraveLocation / MapCellSize
		var minimalPath = astarGrid.get_point_path(StartId, endId)
		
		if EnablePathDebug:
			#ddDebugPrintAStarPath(minimalPath)
			queue_redraw()
		
		return minimalPath.size()

func DebugPrintAStarPath(PathToFollow):
	
	for pathLocation in PathToFollow:
		var debug_cell = DebugPath_Scene.instantiate()
		debug_cell.set_position(pathLocation)
		add_child(debug_cell)

func update_path():
	
	if EnablePathDebug:
		var StartId : Vector2i = PathStartLoc / MapCellSize
		var endId : Vector2i = GraveLocation / MapCellSize
		$Line2D.points = PackedVector2Array(astarGrid.get_point_path(StartId, endId))
