extends Control
@onready var optionsMenu = $MarginContainer/OptionsMenu
@onready var mainMenu = $MarginContainer/MainMenu
@onready var creditsMenu = $MarginContainer/Credits1
var menus = []

func _ready():
	menus = [mainMenu, optionsMenu, creditsMenu]
	switchPanel(mainMenu)
	optionsMenu.connect("closePanel", _on_close_options)
	creditsMenu.connect("credits_closed", _on_close_credits)

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/Level1.tscn")


func _on_options_pressed():
	switchPanel(optionsMenu)


func _on_quit_pressed():
	get_tree().quit()

func switchPanel(panel):
	for menu in menus:
		if menu.name == panel.name:
			menu.visible = true
			menu.mouse_filter = MOUSE_FILTER_IGNORE
		else:
			menu.visible = false
			menu.mouse_filter = MOUSE_FILTER_PASS

func _on_close_options():
	switchPanel(mainMenu)

func _on_close_credits():
	switchPanel(mainMenu)


func _on_credits_pressed():
	switchPanel(creditsMenu)
