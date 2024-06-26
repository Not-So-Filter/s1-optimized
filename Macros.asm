; ---------------------------------------------------------------------------
; Set a VRAM address via the VDP control port.
; input: 16-bit VRAM address, control port (default is (vdp_control_port).l)
; ---------------------------------------------------------------------------

locVRAM:	macro loc,controlport
		if ("controlport"=="")
		move.l	#($40000000+(((loc)&$3FFF)<<16)+(((loc)&$C000)>>14)),(vdp_control_port).l
		else
		move.l	#($40000000+(((loc)&$3FFF)<<16)+(((loc)&$C000)>>14)),controlport
		endif
		endm

; ---------------------------------------------------------------------------
; DMA copy data from 68K (ROM/RAM) to the VRAM
; input: source, length, destination
; ---------------------------------------------------------------------------

writeVRAM:	macro source,length,destination
		move.l	#$94000000+(((length>>1)&$FF00)<<8)+$9300+((length>>1)&$FF),(a5)
		move.l	#$96000000+(((source>>1)&$FF00)<<8)+$9500+((source>>1)&$FF),(a5)
		move.w	#$9700+((((source>>1)&$FF0000)>>16)&$7F),(a5)
		move.w	#$4000+((destination)&$3FFF),(a5)
		move.w	#$80+(((destination)&$C000)>>14),(v_vdp_buffer2).w
		move.w	(v_vdp_buffer2).w,(a5)
		endm

; ---------------------------------------------------------------------------
; DMA copy data from 68K (ROM/RAM) to the CRAM
; input: source, length, destination
; ---------------------------------------------------------------------------

writeCRAM:	macro source,length,destination
		move.l	#$94000000+(((length>>1)&$FF00)<<8)+$9300+((length>>1)&$FF),(a5)
		move.l	#$96000000+(((source>>1)&$FF00)<<8)+$9500+((source>>1)&$FF),(a5)
		move.w	#$9700+((((source>>1)&$FF0000)>>16)&$7F),(a5)
		move.w	#$C000+(destination&$3FFF),(a5)
		move.w	#$80+((destination&$C000)>>14),(v_vdp_buffer2).w
		move.w	(v_vdp_buffer2).w,(a5)
		endm

; ---------------------------------------------------------------------------
; DMA fill VRAM with a value
; input: value, length, destination
; ---------------------------------------------------------------------------

fillVRAM:	macro value,length,loc
		lea	(vdp_control_port).l,a5
		move.w	#$8F01,(a5)
		move.l	#$94000000+((length&$FF00)<<8)+$9300+(length&$FF),(a5)
		move.w	#$9780,(a5)
		move.l	#$40000080+((loc&$3FFF)<<16)+((loc&$C000)>>14),(a5)
		move.w	#value,(vdp_data_port).l
		endm

; ---------------------------------------------------------------------------
; DMA fill VRAM with a value
; input: value, length, destination
; ---------------------------------------------------------------------------

fillVRAMsrcdefined:	macro value,length,loc
		move.w	#$8F01,(a5)
		move.l	#$94000000+((length&$FF00)<<8)+$9300+(length&$FF),(a5)
		move.w	#$9780,(a5)
		move.l	#$40000080+((loc&$3FFF)<<16)+((loc&$C000)>>14),(a5)
		move.w	#value,(vdp_data_port).l
		endm
		
; calculates initial loop counter value for a dbf loop
; that writes n bytes total at 4 bytes per iteration
bytesToLcnt function n,n>>2-1

; calculates initial loop counter value for a dbf loop
; that writes n bytes total at 2 bytes per iteration
bytesToWcnt function n,n>>1-1

; ---------------------------------------------------------------------------
; Fill portion of RAM with 0
; input: start, end
; ---------------------------------------------------------------------------

clearRAM:	macro start,end
		lea	(start).w,a1
		moveq	#0,d0
		move.w	#((end)-(start))/4-1,d1

.loop:
		move.l	d0,(a1)+
		dbf	d1,.loop

	if (end-start)&2
		move.w	d0,(a1)+
	endif

	if (end-start)&1
		move.b	d0,(a1)+
	endif
		endm

; ---------------------------------------------------------------------------
; Fill portion of RAM with 0
; input: start, end
; ---------------------------------------------------------------------------

clearRAMopt:	macro start,end
		lea	(start).w,a1
		moveq	#0,d0
		moveq	#((end)-(start))/4-1,d1

.loop:
		move.l	d0,(a1)+
		dbf	d1,.loop

	if (end-start)&2
		move.w	d0,(a1)+
	endif

	if (end-start)&1
		move.b	d0,(a1)+
	endif
		endm

; ---------------------------------------------------------------------------
; Copy a tilemap from 68K (ROM/RAM) to the VRAM without using DMA
; input: source, destination, width [cells], height [cells]
; ---------------------------------------------------------------------------

copyTilemap:	macro source,destination,width,height
	if ((source)&$8000)==0
		lea	(source).l,a1
	else
		lea	(source).w,a1
	endif
		locVRAM	destination,d0
		moveq	#width,d1
		moveq	#height,d2
		bsr.w	TilemapToVRAM
		endm

; ---------------------------------------------------------------------------
; Copy a tilemap from 68K (ROM/RAM) to the VRAM without using DMA
; input: source, destination, width [cells], height [cells]
; ---------------------------------------------------------------------------

copyTilemap_end:	macro source,destination,width,height
	if ((source)&$8000)==0
		lea	(source).l,a1
	else
		lea	(source).w,a1
	endif
		locVRAM	destination,d0
		moveq	#width,d1
		moveq	#height,d2
		bra.w	TilemapToVRAM
		endm

; ---------------------------------------------------------------------------
; stop the Z80
; ---------------------------------------------------------------------------

stopZ80:	macro
		move.w	#$100,(z80_bus_request).l
.wait:		tst.w	(z80_bus_request).l
		beq.s	.wait
		endm

; ---------------------------------------------------------------------------
; reset the Z80
; ---------------------------------------------------------------------------

resetZ80:	macro
		move.w	#$100,(z80_reset).l
		endm

resetZ80a:	macro
		move.w	#0,(z80_reset).l
		endm

; ---------------------------------------------------------------------------
; start the Z80
; ---------------------------------------------------------------------------

startZ80:	macro
		move.w	#0,(z80_bus_request).l
		endm
		
; function to make a little-endian 16-bit pointer for the Z80 sound driver
z80_ptr function x,(x)<<8&$FF00|(x)>>8&$7F|$80

; macro to declare a little-endian 16-bit pointer for the Z80 sound driver
rom_ptr_z80	macro addr
		dc.w z80_ptr(addr)
		endm
		
; Function to make a little endian (z80) pointer
k68z80Pointer function addr,((((addr&$7FFF)+$8000)<<8)&$FF00)+(((addr&$7FFF)+$8000)>>8)

little_endian function x,(x)<<8&$FF00|(x)>>8&$FF

startBank macro {INTLABEL}
	align	$8000
__LABEL__ label *
soundBankStart := __LABEL__
soundBankName := "__LABEL__"
    endm

DebugSoundbanks := 1

finishBank macro
	if * > soundBankStart + $8000
		fatal "soundBank \{soundBankName} must fit in $8000 bytes but was $\{*-soundBankStart}. Try moving something to the other bank."
	elseif (DebugSoundbanks<>0)&&(MOMPASS=1)
		message "soundBank \{soundBankName} has $\{$8000+soundBankStart-*} bytes free at end."
	endif
    endm

; macro to declare an entry in an offset table rooted at a bank
offsetBankTableEntry macro ptr
	dc.ATTRIBUTE k68z80Pointer(ptr-soundBankStart)
    endm

; Special BINCLUDE wrapper function
DACBINCLUDE macro file,{INTLABEL}
__LABEL__ label *
	BINCLUDE file
__LABEL___Len  := little_endian(*-__LABEL__)
__LABEL___Ptr  := k68z80Pointer(__LABEL__-soundBankStart)
__LABEL___Bank := soundBankStart
    endm

; Setup macro for DAC samples.
DAC_Setup macro rate,dacptr
	dc.b	rate
	dc.w	dacptr_Len
	dc.w	dacptr_Ptr
    endm

; Setup a null entry for a DAC sample.
DAC_Null_Setup macro rate
	dc.b	rate
	dc.w 	$0000,$0000
    endm

; Setup a chain-linked invalid entry for a DAC sample.
; The sample's length is correctly stored for the sample,
; while the pointer (usually) goes towards the DAC pointer
; entry of another DAC sample setup.
DAC_Null_Chain macro rate,linkptr
	dc.b	rate
	dc.w 	$0000,k68z80Pointer(linkptr+3-soundBankStart)
    endm

; ---------------------------------------------------------------------------
; disable interrupts
; ---------------------------------------------------------------------------

disable_ints:	macro
		move	#$2700,sr
		endm

; ---------------------------------------------------------------------------
; enable interrupts
; ---------------------------------------------------------------------------

enable_ints:	macro
		move	#$2300,sr
		endm

; ---------------------------------------------------------------------------
; check if object moves out of range
; input: location to jump to if out of range, x-axis pos (obX(a0) by default)
; ---------------------------------------------------------------------------

out_of_range:	macro exit,pos
		if ("pos"<>"")
		move.w	pos,d0		; get object position (if specified as not obX)
		else
		move.w	obX(a0),d0	; get object position
		endif
		andi.w	#$FF80,d0	; round down to nearest $80
		move.w	(v_screenposx).w,d1 ; get screen position
		subi.w	#128,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0		; approx distance between object and screen
	if GenesisPlusGXWide=1
		cmpi.w	#128+400+192,d0
	else
		cmpi.w	#128+320+192,d0
	endif
		bhi.ATTRIBUTE	exit
		endm

; ---------------------------------------------------------------------------
; bankswitch between SRAM and ROM
; (remember to enable SRAM in the header first!)
; ---------------------------------------------------------------------------

gotoSRAM:	macro
		move.b	#1,(sram_port).l
		endm

gotoROM:	macro
		move.b	#0,(sram_port).l
		endm

; ---------------------------------------------------------------------------
; compare the size of an index with ZoneCount constant
; (should be used immediately after the index)
; input: index address, element size
; ---------------------------------------------------------------------------

zonewarning:	macro loc,elementsize
._end:
		if (._end-loc)-(ZoneCount*elementsize)<>0
		warning "Size of loc (\{(._end-loc)/elementsize}) does not match ZoneCount (\{ZoneCount})."
		endif
		endm

; ---------------------------------------------------------------------------
; produce a packed art-tile
; ---------------------------------------------------------------------------

make_art_tile function addr,pal,pri,((pri&1)<<15)|((pal&3)<<13)|addr

; ---------------------------------------------------------------------------
; sprite mappings and DPLCs macros
; ---------------------------------------------------------------------------

SonicMappingsVer = 3
SonicDplcVer = 2
		include	"_maps/MapMacros.asm"

; ---------------------------------------------------------------------------
; turn a sample rate into a djnz loop counter
; ---------------------------------------------------------------------------
                                                                                
	if SoundDriverType<>2
pcmLoopCounter function sampleRate,baseCycles, 1+(53693175/15/(sampleRate)-(baseCycles)+(13/2))/13
dpcmLoopCounter function sampleRate, pcmLoopCounter(sampleRate,295/2) ; 295 is the number of cycles zPlayPCMLoop takes.
	endif