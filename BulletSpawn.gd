extends KinematicBody2D

var speed = 750
var velocity = Vector2()
export(PackedScene) var explosionScene

func start(pos, dir):
    rotation = dir
    position = pos
    velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
    var collision = move_and_collide(velocity * delta)
    if collision:
        if (explosionScene):
            var e = explosionScene.instance();
            e.position = collision.position;
            get_tree().get_root().add_child(e)
        queue_free();
        #velocity = velocity.bounce(collision.normal)
        if collision.collider.has_method("hit"):
            collision.collider.hit()


func _on_VisibilityNotifier2D_screen_exited():
    queue_free()