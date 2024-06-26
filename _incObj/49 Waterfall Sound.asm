; ---------------------------------------------------------------------------
; Object 49 - waterfall	sound effect (GHZ)
; ---------------------------------------------------------------------------

WaterSound:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		jmp	WSnd_Index(pc,d0.w)
; ===========================================================================
WSnd_Index:	bra.s	WSnd_Main
		bra.s	WSnd_PlaySnd
; ===========================================================================

WSnd_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.b	#4,obRender(a0)

WSnd_PlaySnd:	; Routine 2
		moveq	#$3F,d0
		and.b	(v_vbla_byte).w,d0 ; get low byte of VBlank counter
		bne.s	WSnd_ChkDel
		moveq	#sfx_Waterfall,d0
		jsr	(PlaySound_Special).w	; play waterfall sound

WSnd_ChkDel:
		out_of_range.w	DeleteObject
		rts	