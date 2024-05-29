; ---------------------------------------------------------------------------
; Subroutine to	pause the game
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PauseGame:
		tst.b	(v_lives).w	; do you have any lives	left?
		beq.w	Unpause		; if not, branch
		tst.b	(f_pause).w	; is game already paused?
		bne.s	Pause_StopGame	; if yes, branch
		btst	#bitStart,(v_jpadpress1).w ; is Start button pressed?
		beq.w	Pause_DoNothing	; if not, branch

Pause_StopGame:
		moveq	#1,d0
		move.b	d0,(f_pause).w	; freeze time
	if SoundDriverType=4
		SMPS_Pause
	endif
	if SoundDriverType=1
		move.b	d0,(v_snddriver_ram+f_pausemusic).w ; pause music
	else
		stopZ80
	if SoundDriverType=2
		move.b	#MusID_Pause,(z80_ram+zAbsVar.StopMusic).l	; Pause the music
	endif
	if SoundDriverType=3
		move.b	d0,(z80_ram+zPauseFlag).l	; Pause the music
	endif
		startZ80
	endif

Pause_Loop:
		move.b	#id_VB_0C,(v_vbla_routine).w
		bsr.w	WaitForVBla
		tst.b	(f_slomocheat).w ; is slow-motion cheat on?
		beq.s	Pause_ChkStart	; if not, branch
		btst	#bitA,(v_jpadpress1).w ; is button A pressed?
		beq.s	Pause_ChkBC	; if not, branch
		move.b	#id_Title,(v_gamemode).w ; set game mode to 4 (title screen)
		bra.s	Pause_EndMusic
; ===========================================================================

Pause_ChkBC:
		btst	#bitB,(v_jpadhold1).w ; is button B pressed?
		bne.s	Pause_SlowMo	; if yes, branch
		btst	#bitC,(v_jpadpress1).w ; is button C pressed?
		bne.s	Pause_SlowMo	; if yes, branch

Pause_ChkStart:
		btst	#bitStart,(v_jpadpress1).w ; is Start button pressed?
		beq.s	Pause_Loop	; if not, branch

Pause_EndMusic:
	if SoundDriverType=4
		SMPS_Unpause
	endif
	if SoundDriverType=1
		move.b	#$80,(v_snddriver_ram+f_pausemusic).w	; unpause the music
	else
		stopZ80
	if SoundDriverType=2
		move.b	#MusID_Unpause,(z80_ram+zAbsVar.StopMusic).l	; Unpause the music
	endif
	if SoundDriverType=3
		move.b	#$80,(z80_ram+zPauseFlag).l	; Unpause the music
	endif
		startZ80
	endif

Unpause:
		clr.b	(f_pause).w	; unpause the game

Pause_DoNothing:
		rts
; ===========================================================================

Pause_SlowMo:
		st.b	(f_pause).w
	if SoundDriverType=4
		SMPS_Unpause
	endif
	if SoundDriverType=1
		move.b	#$80,(v_snddriver_ram+f_pausemusic).w	; Unpause the music
	else
		stopZ80
	if SoundDriverType=2
		move.b	#MusID_Unpause,(z80_ram+zAbsVar.StopMusic).l	; Unpause the music
	endif
	if SoundDriverType=3
		move.b	#$80,(z80_ram+zPauseFlag).l	; Unpause the music
	endif
		startZ80
	endif
		rts
; End of function PauseGame
