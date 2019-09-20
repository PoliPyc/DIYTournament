extends Node

var Bullet = preload("res://Bullet.tscn")
var speed = 200
var velocity = Vector2()
var rotation = 0

func shoot():
    print('tyk')
    # "Muzzle" is a Position2D placed at the barrel of the gun.
    var b = Bullet.instance()
    b.start(get_parent().position, rotation)
    get_parent().add_child(b)
