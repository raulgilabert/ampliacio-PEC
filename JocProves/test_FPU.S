.macro $movei p1 imm16

movi    \p1, lo(\imm16)

movhi   \p1, hi(\imm16)

.endm





.text

$MOVEI r1, 0xD0D0  ;-6

$MOVEI r2, 0x0002

st 0(r2), r1

ldf f1, 0(r2)

$MOVEI r1, 0xBE80  ;-0.25

$MOVEI r2, 0x0004

st 0(r2), r1

ldf f2, 0(r2)

addf f0, f1, f2

stf 2(r2), f0

subf f0, f1, f2

stf 4(r2), f0

mulf f0, f1, f2

stf 6(r2), f0

divf f0, f1, f2

stf 8(r2), f0

cmpltf r1, f1, f2

st 0xA(r2), r1

cmplef r1, f1, f2

st 0xC(r2), r1

cmpeqf r1, f1, f2

st 0xE(r2), r1

halt

