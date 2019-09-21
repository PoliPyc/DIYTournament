extends Control

func _input(event):
    if event is InputEventKey:
        print(event.as_text())
    if Input.is_action_just_pressed('escape'):
        print('escape')
        showMenu()

func showMenu():
	show()

func _on_Start_pressed():
	hide()


func _on_Quit_pressed():
	get_tree().quit()
