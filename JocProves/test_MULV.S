.text
movi r0, 0x00
movhi r0, 0x11
mvrv v0, r0, 0

movi r0, 0x22
movhi r0, 0x33
mvrv v0, r0, 1

movi r0, 0x44
movhi r0, 0x55
mvrv v0, r0, 2

movi r0, 0x66
movhi r0, 0x77
mvrv v0, r0, 3

movi r0, 0x88
movhi r0, 0x99
mvrv v0, r0, 4

movi r0, 0xaa
movhi r0, 0xbb
mvrv v0, r0, 5

movi r0, 0xcc
movhi r0, 0xdd
mvrv v0, r0, 6

movi r0, 0xee
movhi r0, 0xff
mvrv v0, r0, 7

movi r0, 0xff
movhi r0, 0xee
mvrv v1, r0, 0

movi r0, 0xdd
movhi r0, 0xcc
mvrv v1, r0, 1

movi r0, 0xbb
movhi r0, 0xaa
mvrv v1, r0, 2

movi r0, 0x99
movhi r0, 0x88
mvrv v1, r0, 3

movi r0, 0x77
movhi r0, 0x66
mvrv v1, r0, 4

movi r0, 0x55
movhi r0, 0x44
mvrv v1, r0, 5

movi r0, 0x33
movhi r0, 0x22
mvrv v1, r0, 6

movi r0, 0x11
movhi r0, 0x00
mvrv v1, r0, 7

mulv v2, v0, v1
mulhv v3, v0, v1
mulhuv v4, v0, v1

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

addi r1, r1, 16

mvvr r0, v4, 0
st 0(r1), r0

mvvr r0, v4, 1
st 2(r1), r0

mvvr r0, v4, 2
st 4(r1), r0

mvvr r0, v4, 3
st 6(r1), r0

mvvr r0, v4, 4
st 8(r1), r0

mvvr r0, v4, 5
st 10(r1), r0

mvvr r0, v4, 6
st 12(r1), r0

mvvr r0, v4, 7
st 14(r1), r0

halt

