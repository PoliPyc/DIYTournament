extends Node2D
class_name Flag

var playerNumber = '0';
var map = null;

#TODO: Różne grafiki dla osobnych graczy?
func setPlayerNumber(number):
    playerNumber = number;
    match (playerNumber):
        '0':
            #error            
            $Sprite.modulate = Color(1,0,0);
        '1':
            $Sprite.modulate = Color(1,1,0);
        '2':
            $Sprite.modulate = Color(1,0,1);
        
func _ready():
   map = get_parent() as Map

func _on_Node2D_body_entered(body):
    if (body.get('playerNumber') != null && body.playerNumber != playerNumber):
        call_deferred("reparent", body)
    elif(body.get('playerNumber') != null && body.playerNumber == playerNumber && body.isCarryingFlag):
        call_deferred("score", body)
        
# "Pickup" flag        
func reparent(body):
    var mapCoord = map.worldToTileCoordinate(self.position);
    map.world[mapCoord.x][mapCoord.y] = null;
    
    self.get_parent().remove_child(self);
    body.add_child(self)
    self.position.x = 0
    self.position.y = 0
    body.isCarryingFlag = true;

func score(player):
    player.isCarryingFlag = false;
    #GÓWNO
    print(player)
    print(player.get_child_count())
    print(player.get_child(player.get_child_count() - 1))
    for i in range(player.get_child_count()):
        if (player.get_child(i).get_class() == 'Area2D'):
            player.get_child(i).queue_free();

func validatePosition(vector, map):
    return map.world[vector.x][vector.y + 1] != null && map.world[vector.x][vector.y + 1] is Dirt