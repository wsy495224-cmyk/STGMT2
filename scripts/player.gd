extends CharacterBody3D
var game
var speed=7.0
var last_attack=0.0
var manual_override=false

func _physics_process(delta):
	if game and game.mouse_control:game.mouse_control.physics(delta)
	var v=Input.get_vector("move_left","move_right","move_forward","move_back")
	if v.length()>.1:
		manual_override=true
		var d=Vector3(v.x,0,v.y);classic_move(d.normalized(),delta)
	else:manual_override=false
	global_position.x=clamp(global_position.x,-43.,43.);global_position.z=clamp(global_position.z,-43.,43.)
	var avatar=get_node_or_null("CharacterVisualV26")
	if avatar:avatar.animate_move(v.length()>.1 or velocity.length()>0.2,delta)

func classic_move(d,delta):
	velocity.x=d.x*speed;velocity.z=d.z*speed
	if d.length()>.1:rotation.y=lerp_angle(rotation.y,atan2(-d.x,-d.z),delta*10.)
	move_and_slide()

func classic_stop():
	if manual_override:return
	velocity=Vector3.ZERO

func _unhandled_input(event):
	if game and game.mouse_control:game.mouse_control.input(event)
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode==KEY_I:game.toggle_inventory()
		elif event.keycode==KEY_V:game.show_skills()
		elif event.keycode==KEY_O:game.toggle_social()
		elif event.keycode==KEY_M:game.mount_toggle()
		elif event.keycode==KEY_J:game.claim_quests()
		elif event.keycode==KEY_T:game.toggle_skill_tree()
		elif event.keycode==KEY_B:game.toggle_market()
		elif event.keycode==KEY_G:game.toggle_guild()
		elif event.keycode==KEY_P:game.toggle_party()
		elif event.keycode==KEY_C:game.toggle_crafting()
		elif event.keycode==KEY_L:game.toggle_mail()
		elif event.keycode==KEY_N:game.toggle_events()
		elif event.keycode==KEY_F:game.quick_fish()
		elif event.keycode==KEY_H:game.quick_gather()
		elif event.keycode>=KEY_1 and event.keycode<=KEY_6:game.cast_skill(event.keycode-KEY_1)
