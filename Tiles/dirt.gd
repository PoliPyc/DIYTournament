extends Node2D
class_name Dirt

var hp = 3
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var map = null
# Called when the node enters the scene tree for the first time.
func _ready():
    map = get_tree().get_root().get_node("World").get_node("Map") as Map

func hit():
    print("HIT W GLEBE")
    hp -= 1
    if hp < 0:
        queue_free()
        var tableIndex = map.worldToTileCoordinate(self.position);
        map.world[tableIndex.x][tableIndex.y] = null
    else:
        $Sprite.frame = 3 - hp        
