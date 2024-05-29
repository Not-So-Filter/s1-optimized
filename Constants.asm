; ---------------------------------------------------------------------------
; Constants
; ---------------------------------------------------------------------------

; ---------------------------------------------------------------------------
; some variables and functions to help define those constants (redefined before a new set of IDs)
offset :=	0		; this is the start of the pointer table
ptrsize :=	1		; this is the size of a pointer (should be 1 if the ID is a multiple of the actual size)
idstart :=	0		; value to add to all IDs

; function using these variables
id function ptr,((ptr-offset)/ptrsize+idstart)

	if SoundDriverType=2
; ---------------------------------------------------------------------------
; size variables - you'll get an informational error if you need to change these...
; they are all in units of bytes
Size_of_DAC_samples =		$2F00
Size_of_SEGA_sound =		$6174
Size_of_DAC_driver_guess =	$F64 ; approximate post-compressed size of the Z80 sound driver

MusID_Pause =		$7F			; FE
MusID_Unpause =		$80			; FF
	endif

	if SoundDriverType=1
Size_of_SegaPCM:		equ $6978
Size_of_DAC_driver_guess:	equ $1760
	endif

	if SoundDriverType=3
Size_of_Snd_driver_guess = $E00
Size_of_Snd_driver2_guess = $690
; Approximate size of compressed sound driver. Change when appropriate
	endif

; VDP addressses
vdp_data_port:		equ $C00000
vdp_control_port:	equ $C00004
vdp_counter:		equ $C00008

psg_input:		equ $C00011

; Z80 addresses
z80_ram:		equ $A00000	; start of Z80 RAM
	if SoundDriverType=1
z80_dac_timpani_pitch:	equ z80_ram+zTimpani_Pitch
z80_dac_status:		equ z80_ram+zDAC_Status
z80_dac_sample:		equ z80_ram+zDAC_Sample
	endif
z80_ram_end:		equ $A02000	; end of non-reserved Z80 RAM
z80_version:		equ $A10001
z80_port_1_data:	equ $A10002
z80_port_1_control:	equ $A10008
z80_port_2_control:	equ $A1000A
z80_expansion_control:	equ $A1000C
z80_bus_request:	equ $A11100
z80_reset:		equ $A11200
ym2612_a0:		equ $A04000
ym2612_d0:		equ $A04001
ym2612_a1:		equ $A04002
ym2612_d1:		equ $A04003

sram_port:		equ $A130F1

security_addr:		equ $A14000

	if SoundDriverType=1
; Sound driver constants
	phase 0
TrackPlaybackControl:	ds.b 1		; All tracks
TrackVoiceControl:	ds.b 1		; All tracks
TrackTempoDivider:	ds.w 1		; All tracks
TrackDataPointer:	ds.l 1		; All tracks (4 bytes)
TrackTranspose:		ds.b 1		; FM/PSG only (sometimes written to as a word, to include TrackVolume)
TrackVolume:		ds.b 1		; FM/PSG only
TrackAMSFMSPan:		ds.b 1		; FM/DAC only
TrackVoiceIndex:	ds.b 1		; FM/PSG only
TrackVolEnvIndex:	ds.b 1		; PSG only
TrackStackPointer:	ds.b 1		; All tracks
TrackDurationTimeout:	ds.b 1		; All tracks
TrackSavedDuration:	ds.b 1		; All tracks
TrackSavedDAC:				; DAC only
TrackFreq:		ds.w 1		; FM/PSG only (2 bytes)
TrackNoteTimeout:	ds.b 1		; FM/PSG only
TrackNoteTimeoutMaster:	ds.b 1		; FM/PSG only
TrackModulationPtr:	ds.l 1		; FM/PSG only (4 bytes)
TrackModulationWait:	ds.b 1		; FM/PSG only
TrackModulationSpeed:	ds.b 1		; FM/PSG only
TrackModulationDelta:	ds.b 1		; FM/PSG only
TrackModulationSteps:	ds.b 1		; FM/PSG only
TrackModulationVal:	ds.w 1		; FM/PSG only (2 bytes)
TrackDetune:		ds.b 1		; FM/PSG only
TrackPSGNoise:				; PSG only
TrackFeedbackAlgo:	ds.b 1		; FM only
TrackVoicePtr:		ds.l 1		; FM SFX only (4 bytes)
TrackLoopCounters:	ds.l 3		; All tracks (multiple bytes)
TrackGoSubStack:			; All tracks (multiple bytes. This constant won't get to be used because of an optimisation that just uses TrackSz)

TrackSz:
	dephase
	!org 0
	endif

; VRAM data
vram_fg:	equ $C000	; foreground namespace
vram_bg:	equ $E000	; background namespace
vram_sprites:	equ $F800	; sprite table
vram_hscroll:	equ $FC00	; horizontal scroll table

; Game modes
id_Sega:	equ ptr_GM_Sega-GameModeArray	; $00
id_Title:	equ ptr_GM_Title-GameModeArray	; $04
id_Demo:	equ ptr_GM_Demo-GameModeArray	; $08
id_Level:	equ ptr_GM_Level-GameModeArray	; $0C
id_Special:	equ ptr_GM_Special-GameModeArray; $10
id_Continue:	equ ptr_GM_Cont-GameModeArray	; $14
id_Ending:	equ ptr_GM_Ending-GameModeArray	; $18
id_Credits:	equ ptr_GM_Credits-GameModeArray; $1C

; Game modes
id_VB_00:	equ ptr_VB_00-VBla_Index	; $00
id_VB_02:	equ ptr_VB_02-VBla_Index	; $02
id_VB_04:	equ ptr_VB_04-VBla_Index	; $04
id_VB_06:	equ ptr_VB_06-VBla_Index	; $06
id_VB_08:	equ ptr_VB_08-VBla_Index	; $08
id_VB_0A:	equ ptr_VB_0A-VBla_Index	; $0A
id_VB_0C:	equ ptr_VB_0C-VBla_Index	; $0C
id_VB_0E:	equ ptr_VB_0E-VBla_Index	; $0E
id_VB_10:	equ ptr_VB_10-VBla_Index	; $10
id_VB_12:	equ ptr_VB_12-VBla_Index	; $12

; Levels
id_GHZ:		equ 0
id_LZ:		equ 1
id_MZ:		equ 2
id_SLZ:		equ 3
id_SYZ:		equ 4
id_SBZ:		equ 5
id_EndZ:	equ 6
id_SS:		equ 7

; Colours
cBlack:		equ $000		; colour black
cWhite:		equ $EEE		; colour white
cBlue:		equ $E00		; colour blue
cGreen:		equ $0E0		; colour green
cRed:		equ $00E		; colour red
cYellow:	equ cGreen+cRed		; colour yellow
cAqua:		equ cGreen+cBlue	; colour aqua
cMagenta:	equ cBlue+cRed		; colour magenta

; Joypad input
btnStart:	equ %10000000 ; Start button	($80)
btnA:		equ %01000000 ; A		($40)
btnC:		equ %00100000 ; C		($20)
btnB:		equ %00010000 ; B		($10)
btnR:		equ %00001000 ; Right		($08)
btnL:		equ %00000100 ; Left		($04)
btnDn:		equ %00000010 ; Down		($02)
btnUp:		equ %00000001 ; Up		($01)
btnDir:		equ %00001111 ; Any direction	($0F)
btnABC:		equ %01110000 ; A, B or C	($70)
bitStart:	equ 7
bitA:		equ 6
bitC:		equ 5
bitB:		equ 4
bitR:		equ 3
bitL:		equ 2
bitDn:		equ 1
bitUp:		equ 0

; Object variables
obID:		equ 0	; object ID number
obRender:	equ 1	; bitfield for x/y flip, display mode
obGfx:		equ 2	; palette line & VRAM setting (2 bytes)
obMap:		equ 4	; mappings address (4 bytes)
obX:		equ 8	; x-axis position (2-4 bytes)
obScreenY:	equ $A	; y-axis position for screen-fixed items (2 bytes)
obY:		equ $C	; y-axis position (2-4 bytes)
obVelX:		equ $10	; x-axis velocity (2 bytes)
obVelY:		equ $12	; y-axis velocity (2 bytes)
obActWid:	equ $14	; action width
obHeight:	equ $16	; height/2
obWidth:	equ $17	; width/2
obPriority:	equ $18	; sprite stack priority -- 0 is front
obFrame:	equ $1A	; current frame displayed
obAniFrame:	equ $1B	; current frame in animation script
obAnim:		equ $1C	; current animation
obPrevAni:	equ $1D	; previous animation
obTimeFrame:	equ $1E	; time to next frame
obDelayAni:	equ $1F	; time to delay animation
obInertia:	equ $20	; potential speed (2 bytes)
obColType:	equ $20	; collision response type
obColProp:	equ $21	; collision extra property
obStatus:	equ $22	; orientation or mode
obRespawnNo:	equ $23	; respawn list index number
obRoutine:	equ $24	; routine number
ob2ndRout:	equ $25	; secondary routine number
obAngle:	equ $26	; angle
obSubtype:	equ $28	; object subtype
obSolid:	equ ob2ndRout ; solid status flag

; ---------------------------------------------------------------------------
; when childsprites are activated (i.e. bit #6 of render_flags set)
mainspr_width		= $A
mainspr_height		= $B
mainspr_mapframe	= $E
mainspr_childsprites 	= $F	; amount of child sprites
subspr_data		= $10
sub2_x_pos		= $10	;x_vel
sub2_y_pos		= $12	;y_vel
sub2_mapframe		= $15
sub3_x_pos		= $16	;y_radius
sub3_y_pos		= $18	;anim
sub3_mapframe		= $1B	;anim_frame
sub4_x_pos		= $1C	;anim_frame_timer
sub4_y_pos		= $1E	;angle
sub4_mapframe		= $21	;collision_property
sub5_x_pos		= $22	;status
sub5_y_pos		= $24	;subtype
sub5_mapframe		= $27
sub6_x_pos		= $28
sub6_y_pos		= $2A
sub6_mapframe		= $2D
sub7_x_pos		= $2E
sub7_y_pos		= $30
sub7_mapframe		= $33
sub8_x_pos		= $34
sub8_y_pos		= $36
sub8_mapframe		= $39
sub9_x_pos		= $3A
sub9_y_pos		= $3C
sub9_mapframe		= $3F
next_subspr		= 6

; Object variables used by Sonic
flashtime:	equ $30	; time between flashes after getting hit
invtime:	equ $32	; time left for invincibility
shoetime:	equ $34	; time left for speed shoes
stick_to_convex:equ objoff_38
standonobject:	equ $3D	; object Sonic stands on

; Miscellaneous object scratch-RAM
objoff_25:	equ $25
objoff_26:	equ $26
objoff_29:	equ $29
objoff_2A:	equ $2A
objoff_2B:	equ $2B
objoff_2C:	equ $2C
objoff_2E:	equ $2E
objoff_2F:	equ $2F
objoff_30:	equ $30
objoff_32:	equ $32
objoff_33:	equ $33
objoff_34:	equ $34
objoff_35:	equ $35
objoff_36:	equ $36
objoff_37:	equ $37
objoff_38:	equ $38
objoff_39:	equ $39
objoff_3A:	equ $3A
objoff_3B:	equ $3B
objoff_3C:	equ $3C
objoff_3D:	equ $3D
objoff_3E:	equ $3E
objoff_3F:	equ $3F

object_size_bits:	equ 6
object_size:	equ 1<<object_size_bits

; Animation flags
afEnd:		equ $FF	; return to beginning of animation
afBack:		equ $FE	; go back (specified number) bytes
afChange:	equ $FD	; run specified animation
afRoutine:	equ $FC	; increment routine counter
afReset:	equ $FB	; reset animation and 2nd object routine counter
af2ndRoutine:	equ $FA	; increment 2nd routine counter

	if SoundDriverType=1
; Background music
bgm__First:	equ $01
bgm_GHZ:	equ ((ptr_mus81-MusicIndex)/4)+bgm__First
bgm_LZ:		equ ((ptr_mus82-MusicIndex)/4)+bgm__First
bgm_MZ:		equ ((ptr_mus83-MusicIndex)/4)+bgm__First
bgm_SLZ:	equ ((ptr_mus84-MusicIndex)/4)+bgm__First
bgm_SYZ:	equ ((ptr_mus85-MusicIndex)/4)+bgm__First
bgm_SBZ:	equ ((ptr_mus86-MusicIndex)/4)+bgm__First
bgm_Invincible:	equ ((ptr_mus87-MusicIndex)/4)+bgm__First
bgm_ExtraLife:	equ ((ptr_mus88-MusicIndex)/4)+bgm__First
bgm_SS:		equ ((ptr_mus89-MusicIndex)/4)+bgm__First
bgm_Title:	equ ((ptr_mus8A-MusicIndex)/4)+bgm__First
bgm_Ending:	equ ((ptr_mus8B-MusicIndex)/4)+bgm__First
bgm_Boss:	equ ((ptr_mus8C-MusicIndex)/4)+bgm__First
bgm_FZ:		equ ((ptr_mus8D-MusicIndex)/4)+bgm__First
bgm_GotThrough:	equ ((ptr_mus8E-MusicIndex)/4)+bgm__First
bgm_GameOver:	equ ((ptr_mus8F-MusicIndex)/4)+bgm__First
bgm_Continue:	equ ((ptr_mus90-MusicIndex)/4)+bgm__First
bgm_Credits:	equ ((ptr_mus91-MusicIndex)/4)+bgm__First
bgm_Drowning:	equ ((ptr_mus92-MusicIndex)/4)+bgm__First
bgm_Emerald:	equ ((ptr_mus93-MusicIndex)/4)+bgm__First
bgm__Last:	equ ((ptr_musend-MusicIndex-4)/4)+bgm__First

; Sound effects
sfx__First:	equ bgm__Last+1
sfx_Jump:	equ ((ptr_sndA0-SoundIndex)/4)+sfx__First
sfx_Lamppost:	equ ((ptr_sndA1-SoundIndex)/4)+sfx__First
sfx_A2:		equ ((ptr_sndA2-SoundIndex)/4)+sfx__First
sfx_Death:	equ ((ptr_sndA3-SoundIndex)/4)+sfx__First
sfx_Skid:	equ ((ptr_sndA4-SoundIndex)/4)+sfx__First
sfx_A5:		equ ((ptr_sndA5-SoundIndex)/4)+sfx__First
sfx_HitSpikes:	equ ((ptr_sndA6-SoundIndex)/4)+sfx__First
sfx_Push:	equ ((ptr_sndA7-SoundIndex)/4)+sfx__First
sfx_SSGoal:	equ ((ptr_sndA8-SoundIndex)/4)+sfx__First
sfx_SSItem:	equ ((ptr_sndA9-SoundIndex)/4)+sfx__First
sfx_Splash:	equ ((ptr_sndAA-SoundIndex)/4)+sfx__First
sfx_AB:		equ ((ptr_sndAB-SoundIndex)/4)+sfx__First
sfx_HitBoss:	equ ((ptr_sndAC-SoundIndex)/4)+sfx__First
sfx_Bubble:	equ ((ptr_sndAD-SoundIndex)/4)+sfx__First
sfx_Fireball:	equ ((ptr_sndAE-SoundIndex)/4)+sfx__First
sfx_Shield:	equ ((ptr_sndAF-SoundIndex)/4)+sfx__First
sfx_Saw:	equ ((ptr_sndB0-SoundIndex)/4)+sfx__First
sfx_Electric:	equ ((ptr_sndB1-SoundIndex)/4)+sfx__First
sfx_Drown:	equ ((ptr_sndB2-SoundIndex)/4)+sfx__First
sfx_Flamethrower:equ ((ptr_sndB3-SoundIndex)/4)+sfx__First
sfx_Bumper:	equ ((ptr_sndB4-SoundIndex)/4)+sfx__First
sfx_Ring:	equ ((ptr_sndB5-SoundIndex)/4)+sfx__First
sfx_SpikesMove:	equ ((ptr_sndB6-SoundIndex)/4)+sfx__First
sfx_Rumbling:	equ ((ptr_sndB7-SoundIndex)/4)+sfx__First
sfx_B8:		equ ((ptr_sndB8-SoundIndex)/4)+sfx__First
sfx_Collapse:	equ ((ptr_sndB9-SoundIndex)/4)+sfx__First
sfx_SSGlass:	equ ((ptr_sndBA-SoundIndex)/4)+sfx__First
sfx_Door:	equ ((ptr_sndBB-SoundIndex)/4)+sfx__First
sfx_Teleport:	equ ((ptr_sndBC-SoundIndex)/4)+sfx__First
sfx_ChainStomp:	equ ((ptr_sndBD-SoundIndex)/4)+sfx__First
sfx_Roll:	equ ((ptr_sndBE-SoundIndex)/4)+sfx__First
sfx_Continue:	equ ((ptr_sndBF-SoundIndex)/4)+sfx__First
sfx_Basaran:	equ ((ptr_sndC0-SoundIndex)/4)+sfx__First
sfx_BreakItem:	equ ((ptr_sndC1-SoundIndex)/4)+sfx__First
sfx_Warning:	equ ((ptr_sndC2-SoundIndex)/4)+sfx__First
sfx_GiantRing:	equ ((ptr_sndC3-SoundIndex)/4)+sfx__First
sfx_Bomb:	equ ((ptr_sndC4-SoundIndex)/4)+sfx__First
sfx_Cash:	equ ((ptr_sndC5-SoundIndex)/4)+sfx__First
sfx_RingLoss:	equ ((ptr_sndC6-SoundIndex)/4)+sfx__First
sfx_ChainRise:	equ ((ptr_sndC7-SoundIndex)/4)+sfx__First
sfx_Burning:	equ ((ptr_sndC8-SoundIndex)/4)+sfx__First
sfx_Bonus:	equ ((ptr_sndC9-SoundIndex)/4)+sfx__First
sfx_EnterSS:	equ ((ptr_sndCA-SoundIndex)/4)+sfx__First
sfx_WallSmash:	equ ((ptr_sndCB-SoundIndex)/4)+sfx__First
sfx_Spring:	equ ((ptr_sndCC-SoundIndex)/4)+sfx__First
sfx_Switch:	equ ((ptr_sndCD-SoundIndex)/4)+sfx__First
sfx_RingLeft:	equ ((ptr_sndCE-SoundIndex)/4)+sfx__First
sfx_Signpost:	equ ((ptr_sndCF-SoundIndex)/4)+sfx__First
sfx__Last:	equ ((ptr_sndend-SoundIndex-4)/4)+sfx__First

; Special sound effects
spec__First:	equ sfx__Last+1
sfx_Waterfall:	equ sfx__Last+1
spec__Last:	equ sfx__Last+1

flg__First:	equ spec__Last+1
bgm_Fade:	equ ((ptr_flgE0-Sound_ExIndex)/4)+flg__First
sfx_Sega:	equ ((ptr_flgE1-Sound_ExIndex)/4)+flg__First
bgm_Speedup:	equ ((ptr_flgE2-Sound_ExIndex)/4)+flg__First
bgm_Slowdown:	equ ((ptr_flgE3-Sound_ExIndex)/4)+flg__First
bgm_Stop:	equ ((ptr_flgE4-Sound_ExIndex)/4)+flg__First
flg__Last:	equ ((ptr_flgend-Sound_ExIndex-4)/4)+flg__First
	endif

	if SoundDriverType=2
; Music IDs
offset :=	zMasterPlaylist
ptrsize :=	1
idstart :=	$01
; Background music
bgm__First	= idstart
bgm_GHZ		= id(zMusIDPtr_GHZ)
bgm_LZ		= id(zMusIDPtr_LZ)
bgm_MZ		= id(zMusIDPtr_MZ)
bgm_SLZ		= id(zMusIDPtr_SLZ)
bgm_SYZ		= id(zMusIDPtr_SYZ)
bgm_SBZ		= id(zMusIDPtr_SBZ)
bgm_Invincible	= id(zMusIDPtr_Invinc)
bgm_ExtraLife	= id(zMusIDPtr_1UP)
bgm_SS		= id(zMusIDPtr_SS)
bgm_Title	= id(zMusIDPtr_Title)
bgm_Ending	= id(zMusIDPtr_Ending)
bgm_Boss	= id(zMusIDPtr_Boss)
bgm_FZ		= id(zMusIDPtr_FZ)
bgm_GotThrough	= id(zMusIDPtr_GotThrough)
bgm_GameOver	= id(zMusIDPtr_GameOver)
bgm_Continue	= id(zMusIDPtr_Continue)
bgm_Credits	= id(zMusIDPtr_Credits)
bgm_Drowning	= id(zMusIDPtr_Drowning)
bgm_Emerald	= id(zMusIDPtr_Emerald)
bgm__Last	= id(zMusIDPtr__End)

; Sound IDs
offset :=	SoundIndex
ptrsize :=	2
idstart :=	bgm__Last
; Sound effects
sfx__First	= idstart
sfx_Jump	= id(ptr_sndA0)
sfx_Lamppost	= id(ptr_sndA1)
sfx_A2		= id(ptr_sndA2)
sfx_Death	= id(ptr_sndA3)
sfx_Skid	= id(ptr_sndA4)
sfx_A5		= id(ptr_sndA5)
sfx_HitSpikes	= id(ptr_sndA6)
sfx_Push	= id(ptr_sndA7)
sfx_SSGoal	= id(ptr_sndA8)
sfx_SSItem	= id(ptr_sndA9)
sfx_Splash	= id(ptr_sndAA)
sfx_AB		= id(ptr_sndAB)
sfx_HitBoss	= id(ptr_sndAC)
sfx_Bubble	= id(ptr_sndAD)
sfx_Fireball	= id(ptr_sndAE)
sfx_Shield	= id(ptr_sndAF)
sfx_Saw		= id(ptr_sndB0)
sfx_Electric	= id(ptr_sndB1)
sfx_Drown	= id(ptr_sndB2)
sfx_Flamethrower	= id(ptr_sndB3)
sfx_Bumper	= id(ptr_sndB4)
sfx_Ring	= id(ptr_sndB5)
sfx_SpikesMove	= id(ptr_sndB6)
sfx_Rumbling	= id(ptr_sndB7)
sfx_B8		= id(ptr_sndB8)
sfx_Collapse	= id(ptr_sndB9)
sfx_SSGlass	= id(ptr_sndBA)
sfx_Door	= id(ptr_sndBB)
sfx_Teleport	= id(ptr_sndBC)
sfx_ChainStomp	= id(ptr_sndBD)
sfx_Roll	= id(ptr_sndBE)
sfx_Continue	= id(ptr_sndBF)
sfx_Basaran	= id(ptr_sndC0)
sfx_BreakItem	= id(ptr_sndC1)
sfx_Warning	= id(ptr_sndC2)
sfx_GiantRing	= id(ptr_sndC3)
sfx_Bomb	= id(ptr_sndC4)
sfx_Cash	= id(ptr_sndC5)
sfx_RingLoss	= id(ptr_sndC6)
sfx_ChainRise	= id(ptr_sndC7)
sfx_Burning	= id(ptr_sndC8)
sfx_Bonus	= id(ptr_sndC9)
sfx_EnterSS	= id(ptr_sndCA)
sfx_WallSmash	= id(ptr_sndCB)
sfx_Spring	= id(ptr_sndCC)
sfx_Switch	= id(ptr_sndCD)
sfx_RingLeft	= id(ptr_sndCE)
sfx_Signpost	= id(ptr_sndCF)
sfx_Waterfall:	= id(ptr_sndD0)
sfx__Last	= id(ptr_sndend)

; Sound command IDs
offset :=	zCommandIndex
ptrsize :=	4
idstart :=	sfx__Last
flg__First	= idstart
bgm_Fade	= id(CmdPtr_FadeOut)
sfx_Sega	= id(CmdPtr_SegaSound)
bgm_Speedup	= id(CmdPtr_SpeedUp)
bgm_Slowdown	= id(CmdPtr_SlowDown)
bgm_Stop	= id(CmdPtr_Stop)
flg__Last	= id(CmdPtr__End)
	endif

	if SoundDriverType=3
; Background music
	phase $01
bgm__First:	ds.b 0
bgm_GHZ:	ds.b 1
bgm_LZ:		ds.b 1
bgm_MZ:		ds.b 1
bgm_SLZ:	ds.b 1
bgm_SYZ:	ds.b 1
bgm_SBZ:	ds.b 1
bgm_Invincible:	ds.b 1
bgm_ExtraLife:	ds.b 1
bgm_SS:		ds.b 1
bgm_Title:	ds.b 1
bgm_Ending:	ds.b 1
bgm_Boss:	ds.b 1
bgm_FZ:		ds.b 1
bgm_GotThrough:	ds.b 1
bgm_GameOver:	ds.b 1
bgm_Continue:	ds.b 1
bgm_Credits:	ds.b 1
bgm_Drowning:	ds.b 1
bgm_Emerald:	ds.b 1
bgm__Last:	ds.b 1

; Sound effects
sfx__First:	ds.b 0
sfx_Jump:	ds.b 1
sfx_Lamppost:	ds.b 1
sfx_A2:		ds.b 1
sfx_Death:	ds.b 1
sfx_Skid:	ds.b 1
sfx_A5:		ds.b 1
sfx_HitSpikes:	ds.b 1
sfx_Push:	ds.b 1
sfx_SSGoal:	ds.b 1
sfx_SSItem:	ds.b 1
sfx_Splash:	ds.b 1
sfx_AB:		ds.b 1
sfx_HitBoss:	ds.b 1
sfx_Bubble:	ds.b 1
sfx_Fireball:	ds.b 1
sfx_Shield:	ds.b 1
sfx_Saw:	ds.b 1
sfx_Electric:	ds.b 1
sfx_Drown:	ds.b 1
sfx_Flamethrower:ds.b 1
sfx_Bumper:	ds.b 1
sfx_Ring:	ds.b 1
sfx_SpikesMove:	ds.b 1
sfx_Rumbling:	ds.b 1
sfx_B8:		ds.b 1
sfx_Collapse:	ds.b 1
sfx_SSGlass:	ds.b 1
sfx_Door:	ds.b 1
sfx_Teleport:	ds.b 1
sfx_ChainStomp:	ds.b 1
sfx_Roll:	ds.b 1
sfx_Continue:	ds.b 1
sfx_Basaran:	ds.b 1
sfx_BreakItem:	ds.b 1
sfx_Warning:	ds.b 1
sfx_GiantRing:	ds.b 1
sfx_Bomb:	ds.b 1
sfx_Cash:	ds.b 1
sfx_RingLoss:	ds.b 1
sfx_ChainRise:	ds.b 1
sfx_Burning:	ds.b 1
sfx_Bonus:	ds.b 1
sfx_EnterSS:	ds.b 1
sfx_WallSmash:	ds.b 1
sfx_Spring:	ds.b 1
sfx_Switch:	ds.b 1
sfx_RingLeft:	ds.b 1
sfx_Signpost:	ds.b 1
sfx__Last:	ds.b 1

; Special sound effects
spec__First:	ds.b 0
sfx_Waterfall:	ds.b 0
spec__Last:	ds.b 1

flg__First:	ds.b 0
bgm_Fade:	ds.b 1
sfx_Sega:	ds.b 1
bgm_Speedup:	ds.b 1
bgm_Slowdown:	ds.b 1
bgm_Stop:	ds.b 1
mus_StopSEGA:	ds.b 1
flg__Last:	ds.b 1
	dephase
	!org 0
	endif

; Sonic frame IDs
fr_Null:	equ 0
fr_Stand:	equ 1
fr_Wait1:	equ 2
fr_Wait2:	equ 3
fr_Wait3:	equ 4
fr_LookUp:	equ 5
fr_Walk11:	equ 6
fr_Walk12:	equ 7
fr_Walk13:	equ 8
fr_Walk14:	equ 9
fr_Walk15:	equ $A
fr_Walk16:	equ $B
fr_Walk21:	equ $C
fr_Walk22:	equ $D
fr_Walk23:	equ $E
fr_Walk24:	equ $F
fr_Walk25:	equ $10
fr_Walk26:	equ $11
fr_Walk31:	equ $12
fr_Walk32:	equ $13
fr_Walk33:	equ $14
fr_Walk34:	equ $15
fr_Walk35:	equ $16
fr_Walk36:	equ $17
fr_Walk41:	equ $18
fr_Walk42:	equ $19
fr_Walk43:	equ $1A
fr_Walk44:	equ $1B
fr_Walk45:	equ $1C
fr_Walk46:	equ $1D
fr_Run11:	equ $1E
fr_Run12:	equ $1F
fr_Run13:	equ $20
fr_Run14:	equ $21
fr_Run21:	equ $22
fr_Run22:	equ $23
fr_Run23:	equ $24
fr_Run24:	equ $25
fr_Run31:	equ $26
fr_Run32:	equ $27
fr_Run33:	equ $28
fr_Run34:	equ $29
fr_Run41:	equ $2A
fr_Run42:	equ $2B
fr_Run43:	equ $2C
fr_Run44:	equ $2D
fr_Roll1:	equ $2E
fr_Roll2:	equ $2F
fr_Roll3:	equ $30
fr_Roll4:	equ $31
fr_Roll5:	equ $32
fr_Warp1:	equ $33
fr_Warp2:	equ $34
fr_Warp3:	equ $35
fr_Warp4:	equ $36
fr_Stop1:	equ $37
fr_Stop2:	equ $38
fr_Duck:	equ $39
fr_Balance1:	equ $3A
fr_Balance2:	equ $3B
fr_Float1:	equ $3C
fr_Float2:	equ $3D
fr_Float3:	equ $3E
fr_Float4:	equ $3F
fr_Spring:	equ $40
fr_Hang1:	equ $41
fr_Hang2:	equ $42
fr_Leap1:	equ $43
fr_Leap2:	equ $44
fr_Push1:	equ $45
fr_Push2:	equ $46
fr_Push3:	equ $47
fr_Push4:	equ $48
fr_Surf:	equ $49
fr_BubStand:	equ $4A
fr_Burnt:	equ $4B
fr_Drown:	equ $4C
fr_Death:	equ $4D
fr_Shrink1:	equ $4E
fr_Shrink2:	equ $4F
fr_Shrink3:	equ $50
fr_Shrink4:	equ $51
fr_Shrink5:	equ $52
fr_Float5:	equ $53
fr_Float6:	equ $54
fr_Injury:	equ $55
fr_GetAir:	equ $56
fr_WaterSlide:	equ $57

; Boss locations
; The main values are based on where the camera boundaries mainly lie
; The end values are where the camera scrolls towards after defeat
boss_ghz_x:	equ $2960		; Green Hill Zone
boss_ghz_y:	equ $300
boss_ghz_end:	equ boss_ghz_x+$160

boss_lz_x:	equ $1DE0		; Labyrinth Zone
boss_lz_y:	equ $C0
boss_lz_end:	equ boss_lz_x+$250

boss_mz_x:	equ $1800		; Marble Zone
boss_mz_y:	equ $210
boss_mz_end:	equ boss_mz_x+$160

boss_slz_x:	equ $2000		; Star Light Zone
boss_slz_y:	equ $210
boss_slz_end:	equ boss_slz_x+$160

boss_syz_x:	equ $2C00		; Spring Yard Zone
boss_syz_y:	equ $4CC
boss_syz_end:	equ boss_syz_x+$140

boss_sbz2_x:	equ $2050		; Scrap Brain Zone Act 2 Cutscene
boss_sbz2_y:	equ $510

boss_fz_x:	equ $2450		; Final Zone
boss_fz_y:	equ $510
boss_fz_end:	equ boss_fz_x+$2B0

; Tile VRAM Locations

; Shared
ArtTile_GHZ_MZ_Swing:		equ $380
ArtTile_MZ_SYZ_Caterkiller:	equ $4FF
ArtTile_GHZ_SLZ_Smashable_Wall:	equ $50F

; Green Hill Zone
ArtTile_GHZ_Flower_4:		equ ArtTile_Level+$340
ArtTile_GHZ_Edge_Wall:		equ $34C
ArtTile_GHZ_Flower_Stalk:	equ ArtTile_Level+$358
ArtTile_GHZ_Big_Flower_1:	equ ArtTile_Level+$35C
ArtTile_GHZ_Small_Flower:	equ ArtTile_Level+$36C
ArtTile_GHZ_Waterfall:		equ ArtTile_Level+$378
ArtTile_GHZ_Flower_3:		equ ArtTile_Level+$380
ArtTile_GHZ_Bridge:		equ $38E
ArtTile_GHZ_Big_Flower_2:	equ ArtTile_Level+$390
ArtTile_GHZ_Spike_Pole:		equ $398
ArtTile_GHZ_Giant_Ball:		equ $3AA
ArtTile_GHZ_Purple_Rock:	equ $3D0

; Marble Zone
ArtTile_MZ_Block:		equ $2B8
ArtTile_MZ_Animated_Magma:	equ ArtTile_Level+$2D2
ArtTile_MZ_Animated_Lava:	equ ArtTile_Level+$2E2
ArtTile_MZ_Torch:		equ ArtTile_Level+$2F2
ArtTile_MZ_Spike_Stomper:	equ $300
ArtTile_MZ_Fireball:		equ $345
ArtTile_MZ_Glass_Pillar:	equ $38E
ArtTile_MZ_Lava:		equ $3A8

; Spring Yard Zone
ArtTile_SYZ_Bumper:		equ $380
ArtTile_SYZ_Big_Spikeball:	equ $396
ArtTile_SYZ_Spikeball_Chain:	equ $3BA

; Labyrinth Zone
ArtTile_LZ_Block_1:		equ $1E0
ArtTile_LZ_Block_2:		equ $1F0
ArtTile_LZ_Splash:		equ $259
ArtTile_LZ_Gargoyle:		equ $2E9
ArtTile_LZ_Water_Surface:	equ $300
ArtTile_LZ_Spikeball_Chain:	equ $310
ArtTile_LZ_Flapping_Door:	equ $328
ArtTile_LZ_Bubbles:		equ $348
ArtTile_LZ_Moving_Block:	equ $3BC
ArtTile_LZ_Door:		equ $3C4
ArtTile_LZ_Harpoon:		equ $3CC
ArtTile_LZ_Pole:		equ $3DE
ArtTile_LZ_Push_Block:		equ $3DE
ArtTile_LZ_Blocks:		equ $3E6
ArtTile_LZ_Conveyor_Belt:	equ $3F6
ArtTile_LZ_Sonic_Drowning:	equ $440
ArtTile_LZ_Rising_Platform:	equ ArtTile_LZ_Blocks+$69
ArtTile_LZ_Orbinaut:		equ $467
ArtTile_LZ_Cork:		equ ArtTile_LZ_Blocks+$11A

; Star Light Zone
ArtTile_SLZ_Seesaw:		equ $374
ArtTile_SLZ_Fan:		equ $3A0
ArtTile_SLZ_Pylon:		equ $3CC
ArtTile_SLZ_Swing:		equ $3DC
ArtTile_SLZ_Orbinaut:		equ $429
ArtTile_SLZ_Fireball:		equ $480
ArtTile_SLZ_Fireball_Launcher:	equ $4D8
ArtTile_SLZ_Collapsing_Floor:	equ $4E0
ArtTile_SLZ_Spikeball:		equ $4F0

; Scrap Brain Zone
ArtTile_SBZ_Caterkiller:	equ $2B0
ArtTile_SBZ_Moving_Block_Short:	equ $2C0
ArtTile_SBZ_Door:		equ $2E8
ArtTile_SBZ_Girder:		equ $2F0
ArtTile_SBZ_Disc:		equ $344
ArtTile_SBZ_Junction:		equ $348
ArtTile_SBZ_Swing:		equ $391
ArtTile_SBZ_Saw:		equ $3B5
ArtTile_SBZ_Flamethrower:	equ $3D9
ArtTile_SBZ_Collapsing_Floor:	equ $3F5
ArtTile_SBZ_Orbinaut:		equ $429
ArtTile_SBZ_Smoke_Puff_1:	equ ArtTile_Level+$448
ArtTile_SBZ_Smoke_Puff_2:	equ ArtTile_Level+$454
ArtTile_SBZ_Moving_Block_Long:	equ $460
ArtTile_SBZ_Horizontal_Door:	equ $46F
ArtTile_SBZ_Electric_Orb:	equ $47E
ArtTile_SBZ_Trap_Door:		equ $492
ArtTile_SBZ_Vanishing_Block:	equ $4C3
ArtTile_SBZ_Spinning_Platform:	equ $4DF

; Final Zone
ArtTile_FZ_Boss:		equ $300
ArtTile_FZ_Eggman_Fleeing:	equ $3A0
ArtTile_FZ_Eggman_No_Vehicle:	equ $470

; General Level Art
ArtTile_Level:			equ $000
ArtTile_Ball_Hog:		equ $302
ArtTile_Bomb:			equ $400
ArtTile_Crabmeat:		equ $400
ArtTile_Missile_Disolve:	equ $41C ; Unused
ArtTile_Buzz_Bomber:		equ $444
ArtTile_Chopper:		equ $47B
ArtTile_Yadrin:			equ $47B
ArtTile_Jaws:			equ $486
ArtTile_Newtron:		equ $49B
ArtTile_Burrobot:		equ $4A6
ArtTile_Basaran:		equ $4B8
ArtTile_Roller:			equ $4B8
ArtTile_Moto_Bug:		equ $4F0
ArtTile_Button:			equ $50F
ArtTile_Spikes:			equ $51B
ArtTile_Spring_Horizontal:	equ $523
ArtTile_Spring_Vertical:	equ $533
ArtTile_Shield:			equ $541
ArtTile_Invincibility:		equ $55C
ArtTile_Game_Over:		equ $55E
ArtTile_Title_Card:		equ $580
ArtTile_Animal_1:		equ $580
ArtTile_Animal_2:		equ $592
ArtTile_Explosion:		equ $5A0
ArtTile_Monitor:		equ $680
ArtTile_HUD:			equ $6CA
ArtTile_Sonic:			equ $780
ArtTile_Points:			equ $797
ArtTile_Lamppost:		equ $7A0
ArtTile_Ring:			equ $7B2
ArtTile_Lives_Counter:		equ $7D4

; Eggman
ArtTile_Eggman:			equ $400
ArtTile_Eggman_Weapons:		equ $46C
ArtTile_Eggman_Button:		equ $4A4
ArtTile_Eggman_Spikeball:	equ $518
ArtTile_Eggman_Trap_Floor:	equ $518
ArtTile_Eggman_Exhaust:		equ ArtTile_Eggman+$12A

; End of Level
ArtTile_Giant_Ring:		equ $400
ArtTile_Giant_Ring_Flash:	equ $462
ArtTile_Prison_Capsule:		equ $49D
ArtTile_Hidden_Points:		equ $4B6
ArtTile_Warp:			equ $541
ArtTile_Mini_Sonic:		equ $551
ArtTile_Bonuses:		equ $570
ArtTile_Signpost:		equ $680

; Title Screen
ArtTile_Title_Foreground:	equ $200
ArtTile_Title_Sonic:		equ $300
ArtTile_Title_Trademark:	equ $510
ArtTile_Level_Select_Font:	equ $680

; Continue Screen
ArtTile_Continue_Sonic:		equ $500

; Ending
ArtTile_Ending_Flowers:		equ $3A0
ArtTile_Ending_Emeralds:	equ $3C5
ArtTile_Ending_Sonic:		equ $3E1
ArtTile_Ending_Eggman:		equ $524
ArtTile_Ending_Rabbit:		equ $553
ArtTile_Ending_Chicken:		equ $565
ArtTile_Ending_Penguin:		equ $573
ArtTile_Ending_Seal:		equ $585
ArtTile_Ending_Pig:		equ $593
ArtTile_Ending_Flicky:		equ $5A5
ArtTile_Ending_Squirrel:	equ $5B3
ArtTile_Ending_STH:		equ $5C5

; Try Again Screen
ArtTile_Try_Again_Emeralds:	equ $3C5
ArtTile_Try_Again_Eggman:	equ $3E1

; Special Stage
ArtTile_SS_Background_Clouds:	equ $000
ArtTile_SS_Background_Fish:	equ $051
ArtTile_SS_Wall:		equ $142
ArtTile_SS_Bumper:		equ $23B
ArtTile_SS_Goal:		equ $251
ArtTile_SS_Up_Down:		equ $263
ArtTile_SS_R_Block:		equ $2F0
ArtTile_SS_Extra_Life:		equ $370
ArtTile_SS_Emerald_Sparkle:	equ $3F0
ArtTile_SS_Red_White_Block:	equ $470
ArtTile_SS_Ghost_Block:		equ $4F0
ArtTile_SS_W_Block:		equ $570
ArtTile_SS_Glass:		equ $5F0
ArtTile_SS_Emerald:		equ $770
ArtTile_SS_Zone_1:		equ $797
ArtTile_SS_Zone_2:		equ $7A0
ArtTile_SS_Zone_3:		equ $7A9
ArtTile_SS_Zone_4:		equ $797
ArtTile_SS_Zone_5:		equ $7A0
ArtTile_SS_Zone_6:		equ $7A9

; Special Stage Results
ArtTile_SS_Results_Emeralds:	equ $541

; Font
ArtTile_Sonic_Team_Font:	equ $0A6
ArtTile_Credits_Font:		equ $5A0
