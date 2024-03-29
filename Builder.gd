extends Node

var map

var cursorOffset = Vector2(0,0)
var basePosition = Vector2(0,0)
var cursorPosition = Vector2(0,0)
export(PackedScene) var cursor_prefab
export(Array, PackedScene) var tile_prefabs
var cursor = null
var playerNumber = '0'
var currentTileNumber = 0;
var canSpawnTile = true;

func _ready():
    print(get_tree().get_root());
    map = get_parent().get_parent().get_node("Map") as Map
    playerNumber = (get_parent() as Player).playerNumber
    basePosition = map.worldToTileCoordinate(get_parent().position)
    spawnStartPlatform();
    spawnDebugFlags();
    handleCursorExistance();
    refreshCursorSprite();
    
func _process(delta):
    basePosition = get_parent().position
    processInput();
    
func handleCursorExistance():
    if (!cursor):
        cursor = cursor_prefab.instance()
        cursor.position = map.tileToWorldCoordinate(cursorPosition);
        (map as Node).add_child(cursor)

func processInput():
    var hasPositionChanged = false;
    if Input.is_action_just_pressed("cursor_right"+playerNumber):
        cursorOffset.x += 1
        hasPositionChanged = true;        
    elif Input.is_action_just_pressed("cursor_left"+playerNumber):
        cursorOffset.x -= 1
        hasPositionChanged = true;        
    elif Input.is_action_just_pressed("cursor_up"+playerNumber):
        cursorOffset.y -= 1
        hasPositionChanged = true;        
    elif Input.is_action_just_pressed("cursor_down"+playerNumber):
        cursorOffset.y += 1
        hasPositionChanged = true;
    cursorOffset.y = clamp(cursorOffset.y, -2, 2)
    cursorOffset.x = clamp(cursorOffset.x, -2 ,2)
    if Input.is_action_just_pressed("spawnBlock"+playerNumber):
        print("SPAWN")
        spawnAtCursor()
    elif Input.is_action_just_pressed("next_block"+playerNumber):
        currentTileNumber += 1
        if (currentTileNumber >= len(tile_prefabs)):
            currentTileNumber = 0;
        if (cursor):
            refreshCursorSprite();
    elif Input.is_action_just_pressed("previous_block"+playerNumber):
        currentTileNumber -= 1
        if (currentTileNumber < 0):
            currentTileNumber = len(tile_prefabs) - 1;
        if (cursor):
            refreshCursorSprite();
    cursorPosition = cursorOffset+map.worldToTileCoordinate(basePosition+Vector2(16,16))
    #if hasPositionChanged:
    cursorPosition.x = clamp(cursorPosition.x, 0, map.LEVEL_WIDTH)
    cursorPosition.y = clamp(cursorPosition.y, 0, map.LEVEL_HEIGHT)
    cursor.position = map.tileToWorldCoordinate(cursorPosition);
    refreshCursorSprite();

func refreshCursorSprite():
    # hack na wyciągnięcie tekstury z zapakowanej sceny, jebać godota
    var temp = tile_prefabs[currentTileNumber].instance()
    cursor.get_node('Sprite').set_texture(temp.get_node('Sprite').texture);
    cursor.get_node('Sprite').set_vframes(temp.get_node('Sprite').get_vframes());
    cursor.get_node('Sprite').set_hframes(temp.get_node('Sprite').get_hframes());
    
    if (temp.has_method("validatePosition")):
        canSpawnTile = temp.validatePosition(cursorPosition, map);
    else:
        canSpawnTile = true;
    if (canSpawnTile):
        cursor.get_node('Sprite').modulate = Color(1, 1, 1, 0.25);
    else:
        cursor.get_node('Sprite').modulate = Color(1, 0, 0, 0.25);
        
    temp.queue_free();

func spawnAtCursor():
    if (!canSpawnTile):
        return;
    if (map.world[cursorPosition.x][cursorPosition.y] != null):
        map.world[cursorPosition.x][cursorPosition.y].queue_free()
        map.world[cursorPosition.x][cursorPosition.y] = null
        
    var tile = tile_prefabs[currentTileNumber].instance()
    tile.position = map.tileToWorldCoordinate(cursorPosition);
    (map as Node).add_child(tile)
    map.world[cursorPosition.x][cursorPosition.y] = tile
    if (tile.has_method("setPlayerNumber")):
        tile.setPlayerNumber(playerNumber);

# Wiem że to nie powinno tu być, jebać
func spawnStartPlatform():
    var parentPosition = map.worldToTileCoordinate(get_parent().position)
    
    map.world[parentPosition.x][parentPosition.y + 1] = map.default_tile.instance()
    map.world[parentPosition.x][parentPosition.y + 1].position = map.tileToWorldCoordinate(parentPosition + Vector2(0,1))
    (map as Node).add_child(map.world[parentPosition.x][parentPosition.y + 1])
    
    map.world[parentPosition.x - 1][parentPosition.y + 1] = map.default_tile.instance()
    map.world[parentPosition.x - 1][parentPosition.y + 1].position = map.tileToWorldCoordinate(parentPosition + Vector2(-1,1))
    (map as Node).add_child(map.world[parentPosition.x - 1][parentPosition.y + 1])
    
    map.world[parentPosition.x - 2][parentPosition.y + 1] = map.default_tile.instance()
    map.world[parentPosition.x - 2][parentPosition.y + 1].position = map.tileToWorldCoordinate(parentPosition + Vector2(-2,1))
    (map as Node).add_child(map.world[parentPosition.x - 2][parentPosition.y + 1])
    
    map.world[parentPosition.x + 1][parentPosition.y + 1] = map.default_tile.instance()
    map.world[parentPosition.x + 1][parentPosition.y + 1].position = map.tileToWorldCoordinate(parentPosition + Vector2(1,1))
    (map as Node).add_child(map.world[parentPosition.x + 1][parentPosition.y + 1])
   
    map.world[parentPosition.x + 2][parentPosition.y + 1] = map.default_tile.instance()
    map.world[parentPosition.x + 2][parentPosition.y + 1].position = map.tileToWorldCoordinate(parentPosition + Vector2(2,1))
    (map as Node).add_child(map.world[parentPosition.x + 2][parentPosition.y + 1])
func spawnDebugFlags():
    var parentPosition = map.worldToTileCoordinate(get_parent().position)
    
    map.world[parentPosition.x + 2][parentPosition.y] = tile_prefabs[1].instance()
    map.world[parentPosition.x + 2][parentPosition.y].position = map.tileToWorldCoordinate(parentPosition + Vector2(2,0))
    (map as Node).add_child(map.world[parentPosition.x + 2][parentPosition.y])
    map.world[parentPosition.x + 2][parentPosition.y].setPlayerNumber('1');
    
    map.world[parentPosition.x - 2][parentPosition.y] = tile_prefabs[1].instance()
    map.world[parentPosition.x - 2][parentPosition.y].position = map.tileToWorldCoordinate(parentPosition + Vector2(-2,0))
    (map as Node).add_child(map.world[parentPosition.x - 2][parentPosition.y])
    map.world[parentPosition.x - 2][parentPosition.y].setPlayerNumber('2');