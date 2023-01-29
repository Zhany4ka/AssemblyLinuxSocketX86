section .data
    listen_port db 0x13, 0x37 ; port number in big endian

section .text
    global _start

_start:
    ; create a socket
    mov eax, 41
    mov ebx, 2
    mov ecx, 1
    int 0x80
    mov [socket], eax

    ; bind the socket to a port
    mov eax, 49
    mov ebx, [socket]
    mov ecx, sockaddr
    mov edx, 16
    int 0x80

    ; listen for incoming connections
    mov eax, 50
    mov ebx, [socket]
    mov ecx, 5
    int 0x80

    ; accept incoming connections
    mov eax, 43
    mov ebx, [socket]
    mov ecx, client_sockaddr
    mov edx, client_sockaddr_len
    int 0x80
    mov [client_socket], eax

    ; read data from the client
    mov eax, 3
    mov ebx, [client_socket]
    mov ecx, buffer
    mov edx, 1024
    int 0x80

    ; write data back to the client
    mov eax, 4
    mov ebx, [client_socket]
    mov ecx, buffer
    mov edx, eax
    int 0x80

    ; close the client socket
    mov eax, 6
    mov ebx, [client_socket]
    int 0x80

    ; close the main socket
    mov eax, 6
    mov ebx, [socket]
    int 0x80

    ; exit the program
    mov eax, 1
    xor ebx, ebx
    int 0x80

section .bss
    socket resd 1
    client_socket resd 1
    buffer resb 1024
    sockaddr resb 16
    client_sockaddr resb 16
    client_sockaddr_len resd 1
