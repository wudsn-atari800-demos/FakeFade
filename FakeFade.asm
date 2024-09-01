;
;	>> Fake Fade <<
;
;	A 64-byte intro for the Atari 800 XL (c) 2010-09-10 by JAC!
;
;	Fades the screen up and down again in graphics 9 (16 shades) by drawing random shade lines.
;	Background color cycles through every color at the speed 256/50 = 5 s.
;	Fade down starts after all background colors are displayed, i.e., after 82 s.
;	Can be loaded from any Atari DOS.
;
;	Creating this one was really fun, and the code contains some sequences that I'm happy about now.

;	For non Atarians:
;	The Atari executable format requires 8+4 = 12 bytes overhead.
;	So the code is only 52 (!) bytes ... I am wondering what rrrola would do with that  ;-)
;
;	For PC users:
;	No, there is no ESC support because Atarians and Chuck Norris use RESET instead.
;
;	Created using WUDSN IDE. Visit https://www.wudsn.com to increase my hit counter.

;	IOCB commands
open	= $03
close	= $0c
plot	= $09
draw	= $11
fill	= $12

iocom	= $342	;Command
ioadr	= $344	;Address
icaux1	= $034A	;Auxilary 1
icaux2	= $034B	;Auxilary 2
ciov	= $e456	;CIO vector

rowcrs	= $54	;Row of cursor, 1 byte
colcrs	= $55	;Column of cursor, 2 bytes

color	= $2fb	;Color for graphics operations


	org $8000		;Save to load from any DOS.

start	ldx #$60	;Channel 6
	lda #open	;Set open command
	sta iocom,x
;	lda #<screen	;ioadr,x points to $00 after startup
;	sta ioadr,x
;	lda #>screen
;	sta ioadr+1,x
	lda #'S'	;Instead of string definition "S:",$9B
 	sta $00


	lda #$18	;Graphics 8, $10 is ignored
	sta icaux2,x	;icaus1,x is already 0
 	sta 19		;Has bit 4 set
loop 	jsr ciov
 	stx 623		;$60 = $40 (GTIA 9) + $20 (ignored)
	lda 19		;Incremented every 256 frames
	asl
	asl
	asl
	asl
	sta 712		;Set color with brightness 0
 	ror color	;Toggles color with bit 4 of counter, only bit 0 is evaluated, rest is ignored

 	lda $d20a	;Random column
 	sta rowcrs
 	eor 20		;Pseudo random to save a byte
	sta colcrs
 	lda #draw	;Set draw command
	sta iocom,x
	bne loop

	run start
