extends Node

var map

var isBuilderMode = false
var cursorX = 0
var cursorY = 0
export(PackedScene) var cursor_prefab
export(PackedScene) var tile_prefab
var cursor = null
var playerNumber = '0'

func _ready():
    map = get_tree().get_root().get_node("World").get_node("Map") as Map
    playerNumber = (get_parent() as Player).playerNumber
    cursorX = map.worldCoordToTileCoord(get_parent().position.x)
    cursorY = map.worldCoordToTileCoord(get_parent().position.y)
    spawnStartPlatform()
    handleCursorExistance();

func _process(delta):
    processInput();

    
func handleCursorExistance():
    if (!cursor):
        cursor = cursor_prefab.instance()
        cursor.position.x = map.tileCoordToWorldCoord(cursorX);
        cursor.position.y = map.tileCoordToWorldCoord(cursorY);
        (map as Node).add_child(cursor)

func _input(event):
    if event is InputEventKey:
        print(event.as_text())

        
func processInput():
    var hasPositionChanged = false;
    if Input.is_action_just_pressed("cursor_right"+playerNumber):
        print("R")
        cursorX += 1
        hasPositionChanged = true;        
    elif Input.is_action_just_pressed("cursor_left"+playerNumber):
        print("L")
        cursorX -= 1
        hasPositionChanged = true;        
    elif Input.is_action_just_pressed("cursor_up"+playerNumber):
        print("U")
        cursorY -= 1
        hasPositionChanged = true;        
    elif Input.is_action_just_pressed("cursor_down"+playerNumber):
        print("D")
        cursorY += 1
        hasPositionChanged = true;
    elif Input.is_action_just_pressed("spawnBlock"+playerNumber):
        print("SPAWN")
        spawnAtCursor()
    if cursor:
        cursor.position.x = map.tileCoordToWorldCoord(cursorX);
        cursor.position.y = map.tileCoordToWorldCoord(cursorY);

func spawnAtCursor():
    if (map.world[cursorX][cursorY] != null):
        map.world[cursorX][cursorY].queue_free()
        map.world[cursorX][cursorY] = null
        
    var tile = tile_prefab.instance()
    tile.position.x = map.tileCoordToWorldCoord(cursorX);
    tile.position.y = map.tileCoordToWorldCoord(cursorY);
    (map as Node).add_child(tile)
    map.world[cursorX][cursorY] = tile
   
# Wiem że to nie powinno tu być, jebać
func spawnStartPlatform():
    var x = map.worldCoordToTileCoord(get_parent().position.x)
    var y = map.worldCoordToTileCoord(get_parent().position.y)
    
    map.world[x][y + 1] = map.default_tile.instance()
    map.world[x][y + 1].position.x = map.tileCoordToWorldCoord(x)
    map.world[x][y + 1].position.y = map.tileCoordToWorldCoord(y + 1)
    (map as Node).add_child(map.world[x][y + 1])
    
    map.world[x - 1][y + 1] = map.default_tile.instance()
    map.world[x - 1][y + 1].position.y = map.tileCoordToWorldCoord(y + 1)
    map.world[x - 1][y + 1].position.x = map.tileCoordToWorldCoord(x - 1)
    (map as Node).add_child(map.world[x - 1][y + 1])
    
    map.world[x + 1][y + 1] = map.default_tile.instance()
    map.world[x + 1][y + 1].position.x = map.tileCoordToWorldCoord(x + 1)
    map.world[x + 1][y + 1].position.y = map.tileCoordToWorldCoord(y + 1)
    (map as Node).add_child(map.world[x + 1][y + 1])
    