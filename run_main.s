.file "run_main.s"
.section .rodata
    format_int1: .string "%d"
    format_string: .string "%s"
.text
.global run_main
    .type   run_main, @function
run_main:
    push %rbp
    movq %rsp, %rbp
    push %r10
    push %r11
    push %r12
    push %r13
    subq $8, %rsp
    pushq $0
    movq $format_int1, %rdi
    movq %rsp, %rsi
    movq $0, %rax
    call scanf
    pop %r10         # n1 -> %r10
    pop %rsi
    #########
    subq $272, %rsp
    movq $format_string, %rdi
    leaq 1(%rsp), %rsi
    movq $0, %rax
    push %r10
    subq $8, %rsp
    call scanf
    addq $8, %rsp
    pop %r10
    leaq 1(%rsp), %r11
    addq %r10, %r11
    movb $0, (%r11)
    movb %r10b, (%rsp)
    movq %rsp, %r12      #pstr1 -> %r12
    #########
    subq $8, %rsp
    pushq $0
    movq $format_int1, %rdi
    movq %rsp, %rsi
    movq $0, %rax
    push %r12
    subq $8, %rsp
    call scanf
    addq $8, %rsp
    pop %r12
    pop %r10           # n2 -> %r10
    pop %rsi
    #########
    subq $272, %rsp
    movq $format_string, %rdi
    leaq 1(%rsp), %rsi
    movq $0, %rax
    push %r10
    push %r12
    call scanf
    pop %r12
    pop %r10
    leaq 1(%rsp), %r11
    addq %r10, %r11
    movb $0, (%r11)
    movb %r10b, (%rsp)
    movq %rsp, %r13     #pstr2 -> %r13
    #########
    subq $8, %rsp
    pushq $0
    movq $format_int1, %rdi
    movq %rsp, %rsi
    movq $0, %rax
    push %r12
    push %r13
    call scanf
    pop %r13
    pop %r12
    pop %rdx
    pop %r10
    movq %r12, %rdi
    movq %r13, %rsi
    call run_func
    addq $544, %rsp
    pop %r13
    pop %r12
    pop %r11
    pop %r10
    movq %rbp, %rsp
    pop %rbp
    ret
