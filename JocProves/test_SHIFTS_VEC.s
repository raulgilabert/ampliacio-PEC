.text
movi r0, 0xFF
movhi r0, 0xFF
mvrv v0, r0, 0

movi r0, 0xFF
movhi r0, 0xFF
mvrv v0, r0, 1

movi r0, 0xFF
movhi r0, 0xFF
mvrv v0, r0, 2

movi r0, 0xFF
movhi r0, 0xFF
mvrv v0, r0, 3

movi r0, 0xFF
movhi r0, 0xFF
mvrv v0, r0, 4

movi r0, 0xFF
movhi r0, 0xFF
mvrv v0, r0, 5

movi r0, 0xFF
movhi r0, 0xFF
mvrv v0, r0, 6

movi r0, 0xFF
movhi r0, 0xFF
mvrv v0, r0, 7

movi r0, 0
mvrv v1, r0, 0

movi r0, 3
mvrv v1, r0, 1

movi r0, 8
mvrv v1, r0, 2

movi r0, 15
mvrv v1, r0, 3

movi r0, 15
mvrv v1, r0, 4

movi r0, 16 ; -16
mvrv v1, r0, 5

movi r0, 20 ; -12
mvrv v1, r0, 6

movi r0, 31 ; -1
mvrv v1, r0, 7

shav v2, v0, v1
shlv v3, v0, v1

movi r1, 0x00
movhi r1, 0x00

mvvr r0, v2, 0
st 0(r1), r0

mvvr r0, v2, 1
st 2(r1), r0

mvvr r0, v2, 2
st 4(r1), r0

mvvr r0, v2, 3
st 6(r1), r0

mvvr r0, v2, 4
st 8(r1), r0

mvvr r0, v2, 5
st 10(r1), r0

mvvr r0, v2, 6
st 12(r1), r0

mvvr r0, v2, 7
st 14(r1), r0

addi r1, r1, 16

mvvr r0, v3, 0
st 0(r1), r0

mvvr r0, v3, 1
st 2(r1), r0

mvvr r0, v3, 2
st 4(r1), r0

mvvr r0, v3, 3
st 6(r1), r0

mvvr r0, v3, 4
st 8(r1), r0

mvvr r0, v3, 5
st 10(r1), r0

mvvr r0, v3, 6
st 12(r1), r0

mvvr r0, v3, 7
st 14(r1), r0

halt

