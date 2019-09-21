extends Node

var Bullet = preload("res://Bullet.tscn")
var speed = 200
var velocity = Vector2()
var rotation = 0

func shoot():
    var b = Bullet.instance()
    get_tree().get_root().add_child(b)
    #print(self.global_position)
    #print(get_parent().lookingVector*400)
    b.start(self.global_position+(get_parent().lookingVector*25), get_parent().lookingVector.angle())