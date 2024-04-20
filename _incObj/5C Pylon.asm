; ---------------------------------------------------------------------------
; Object 5C - metal pylons in foreground (SLZ)
; ---------------------------------------------------------------------------

Pylon:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		jmp	Pyl_Index(pc,d0.w)
; ===========================================================================
Pyl_Index:	bra.s	Pyl_Main
		bra.s	Pyl_Display
; ===========================================================================

Pyl_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Pylon,obMap(a0)
		move.w	#make_art_tile(ArtTile_SLZ_Pylon,0,1),obGfx(a0)
		move.b	#$10,obActWid(a0)

Pyl_Display:	; Routine 2
		move.w	(v_screenposx).w,d0
		asl.w	#1,d0
		neg.w	d0
		move.w	d0,obX(a0)
		move.w	(v_screenposy).w,d0
		asl.w	#1,d0
		andi.w	#$3F,d0
		neg.w	d0
		addi.w	#$100,d1
		move.w	d1,obScreenY(a0)
		bra.w	DisplaySprite