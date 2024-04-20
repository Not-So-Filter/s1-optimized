; ===========================================================================
; ----------------------------------------------------------------------------
; Object 15 - Swinging platform from Aquatic Ruin Zone
; ----------------------------------------------------------------------------
; Sprite_FC9C:
SwingingPlatform:
		btst	#6,obRender(a0)
		bne.s	+
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj15_Index(pc,d0.w),d1
		jmp	Obj15_Index(pc,d1.w)
; ---------------------------------------------------------------------------
+
		move.w	#4*$80,d0
		bra.w	DisplaySprite2
; ===========================================================================
; off_FCBC: Obj15_States:
Obj15_Index:	dc.w Swing_Main-Obj15_Index		;  0
		dc.w Swing_Action2-Obj15_Index		;  2
		dc.w Swing_Display-Obj15_Index		;  4
		dc.w Obj15_State4-Obj15_Index		;  6
		dc.w Obj15_State5-Obj15_Index		;  8
		dc.w Obj15_State6-Obj15_Index		; $A
		dc.w Obj15_State7-Obj15_Index		; $C
; ===========================================================================
; loc_FCCA:
Swing_Main:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Swing_GHZ,obMap(a0) ; GHZ and MZ specific code
		move.w	#make_art_tile(ArtTile_GHZ_MZ_Swing,2,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$18,obActWid(a0)
		move.b	#8,obHeight(a0)
		move.w	obY(a0),objoff_38(a0)
		move.w	obX(a0),objoff_3A(a0)
		cmpi.b	#id_SLZ,(v_zone).w ; check if level is SLZ
		bne.s	.notSLZ
		move.l	#Map_Swing_SLZ,obMap(a0) ; SLZ specific code
		move.w	#make_art_tile(ArtTile_SLZ_Swing,2,0),obGfx(a0)
		move.b	#$20,obActWid(a0)
		move.b	#$10,obHeight(a0)
		move.b	#$99,obColType(a0)
.notSLZ:
		cmpi.b	#id_SBZ,(v_zone).w ; check if level is SBZ
		bne.s	.length
		move.l	#Map_BBall,obMap(a0) ; SBZ specific code
		move.w	#make_art_tile(ArtTile_SBZ_Swing,0,0),obGfx(a0)
		move.b	#$18,obActWid(a0)
		move.b	#$18,obHeight(a0)
		move.b	#$86,obColType(a0)
		move.b	#$C,obRoutine(a0) ; goto Swing_Action next
.length:
		moveq	#0,d1
		move.b	obSubtype(a0),d1
		bpl.s	+
		addq.b	#4,obRoutine(a0)
+
		move.b	d1,d4
		andi.b	#$70,d4
		andi.w	#$F,d1
		move.w	obX(a0),d2
		move.w	obY(a0),d3
		jsr	FindNextFreeObj
		bne.w	+++
		move.b	obID(a0),obID(a1) ; load obj15
		move.l	obMap(a0),obMap(a1)
		move.w	obGfx(a0),obGfx(a1)
		move.b	#4,obRender(a1)
		cmpi.b	#$20,d4
		bne.s	+
		move.b	#4,obRoutine(a1)
		move.w	#4*$80,obPriority(a1)
		move.b	#$10,obActWid(a1)
		move.b	#$50,obHeight(a1)
		bset	#4,obRender(a1)
		move.b	#3,mapping_frame(a1)
		move.w	d2,obX(a1)
		addi.w	#$40,d3
		move.w	d3,obY(a1)
		addi.w	#$48,d3
		move.w	d3,obY(a0)
		bra.s	++
; ===========================================================================
+
		bset	#6,obRender(a1)
		move.b	#$48,mainspr_width(a1)
		move.b	d1,mainspr_childsprites(a1)
		subq.b	#1,d1
		lea	subspr_data(a1),a2

-		move.w	d2,(a2)+	; sub?_obX
		move.w	d3,(a2)+	; sub?_obY
		move.w	#1,(a2)+	; sub2_mapframe
		addi.w	#$10,d3
		dbf	d1,-

		move.b	#2,sub2_mapframe(a1)
		move.w	sub6_x_pos(a1),obX(a1)
		move.w	sub6_y_pos(a1),obY(a1)
		move.w	d2,sub6_x_pos(a1)
		move.w	d3,sub6_y_pos(a1)
		move.b	#1,mainspr_mapframe(a1)
		addq.w	#8,d3
		move.w	d3,obY(a0)
		move.b	#$50,mainspr_height(a1)
		bset	#4,obRender(a1)
+
		move.l	a1,objoff_30(a0)
+
		move.w	#$8000,obAngle(a0)
		move.w	#0,objoff_3E(a0)
		move.b	obSubtype(a0),d1
		andi.w	#$70,d1
		move.b	d1,obSubtype(a0)
;		cmpi.b	#$40,d1
;		bne.s	Swing_Action2
;		move.l	#Obj15_MapUnc_102DE,obMap(a0)
;		move.b	#$A7,obColType(a0)

; loc_FE50:
Swing_Action2:
		move.w	obX(a0),-(sp)
		bsr.s	sub_FE70
		moveq	#0,d1
		move.b	obActWid(a0),d1
		moveq	#0,d3
		move.b	obHeight(a0),d3
		addq.b	#1,d3
		move.w	(sp)+,d4
		jsr	PlatformObject2
		bra.w	loc_1000C

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_FE70:
		moveq	#0,d0
		moveq	#0,d1
		move.b	(v_oscillate+$18).w,d0
		move.b	obSubtype(a0),d1
		beq.s	loc_FEC2
		cmpi.b	#$10,d1
		bne.s	++
		cmpi.b	#$3F,d0
		beq.s	+
		bhs.s	loc_FEC2
		moveq	#$40,d0
		bra.s	loc_FEC2
; ===========================================================================
/
		moveq	#SndID_PlatformKnock,d0
		jsr	(PlaySoundLocal).w
		moveq	#$40,d0
		bra.s	loc_FEC2
; ===========================================================================
+
		cmpi.b	#$20,d1
		beq.w	+++	; rts
		cmpi.b	#$30,d1
		bne.s	+
		cmpi.b	#$41,d0
		beq.s	-
		blo.s	loc_FEC2
		moveq	#$40,d0
		bra.s	loc_FEC2
; ===========================================================================
+
		cmpi.b	#$40,d1
		bne.s	loc_FEC2
		bsr.w	loc_FF6E

loc_FEC2:
		move.b	objoff_2E(a0),d1
		cmp.b	d0,d1
		beq.w	++	; rts
		move.b	d0,objoff_2E(a0)
		move.w	#$80,d1
		btst	#0,obStatus(a0)
		beq.s	+
		neg.w	d0
		add.w	d1,d0
+
		jsr	(CalcSine).w
		move.w	objoff_38(a0),d2
		move.w	objoff_3A(a0),d3
		moveq	#0,d6
		movea.l	objoff_30(a0),a1
		move.b	mainspr_childsprites(a1),d6
		subq.w	#1,d6
		bcs.s	+	; rts
		swap	d0
		swap	d1
		asr.l	#4,d0
		asr.l	#4,d1
		moveq	#0,d4
		moveq	#0,d5
		lea	subspr_data(a1),a2

-		move.l	d4,-(sp)
		move.l	d5,-(sp)
		swap	d4
		swap	d5
		add.w	d2,d4
		add.w	d3,d5
		move.w	d5,(a2)+	; sub?_obX
		move.w	d4,(a2)+	; sub?_obY
		move.l	(sp)+,d4
		move.l	(sp)+,d5
		add.l	d0,d4
		add.l	d1,d5
		addq.w	#next_subspr-4,a2
		dbf	d6,-

		move.l	d4,-(sp)
		move.l	d5,-(sp)
		swap	d4
		swap	d5
		add.w	d2,d4
		add.w	d3,d5
		move.w	sub6_obX(a1),d2
		move.w	sub6_obY(a1),d3
		move.w	d5,sub6_obX(a1)
		move.w	d4,sub6_obY(a1)
		move.w	d2,obX(a1)
		move.w	d3,obY(a1)
		move.l	(sp)+,d4
		move.l	(sp)+,d5
		asr.l	#1,d0
		asr.l	#1,d1
		add.l	d0,d4
		add.l	d1,d5
		swap	d4
		swap	d5
		add.w	objoff_38(a0),d4
		add.w	objoff_3A(a0),d5
		move.w	d4,obY(a0)
		move.w	d5,obX(a0)
+
		rts
; End of function sub_FE70

; ===========================================================================

loc_FF6E:
		tst.w	objoff_36(a0)
		beq.s	+
		subq.w	#1,objoff_36(a0)
		bra.w	loc_10006
; ===========================================================================
+
		tst.b	objoff_34(a0)
		bne.s	+
		move.w	(MainCharacter+obX).w,d0
		sub.w	objoff_3A(a0),d0
		addi.w	#$20,d0
		cmpi.w	#$40,d0
		bhs.s	loc_10006
		tst.w	(Debug_placement_mode).w
		bne.s	loc_10006
		move.b	#1,objoff_34(a0)
+
		tst.b	objoff_3D(a0)
		beq.s	+
		move.w	objoff_3E(a0),d0
		addq.w	#8,d0
		move.w	d0,objoff_3E(a0)
		add.w	d0,obAngle(a0)
		cmpi.w	#$200,d0
		bne.s	loc_10006
		move.w	#0,objoff_3E(a0)
		move.w	#$8000,obAngle(a0)
		move.b	#0,objoff_3D(a0)
		move.w	#60,objoff_36(a0)
		bra.s	loc_10006
; ===========================================================================
+
		move.w	objoff_3E(a0),d0
		subq.w	#8,d0
		move.w	d0,objoff_3E(a0)
		add.w	d0,obAngle(a0)
		cmpi.w	#$FE00,d0
		bne.s	loc_10006
		move.w	#0,objoff_3E(a0)
		move.w	#$4000,obAngle(a0)
		move.b	#1,objoff_3D(a0)
; loc_10000:
		move.w	#60,objoff_36(a0)

loc_10006:
		move.b	obAngle(a0),d0
		rts
; ===========================================================================

loc_1000C:
		tst.b	(Two_player_mode).w
		beq.s	+
		bra.w	DisplaySprite
; ===========================================================================
+
		move.w	objoff_3A(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_obX_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.s	+
		bra.w	DisplaySprite
; ===========================================================================
+
		movea.l	objoff_30(a0),a1
		bsr.w	DeleteObject2
		bra.w	DeleteObject
; ===========================================================================

Swing_Display: ;;
		bra.w	DisplaySprite
; ===========================================================================

; loc_1003E:
Obj15_State4:
		move.w	obX(a0),-(sp)
		bsr.w	sub_FE70
		moveq	#0,d1
		move.b	obActWid(a0),d1
		moveq	#0,d3
		move.b	obHeight(a0),d3
		addq.b	#1,d3
		move.w	(sp)+,d4
		jsr	PlatformObject2
		moveq	#standonobject,d0
		and.b	obStatus(a0),d0
		beq.s	loc_1000C
		tst.b	(v_oscillate+$18).w
		bne.s	loc_1000C
		jsr	FindNextFreeObj
		bne.s	loc_100E4
		moveq	#0,d0

		moveq	#bytesToLcnt(object_size),d1
-		move.l	(a0,d0.w),(a1,d0.w)
		addq.w	#4,d0
		dbf	d1,-
	if object_size&3
		move.w	(a0,d0.w),(a1,d0.w)
	endif

		move.b	#$A,obRoutine(a1)
;		cmpi.b	#aquatic_ruin_zone,(Current_Zone).w
;		bne.s	+
;		addq.b	#2,obRoutine(a1)
+
		move.w	#$200,obVelX(a1)
		btst	#0,obStatus(a0)
		beq.s	+
		neg.w	obVelX(a1)
+
		bset	#1,obStatus(a1)
		move.w	a0,d0
		subi.w	#v_objspace,d0
		lsr.w	#object_size_bits,d0
		andi.w	#$7F,d0
		move.w	a1,d1
		subi.w	#v_objspace,d1
		lsr.w	#object_size_bits,d1
		andi.w	#$7F,d1
		lea	(v_player).w,a1 ; a1=character
		cmp.b	standonobject(a1),d0
		bne.s	loc_100E4
		move.b	d1,standonobject(a1)

loc_100E4:
		move.b	#3,obFrame(a0)
		addq.b	#2,obRoutine(a0)
		andi.b	#$E7,obStatus(a0)

BranchTo_loc_1000C ; BranchTo
		bra.w	loc_1000C
; ===========================================================================
; loc_100F8:
Obj15_State5:
		bsr.w	sub_FE70
		bra.w	loc_1000C
; ===========================================================================
; loc_10100:
Obj15_State6:
		move.w	obX(a0),-(sp)
		btst	#1,obStatus(a0)
		beq.s	+
		bsr.w	SpeedToPos
		addi.w	#$18,obVelY(a0)
		cmpi.w	#$720,obY(a0)
		blo.s	++
		move.w	#$720,obY(a0)
		bclr	#1,obStatus(a0)
		move.w	#0,obVelX(a0)
		move.w	#0,obVelY(a0)
		move.w	obY(a0),objoff_38(a0)
		bra.s	++
; ===========================================================================
+
		moveq	#0,d0
		move.b	(v_oscillate+$14).w,d0
		lsr.w	#1,d0
		add.w	objoff_38(a0),d0
		move.w	d0,obY(a0)
+
		moveq	#0,d1
		move.b	obActWid(a0),d1
		moveq	#0,d3
		move.b	obHeight(a0),d3
		addq.b	#1,d3
		move.w	(sp)+,d4
		jsr	PlatformObject2
		bra.w	MarkObjGone
; ===========================================================================
; loc_10166:
Obj15_State7:
		move.w	obX(a0),-(sp)
		bsr.w	SpeedToPos
		btst	#1,obStatus(a0)
		beq.s	+
		addi.w	#$18,obVelY(a0)
		move.w	(Water_Level_2).w,d0
		cmp.w	obY(a0),d0
		bhi.s	++
		move.w	d0,obY(a0)
		move.w	d0,objoff_38(a0)
		bclr	#1,obStatus(a0)
		move.w	#$100,obVelX(a0)
		move.w	#0,obVelY(a0)
		bra.s	++
; ===========================================================================
+
		moveq	#0,d0
		move.b	(v_oscillate+$14).w,d0
		lsr.w	#1,d0
		add.w	objoff_38(a0),d0
		move.w	d0,obY(a0)
		tst.w	obVelX(a0)
		beq.s	+
		moveq	#0,d3
		move.b	obActWid(a0),d3
		jsr	ObjCheckRightWallDist
		tst.w	d1
		bpl.s	+
		add.w	d1,obX(a0)
		move.w	#0,obVelX(a0)
+
		moveq	#0,d1
		move.b	obActWid(a0),d1
		moveq	#0,d3
		move.b	obHeight(a0),d3
		addq.b	#1,d3
		move.w	(sp)+,d4
		jsr	PlatformObject2
		bra.w	MarkObjGone