extends Node3D

const SPEED = 40

@onready var mesh = $MeshInstance3D
@onready var ray = $RayCast3D
@onready var particles = $GPUParticles3D
var player = null
var damage = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.basis * Vector3(0,0,-SPEED) * delta
	if ray.is_colliding():
		particles.emitting = true
		mesh.visible = false
		if ray.get_collider().is_in_group("enemy"):
			var points = ray.get_collider().getPointAmount(damage)
			if(player != null):
				player.setPoints(points)
			ray.get_collider().hit(damage)
		ray.enabled = false
		await get_tree().create_timer(1.0).timeout
		queue_free()

func _on_timer_timeout():
	queue_free()
