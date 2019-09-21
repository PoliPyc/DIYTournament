extends Node
class_name Map

export(int) var LEVEL_WIDTH  = 40
export(int) var LEVEL_HEIGHT = 22
export(int) var TILE_SIZE = 32

export(PackedScene) var default_tile

var world = []

# Called when the node enters the scene tree for the first time.
func _ready():
    generate() # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func generate():
    print("gen")
    for x in range(LEVEL_WIDTH + 1):
        world.append([])
        world[x] = []
        for y in range(LEVEL_HEIGHT + 1):
            world[x].append([])
            world[x][y] = null
            
func tileToWorldCoordinate(vector):
    return Vector2(vector.x * TILE_SIZE, vector.y * TILE_SIZE);
    
func worldToTileCoordinate(vector):
    return Vector2(clamp(int(vector.x / TILE_SIZE), 0, LEVEL_WIDTH), clamp(int(vector.y / TILE_SIZE), 0 ,LEVEL_HEIGHT));