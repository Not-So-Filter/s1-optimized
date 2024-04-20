; ---------------------------------------------------------------------------
; Object 21 - SCORE, TIME, RINGS
; ---------------------------------------------------------------------------

HUD:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		jmp	HUD_Index(pc,d0.w)
; ===========================================================================
HUD_Index:	bra.s	HUD_Main
		bra.s	HUD_Flash
; ===========================================================================

HUD_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.w	#$90,obX(a0)
		move.w	#$108,obScreenY(a0)
		move.l	#Map_HUD,obMap(a0)
		move.w	#make_art_tile(ArtTile_HUD,0,0),obGfx(a0)
		move.b	#0,obRender(a0)
		move.w	#0*$80,obPriority(a0)

HUD_Flash:	; Routine 2
		cmpi.b	#6,(v_player+obRoutine).w ; has Sonic just died?
		bhs.s	.yellow		; if yes, branch
		tst.w	(v_rings).w	; do you have any rings?
		beq.s	.norings	; if not, branch
		
.yellow:
		clr.b	obFrame(a0)	; make all counters yellow
		jmp	(DisplaySprite).l
; ===========================================================================

.norings:
		moveq	#0,d0
		btst	#3,(v_framebyte).w
		bne.s	.display
		addq.b	#1,d0		; make ring counter flash red
		cmpi.b	#9,(v_timemin).w ; have	9 minutes elapsed?
		bne.s	.display	; if not, branch
		addq.b	#2,d0		; make time counter flash red

.display:
		move.b	d0,obFrame(a0)
		jmp	(DisplaySprite).l