extends Control

@onready var health_text = $CanvasLayer/HUD/healthTxt
@onready var game_over_text = $CanvasLayer/GameOverMenu/gameOverTxt
@onready var interact_text = $CanvasLayer/interactTxt
@onready var inventory_ui = $CanvasLayer/Inventory
@onready var paused_text = $CanvasLayer/PauseMenu/MarginContainer/VBoxContainer/pauseTxt
@onready var try_again_btn = $CanvasLayer/GameOverMenu/tryAgain
@onready var quit_btn = $CanvasLayer/GameOverMenu/quit
@onready var philsopher_table = $"../Map/PhilosopherTable"
@onready var player = null

@onready var HUD = $CanvasLayer/HUD
@onready var GameOverMenu = $CanvasLayer/GameOverMenu
@onready var PauseMenu = $CanvasLayer/PauseMenu
@onready var OptionsMenu = $CanvasLayer/OptionsMenu
@onready var PhilosopherMenu = $CanvasLayer/PhilosopherMenu

@onready var playerCamera = null
@onready var philsopherCamera = $"../Map/PhilosopherTable/PhilosopherCamera"
var menus

signal alchemy_started
signal alchemy_ended

func _ready():
	menus = [HUD, GameOverMenu, PauseMenu, OptionsMenu, PhilosopherMenu]
	setPanel(HUD)
	OptionsMenu.connect("closePanel", _on_options_closed)
	alchemy_started.connect(_on_alchemy_started)
	alchemy_ended.connect(_on_alchemy_ended)

func set_active_camera(node_path):
	var cameras = [playerCamera, philsopherCamera]
	for camera in cameras:
		if camera == node_path:
			camera.current = true
		else:
			camera.current = false

func _on_player_player_died():
	setPanel(GameOverMenu)

func _on_player_player_hit(health):
	HUD.setHealth(health)

func _on_player_player_healed(health):
	HUD.setHealth(health)

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("open_inventory") and player.current_state == player.PLAYER_STATE.ACTIVE:
			inventory_ui.visible = true
			player.current_state = player.PLAYER_STATE.INVENTORY
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif event.is_action_released("open_inventory") and player.current_state == player.PLAYER_STATE.INVENTORY:
			inventory_ui.visible = false
			player.current_state = player.PLAYER_STATE.ACTIVE
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		elif event.is_action_pressed("interact") and (player.current_state == player.PLAYER_STATE.ACTIVE
																	or player.current_state == player.PLAYER_STATE.ALCHEMY):
			if player.isByPhilsopherTable:
				if not PhilosopherMenu.visible:
					emit_signal("alchemy_started")
				else:
					emit_signal("alchemy_ended")

func _on_alchemy_started():
	player.current_state = player.PLAYER_STATE.ALCHEMY
	setPanel(PhilosopherMenu)
	interact_text.visible = false
	player.visible = false
	set_active_camera(philsopherCamera)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	philsopher_table.setup_philosopher_table()
	
func _on_alchemy_ended():
	player.current_state = player.PLAYER_STATE.ACTIVE
	setPanel(HUD)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player.visible = true
	set_active_camera(playerCamera)
	philsopher_table.end_alchemy_session()

func _on_world_player_created(player_path):
	player = get_node(player_path)
	playerCamera = get_node(player.camera.get_path())
	player.connect("player_hit", _on_player_player_hit)
	player.connect("player_died", _on_player_player_died)
	player.connect("player_healed", _on_player_player_healed)
	player.connect("player_received_points", _on_player_received_points)

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

func _on_player_received_points(points):
	HUD.setPoints(points)

func setHealth(health):
	HUD.setHealth(health)
	
