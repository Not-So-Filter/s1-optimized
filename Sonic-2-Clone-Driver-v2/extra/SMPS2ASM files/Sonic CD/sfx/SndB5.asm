SndB5_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     SndB5_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM4, SndB5_FM4,	$D0, $0D

; FM4 Data
SndB5_FM4:
	smpsSetvoice        $00
	dc.b	nF1, $03, nCs2, $10
	smpsStop

SndB5_Voices:
;	Voice $00
;	$3D
;	$12, $70, $13, $30, 	$5F, $5F, $5F, $5F, 	$0D, $0D, $0D, $0D
;	$0D, $0F, $0F, $0F, 	$4F, $4F, $4F, $4F, 	$14, $80, $80, $80
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $01, $07, $01
	smpsVcCoarseFreq    $00, $03, $00, $02
	smpsVcRateScale     $01, $01, $01, $01
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0D, $0D, $0D, $0D
	smpsVcDecayRate2    $0F, $0F, $0F, $0D
	smpsVcDecayLevel    $04, $04, $04, $04
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $80, $80, $14

