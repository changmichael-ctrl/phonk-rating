extends Node2D
var rating = 5

var thumbnailpos = Vector2(54,295)
var ratedphonk = []
var ratedphonkname =[]
var ratedphonklabels = []
var playing = true

var songnumber = 0
var phonkplaylist = [
	[preload("uid://3dqar3gvo01u"),"Phonk Music","SigmaMusicArt",preload("uid://bk0l2h7bf32qb")],
	[preload("uid://b2kjwmiaoxja5"),"Passo Bem Solto","ATLXS",preload("uid://bdcyh6hdyx6wd")],
	[preload("uid://dp2cek1u647eb"),"Montagem Tomada","MXZI",preload("uid://wr1mq6b7b0kb")],
	[preload("uid://bw2kv55onbxcp"),"Funk Universo","Irokz",preload("uid://b1ycw4ytq7buv")],
	[preload("uid://kmyv6hos8876"),"Avangard","LONOWN",preload("uid://b314m2hbp24b8")],
	[preload("uid://57x4sqnmgqji"),"Acelerada","MXZI & sma$her",preload("uid://cm8qy677ka524")],
	]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$UI/Playing.texture_normal = preload("uid://c7uompxmp4yka")
	$UI/Songprogress.text = "Song " + str(songnumber+1) + "/" + str(len(phonkplaylist))
	$UI/Rating.text = "Rating:\n5/10"
	loadnextsong()
	$Phonkthumbnail.global_position = thumbnailpos
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var progressminutes = int(floor($"speaker/Phonk player".get_playback_position()/60))
	var progressseconds 
	var maxmin=int(floor(phonkplaylist[songnumber][0].get_length()/60))
	var maxsec
	if int(floor($"speaker/Phonk player".get_playback_position() - progressminutes*60)) < 10:
		progressseconds = "0" + str(int(floor($"speaker/Phonk player".get_playback_position() - progressminutes*60)))
	else:
		progressseconds = str(int(floor($"speaker/Phonk player".get_playback_position() - progressminutes*60)))
	if int(floor(phonkplaylist[songnumber][0].get_length() - maxmin*60)) < 10:
		maxsec = "0" + str(int(floor(phonkplaylist[songnumber][0].get_length() - maxmin*60)))
	else:
		maxsec = str(int(floor(phonkplaylist[songnumber][0].get_length() - maxmin*60)))
	
	$UI/Songprogressbar/secondsprogress.text = str(progressminutes) + ":" + str(progressseconds) + " / " + str(maxmin) +":"+str(maxsec)
	$UI/Songprogressbar.value = $"speaker/Phonk player".get_playback_position()
func loadnextsong():
	$"speaker/Phonk player".pitch_scale = 1
	$Good.disabled = false
	$Bad.disabled = false
	$Good.texture_normal = preload("uid://byg71abmminqe")
	$Bad.texture_normal = preload("uid://gtc3sawh3hrx")
	$Submitphonk.disabled = false
	$UI/Songprogressbar.value = 0
	$UI/Songprogressbar.max_value = phonkplaylist[songnumber][0].get_length()
	$"speaker/Phonk player".stream = phonkplaylist[songnumber][0]
	$"speaker/Phonk player".play()
	rating = 5
	$UI/Rating.text = "Rating:\n5/10"
	$UI/Name.text = str(phonkplaylist[songnumber][1])
	$UI/By.text = str(phonkplaylist[songnumber][2])
	$Phonkthumbnail.texture = phonkplaylist[songnumber][3]
	ratedphonk.sort_custom(Callable(self, "compare_by_rating_desc"))
	for label in ratedphonklabels:
		label.queue_free()
	ratedphonklabels.clear()
	var i = 0
	for label in ratedphonk:
		i+=1
		var labelhi = Label.new()
		add_child(labelhi)
		ratedphonklabels.append(labelhi)
		labelhi.global_position = Vector2(12,344 + 34 * i)
		labelhi.text = str(phonkplaylist[label[0]][1]) + " - " + str(label[1])
		if label[1] == 1000:
			labelhi.text = str(phonkplaylist[label[0]][1]) + " - sacrificed"
		labelhi.add_theme_constant_override("outline_size",7)
func _on_good_pressed() -> void:
	if rating < 10:
		rating+=1
		$UI/Rating.text = "Rating:\n"+str(rating)+"/10"
		

func _on_bad_pressed() -> void:
	if rating > 0:
		rating-=1
		$UI/Rating.text = "Rating:\n"+str(rating)+"/10"

func compare_by_rating_desc(a, b):
	return a[1] > b[1]
func _on_submitphonk_pressed() -> void:
	$"speaker/Phonk player".stop()
	$Submitphonk.disabled = true
	ratedphonk.append([songnumber,rating])
	if songnumber+1 < len(phonkplaylist):
		songnumber+=1
		$UI/Songprogress.text = "Song " + str(songnumber+1) + "/" + str(len(phonkplaylist))
		loadnextsong()
		playing = true
		$"speaker/Phonk player".stream_paused = false
		$UI/Playing.texture_normal = preload("uid://c7uompxmp4yka")
	$Phonkthumbnail.global_position = thumbnailpos


func _on_playing_pressed() -> void:
	if playing == true:
		playing = false
		$"speaker/Phonk player".stream_paused = true
		$UI/Playing.texture_normal = preload("uid://bpyyvdxv6vpur")
	else:
		playing = true
		$"speaker/Phonk player".stream_paused = false
		$UI/Playing.texture_normal = preload("uid://c7uompxmp4yka")


func _on_backten_pressed() -> void:
	var tenbehind
	if $"speaker/Phonk player".get_playback_position()-10 < 0:
		tenbehind = 0
	else:
		tenbehind = $"speaker/Phonk player".get_playback_position()-10
	$"speaker/Phonk player".play(tenbehind)
	playing = true
	$"speaker/Phonk player".stream_paused = false
	$UI/Playing.texture_normal = preload("uid://c7uompxmp4yka")
func _on_forwardten_pressed() -> void:
	var tenahead = $"speaker/Phonk player".get_playback_position()+10
	$"speaker/Phonk player".play(tenahead)
	print(tenahead)
	playing = true
	$"speaker/Phonk player".stream_paused = false
	$UI/Playing.texture_normal = preload("uid://c7uompxmp4yka")

func _on_phonk_player_finished() -> void:
	$"speaker/Phonk player".play()



func _on_volumeslider_value_changed(value: float) -> void:
	$"speaker/Phonk player".volume_db = $Volumeslider.value


func _on_reset_volume_pressed() -> void:
	$"speaker/Phonk player".volume_db = 0
	$Volumeslider.value = 0


func _on_sacraficephonk_pressed() -> void:
	rating = 1000
	$UI/Rating.text = "Rating:\nSACRIFICED"
	$Good.disabled = true
	$Bad.disabled = true
	$Good.texture_normal = preload("uid://8ict71531c4m")
	$Bad.texture_normal = preload("uid://8ict71531c4m")
	$UI/sacraficephonk/SACRIfice.play()
	playing = true
	_on_playing_pressed()
	$"speaker/Phonk player".pitch_scale = 0.1
