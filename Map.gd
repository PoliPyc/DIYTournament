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
    for x in range(LEVEL_WIDTH):
        world.append([])
        world[x] = []
        for y in range(LEVEL_HEIGHT):
            world[x].append([])
            world[x][y] = null
#            world[x][y] = default_tile.instance()
#            world[x][y].position.x = tileCoordToWorldCoord(x)
#            world[x][y].position.y = tileCoordToWorldCoord(y)
#            self.add_child(world[x][y])

func tileCoordToWorldCoord(coord):
    return coord * TILE_SIZE;
    
func worldCoordToTileCoord(coord):
    return coord / TILE_SIZE;
    
    
    
    
    
    
    
    
    