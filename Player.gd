extends KinematicBody2D

#Jump 
export var fallMultiplier = 2 
export var lowJumpMultiplier = 10 
export var jumpVelocity = 400 #Jump height
export var speed = 100
#Physics
var velocity = Vector2()
export var gravity = 8

func get_input():
    #Applying gravity to player
    velocity.y += gravity 
    
    if Input.is_action_just_pressed('shoot'):
        $Projectile_spawn.shoot()
    
    #Jump Physics
    if velocity.y > 0: #Player is falling
        velocity += Vector2.UP * (-9.81) * (fallMultiplier) #Falling action is faster than jumping action | Like in mario

    elif velocity.y < 0 && Input.is_action_just_released("ui_accept"): #Player is jumping 
        velocity += Vector2.UP * (-9.81) * (lowJumpMultiplier) #Jump Height depends on how long you will hold key

    if is_on_floor():
        if Input.is_action_just_pressed("ui_accept"): 
            velocity = Vector2.UP * jumpVelocity #Normal Jump action
    if Input.is_key_pressed(KEY_RIGHT):
        print("RAJT");
        velocity.x = speed
    elif Input.is_key_pressed(KEY_LEFT):
        print("LEFT")
        velocity.x = -speed
    else:
        velocity.x = 0
    velocity = move_and_slide(velocity, Vector2(0,-1))

func _physics_process(delta):
    get_input()
    

      
