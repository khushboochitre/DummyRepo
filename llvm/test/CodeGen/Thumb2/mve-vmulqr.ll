; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-arm-none-eabi -verify-machineinstrs -mattr=+mve %s -o - | FileCheck %s

define arm_aapcs_vfpcc <4 x i32> @vmulqr_v4i32(<4 x i32> %src, i32 %src2, <4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: vmulqr_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmul.i32 q0, q0, r0
; CHECK-NEXT:    bx lr
entry:
  %i = insertelement <4 x i32> undef, i32 %src2, i32 0
  %sp = shufflevector <4 x i32> %i, <4 x i32> undef, <4 x i32> zeroinitializer
  %c = mul <4 x i32> %src, %sp
  ret <4 x i32> %c
}

define arm_aapcs_vfpcc <8 x i16> @vmulqr_v8i16(<8 x i16> %src, i16 %src2, <8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: vmulqr_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmul.i16 q0, q0, r0
; CHECK-NEXT:    bx lr
entry:
  %i = insertelement <8 x i16> undef, i16 %src2, i32 0
  %sp = shufflevector <8 x i16> %i, <8 x i16> undef, <8 x i32> zeroinitializer
  %c = mul <8 x i16> %src, %sp
  ret <8 x i16> %c
}

define arm_aapcs_vfpcc <16 x i8> @vmulqr_v16i8(<16 x i8> %src, i8 %src2, <16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: vmulqr_v16i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmul.i8 q0, q0, r0
; CHECK-NEXT:    bx lr
entry:
  %i = insertelement <16 x i8> undef, i8 %src2, i32 0
  %sp = shufflevector <16 x i8> %i, <16 x i8> undef, <16 x i32> zeroinitializer
  %c = mul <16 x i8> %src, %sp
  ret <16 x i8> %c
}

define arm_aapcs_vfpcc <4 x i32> @vmulqr_v4i32_2(<4 x i32> %src, i32 %src2, <4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: vmulqr_v4i32_2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmul.i32 q0, q0, r0
; CHECK-NEXT:    bx lr
entry:
  %i = insertelement <4 x i32> undef, i32 %src2, i32 0
  %sp = shufflevector <4 x i32> %i, <4 x i32> undef, <4 x i32> zeroinitializer
  %c = mul <4 x i32> %sp, %src
  ret <4 x i32> %c
}

define arm_aapcs_vfpcc <8 x i16> @vmulqr_v8i16_2(<8 x i16> %src, i16 %src2, <8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: vmulqr_v8i16_2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmul.i16 q0, q0, r0
; CHECK-NEXT:    bx lr
entry:
  %i = insertelement <8 x i16> undef, i16 %src2, i32 0
  %sp = shufflevector <8 x i16> %i, <8 x i16> undef, <8 x i32> zeroinitializer
  %c = mul <8 x i16> %sp, %src
  ret <8 x i16> %c
}

define arm_aapcs_vfpcc <16 x i8> @vmulqr_v16i8_2(<16 x i8> %src, i8 %src2, <16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: vmulqr_v16i8_2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmul.i8 q0, q0, r0
; CHECK-NEXT:    bx lr
entry:
  %i = insertelement <16 x i8> undef, i8 %src2, i32 0
  %sp = shufflevector <16 x i8> %i, <16 x i8> undef, <16 x i32> zeroinitializer
  %c = mul <16 x i8> %sp, %src
  ret <16 x i8> %c
}
