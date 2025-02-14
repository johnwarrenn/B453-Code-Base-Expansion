extends Node

func play_bg_music():
	if !$AudioStreamPlayer.playing:
		$AudioStreamPlayer.play()
	
func stop_bg_music():
	$AudioStreamPlayer.stop()

func play_enemy_kill():
	$EnemyGrunt.play()
	
func play_death_sound():
	$PlayerDeathSound.play()
	
func play_start_sound():
	$PlayerStartSoud.play()
	
func play_yabai():
	$yabai.play()

func play_ninja_star():
	$NinjaStarThrow.play()
	
func player_hit():
	$PlayerHit.play()
	
func enemy_hit():
	$EnemyHit.play()
	
func dodge_roll():
	$DodgeRoll.play()

func jump():
	$AudioStreamPlayer2.play()
