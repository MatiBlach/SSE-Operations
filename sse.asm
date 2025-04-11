; Program przykładowy ilustrujący operacje SSE procesora
; Poniższy podprogram jest przystosowany do wywoływania
; z poziomu języka C (program arytmc_SSE.c)
.686
.XMM ; zezwolenie na asemblację rozkazów grupy SSE
.model flat
public _dodaj_SSE, _pierwiastek_SSE, _odwrotnosc_SSE
public _suma_SSE_char, _int2float,_pm_jeden

.data
jedynki dd 4 dup (+1.0)
.code

_pm_jeden proc
push ebp
mov ebp,esp
push esi
mov esi,[ebp+8]
movups xmm5, [esi]
ADDSUBPS xmm5, jedynki 
movups[esi],xmm5

pop esi
pop ebp
ret
_pm_jeden ENDP

_int2float PROC
push ebp
mov ebp,esp
push esi
push edi
mov esi,[ebp+8] ; adres tablicy z int
mov edi,[ebp+12] ; adres tablicy float
cvtpi2ps xmm5, qword ptr [esi]
movups [edi],xmm5

pop edi
pop esi
pop ebp
ret
_int2float ENDP

_suma_SSE_char PROC
push ebp
mov ebp, esp
push ebx
push edi
push esi
mov ebx,[ebp+8]
mov edi,[ebp+12]
mov esi, [ebp+16]

movups xmm5, [ebx]
movups xmm6, [edi]
paddsb xmm5,xmm6
movups [esi],xmm5

pop esi
pop edi
pop ebx
pop ebp
ret
_suma_SSE_char ENDP

_dodaj_SSE PROC
 push ebp
 mov ebp, esp
 push ebx
 push esi
 push edi
 mov esi, [ebp+8] ; adres pierwszej tablicy
 mov edi, [ebp+12] ; adres drugiej tablicy
 mov ebx, [ebp+16] ; adres tablicy wynikowej
; ładowanie do rejestru xmm5 czterech liczb zmiennoprzecin-
; kowych 32-bitowych - liczby zostają pobrane z tablicy,
; której adres poczatkowy podany jest w rejestrze ESI
; interpretacja mnemonika "movups" :
; mov - operacja przesłania,
; u - unaligned (adres obszaru nie jest podzielny przez 16),
; p - packed (do rejestru ładowane są od razu cztery liczby),
; s - short (inaczej float, liczby zmiennoprzecinkowe
; 32-bitowe)
 movups xmm5, [esi]
 movups xmm6, [edi]
; sumowanie czterech liczb zmiennoprzecinkowych zawartych
; w rejestrach xmm5 i xmm6
 addps xmm5, xmm6

; zapisanie wyniku sumowania w tablicy w pamięci
 movups [ebx], xmm5
 pop edi
 pop esi
 pop ebx
 pop ebp
 ret
_dodaj_SSE ENDP

_pierwiastek_SSE PROC
 push ebp
 mov ebp, esp
 push ebx
 push esi
 mov esi, [ebp+8] ; adres pierwszej tablicy
 mov ebx, [ebp+12] ; adres tablicy wynikowej
; ładowanie do rejestru xmm5 czterech liczb zmiennoprzecin-
; kowych 32-bitowych - liczby zostają pobrane z tablicy,
; której adres początkowy podany jest w rejestrze ESI
; mnemonik "movups": zob. komentarz podany w funkcji dodaj_SSE
 movups xmm6, [esi]
; obliczanie pierwiastka z czterech liczb zmiennoprzecinkowych
; znajdujących sie w rejestrze xmm6
; - wynik wpisywany jest do xmm5
 sqrtps xmm5, xmm6

; zapisanie wyniku sumowania w tablicy w pamięci
 movups [ebx], xmm5
 pop esi
 pop ebx
 pop ebp
 ret
_pierwiastek_SSE ENDP

_odwrotnosc_SSE PROC
;=========================================================
; rozkaz RCPPS wykonuje obliczenia na 12-bitowej mantysie
; (a nie na typowej 24-bitowej) - obliczenia wykonywane są
; szybciej, ale są mniej dokładne
 push ebp
 mov ebp, esp
 push ebx
 push esi
 mov esi, [ebp+8] ; adres pierwszej tablicy
 mov ebx, [ebp+12] ; adres tablicy wynikowej
; ladowanie do rejestru xmm5 czterech liczb zmiennoprzecin-
; kowych 32-bitowych - liczby zostają pobrane z tablicy,
; której adres poczatkowy podany jest w rejestrze ESI
; mnemonik "movups": zob. komentarz podany w funkcji dodaj_SSE
 movups xmm6, [esi]
; obliczanie odwrotności czterech liczb zmiennoprzecinkowych
; znajdujących się w rejestrze xmm6
; - wynik wpisywany jest do xmm5
 rcpps xmm5, xmm6

; zapisanie wyniku sumowania w tablicy w pamieci
 movups [ebx], xmm5
 pop esi
 pop ebx
 pop ebp
 ret
_odwrotnosc_SSE ENDP
END
