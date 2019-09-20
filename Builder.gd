extends Node

var map

var isBuilderMode = false
var cursorX = 0
var cursorY = 0
export(PackedScene) var cursor_prefab
export(PackedScene) var tile_prefab
var cursor = null

func _ready():
    map = get_tree().get_root().get_node("World").get_node("Map") as Map
    cursorX = map.worldCoordToTileCoord(get_parent().position.x)
    cursorY = map.worldCoordToTileCoord(get_parent().position.y)
    spawnStartPlatform()

func _process(delta):
    processInput();
    handleCursorExistance();
    
func handleCursorExistance():
    if (cursor == null && isBuilderMode):
        cursor = cursor_prefab.instance()
        cursor.position.x = map.tileCoordToWorldCoord(cursorX);
        cursor.position.y = map.tileCoordToWorldCoord(cursorY);
        (map as Node).add_child(cursor)
    elif (cursor != null && !isBuilderMode):
        cursor.queue_free()
        cursor = null
    
func processInput():
    var hasPositionChanged = false;
    if Input.is_action_just_pressed("ui_focus_next"):
        isBuilderMode = !isBuilderMode;
    if (!isBuilderMode):
        return
        
    if Input.is_action_just_pressed("ui_right"):
        cursorX += 1
        hasPositionChanged = true;        
    elif Input.is_action_just_pressed("ui_left"):
        cursorX -= 1
        hasPositionChanged = true;        
    elif Input.is_action_just_pressed("ui_up"):
        cursorY -= 1
        hasPositionChanged = true;        
    elif Input.is_action_just_pressed("ui_down"):
        cursorY += 1
        hasPositionChanged = true;
    elif Input.is_action_just_pressed("ui_select"):
        spawnAtCursor()
        hasPositionChanged = true;
    if (hasPositionChanged):
        cursor.position.x = map.tileCoordToWorldCoord(cursorX);
        cursor.position.y = map.tileCoordToWorldCoord(cursorY);

func spawnAtCursor():
    print(map.world[cursorX][cursorY])
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
    