#   209275114 Sahar Rofe
.file "func_select.s"
.section .rodata               #jump table
       .align 8
    .switch_case:
    .quad .Op50 #Op = 50
    .quad .noOp # 51
    .quad .Op52 #Op = 52
    .quad .Op53 #Op = 53
    .quad .Op54 #Op = 54
    .quad .Op55 #Op = 55
    .quad .noOp # 56
    .quad .noOp # 57
    .quad .noOp # 58
    .quad .noOp # 59
    .quad .Op50 #Op = 60
#massages for all the options for printf and scanf
message_50_60: .string "first pstring length: %d, second pstring length: %d\n"
message_52: .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
message_53: .string "length: %d, string: %s\n"
message_54: .string "length: %d, string: %s\n"
message_55: .string "compare result: %d\n"
error_op: .string "invalid option!\n"
format_int: .string "%d"
format_char: .string " %c"

.text
.global run_func
    .type   run_func, @function

#the arguments
#pstr1 -> %rdi, pstr2 -> %rsi, oprion -> %rdx
run_func:
    #check the option
    push %rbp
    movq %rsp, %rbp
    cmp $50, %rdx     #check the option
    jl .noOp
    cmp $60, %rdx
    jg .noOp
    sub $50, %rdx
    jmp *.switch_case(,%rdx,8)   #send to the apropriate label
.noOp:
    #print error
    movq $error_op, %rdi         #error
    call printf
    jmp .done
.Op50:
    #save registers
    push %r12
    push %r13
    push %rdi
    push %rsi
    call pstrlen
    movq %rax, %r12     #r12 <- len pstr1
    pop %rsi
    #argument to pstrlen
    movq %rsi, %rdi
    call pstrlen
    movq %rax, %r13     #r13 <- len pstr2
    #arguments to printf
    movq $message_50_60, %rdi
    movq %r12, %rsi
    movq %r13, %rdx
    movq $0, %rax
    call printf
    #registers that I had saved
    pop %rdi
    pop %r13
    pop %r12
    jmp .done
.Op52:
    #save value
    push %rsi
    push %rdi
    subq $16, %rsp
    #prapere scanf
    movq $format_char, %rdi
    movq %rsp, %rsi
    movq $0, %rax
    call scanf
    #save the result
    pop %rdi
    pop %rsi
    push %rdi
    subq $8, %rsp
    movq $format_char, %rdi
    movq %rsp, %rsi
    movq $0, %rax
    call scanf
    xorq %rdx, %rdx
    xorq %rsi, %rsi
    pop %rdx         # newChar -> %rdx
    pop %rsi         # oldChar -> %rsi
    pop %rdi         # pstr1 -> %rdi
    push %rdx        #for saving the registers
    push %rsi
    call replaceChar
    #save values
    pop %rsi
    pop %rdx
    pop %rdi
    push %rax
    push %rsi
    push %rdx
    call replaceChar
    pop %rdx          #prepre printf
    pop %rsi
    pop %rcx
    movq %rax, %r8
    #send the adress of the stert of the string
    addq $1, %rcx
    addq $1, %r8
    movq $message_52, %rdi
    call printf
    jmp .done
.Op53:
    #save registers
    push %rsi
    push %rdi
    subq $16, %rsp
    #aruments to scanf
    movq $format_int, %rdi
    movq %rsp, %rsi
    movq $0, %rax
    call scanf
    pop %rdi
    pop %rsi
    push %rdi
    subq $8, %rsp
    movq $format_int, %rdi
    movq %rsp, %rsi
    movq $0, %rax
    call scanf
    xorq %rdx, %rdx
    xorq %rcx, %rcx
    pop %rcx         # j -> %rcx
    pop %rdx         # i -> %rdx
    pop %rdi         # dest/str1 -> %rdi
    pop %rsi         # scr/str2 -> %rsi
    push %rsi
    call pstrijcpy
    movq $message_53, %rdi
    xorq %rsi, %rsi
    movb (%rax), %sil
    addq $1, %rax
    movq %rax, %rdx
    pushq $0
    call printf
    popq %rsi
    movq $message_53, %rdi
    xorq %rsi, %rsi
    pop %r8
    movb (%r8), %sil
    add $1, %r8
    movq %r8, %rdx
    call printf
    jmp .done
.Op54:
    push %r12
    push %r13
    push %rsi
    call swapCase # pstr1 in rdi
    movq %rax, %r12
    pop %rsi
    movq %rsi, %rdi
    call swapCase # pstr2 in rdi
    movq %rax, %r13
    movq $message_54, %rdi  #call printf with (massage, len, string)
    xorq %rsi, %rsi
    movb (%r12), %sil
    leaq 1(%r12), %rdx
    movq $0, %rax
    push %r13
    push %r12
    call printf
    pop %r12
    pop %r13
    movq $message_54, %rdi #call printf with (massage, len, string)
    xorq %rsi, %rsi
    movb (%r13), %sil
    leaq 1(%r13), %rdx
    movq $0, %rax
    call printf
    pop %r13
    pop %r12
    jmp .done
.Op55:
    push %rsi
    push %rdi
    subq $16, %rsp          #prepare scanf
    movq $format_int, %rdi
    movq %rsp, %rsi
    movq $0, %rax
    call scanf
    pop %rdi
    pop %rsi
    push %rdi
    subq $8, %rsp
    movq $format_int, %rdi
    movq %rsp, %rsi
    movq $0, %rax
    call scanf
    xorq %rdx, %rdx
    xorq %rcx, %rcx
    pop %rcx         # j -> %rcx
    pop %rdx         # i -> %rdx
    pop %rdi         # str1 -> %rdi
    pop %rsi         # str2 -> %rsi
    call pstrijcmp
    movq $message_55, %rdi
    movq %rax, %rsi
    movq $0, %rax
    call printf
    jmp .done
.done:
    movq %rbp, %rsp
    pop %rbp
    ret
