extends KinematicBody2D

var velocity = Vector2()

func get_input():
    # Add these actions in Project Settings -> Input Map.
    velocity = Vector2()
   # if Input.is_action_pressed('backward'):
   #     velocity = Vector2(-speed/3, 0).rotated(rotation)
   # if Input.is_action_pressed('forward'):
   #     velocity = Vector2(speed, 0).rotated(rotation)

    if Input.is_action_just_pressed('shoot'):
        $Projectile_spawn.shoot()

func _physics_process(delta):
	get_input()