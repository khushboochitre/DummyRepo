; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- | FileCheck %s

; Don't optimize away zext-inreg and sext-inreg on the loop induction
; variable, because it isn't safe to do so in these cases.

define void @count_up(double* %d, i64 %n) nounwind {
; CHECK-LABEL: count_up:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl $10, %eax
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB0_1: # %loop
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movzbl %al, %ecx
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm0, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rcx,8)
; CHECK-NEXT:    movl %eax, %ecx
; CHECK-NEXT:    andl $16777215, %ecx # imm = 0xFFFFFF
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm1, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rcx,8)
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm2, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rax,8)
; CHECK-NEXT:    incq %rax
; CHECK-NEXT:    jne .LBB0_1
; CHECK-NEXT:  # %bb.2: # %return
; CHECK-NEXT:    retq
entry:
	br label %loop

loop:
	%indvar = phi i64 [ 10, %entry ], [ %indvar.next, %loop ]
	%indvar.i8 = and i64 %indvar, 255
	%t0 = getelementptr double, double* %d, i64 %indvar.i8
	%t1 = load double, double* %t0
	%t2 = fmul double %t1, 0.1
	store double %t2, double* %t0
	%indvar.i24 = and i64 %indvar, 16777215
	%t3 = getelementptr double, double* %d, i64 %indvar.i24
	%t4 = load double, double* %t3
	%t5 = fmul double %t4, 2.3
	store double %t5, double* %t3
	%t6 = getelementptr double, double* %d, i64 %indvar
	%t7 = load double, double* %t6
	%t8 = fmul double %t7, 4.5
	store double %t8, double* %t6
	%indvar.next = add i64 %indvar, 1
	%exitcond = icmp eq i64 %indvar.next, 0
	br i1 %exitcond, label %return, label %loop

return:
	ret void
}

define void @count_down(double* %d, i64 %n) nounwind {
; CHECK-LABEL: count_down:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl $10, %eax
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB1_1: # %loop
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movzbl %al, %ecx
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm0, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rcx,8)
; CHECK-NEXT:    movl %eax, %ecx
; CHECK-NEXT:    andl $16777215, %ecx # imm = 0xFFFFFF
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm1, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rcx,8)
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm2, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rax,8)
; CHECK-NEXT:    decq %rax
; CHECK-NEXT:    cmpq $20, %rax
; CHECK-NEXT:    jne .LBB1_1
; CHECK-NEXT:  # %bb.2: # %return
; CHECK-NEXT:    retq
entry:
	br label %loop

loop:
	%indvar = phi i64 [ 10, %entry ], [ %indvar.next, %loop ]
	%indvar.i8 = and i64 %indvar, 255
	%t0 = getelementptr double, double* %d, i64 %indvar.i8
	%t1 = load double, double* %t0
	%t2 = fmul double %t1, 0.1
	store double %t2, double* %t0
	%indvar.i24 = and i64 %indvar, 16777215
	%t3 = getelementptr double, double* %d, i64 %indvar.i24
	%t4 = load double, double* %t3
	%t5 = fmul double %t4, 2.3
	store double %t5, double* %t3
	%t6 = getelementptr double, double* %d, i64 %indvar
	%t7 = load double, double* %t6
	%t8 = fmul double %t7, 4.5
	store double %t8, double* %t6
	%indvar.next = sub i64 %indvar, 1
	%exitcond = icmp eq i64 %indvar.next, 20
	br i1 %exitcond, label %return, label %loop

return:
	ret void
}

define void @count_up_signed(double* %d, i64 %n) nounwind {
; CHECK-LABEL: count_up_signed:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl $10, %eax
; CHECK-NEXT:    movl $167772160, %ecx # imm = 0xA000000
; CHECK-NEXT:    movl $2560, %edx # imm = 0xA00
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB2_1: # %loop
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movq %rdx, %rsi
; CHECK-NEXT:    sarq $8, %rsi
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm0, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rsi,8)
; CHECK-NEXT:    movq %rcx, %rsi
; CHECK-NEXT:    sarq $24, %rsi
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm1, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rsi,8)
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm2, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rax,8)
; CHECK-NEXT:    addq $16777216, %rcx # imm = 0x1000000
; CHECK-NEXT:    addq $256, %rdx # imm = 0x100
; CHECK-NEXT:    incq %rax
; CHECK-NEXT:    jne .LBB2_1
; CHECK-NEXT:  # %bb.2: # %return
; CHECK-NEXT:    retq
entry:
	br label %loop

loop:
	%indvar = phi i64 [ 10, %entry ], [ %indvar.next, %loop ]
        %s0 = shl i64 %indvar, 8
	%indvar.i8 = ashr i64 %s0, 8
	%t0 = getelementptr double, double* %d, i64 %indvar.i8
	%t1 = load double, double* %t0
	%t2 = fmul double %t1, 0.1
	store double %t2, double* %t0
	%s1 = shl i64 %indvar, 24
	%indvar.i24 = ashr i64 %s1, 24
	%t3 = getelementptr double, double* %d, i64 %indvar.i24
	%t4 = load double, double* %t3
	%t5 = fmul double %t4, 2.3
	store double %t5, double* %t3
	%t6 = getelementptr double, double* %d, i64 %indvar
	%t7 = load double, double* %t6
	%t8 = fmul double %t7, 4.5
	store double %t8, double* %t6
	%indvar.next = add i64 %indvar, 1
	%exitcond = icmp eq i64 %indvar.next, 0
	br i1 %exitcond, label %return, label %loop

return:
	ret void
}

define void @count_down_signed(double* %d, i64 %n) nounwind {
; CHECK-LABEL: count_down_signed:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movq $-10, %rax
; CHECK-NEXT:    movl $167772160, %ecx # imm = 0xA000000
; CHECK-NEXT:    movl $2560, %edx # imm = 0xA00
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB3_1: # %loop
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movq %rdx, %rsi
; CHECK-NEXT:    sarq $8, %rsi
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm0, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rsi,8)
; CHECK-NEXT:    movq %rcx, %rsi
; CHECK-NEXT:    sarq $24, %rsi
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm1, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rsi,8)
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm2, %xmm3
; CHECK-NEXT:    movsd %xmm3, 160(%rdi,%rax,8)
; CHECK-NEXT:    addq $-16777216, %rcx # imm = 0xFF000000
; CHECK-NEXT:    addq $-256, %rdx
; CHECK-NEXT:    decq %rax
; CHECK-NEXT:    jne .LBB3_1
; CHECK-NEXT:  # %bb.2: # %return
; CHECK-NEXT:    retq
entry:
	br label %loop

loop:
	%indvar = phi i64 [ 10, %entry ], [ %indvar.next, %loop ]
        %s0 = shl i64 %indvar, 8
	%indvar.i8 = ashr i64 %s0, 8
	%t0 = getelementptr double, double* %d, i64 %indvar.i8
	%t1 = load double, double* %t0
	%t2 = fmul double %t1, 0.1
	store double %t2, double* %t0
	%s1 = shl i64 %indvar, 24
	%indvar.i24 = ashr i64 %s1, 24
	%t3 = getelementptr double, double* %d, i64 %indvar.i24
	%t4 = load double, double* %t3
	%t5 = fmul double %t4, 2.3
	store double %t5, double* %t3
	%t6 = getelementptr double, double* %d, i64 %indvar
	%t7 = load double, double* %t6
	%t8 = fmul double %t7, 4.5
	store double %t8, double* %t6
	%indvar.next = sub i64 %indvar, 1
	%exitcond = icmp eq i64 %indvar.next, 20
	br i1 %exitcond, label %return, label %loop

return:
	ret void
}

define void @another_count_up(double* %d, i64 %n) nounwind {
; CHECK-LABEL: another_count_up:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB4_1: # %loop
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movzbl %al, %ecx
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm0, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rcx,8)
; CHECK-NEXT:    movl %eax, %ecx
; CHECK-NEXT:    andl $16777215, %ecx # imm = 0xFFFFFF
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm1, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rcx,8)
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm2, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rax,8)
; CHECK-NEXT:    incq %rax
; CHECK-NEXT:    cmpq %rax, %rsi
; CHECK-NEXT:    jne .LBB4_1
; CHECK-NEXT:  # %bb.2: # %return
; CHECK-NEXT:    retq
entry:
        br label %loop

loop:
        %indvar = phi i64 [ 0, %entry ], [ %indvar.next, %loop ]
        %indvar.i8 = and i64 %indvar, 255
        %t0 = getelementptr double, double* %d, i64 %indvar.i8
        %t1 = load double, double* %t0
        %t2 = fmul double %t1, 0.1
        store double %t2, double* %t0
        %indvar.i24 = and i64 %indvar, 16777215
        %t3 = getelementptr double, double* %d, i64 %indvar.i24
        %t4 = load double, double* %t3
        %t5 = fmul double %t4, 2.3
        store double %t5, double* %t3
        %t6 = getelementptr double, double* %d, i64 %indvar
        %t7 = load double, double* %t6
        %t8 = fmul double %t7, 4.5
        store double %t8, double* %t6
        %indvar.next = add i64 %indvar, 1
        %exitcond = icmp eq i64 %indvar.next, %n
        br i1 %exitcond, label %return, label %loop

return:
        ret void
}

define void @another_count_down(double* %d, i64 %n) nounwind {
; CHECK-LABEL: another_count_down:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB5_1: # %loop
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movzbl %sil, %eax
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm0, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rax,8)
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    andl $16777215, %eax # imm = 0xFFFFFF
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm1, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rax,8)
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm2, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rsi,8)
; CHECK-NEXT:    decq %rsi
; CHECK-NEXT:    cmpq $10, %rsi
; CHECK-NEXT:    jne .LBB5_1
; CHECK-NEXT:  # %bb.2: # %return
; CHECK-NEXT:    retq
entry:
        br label %loop

loop:
        %indvar = phi i64 [ %n, %entry ], [ %indvar.next, %loop ]
        %indvar.i8 = and i64 %indvar, 255
        %t0 = getelementptr double, double* %d, i64 %indvar.i8
        %t1 = load double, double* %t0
        %t2 = fmul double %t1, 0.1
        store double %t2, double* %t0
        %indvar.i24 = and i64 %indvar, 16777215
        %t3 = getelementptr double, double* %d, i64 %indvar.i24
        %t4 = load double, double* %t3
        %t5 = fmul double %t4, 2.3
        store double %t5, double* %t3
        %t6 = getelementptr double, double* %d, i64 %indvar
        %t7 = load double, double* %t6
        %t8 = fmul double %t7, 4.5
        store double %t8, double* %t6
        %indvar.next = sub i64 %indvar, 1
        %exitcond = icmp eq i64 %indvar.next, 10
        br i1 %exitcond, label %return, label %loop

return:
        ret void
}

define void @another_count_up_signed(double* %d, i64 %n) nounwind {
; CHECK-LABEL: another_count_up_signed:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xorl %r8d, %r8d
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    movq %rdi, %rdx
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB6_1: # %loop
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movq %r8, %rax
; CHECK-NEXT:    sarq $8, %rax
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm0, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rax,8)
; CHECK-NEXT:    movq %rcx, %rax
; CHECK-NEXT:    sarq $24, %rax
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm1, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rax,8)
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm2, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdx)
; CHECK-NEXT:    addq $8, %rdx
; CHECK-NEXT:    addq $16777216, %rcx # imm = 0x1000000
; CHECK-NEXT:    addq $256, %r8 # imm = 0x100
; CHECK-NEXT:    decq %rsi
; CHECK-NEXT:    jne .LBB6_1
; CHECK-NEXT:  # %bb.2: # %return
; CHECK-NEXT:    retq
entry:
        br label %loop

loop:
        %indvar = phi i64 [ 0, %entry ], [ %indvar.next, %loop ]
        %s0 = shl i64 %indvar, 8
        %indvar.i8 = ashr i64 %s0, 8
        %t0 = getelementptr double, double* %d, i64 %indvar.i8
        %t1 = load double, double* %t0
        %t2 = fmul double %t1, 0.1
        store double %t2, double* %t0
        %s1 = shl i64 %indvar, 24
        %indvar.i24 = ashr i64 %s1, 24
        %t3 = getelementptr double, double* %d, i64 %indvar.i24
        %t4 = load double, double* %t3
        %t5 = fmul double %t4, 2.3
        store double %t5, double* %t3
        %t6 = getelementptr double, double* %d, i64 %indvar
        %t7 = load double, double* %t6
        %t8 = fmul double %t7, 4.5
        store double %t8, double* %t6
        %indvar.next = add i64 %indvar, 1
        %exitcond = icmp eq i64 %indvar.next, %n
        br i1 %exitcond, label %return, label %loop

return:
        ret void
}

define void @another_count_down_signed(double* %d, i64 %n) nounwind {
; CHECK-LABEL: another_count_down_signed:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    shlq $24, %rax
; CHECK-NEXT:    leaq -10(%rsi), %rcx
; CHECK-NEXT:    shlq $8, %rsi
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB7_1: # %loop
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movq %rsi, %rdx
; CHECK-NEXT:    sarq $8, %rdx
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm0, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rdx,8)
; CHECK-NEXT:    movq %rax, %rdx
; CHECK-NEXT:    sarq $24, %rdx
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm1, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rdx,8)
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm2, %xmm3
; CHECK-NEXT:    movsd %xmm3, 80(%rdi,%rcx,8)
; CHECK-NEXT:    addq $-16777216, %rax # imm = 0xFF000000
; CHECK-NEXT:    addq $-256, %rsi
; CHECK-NEXT:    decq %rcx
; CHECK-NEXT:    jne .LBB7_1
; CHECK-NEXT:  # %bb.2: # %return
; CHECK-NEXT:    retq
entry:
        br label %loop

loop:
        %indvar = phi i64 [ %n, %entry ], [ %indvar.next, %loop ]
        %s0 = shl i64 %indvar, 8
        %indvar.i8 = ashr i64 %s0, 8
        %t0 = getelementptr double, double* %d, i64 %indvar.i8
        %t1 = load double, double* %t0
        %t2 = fmul double %t1, 0.1
        store double %t2, double* %t0
        %s1 = shl i64 %indvar, 24
        %indvar.i24 = ashr i64 %s1, 24
        %t3 = getelementptr double, double* %d, i64 %indvar.i24
        %t4 = load double, double* %t3
        %t5 = fmul double %t4, 2.3
        store double %t5, double* %t3
        %t6 = getelementptr double, double* %d, i64 %indvar
        %t7 = load double, double* %t6
        %t8 = fmul double %t7, 4.5
        store double %t8, double* %t6
        %indvar.next = sub i64 %indvar, 1
        %exitcond = icmp eq i64 %indvar.next, 10
        br i1 %exitcond, label %return, label %loop

return:
        ret void
}

define void @yet_another_count_down(double* %d, i64 %n) nounwind {
; CHECK-LABEL: yet_another_count_down:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movq $-2040, %rax # imm = 0xF808
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; CHECK-NEXT:    movq %rdi, %rcx
; CHECK-NEXT:    movq %rdi, %rdx
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB8_1: # %loop
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm0, %xmm3
; CHECK-NEXT:    movsd %xmm3, 2040(%rdi,%rax)
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm1, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rcx)
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm2, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdx)
; CHECK-NEXT:    addq $-8, %rdx
; CHECK-NEXT:    addq $134217720, %rcx # imm = 0x7FFFFF8
; CHECK-NEXT:    addq $2040, %rax # imm = 0x7F8
; CHECK-NEXT:    jne .LBB8_1
; CHECK-NEXT:  # %bb.2: # %return
; CHECK-NEXT:    retq
entry:
	br label %loop

loop:
	%indvar = phi i64 [ 0, %entry ], [ %indvar.next, %loop ]
	%indvar.i8 = and i64 %indvar, 255
	%t0 = getelementptr double, double* %d, i64 %indvar.i8
	%t1 = load double, double* %t0
	%t2 = fmul double %t1, 0.1
	store double %t2, double* %t0
	%indvar.i24 = and i64 %indvar, 16777215
	%t3 = getelementptr double, double* %d, i64 %indvar.i24
	%t4 = load double, double* %t3
	%t5 = fmul double %t4, 2.3
	store double %t5, double* %t3
	%t6 = getelementptr double, double* %d, i64 %indvar
	%t7 = load double, double* %t6
	%t8 = fmul double %t7, 4.5
	store double %t8, double* %t6
	%indvar.next = sub i64 %indvar, 1
	%exitcond = icmp eq i64 %indvar.next, 18446744073709551615
	br i1 %exitcond, label %return, label %loop

return:
	ret void
}

define void @yet_another_count_up(double* %d, i64 %n) nounwind {
; CHECK-LABEL: yet_another_count_up:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB9_1: # %loop
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movzbl %al, %ecx
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm0, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rcx,8)
; CHECK-NEXT:    movl %eax, %ecx
; CHECK-NEXT:    andl $16777215, %ecx # imm = 0xFFFFFF
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm1, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rcx,8)
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm2, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rax,8)
; CHECK-NEXT:    addq $3, %rax
; CHECK-NEXT:    cmpq $10, %rax
; CHECK-NEXT:    jne .LBB9_1
; CHECK-NEXT:  # %bb.2: # %return
; CHECK-NEXT:    retq
entry:
        br label %loop

loop:
        %indvar = phi i64 [ 0, %entry ], [ %indvar.next, %loop ]
        %indvar.i8 = and i64 %indvar, 255
        %t0 = getelementptr double, double* %d, i64 %indvar.i8
        %t1 = load double, double* %t0
        %t2 = fmul double %t1, 0.1
        store double %t2, double* %t0
        %indvar.i24 = and i64 %indvar, 16777215
        %t3 = getelementptr double, double* %d, i64 %indvar.i24
        %t4 = load double, double* %t3
        %t5 = fmul double %t4, 2.3
        store double %t5, double* %t3
        %t6 = getelementptr double, double* %d, i64 %indvar
        %t7 = load double, double* %t6
        %t8 = fmul double %t7, 4.5
        store double %t8, double* %t6
        %indvar.next = add i64 %indvar, 3
        %exitcond = icmp eq i64 %indvar.next, 10
        br i1 %exitcond, label %return, label %loop

return:
        ret void
}

define void @still_another_count_down(double* %d, i64 %n) nounwind {
; CHECK-LABEL: still_another_count_down:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl $10, %eax
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB10_1: # %loop
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movzbl %al, %ecx
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm0, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rcx,8)
; CHECK-NEXT:    movl %eax, %ecx
; CHECK-NEXT:    andl $16777215, %ecx # imm = 0xFFFFFF
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm1, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rcx,8)
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm2, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rax,8)
; CHECK-NEXT:    addq $-3, %rax
; CHECK-NEXT:    jne .LBB10_1
; CHECK-NEXT:  # %bb.2: # %return
; CHECK-NEXT:    retq
entry:
        br label %loop

loop:
        %indvar = phi i64 [ 10, %entry ], [ %indvar.next, %loop ]
        %indvar.i8 = and i64 %indvar, 255
        %t0 = getelementptr double, double* %d, i64 %indvar.i8
        %t1 = load double, double* %t0
        %t2 = fmul double %t1, 0.1
        store double %t2, double* %t0
        %indvar.i24 = and i64 %indvar, 16777215
        %t3 = getelementptr double, double* %d, i64 %indvar.i24
        %t4 = load double, double* %t3
        %t5 = fmul double %t4, 2.3
        store double %t5, double* %t3
        %t6 = getelementptr double, double* %d, i64 %indvar
        %t7 = load double, double* %t6
        %t8 = fmul double %t7, 4.5
        store double %t8, double* %t6
        %indvar.next = sub i64 %indvar, 3
        %exitcond = icmp eq i64 %indvar.next, 0
        br i1 %exitcond, label %return, label %loop

return:
        ret void
}

define void @yet_another_count_up_signed(double* %d, i64 %n) nounwind {
; CHECK-LABEL: yet_another_count_up_signed:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movq $-10, %rax
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB11_1: # %loop
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movq %rcx, %rsi
; CHECK-NEXT:    sarq $8, %rsi
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm0, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rsi,8)
; CHECK-NEXT:    movq %rdx, %rsi
; CHECK-NEXT:    sarq $24, %rsi
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm1, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rsi,8)
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm2, %xmm3
; CHECK-NEXT:    movsd %xmm3, 80(%rdi,%rax,8)
; CHECK-NEXT:    addq $50331648, %rdx # imm = 0x3000000
; CHECK-NEXT:    addq $768, %rcx # imm = 0x300
; CHECK-NEXT:    addq $3, %rax
; CHECK-NEXT:    jne .LBB11_1
; CHECK-NEXT:  # %bb.2: # %return
; CHECK-NEXT:    retq
entry:
        br label %loop

loop:
        %indvar = phi i64 [ 0, %entry ], [ %indvar.next, %loop ]
        %s0 = shl i64 %indvar, 8
        %indvar.i8 = ashr i64 %s0, 8
        %t0 = getelementptr double, double* %d, i64 %indvar.i8
        %t1 = load double, double* %t0
        %t2 = fmul double %t1, 0.1
        store double %t2, double* %t0
        %s1 = shl i64 %indvar, 24
        %indvar.i24 = ashr i64 %s1, 24
        %t3 = getelementptr double, double* %d, i64 %indvar.i24
        %t4 = load double, double* %t3
        %t5 = fmul double %t4, 2.3
        store double %t5, double* %t3
        %t6 = getelementptr double, double* %d, i64 %indvar
        %t7 = load double, double* %t6
        %t8 = fmul double %t7, 4.5
        store double %t8, double* %t6
        %indvar.next = add i64 %indvar, 3
        %exitcond = icmp eq i64 %indvar.next, 10
        br i1 %exitcond, label %return, label %loop

return:
        ret void
}

define void @yet_another_count_down_signed(double* %d, i64 %n) nounwind {
; CHECK-LABEL: yet_another_count_down_signed:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl $10, %eax
; CHECK-NEXT:    movl $167772160, %ecx # imm = 0xA000000
; CHECK-NEXT:    movl $2560, %edx # imm = 0xA00
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB12_1: # %loop
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movq %rdx, %rsi
; CHECK-NEXT:    sarq $8, %rsi
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm0, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rsi,8)
; CHECK-NEXT:    movq %rcx, %rsi
; CHECK-NEXT:    sarq $24, %rsi
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm1, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rsi,8)
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm2, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rax,8)
; CHECK-NEXT:    addq $-50331648, %rcx # imm = 0xFD000000
; CHECK-NEXT:    addq $-768, %rdx # imm = 0xFD00
; CHECK-NEXT:    addq $-3, %rax
; CHECK-NEXT:    jne .LBB12_1
; CHECK-NEXT:  # %bb.2: # %return
; CHECK-NEXT:    retq
entry:
        br label %loop

loop:
        %indvar = phi i64 [ 10, %entry ], [ %indvar.next, %loop ]
        %s0 = shl i64 %indvar, 8
        %indvar.i8 = ashr i64 %s0, 8
        %t0 = getelementptr double, double* %d, i64 %indvar.i8
        %t1 = load double, double* %t0
        %t2 = fmul double %t1, 0.1
        store double %t2, double* %t0
        %s1 = shl i64 %indvar, 24
        %indvar.i24 = ashr i64 %s1, 24
        %t3 = getelementptr double, double* %d, i64 %indvar.i24
        %t4 = load double, double* %t3
        %t5 = fmul double %t4, 2.3
        store double %t5, double* %t3
        %t6 = getelementptr double, double* %d, i64 %indvar
        %t7 = load double, double* %t6
        %t8 = fmul double %t7, 4.5
        store double %t8, double* %t6
        %indvar.next = sub i64 %indvar, 3
        %exitcond = icmp eq i64 %indvar.next, 0
        br i1 %exitcond, label %return, label %loop

return:
        ret void
}



