extends Node
var player_name="Hero"
var class_name="Blade"
var level=1
var xp=0
var gold=250
var hp=420
var mp=170
var max_hp=420
var max_mp=170
var attack=42
var defense=12
var inventory={"HP Potion":5,"MP Potion":3,"Upgrade Stone":2}
var equipment={"weapon":"Iron Vanguard","armor":"","helmet":"","boots":"","necklace":"","costume":""}
var upgrade_levels={"Iron Vanguard":0}
var achievements=[]
var titles=[]
var current_title=""
var arena_rating=1000
var kills=0
var bosses=0
var crystals=0
var skill_points=0
var current_map=0

func add_item(name,count=1):
	inventory[name]=inventory.get(name,0)+count

func spend_gold(n):
	if gold<n:return false
	gold-=n;return true

func gain_xp(n):
	xp+=n
	var need=level*150
	while xp>=need:
		xp-=need;level+=1;skill_points+=1
		max_hp+=30;max_mp+=12;attack+=4;defense+=1;hp=max_hp;mp=max_mp
		need=level*150

func save_game():
	var d={"player_name":player_name,"class_name":class_name,"level":level,"xp":xp,"gold":gold,"hp":hp,"mp":mp,
	"max_hp":max_hp,"max_mp":max_mp,"attack":attack,"defense":defense,"inventory":inventory,
	"equipment":equipment,"upgrade_levels":upgrade_levels,"achievements":achievements,"titles":titles,
	"current_title":current_title,"arena_rating":arena_rating,"kills":kills,"bosses":bosses,"crystals":crystals,
	"skill_points":skill_points,"current_map":current_map}
	var f=FileAccess.open("user://savegame.json",FileAccess.WRITE);f.store_string(JSON.stringify(d))

func load_game():
	if not FileAccess.file_exists("user://savegame.json"):return false
	var f=FileAccess.open("user://savegame.json",FileAccess.READ)
	var d=JSON.parse_string(f.get_as_text())
	if typeof(d)!=TYPE_DICTIONARY:return false
	for k in d:
		if k in self:
			set(k,d[k])
	return true
