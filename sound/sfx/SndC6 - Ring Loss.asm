SndC6_Ring_Loss_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     SndCE_Ring_Left_Speaker_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $02

	smpsHeaderSFXChannel cFM4, SndC6_Ring_Loss_FM4,	$00, $05
	smpsHeaderSFXChannel cFM5, SndC6_Ring_Loss_FM5,	$00, $08

; FM4 Data
SndC6_Ring_Loss_FM4:
	smpsSetvoice        $00
	dc.b	nA5, $02, $05, $05, $05, $05, $05, $05, $3A
	smpsStop

; FM5 Data
SndC6_Ring_Loss_FM5:
	smpsSetvoice        $00
	dc.b	nRst, $02, nG5, $02, $05, $15, $02, $05, $32
	smpsStop