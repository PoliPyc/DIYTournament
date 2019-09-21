extends Node

var map

var cursorPosition = Vector2(0,0)
export(PackedScene) var cursor_prefab
export(PackedScene) var tile_prefab
var cursor = null
var playerNumber = '0'

func _ready():
    map = get_tree().get_root().get_node("World").get_node("Map") as Map
    playerNumber = (get_parent() as Player).playerNumber
    cursorPosition = map.worldToTileCoordinate(get_parent().position)
    spawnStartPlatform()
    handleCursorExistance();

func _process(delta):
    processInput();
    
func handleCursorExistance():
    if (!cursor):
        cursor = cursor_prefab.instance()
        cursor.position = map.tileToWorldCoordinate(cursorPosition);
        (map as Node).add_child(cursor)

func processInput():
    var hasPositionChanged = false;
    if Input.is_action_just_pressed("cursor_right"+playerNumber):
        print("R")
        cursorPosition.x += 1
        hasPositionChanged = true;        
    elif Input.is_action_just_pressed("cursor_left"+playerNumber):
        print("L")
        cursorPosition.x -= 1
        hasPositionChanged = true;        
    elif Input.is_action_just_pressed("cursor_up"+playerNumber):
        print("U")
        cursorPosition.y -= 1
        hasPositionChanged = true;        
    elif Input.is_action_just_pressed("cursor_down"+playerNumber):
        print("D")
        cursorPosition.y += 1
        hasPositionChanged = true;
    elif Input.is_action_just_pressed("spawnBlock"+playerNumber):
        print("SPAWN")
        spawnAtCursor()
    if hasPositionChanged:
        cursorPosition.x = clamp(cursorPosition.x, 0, map.LEVEL_WIDTH)
        cursorPosition.y = clamp(cursorPosition.y, 0, map.LEVEL_HEIGHT)
        cursor.position = map.tileToWorldCoordinate(cursorPosition);

func spawnAtCursor():
    if (map.world[cursorPosition.x][cursorPosition.y] != null):
        return
        map.world[cursorPosition.x][cursorPosition.y].queue_free()
        map.world[cursorPosition.x][cursorPosition.y] = null
        
    var tile = tile_prefab.instance()
    tile.position = map.tileToWorldCoordinate(cursorPosition);
    (map as Node).add_child(tile)
    map.world[cursorPosition.x][cursorPosition.y] = tile
   
# Wiem że to nie powinno tu być, jebać
func spawnStartPlatform():
    var parentPosition = map.worldToTileCoordinate(get_parent().position)
    
    map.world[parentPosition.x][parentPosition.y + 1] = map.default_tile.instance()
    map.world[parentPosition.x][parentPosition.y + 1].position = map.tileToWorldCoordinate(parentPosition + Vector2(0,1))
    (map as Node).add_child(map.world[parentPosition.x][parentPosition.y + 1])
    
    map.world[parentPosition.x - 1][parentPosition.y + 1] = map.default_tile.instance()
    map.world[parentPosition.x - 1][parentPosition.y + 1].position = map.tileToWorldCoordinate(parentPosition + Vector2(-1,1))
    (map as Node).add_child(map.world[parentPosition.x - 1][parentPosition.y + 1])
    
    map.world[parentPosition.x + 1][parentPosition.y + 1] = map.default_tile.instance()
    map.world[parentPosition.x + 1][parentPosition.y + 1].position = map.tileToWorldCoordinate(parentPosition + Vector2(1,1))
    (map as Node).add_child(map.world[parentPosition.x + 1][parentPosition.y + 1])
    