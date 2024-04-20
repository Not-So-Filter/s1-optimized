SndCD_Switch_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoiceNull
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG3, SndCD_Switch_PSG3,	$00, $00

; PSG3 Data
SndCD_Switch_PSG3:
	dc.b	nBb4, $02
	smpsStop