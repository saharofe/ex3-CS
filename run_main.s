#   209275114 Sahar Rofe
.file "run_main.s"
.section .rodata
    format_int1: .string "%d"
    format_string: .string "%s"
.text
.global run_main
    .type   run_main, @function
run_main:
    #save registers
    push %rbp
    movq %rsp, %rbp
    push %r10
    push %r11
    push %r12
    push %r13
    #exted the stack
    subq $8, %rsp
    pushq $0
    #arguments to scaf
    movq $format_int1, %rdi
    movq %rsp, %rsi
    movq $0, %rax
    call scanf
    #the len
    pop %r10         # n1 -> %r10
    pop %rsi
    #extends the stack (255 + 1 + 16) bytes
    subq $272, %rsp
    #arguments to scanf
    movq $format_string, %rdi
    leaq 1(%rsp), %rsi
    movq $0, %rax
    #save register
    push %r10
    #aliment stack
    subq $8, %rsp
    call scanf
    addq $8, %rsp
    pop %r10
    #push \0 at the end of the string
    leaq 1(%rsp), %r11
    addq %r10, %r11
    movb $0, (%r11)
    movb %r10b, (%rsp)
    movq %rsp, %r12      #pstr1 -> %r12
    #aruments to scanf
    subq $8, %rsp
    pushq $0
    movq $format_int1, %rdi
    movq %rsp, %rsi
    movq $0, %rax
    #save the register
    push %r12
    subq $8, %rsp
    call scanf
    addq $8, %rsp
    pop %r12
    #the scan len
    pop %r10           # n2 -> %r10
    pop %rsi
    #extend the stack
    subq $272, %rsp
    #arguments to scanf
    movq $format_string, %rdi
    leaq 1(%rsp), %rsi
    movq $0, %rax
    #save the resisters from scanf
    push %r10
    push %r12
    call scanf
    pop %r12
    pop %r10
    #push \0 at the end of the string
    leaq 1(%rsp), %r11
    addq %r10, %r11
    movb $0, (%r11)
    movb %r10b, (%rsp)
    movq %rsp, %r13     #pstr2 -> %r13
    #extend the stack for scanf
    subq $8, %rsp
    pushq $0
    #argumets for scanf
    movq $format_int1, %rdi
    movq %rsp, %rsi
    movq $0, %rax
    #save the value of the registers
    push %r12
    push %r13
    call scanf
    #prapere the args for run_func
    pop %r13
    pop %r12
    pop %rdx
    pop %r10
    movq %r12, %rdi
    movq %r13, %rsi
    call run_func
    #close the stack
    addq $544, %rsp
    pop %r13
    pop %r12
    pop %r11
    pop %r10
    movq %rbp, %rsp
    pop %rbp
    ret
