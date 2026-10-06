extends Node
var server_inventory=[]
var server_gold=0
var server_mobs={}
var server_mp=0
var quests=[]
var guild={}
var guild_bank=[]
var server_stats={}
var equipment=[]
var session_token=""
func _ready():NetworkClient.message_received.connect(_message)
func _message(m):
	var t=m.get("type","")
	if t=="enter_result" and m.get("ok",false):NetworkClient.request_world()
	elif t=="world_snapshot":
		server_inventory=m.get("inventory",[]);server_gold=int(m.get("gold",0))
		server_mobs.clear()
		for mob in m.get("mobs",[]):server_mobs[mob.id]=mob
	elif t in ["refine_result","market_buy_result","mail_send_result","mail_claim_result"]:
		if m.has("inventory"):server_inventory=m.inventory
		if m.has("gold"):server_gold=int(m.gold)
	elif t=="login_result" and m.get("ok",false):
		session_token=str(m.get("session_token",""))
	elif t=="equipment_result":
		server_stats=m.get("stats",{});equipment=m.get("equipment",[]);server_inventory=m.get("inventory",[])
	elif t=="skill_result":
		if m.get("ok",false):server_mp=int(m.get("mp",server_mp))
	elif t=="quest_rows":quests=m.get("rows",[])
	elif t=="quest_claim_result":quests=m.get("quests",[])
	elif t=="guild_result":
		guild=m.get("guild",{});guild_bank=m.get("bank",[])
	elif t=="attack_result" and m.get("dead",false):
		var reward=m.get("reward",{})
		server_gold+=int(reward.get("gold",0))
func attack(mob_id):return NetworkClient.attack_server(mob_id)
func refine(item,upgrade):return NetworkClient.refine_server(item,upgrade)
func skill(mob_id,index):return NetworkClient.skill_server(mob_id,index)
func craft(recipe):return NetworkClient.craft_server(recipe)
