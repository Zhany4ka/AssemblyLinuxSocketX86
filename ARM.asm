.data
listen_port: .word 0x1337 ; port number in big endian

.text
.global _start

_start:
    ; create a socket
    mov r0, 1
    mov r1, 2
    mov r2, 1
    mov r7, 41
    svc 0
    mov r4, r0

    ; bind the socket to a port
    mov r0, r4
    ldr r1, =sockaddr
    mov r2, 16
    mov r7, 49
    svc 0

    ; listen for incoming connections
    mov r0, r4
    mov r1, 5
    mov r7, 50
    svc 0

    ; accept incoming connections
    mov r0, r4
    ldr r1, =client_sockaddr
    ldr r2, =client_sockaddr_len
    mov r7, 43
    svc 0
    mov r5, r0

    ; read data from the client
    mov r0, r5
    ldr r1, =buffer
    mov r2, 1024
    mov r7, 3
    svc 0

    ; write data back to the client
    mov r0, r5
    ldr r1, =buffer
    mov r2, r0
    mov r7, 4
    svc 0

    ; close the client socket
    mov r0, r5
    mov r7, 6
    svc 0

    ; close the main socket
    mov r0, r4
    mov r7, 6
    svc 0

    ; exit the program
    mov r0, 0
    mov r7, 1
    svc 0

.bss
    socket: .space 4
    client_socket: .space 4
    buffer: .space 1024
    sockaddr: .space 16
    client_sockaddr: .space 16
    client_sockaddr_len: .space 4
