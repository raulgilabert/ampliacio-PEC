### Definicions internes del modul. No haurien d'usar-se ###
#
#

.macro $__push3 argnum p1 p2 p3 p4 p5 p6 p7 p8 p9
.if (\argnum)>0
	.ifnc \p1,void
		st [\argnum-1]*2(r7), \p1
		$__push3 \argnum-1 \p2 \p3 \p4 \p5 \p6 \p7 \p8 \p9 void
	.else
		$__push3 \argnum \p2 \p3 \p4 \p5 \p6 \p7 \p8 \p9 void
	.endif
.endif
.endm

.macro $__push2 argnum p1 p2 p3 p4 p5 p6 p7 p8 p9
    .ifnc \p1,void
	$__push2 \argnum+1 \p2 \p3 \p4 \p5 \p6 \p7 \p8 \p9 \p1
    .elseif (\argnum)==0
	.fail 100
    .else
	addi r7, r7, -(\argnum)*2
	$__push3 \argnum \p1 \p2 \p3 \p4 \p5 \p6 \p7 \p8 \p9
    .endif
.endm

.macro $__pop2 argnum p1 p2 p3 p4 p5 p6 p7 p8
    .ifnc \p1,void
	ld \p1, [\argnum]*2(r7)
	$__pop2 \argnum+1 \p2 \p3 \p4 \p5 \p6 \p7 \p8 void
    .elseif (\argnum)==0
	.fail 100
    .else
	addi r7, r7, [\argnum]*2(r7)
    .endif
.endm


### Macros definides per a l'us habitual ###
#
#

.macro $push p1=void p2=void p3=void p4=void p5=void p6=void p7=void p8=void
	$__push2 0 \p1 \p2 \p3 \p4 \p5 \p6 \p7 \p8 void
.endm

.macro $pop p1=void p2=void p3=void p4=void p5=void p6=void p7=void p8=void
	$__pop2 0 \p1 \p2 \p3 \p4 \p5 \p6 \p7 \p8
.endm

.macro $movei p1 imm16
	movi	\p1, lo(\imm16)
	movhi	\p1, hi(\imm16)
.endm

.macro $call p1 p2
	$movei	\p1 \p2
	jal	\p1, \p1
.endm

.macro $table_entry res id table_start
	$movei \res, \table_start ; res = table_start
	add \res, \res, \id	  ; res = table_start + id
	add \res, \res, \id 	  ; res = table_start + id*2
	ld \res, 0(\res)	  ; res = *(table_start + id*2)
.endm

.macro $save_ctx addr
	wrs s4, r0
	$movei r0, \addr
	ld r0, 0(r0)

	st 2(r0), r1
	st 4(r0), r2
	st 6(r0), r3
	st 8(r0), r4
	st 10(r0), r5
	st 12(r0), r6
	st 14(r0), r7
	rds r1, s4
	st 0(r0), r1

	rds r1, s1
	st 16(r0), r1 		; save pc

	rds r1, s0
	st 18(r0), r1 		; save psw
.endm

.macro $restore_ctx addr
	$movei r0, \addr
	ld r0, 0(r0)

	ld r1, 18(r0)
	wrs s0, r1 		; restore psw

	ld r1, 16(r0)
	wrs s1, r1 		; restore pc

	ld r7, 14(r0)
	ld r6, 12(r0)
	ld r5, 10(r0)
	ld r4, 8(r0)
	ld r3, 6(r0)
	ld r2, 4(r0)
	ld r1, 2(r0)
	ld r0, 0(r0)
.endm

### Macros per a les comparacions que falten en el SISA ###
#
#

.macro $CMPGT p1 p2 p3
	CMPLT \p1, \p3, \p2
.endm

.macro $CMPGE p1 p2 p3
	CMPLE \p1, \p3, \p2
.endm

.macro $CMPNE p1 p2 p3
	CMPEQ \p1, \p2, \p3
	NOT   \p1, \p1
	ADDI  \p1, \p1, 2
.endm

.macro $CMPGTU p1 p2 p3
	CMPLTU \p1, \p3, \p2
.endm

.macro $CMPGEU p1 p2 p3
	CMPLEU \p1, \p3, \p2
.endm
