; ---------------------------------------------------------------------------
; Object 3E - prison capsule
; ---------------------------------------------------------------------------

Prison:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Pri_Index(pc,d0.w),d1
		jsr	Pri_Index(pc,d1.w)
		out_of_range.s	.delete
		jmp	(DisplaySprite).l

.delete:
		jmp	(DeleteObject).l
; ===========================================================================
Pri_Index:	dc.w Pri_Main-Pri_Index
		dc.w Pri_BodyMain-Pri_Index
		dc.w Pri_Switched-Pri_Index
		dc.w Pri_Explosion-Pri_Index
		dc.w Pri_Explosion-Pri_Index
		dc.w Pri_Explosion-Pri_Index
		dc.w Pri_Animals-Pri_Index
		dc.w Pri_EndAct-Pri_Index

pri_origY = objoff_30		; original y-axis position

Pri_Var:	dc.b 2,	$20
		dc.w 4*$80
		dc.b 0, 0
		dc.w 0	; routine, width, priority, frame, padding
		dc.b 4,	$C
		dc.w 5*$80
		dc.b 1, 0
		dc.w 0
		dc.b 6,	$10
		dc.w 4*$80
		dc.b 3, 0
		dc.w 0
		dc.b 8,	$10
		dc.w 3*$80
		dc.b 5, 0
		dc.w 0
; ===========================================================================

Pri_Main:	; Routine 0
		move.l	#Map_Pri,obMap(a0)
		move.w	#make_art_tile(ArtTile_Prison_Capsule,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	obY(a0),pri_origY(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		lsl.w	#3,d0
		lea	Pri_Var(pc,d0.w),a1
		move.b	(a1)+,obRoutine(a0)
		move.b	(a1)+,obActWid(a0)
		move.w	(a1)+,obPriority(a0)
		move.b	(a1)+,obFrame(a0)
		cmpi.w	#8,d0		; is object type number	02?
		bne.s	.not02		; if not, branch

		move.b	#6,obColType(a0)
		move.b	#8,obColProp(a0)

.not02:
		rts
; ===========================================================================

Pri_BodyMain:	; Routine 2
		cmpi.b	#2,(v_bossstatus).w
		beq.s	.chkopened
		moveq	#$2B,d1
		moveq	#$18,d2
		moveq	#$18,d3
		move.w	obX(a0),d4
		jmp	(SolidObject).l
; ===========================================================================

.chkopened:
		tst.b	ob2ndRout(a0)	; has the prison been opened?
		beq.s	.open		; if yes, branch
		clr.b	ob2ndRout(a0)
		bclr	#3,(v_player+obStatus).w
		bset	#1,(v_player+obStatus).w

.open:
		move.b	#2,obFrame(a0)	; use frame number 2 (destroyed	prison)
		rts
; ===========================================================================

Pri_Switched:	; Routine 4
		moveq	#$17,d1
		moveq	#8,d2
		moveq	#8,d3
		move.w	obX(a0),d4
		jsr	(SolidObject).l
		lea	Ani_Pri(pc),a1
		jsr	(AnimateSprite).l
		move.w	pri_origY(a0),obY(a0)
		tst.b	ob2ndRout(a0)	; has prison already been opened?
		beq.s	.open2		; if yes, branch

		addq.w	#8,obY(a0)
		move.b	#$A,obRoutine(a0)
		move.w	#60,obTimeFrame(a0) ; set time between animal spawns
		clr.b	(f_timecount).w	; stop time counter
		clr.b	(f_lockscreen).w ; lock screen position
		move.b	#1,(f_lockctrl).w ; lock controls
		move.w	#(btnR<<8),(v_jpadhold2).w ; make Sonic run to the right
		clr.b	ob2ndRout(a0)
		bclr	#3,(v_player+obStatus).w
		bset	#1,(v_player+obStatus).w

.open2:
		rts
; ===========================================================================

Pri_Explosion:	; Routine 6, 8, $A
		moveq	#7,d0
		and.b	(v_vbla_byte).w,d0
		bne.s	.noexplosion
		jsr	(FindFreeObj).l
		bne.s	.noexplosion
		move.b	#id_ExplosionBomb,obID(a1) ; load explosion object
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		jsr	(RandomNumber).w
		moveq	#0,d1
		move.b	d0,d1
		lsr.b	#2,d1
		subi.w	#$20,d1
		add.w	d1,obX(a1)
;		lsr.w	#8,d0
		move.w	d0,-(sp)		; (save 2 cycles, waste 4 bytes)
		clr.w	d0
		move.b	(sp)+,d0
		lsr.b	#3,d0
		add.w	d0,obY(a1)

.noexplosion:
		subq.w	#1,obTimeFrame(a0)
		beq.s	.makeanimal
		rts
; ===========================================================================

.makeanimal:
		move.b	#2,(v_bossstatus).w
		move.b	#$C,obRoutine(a0)	; replace explosions with animals
		move.b	#6,obFrame(a0)
		move.w	#150,obTimeFrame(a0)
		addi.w	#$20,obY(a0)
		moveq	#7,d6
		move.w	#$9A,d5
		moveq	#-$1C,d4

.loop:
		jsr	(FindFreeObj).l
		bne.s	.fail
		move.b	#id_Animals,obID(a1) ; load animal object
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		add.w	d4,obX(a1)
		addq.w	#7,d4
		move.w	d5,objoff_36(a1)
		subq.w	#8,d5
		dbf	d6,.loop	; repeat 7 more	times

.fail:
		rts
; ===========================================================================

Pri_Animals:	; Routine $C
		moveq	#7,d0
		and.b	(v_vbla_byte).w,d0
		bne.s	.noanimal
		jsr	(FindFreeObj).l
		bne.s	.noanimal
		move.b	#id_Animals,obID(a1) ; load animal object
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		jsr	(RandomNumber).w
		andi.w	#$1F,d0
		subq.w	#6,d0
		tst.w	d1
		bpl.s	.ispositive
		neg.w	d0

.ispositive:
		add.w	d0,obX(a1)
		move.w	#$C,objoff_36(a1)

.noanimal:
		subq.w	#1,obTimeFrame(a0)
		bne.s	.wait
		addq.b	#2,obRoutine(a0)
		move.w	#180,obTimeFrame(a0)

.wait:
		rts
; ===========================================================================

Pri_EndAct:	; Routine $E
		moveq	#(v_lvlobjend-v_lvlobjspace)/object_size-1,d0
		moveq	#id_Animals,d1
		lea	(v_lvlobjspace).w,a1

.findanimal:
		cmp.b	obID(a1),d1		; is object $28	(animal) loaded?
		beq.s	.found		; if yes, branch
		lea	object_size(a1),a1		; next object RAM
		dbf	d0,.findanimal	; repeat $3E times

		jsr	(GotThroughAct).l
		addq.l	#4,sp
		jmp	(DeleteObject).l

.found:
		rts	
