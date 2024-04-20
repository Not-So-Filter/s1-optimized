; ---------------------------------------------------------------------------
; Object 6F - spinning platforms that move around a conveyor belt (SBZ)
; ---------------------------------------------------------------------------

SpinConvey:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	SpinC_Index(pc,d0.w),d1
		jsr	SpinC_Index(pc,d1.w)
		out_of_range.s	loc_1629A,objoff_30(a0)

SpinC_Display:
		jmp	(DisplaySprite).l
; ===========================================================================

loc_1629A:
		cmpi.b	#2,(v_act).w	; check if act is 3
		bne.s	SpinC_Act1or2	; if not, branch
		cmpi.w	#-$80,d0
		bhs.s	SpinC_Display

SpinC_Act1or2:
		move.b	objoff_2F(a0),d0
		bpl.s	SpinC_Delete
		andi.w	#$7F,d0
		lea	(v_obj63).w,a2
		bclr	#0,(a2,d0.w)

SpinC_Delete:
		jmp	(DeleteObject).l
; ===========================================================================
SpinC_Index:	dc.w SpinC_Main-SpinC_Index
		dc.w loc_163D8-SpinC_Index
; ===========================================================================

SpinC_Main:	; Routine 0
		move.b	obSubtype(a0),d0
		bmi.w	loc_16380
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Spin,obMap(a0)
		move.w	#make_art_tile(ArtTile_SBZ_Spinning_Platform,0,0),obGfx(a0)
		move.b	#$10,obActWid(a0)
		ori.b	#4,obRender(a0)
		move.w	#4*$80,obPriority(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		move.w	d0,d1
		lsr.w	#3,d0
		andi.w	#$1E,d0
		lea	off_164A6(pc),a2
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,objoff_38(a0)
		move.w	(a2)+,objoff_30(a0)
		move.l	a2,objoff_3C(a0)
		andi.w	#$F,d1
		lsl.w	#2,d1
		move.b	d1,objoff_38(a0)
		move.b	#4,objoff_3A(a0)
		tst.b	(f_conveyrev).w
		beq.s	loc_16356
		move.b	#1,objoff_3B(a0)
		neg.b	objoff_3A(a0)
		moveq	#0,d1
		move.b	objoff_38(a0),d1
		add.b	objoff_3A(a0),d1
		cmp.b	objoff_39(a0),d1
		blo.s	loc_16352
		move.b	d1,d0
		moveq	#0,d1
		tst.b	d0
		bpl.s	loc_16352
		move.b	objoff_39(a0),d1
		subq.b	#4,d1

loc_16352:
		move.b	d1,objoff_38(a0)

loc_16356:
		move.w	(a2,d1.w),objoff_34(a0)
		move.w	2(a2,d1.w),objoff_36(a0)
		tst.w	d1
		bne.s	loc_1636C
		move.b	#1,obAnim(a0)

loc_1636C:
		cmpi.w	#8,d1
		bne.s	loc_16378
		move.b	#0,obAnim(a0)

loc_16378:
		bsr.w	LCon_ChangeDir
		bra.s	loc_163D8
; ===========================================================================

loc_16380:
		move.b	d0,objoff_2F(a0)
		andi.w	#$7F,d0
		lea	(v_obj63).w,a2
		bset	#0,(a2,d0.w)
		beq.s	loc_1639A
		addq.l	#4,sp
		jmp	(DeleteObject).l
; ===========================================================================

loc_1639A:
		add.w	d0,d0
		andi.w	#$1E,d0
		addi.w	#ObjPosSBZPlatform_Index-ObjPos_Index,d0
		lea	(ObjPos_Index).l,a2
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d1
		movea.l	a0,a1
		bra.s	SpinC_LoadPform
; ===========================================================================

SpinC_Loop:
		jsr	(FindFreeObj).l
		bne.s	loc_163D0

SpinC_LoadPform:
		move.b	#id_SpinConvey,obID(a1)
		move.w	(a2)+,obX(a1)
		move.w	(a2)+,obY(a1)
		move.w	(a2)+,d0
		move.b	d0,obSubtype(a1)

loc_163D0:
		dbf	d1,SpinC_Loop

		addq.l	#4,sp
		rts	
; ===========================================================================

loc_163D8:	; Routine 2
		lea	Ani_SpinConvey(pc),a1
		jsr	(AnimateSprite).l
		tst.b	obFrame(a0)
		bne.s	loc_16404
		move.w	obX(a0),-(sp)
		bsr.s	loc_16424
		moveq	#$1B,d1
		moveq	#7,d2
		moveq	#8,d3
		move.w	(sp)+,d4
		bra.w	SolidObject
; ===========================================================================

loc_16404:
		btst	#3,obStatus(a0)
		beq.s	loc_16424
		lea	(v_player).w,a1
		bclr	#3,obStatus(a1)
		bclr	#3,obStatus(a0)
		clr.b	obSolid(a0)

loc_16424:
		move.w	obX(a0),d0
		cmp.w	objoff_34(a0),d0
		bne.s	loc_16484
		move.w	obY(a0),d0
		cmp.w	objoff_36(a0),d0
		bne.s	loc_16484
		moveq	#0,d1
		move.b	objoff_38(a0),d1
		add.b	objoff_3A(a0),d1
		cmp.b	objoff_39(a0),d1
		blo.s	loc_16456
		move.b	d1,d0
		moveq	#0,d1
		tst.b	d0
		bpl.s	loc_16456
		move.b	objoff_39(a0),d1
		subq.b	#4,d1

loc_16456:
		move.b	d1,objoff_38(a0)
		movea.l	objoff_3C(a0),a1
		move.w	(a1,d1.w),objoff_34(a0)
		move.w	2(a1,d1.w),objoff_36(a0)
		tst.w	d1
		bne.s	loc_16474
		move.b	#1,obAnim(a0)

loc_16474:
		cmpi.w	#8,d1
		bne.s	loc_16480
		move.b	#0,obAnim(a0)

loc_16480:
		bsr.w	LCon_ChangeDir

loc_16484:
		jmp	(SpeedToPos).l
