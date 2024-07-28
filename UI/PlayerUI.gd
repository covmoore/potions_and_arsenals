extends Control

@onready var interact_text = $CanvasLayer/interactTxt
@onready var inventory_ui = $CanvasLayer/Inventory
@onready var alchemy_panel = $CanvasLayer/AlchemyPanel
@onready var philsopher_table = $"../Map/Philosopher Table"
@onready var player = null

@onready var HUD = $CanvasLayer/HUD
@onready var GameOverMenu = $CanvasLayer/GameOverMenu
@onready var PauseMenu = $CanvasLayer/PauseMenu
@onready var OptionsMenu = $CanvasLayer/OptionsMenu
var menus
signal alchemy_started

func _ready():
	menus = [HUD, GameOverMenu, PauseMenu, OptionsMenu]
	setPanel(HUD)
	OptionsMenu.connect("closePanel", _on_options_closed)
	alchemy_started.connect(_on_alchemy_started)

func _on_player_player_died():
	setPanel(GameOverMenu)

func _on_player_player_hit(health):
	HUD.setHealth(health)

func _on_player_player_healed(health):
	HUD.setHealth(health)

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.physical_keycode == KEY_V and (player.current_state == player.PLAYER_STATE.ACTIVE 
																or player.current_state == player.PLAYER_STATE.INVENTORY):
			inventory_ui.visible = not inventory_ui.visible
			#show the cursor if not shown
			if inventory_ui.visible:
				player.current_state = player.PLAYER_STATE.INVENTORY
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				player.current_state = player.PLAYER_STATE.ACTIVE
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		elif event.pressed and event.physical_keycode == KEY_E and (player.current_state == player.PLAYER_STATE.ACTIVE
																	or player.current_state == player.PLAYER_STATE.ALCHEMY):
			if player.isByPhilsopherTable:
				alchemy_panel.visible = not alchemy_panel.visible
				if alchemy_panel.visible:
					emit_signal("alchemy_started")
					interact_text.visible = false
					player.current_state = player.PLAYER_STATE.ALCHEMY
					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				else:
					player.current_state = player.PLAYER_STATE.ACTIVE
					Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_alchemy_started():
	philsopher_table.setup_philosopher_table()

func _on_world_player_created(player_path):
	player = get_node(player_path)
	player.connect("player_hit", _on_player_player_hit)
	player.connect("player_died", _on_player_player_died)
	player.connect("player_healed", _on_player_player_healed)

func _on_try_again_pressed():
	get_tree().reload_current_scene()

func setPanel(panel):
	for menu in menus:
		if menu.name == panel.name:
			menu.visible = true
			menu.mouse_filter = MOUSE_FILTER_PASS
		else:
			menu.visible = false
			menu.mouse_filter = MOUSE_FILTER_IGNORE

func setPaused(x):
	if x == true:
		setPanel(PauseMenu)
	else:
		setPanel(HUD)

func _on_options_closed():
	setPanel(PauseMenu)

func _on_continue_btn_pressed():
	player.resume_game()


func _on_options_btn_pressed():
	setPanel(OptionsMenu)


func _on_leave_game_btn_pressed():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")


func _on_quit_pressed():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
