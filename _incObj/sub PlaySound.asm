; ---------------------------------------------------------------------------
; Subroutine to	play a music track

; input:
;	d0 = track to play
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PlayMusic:
	if SoundDriverType=1
		move.b	d0,(v_snddriver_ram+v_soundqueue0).w
	else
		stopZ80
	if SoundDriverType=2
		move.b	d0,(z80_ram+zAbsVar.Queue0).l
	endif
	if SoundDriverType=3
		move.b	d0,(z80_ram+zMusicNumber).l
	endif
		startZ80
	endif
		rts
; End of function PlaySound

; ---------------------------------------------------------------------------
; Subroutine to	play a sound effect
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PlaySound:
	if SoundDriverType=1
		move.b	d0,(v_snddriver_ram+v_soundqueue1).w
	else
		stopZ80
	if SoundDriverType=2
		move.b	d0,(z80_ram+zAbsVar.Queue1).l
	endif
	if SoundDriverType=3
		move.b	d0,(z80_ram+zSFXNumber0).l
	endif
		startZ80
	endif
		rts
; End of function PlaySound_Special

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	play a special sound effect
; ---------------------------------------------------------------------------

PlaySound_Special:
	if SoundDriverType=1
		move.b	d0,(v_snddriver_ram+v_soundqueue2).w
	else
		stopZ80
	if SoundDriverType=2
		move.b	d0,(z80_ram+zAbsVar.Queue2).l
	endif
	if SoundDriverType=3
		move.b	d0,(z80_ram+zSFXNumber1).l
	endif
		startZ80
	endif
		rts
