; ---------------------------------------------------------------------------
; Object 64 - bubbles (LZ)
; ---------------------------------------------------------------------------

Bubble:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Bub_Index(pc,d0.w),d1
		jmp	Bub_Index(pc,d1.w)
; ===========================================================================
Bub_Index:	dc.w Bub_Main-Bub_Index
		dc.w Bub_Animate-Bub_Index
		dc.w Bub_ChkWater-Bub_Index
		dc.w Bub_Display-Bub_Index
		dc.w Bub_Delete-Bub_Index
		dc.w Bub_BblMaker-Bub_Index

bub_inhalable = objoff_2E	; flag set when bubble is collectable
bub_origX = objoff_30		; original x-axis position
bub_time = objoff_32		; time until next bubble spawn
bub_freq = objoff_33		; frequency of bubble spawn
; ===========================================================================

Bub_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Bub,obMap(a0)
		move.w	#make_art_tile(ArtTile_LZ_Bubbles,0,1),obGfx(a0)
		move.b	#$84,obRender(a0)
		move.b	#$10,obActWid(a0)
		move.w	#1*$80,obPriority(a0)
		move.b	obSubtype(a0),d0 ; get bubble type
		bpl.s	.bubble		; if type is $0-$7F, branch

		addq.b	#8,obRoutine(a0) ; goto Bub_BblMaker next
		andi.w	#$7F,d0		; read only last 7 bits	(deduct	$80)
		move.b	d0,bub_time(a0)
		move.b	d0,bub_freq(a0)	; set bubble frequency
		move.b	#6,obAnim(a0)
		bra.w	Bub_BblMaker
; ===========================================================================

.bubble:
		move.b	d0,obAnim(a0)
		move.w	obX(a0),bub_origX(a0)
		move.w	#-$88,obVelY(a0) ; float bubble upwards
		jsr	(RandomNumber).w
		move.b	d0,obAngle(a0)

Bub_Animate:	; Routine 2
		lea	Ani_Bub(pc),a1
		jsr	(AnimateSprite).l
		cmpi.b	#6,obFrame(a0)	; is bubble full-size?
		bne.s	Bub_ChkWater	; if not, branch

		move.b	#1,bub_inhalable(a0) ; set "inhalable" flag

Bub_ChkWater:	; Routine 4
		move.w	(v_waterpos1).w,d0
		cmp.w	obY(a0),d0	; is bubble underwater?
		blo.s	.wobble		; if yes, branch

.burst:
		move.b	#6,obRoutine(a0) ; goto Bub_Display next
		addq.b	#3,obAnim(a0)	; run "bursting" animation
		bra.w	Bub_Display
; ===========================================================================

.wobble:
		move.b	obAngle(a0),d0
		addq.b	#1,obAngle(a0)
		andi.w	#$7F,d0
		lea	Drown_WobbleData(pc),a1
		move.b	(a1,d0.w),d0
		ext.w	d0
		add.w	bub_origX(a0),d0
		move.w	d0,obX(a0)	; change bubble's x-axis position
		tst.b	bub_inhalable(a0)
		beq.s	.display
		bsr.w	Bub_ChkSonic	; has Sonic touched the	bubble?
		beq.s	.display	; if not, branch

		bsr.w	ResumeMusic	; cancel countdown music
		moveq	#sfx_Bubble,d0
		jsr	(PlaySound).w	; play collecting bubble sound
		lea	(v_player).w,a1
		clr.w	obVelX(a1)
		clr.w	obVelY(a1)
		clr.w	obInertia(a1)	; stop Sonic
		move.b	#id_GetAir,obAnim(a1) ; use bubble-collecting animation
		move.w	#$23,objoff_3E(a1)
		move.b	#0,objoff_3C(a1)
		bclr	#5,obStatus(a1)
		bclr	#4,obStatus(a1)
		btst	#2,obStatus(a1)
		beq.s	.burst
		bclr	#2,obStatus(a1)
		move.b	#$13,obHeight(a1)
		move.b	#9,obWidth(a1)
		subq.w	#5,obY(a1)
		bra.w	.burst
; ===========================================================================

.display:
		bsr.w	SpeedToPos
		tst.b	obRender(a0)
		bpl.s	Bub_Delete
		bra.s	Bub_Display.display
; ===========================================================================

Bub_Display:	; Routine 6
		lea	Ani_Bub(pc),a1
		jsr	(AnimateSprite).l
		tst.b	obRender(a0)
		bpl.s	Bub_Delete
.display:
		bra.w	DisplaySprite
; ===========================================================================

Bub_Delete:	; Routine 8
		bra.w	DeleteObject
; ===========================================================================

Bub_BblMaker:	; Routine $A
		tst.w	objoff_36(a0)
		bne.s	.loc_12874
		move.w	(v_waterpos1).w,d0
		cmp.w	obY(a0),d0	; is bubble maker underwater?
		bhs.w	.chkdel		; if not, branch
		tst.b	obRender(a0)
		bpl.w	.chkdel
		subq.w	#1,objoff_38(a0)
		bpl.w	.loc_12914
		move.w	#1,objoff_36(a0)

.tryagain:
		jsr	(RandomNumber).w
		move.w	d0,d1
		andi.w	#7,d0
		cmpi.w	#6,d0		; random number over 6?
		bhs.s	.tryagain	; if yes, branch

		move.b	d0,objoff_34(a0)
		andi.w	#$C,d1
		lea	Bub_BblTypes(pc),a1
		adda.w	d1,a1
		move.l	a1,objoff_3C(a0)
		subq.b	#1,bub_time(a0)
		bpl.s	.loc_12872
		move.b	bub_freq(a0),bub_time(a0)
		bset	#7,objoff_36(a0)

.loc_12872:
		bra.s	.loc_1287C
; ===========================================================================

.loc_12874:
		subq.w	#1,objoff_38(a0)
		bpl.w	.loc_12914

.loc_1287C:
		jsr	(RandomNumber).w
		andi.w	#$1F,d0
		move.w	d0,objoff_38(a0)
		bsr.w	FindFreeObj
		bne.s	.fail
		move.b	#id_Bubble,obID(a1) ; load bubble object
		move.w	obX(a0),obX(a1)
		jsr	(RandomNumber).w
		andi.w	#$F,d0
		subq.w	#8,d0
		add.w	d0,obX(a1)
		move.w	obY(a0),obY(a1)
		moveq	#0,d0
		move.b	objoff_34(a0),d0
		movea.l	objoff_3C(a0),a2
		move.b	(a2,d0.w),obSubtype(a1)
		tst.w	objoff_36(a0)
		bpl.s	.fail
		jsr	(RandomNumber).w
		andi.w	#3,d0
		bne.s	.loc_buh
		bset	#6,objoff_36(a0)
		bne.s	.fail
		move.b	#2,obSubtype(a1)

.loc_buh:
		tst.b	objoff_34(a0)
		bne.s	.fail
		bset	#6,objoff_36(a0)
		bne.s	.fail
		move.b	#2,obSubtype(a1)

.fail:
		subq.b	#1,objoff_34(a0)
		bpl.s	.loc_12914
		jsr	(RandomNumber).w
		andi.w	#$7F,d0
		addi.w	#$80,d0
		add.w	d0,objoff_38(a0)
		clr.w	objoff_36(a0)

.loc_12914:
		lea	Ani_Bub(pc),a1
		jsr	(AnimateSprite).l

.chkdel:
		out_of_range.w	DeleteObject
		move.w	(v_waterpos1).w,d0
		cmp.w	obY(a0),d0
		blo.w	DisplaySprite
		rts
; ===========================================================================
; bubble production sequence

; 0 = small bubble, 1 =	large bubble

Bub_BblTypes:	dc.b 0,	1, 0, 0, 0, 0, 1, 0, 0,	0, 0, 1, 0, 1, 0, 0, 1,	0

; ===========================================================================

Bub_ChkSonic:
		tst.b	(f_playerctrl).w
		bmi.s	.loc_12998
		lea	(v_player).w,a1
		move.w	obX(a1),d0
		move.w	obX(a0),d1
		subi.w	#$10,d1
		cmp.w	d0,d1
		bhs.s	.loc_12998
		addi.w	#$20,d1
		cmp.w	d0,d1
		blo.s	.loc_12998
		move.w	obY(a1),d0
		move.w	obY(a0),d1
		cmp.w	d0,d1
		bhs.s	.loc_12998
		addi.w	#$10,d1
		cmp.w	d0,d1
		blo.s	.loc_12998
		moveq	#1,d0
		rts
; ===========================================================================

.loc_12998:
		moveq	#0,d0
		rts
