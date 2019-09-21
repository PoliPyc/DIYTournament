extends Node2D
var hp = 3
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var map = null
# Called when the node enters the scene tree for the first time.
func _ready():
    map = get_tree().get_root().get_node("World").get_node("Map") as Map
    pass # Replace with function body.

func hit():
    print("HIT W GLEBE")
    hp =- 1
    if hp < 0:
        queue_free()
        var tableIndex = map.worldToTileCoordinate(self.position);
        map.world[tableIndex.x][tableIndex.y] = null
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
