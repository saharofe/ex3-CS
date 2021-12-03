    .file "pstring.s"
    .data
    .section    .rodata
error: .string "invalid input!\n"  #error string for printf
    .text
.global pstrlen
    .type   pstrlen, @function
.global replaceChar
    .type   replaceChar, @function
.global pstrijcpy
    .type   pstrijcpy, @function
.global swapCase
    .type   swapCase, @function
.global pstrijcmp
    .type   pstrijcmp, @function

# *pstring in %rdi
pstrlen:
    push %rbp
    movq %rsp, %rbp
    xorq %rax, %rax     #rax = 0
    movb (%rdi), %al  #rax = *pstring, len -> rax
    movq %rbp, %rsp
    pop %rbp
    ret

# *pstring in %rdi, char odlchar in %rsi, newchar in %rdx
# %cl <- len, %r8b <- counter,
replaceChar:
    push %rbp
    movq %rsp, %rbp
    push %r10
    movb (%rdi), %cl # move to %cl the pstring len
    xorb %r8b, %r8b   # %r8b = 0
    movb $1, %r8b     # %r8b = 1
    cmpb %r8b, %cl    # if counter <= len
    jge .while_1
    jmp .end_while_1
.while_1:
    movb (%rdi, %r8, 1), %r9b # %r9b = pstring[counter]
    cmpb %r9b, %sil             # if pstring[conter] == oldChar
    je .replace
    addb $1, %r8b
    cmpb %r8b, %cl    # if counter <= len
    jge .while_1
    jmp .end_while_1
.replace:
    leaq (%rdi, %r8, 1), %r10  #%r10 = pstring + counter
    movb %dl, (%r10)           #pstring[conter] = newChar
    addb $1, %r8b
    cmpb %r8b, %cl    # if counter <= len
    jge .while_1
.end_while_1:
    movq %rdi, %rax   #%rax <- *pstring
    pop %r10
    movq %rbp, %rsp
    pop %rbp
    ret

# *pstring in %rdi, %r8b <- counter, %cl <- len
swapCase:
    push %rbp
    movq %rsp, %rbp
    push %r10
    movb (%rdi), %cl    #cl = len
    xorb %r8b, %r8b     #%r8b = 0 <- counter
    jmp .before_while_2
.while_2:
    movb (%rdi, %r8, 1), %r9b
    cmpb $97, %r9b
    jge .more_a
    cmpb $65, %r9b
    jge .more_A
    jmp .before_while_2
.more_A:
    cmpb $90, %r9b
    jl .more_A_less_Z
    jmp .before_while_2
.before_while_2:
    addb $1, %r8b     #counter++
    cmpb %r8b, %cl    # if counter <= len
    jge .while_2
    jmp .end_while_2
.more_A_less_Z:
    leaq (%rdi, %r8, 1), %r10
    addb $32, (%r10)
    jmp .before_while_2
.more_a:
    cmpb $122, %r9b
    jl .more_a_less_z
    jmp .before_while_2
.more_a_less_z:
    leaq (%rdi, %r8, 1), %r10
    subb $32, (%r10)
    jmp .before_while_2
.end_while_2:
    pop %r10
    movq %rdi, %rax
    movq %rbp, %rsp
    pop %rbp
    ret

# dest -> %rdi, src -> %rsi, i -> %rdx, j -> %rcx, counter -> %r8b
pstrijcpy:
    push %rbp
    movq %rsp, %rbp
    push %r10
    jmp .check_error_1
.error_1:
    push %rdi
    movq $error, %rdi
    pushq $0
    call printf
    pop %rsi
    pop %rdi
    jmp .end_while_3
.check_error_1:
    addb $1, %cl
    cmpb (%rdi), %cl   # if len_of_dest < j
    jg .error_1
    cmpb (%rsi), %cl   # if len_of_src < j
    jg .error_1
    movb %dl, %r8b    # counter = i
.before_while_3:
    addb $1, %r8b
    cmpb %r8b, %cl
    jge .while_3
    jmp .end_while_3
.while_3:
    leaq (%rdi, %r8, 1), %r9
    movb (%rsi, %r8, 1), %r10b
    movb %r10b, (%r9)
    jmp .before_while_3
.end_while_3:
    movq %rdi, %rax    # %rax = dest pstring
    pop %r10
    movq %rbp, %rsp
    pop %rbp
    ret

# pstr1 -> %rdi, pstr2 -> %rsi, i -> %rdx, j -> %rcx, counter -> %r8b
pstrijcmp:
    push %rbp
    movq %rsp, %rbp
    push %r10
    jmp .check_error_2
.error_2:
    push %rdi
    movq $error, %rdi
    call printf
    pop %rdi
    movq $-2, %rax
    jmp .finish
.check_error_2:
    addb $1, %cl
    cmpb (%rdi), %cl   # if len_of_pstr1 < j
    jg .error_2
    cmpb (%rsi), %cl   # if len_of_pstr2 < j
    jg .error_2
    movb %dl, %r8b     # counter = i
.before_while_4:
    addb $1, %r8b
    cmpb %r8b, %cl
    jge .while_4
    jmp .equals
.while_4:
    movb (%rdi, %r8, 1), %r9b
    movb (%rsi, %r8, 1), %r10b
    cmpb %r9b, %r10b
    jg .pstr1_smaller
    cmpb %r10b, %r9b
    jg .pstr2_smaller
    jmp .before_while_4
.pstr1_smaller:
    movq $-1, %rax
    jmp .finish
.pstr2_smaller:
    movq $1, %rax
    jmp .finish
.equals:
    movq $0, %rax
    jmp .finish
.finish:
    pop %r10
    movq %rbp, %rsp
    pop %rbp
    ret