;Author information
;  Author name: Art Grichine
;  Author email: ArtGrichine@gmail.com
;Course information
;  Course number: CPSC240
;  Assignment number: 6
;  Due date: 2014-May-08
;Project information
;  Project title: Harmonic Series (Assignment 6)
;  Purpose: Preform summation of harmonic series until the user's input is less than or equal to the sum and return the number of
;		terms added. The number of terms added, clock speed (pre/post calc) are returned to the user.
;  Status: No known errors
;  Project files: driver.cpp, harmonicseries.asm, debug.inc, debug.asm
;Module information
;  This module's call name: harmonicseries
;  Language: X86-64
;  Syntax: Intel
;  Date last modified: 2014-May-06
;  Purpose: Brute force addition of harmonic series until the sumation of the values is equal to the user input.
;  File name: harmonicseries.asm
;  Status: In production.  No known errors.
;  Future enhancements: None planned
;Translator information
;  Assemble: nasm -f elf64 -l harmonicseries.lis -o harmonicseries.o harmonicseries.asm
;References and credits
;  CSUF/Professor Floyd Holliday: http://holliday.ecs.fullerton.edu
;Print information
;  Page width: 132 columns
;  Begin comments: 65
;  Optimal print specification: Landscape, 9 points or smaller, monospace, 8Â1⁄2x11 paper
;
;===== Begin code area ============================================================================================================

%include "debug.inc" 					    ;This file contains the subprogram to be tested with this test program.

extern printf						    ;External C++ function for writing to standard output device

extern scanf						    ;External C++ function for obtaining user input

global harmonicseries	 				    ;This makes harmonicseries callable by functions outside of this file.

segment .data						    ;Place initialized data here

;===== Message Declarations =======================================================================================================

welcome db 10, "Welcome to harmonic series by Art Grichine!", 10,
	db 10, "The program will compute a partial sum of the harmonic series.", 10,
        db 10, "These results were obtained on a MacBook Pro (late 2013) running Haswell i7 at 2.6GHz.", 10, 0

enter_number_x db 10, "Please enter a positive real number X: ", 0 

sum_being_computed db "The smallest harmonic sum ≥ X is being computed.", 10, 0

be_patient db "Please be patient . . . . The sum is now computed.", 10, 0

results db "The harmonic sum is %1.15lf, which required the addition of %ld terms.", 10, 0

system_clock_pre db "The clock time before the calculations began was %ld.", 10, 0

system_clock_post db "The clock time after completion of calculations was %ld.", 10, 0

elapsed_time db "The harmonic computation required %7ld clock cycles (tics) which is %1.8lf seconds.", 10, 0

return_to_caller db "This assembly program will return to the caller.", 10, 0

stringformat db "%s", 0						;general string format

formatOneFloat db "%lf", 0					;this format will absorb Taylor Series input of float type 64-bit

segment .bss							;Place un-initialized data here.

        ;This segment is empty

segment .text							;Place executable instructions in this segment.

harmonicseries:							;Entry point.  Execution begins here.

;=========== Back up all the integer registers used in this program ===============================================================

push rbp 							;Backup the stack base pointer
mov  rbp, rsp							;copy stack on rbp to ensure proper restoration when program is done
push rdi 							;Backup the destination index
push rsi 							;Backup the source index
push rdx							;Backup the register
push rcx							;Backup the register
push r8								;Backup the register
push r9								;Backup the register
push r10							;Backup the register
push r11							;Backup the register
push r12							;Backup the register
push r13							;Backup the register
push r14							;Backup the register
push r15							;Backup the register	

;============  Preliminary ========================================================================================================

vzeroall							;zeros out all SSE registers

;=========== Initialize divider register ==========================================================================================
								;for our calculations we must set 3 SSE registry's to 1.0 to 
								;accomidate for our algorithm: count, nth term, incrimentor
mov  rax, 0x3ff0000000000000 					;copy HEX 1.0 value onto rax
push rax							;push rax value onto the stack for broadcast operation
vbroadcastsd ymm14, [rsp]					;makes ymm14 all 1.0, this will be our count
vbroadcastsd ymm13, [rsp]					;makes ymm13 all 1.0, this will hold our nth term
vbroadcastsd ymm12, [rsp]					;we will use ymm12 to incriment count by 1.0 each iteration
pop  rax							;push operand must be followed by a pop operation when complete

;=========== Show the initial message =============================================================================================

xor  rax, rax							;tell printf not to expect any doubles in upcoming call
mov  rdi, stringformat 						;simple format indicating string ' "%s",0 '
mov  rsi, welcome 						;display: Welcome Message, Name, Machine, Purpose of Assignment 
call printf							;display welcome message from the driver program (.cpp)

;============ Input for X values ==================================================================================================

;==== Display message for x ====
xor  rax, rax							;satisfies printf function, expects no doubles in upcoming printf
mov  rdi, stringformat						;"%s"
mov  rsi, enter_number_x 					;message --> 10, "Please enter a positive real number X: ", 0
call printf							;display user prompt for 'x'

;==== Grab data for x ====
xor  rax, rax							;clear rax registry
push qword 0							;allocate storage for an input number on int stack
mov  rdi, formatOneFloat 					;formats input of scanf to recieve a float number "%lf"
mov  rsi, rsp							;assign register to copy stack pointer location to absorb x
call scanf							;scan user input for 'x' and place in appropriate space
vmovupd ymm15, [rsp] 						;place user x values onto ymm11 for upcoming manipulation
pop rax								;deallocate memory allocation for input

;============ Read system clock pre-calculations===================================================================================
								;System clock-speed found in 1/2 of rdx and 1/2 of rax, to get the
								;accurate clock-speed (in tics) we must read the clock and then 
								;combine the two registers (rdx:rax) into one for the full reading. 
;==== get system clock ====
cpuid								;stop 'look ahead' for cpu; lets us get a more accurate clock speed
rdtsc								;read cpu clock, values stored in rdx:rax
mov qword r13, 0						;zero out r13 register for upcoming calculations, will hold rax
mov qword r12, 0						;zero out r12 register for upcoming calculations, will hold rdx
mov 	  r13, rax						;place rdx value onto r13 in preparation to combine rax/rdx
mov 	  r12, rdx						;place rdx value onto r12 in preparation to combine rax/rdx
shl	  r12, 32						;shift r12 32 bits
or	  r12, r13						;combine r12 and r13, r12 has entire system clock count now 

;============ Calculate Harmonic Sum ==============================================================================================

;==== computation starting message ====
xor  rax, rax							;tell printf not to expect any doubles in upcoming call
mov  rdi, stringformat 						;simple format indicating string ' "%s",0 '
mov  rsi, sum_being_computed					;display: "The smallest harmonic sum ≥ X is being computed.", 10, 0
call printf							;display message from the driver program (.cpp)

;==== single SSE computation ====
iterate_again:							;iterate through until xmm10 ≥ xmm15 (user input)

vmovupd ymm11, ymm13						;initialize our 'nth' term for upcoming computation
vdivpd ymm11, ymm12						;divide 'nth' term by 1.0 which gives us the harmonic value of term
vaddpd ymm10, ymm11						;add harmonic value of the term to our accumulator

ucomisd xmm10, xmm15						;compare calculated harmonic sum to user's number (xmm15)
vaddpd  ymm12, ymm14						;increment count by 1
jb iterate_again						;if xmm10 < xmm15 jump to 'iterate_again:' jb is 'jumb below', if

vsubpd ymm12, ymm14						;subtrack 1 from count, after computation count is too high by 1

;============ Read system clock post-calculations==================================================================================

;==== get system clock ====
cpuid								;stop 'look ahead' for cpu
rdtsc								;read cpu clock, values stored in rdx:rax
mov qword r15, 0						;zero out r15 register for upcoming calculations, will hold rax
mov qword r14, 0						;zero out r14 register for upcoming calculations, will hold rdx
mov 	  r15, rax						;place rax value onto r15 in preparation to combine rax/rdx
mov 	  r14, rdx						;place rdx value onto r14 in preparation to combine rax/rdx
shl	  r14, 32						;shift r14 32 bits
or	  r14, r15						;combine r14 and r15, r14 has entire system clock count now
				
;==== output system clock pre-calc ====
mov rsi, r12							;place timer value from rax into rsi in preperation for output
xor rax, rax							;zero-out rax register
mov rdi, system_clock_pre					;assign output format to rdi for printf output
call printf							;print system clock tics pre-calculation
							
;==== output system clock post-calc ====
mov rsi, r14							;place timer value from rax into rsi in preperation for output
xor rax, rax							;zero-out rax register
mov rdi, system_clock_post					;assign output format to rdi for printf output
call printf							;print system clock tics post-calculation

;========== Elapsed time ==========================================================================================================
								;our values of clockspeed pre-calculations is in r12, clockspeed 
								;post-calculations is in r14
;==== calculate elapsed time (tics) ====
sub r14, r12							;subtract the clockspeed pre-calculation from post-calc clockspeed
								;this gives us our elapsed time
								
								;bc we are doing floating point calculations it is easier to place
								;values onto the SSE registry and do the calculations there.

;==== calculate elapsed time (ns) ====				;our ns conversion formula is (clockspeed (in tics) * 10) / 26 = ns
mov       r11, 10						;need to increase numerator by factor of 10, set up upcoming calc
cvtsi2sd xmm4, r11						;convert 10 into floating point and place onto xmm4
cvtsi2sd xmm5, r14						;convert our clockspeed (in tics) and place onto xmm5
vmulpd   ymm4, ymm5						;multiply clockspeed (in tics) by factor of 10
mov       r11, 26						;int 26 onto r11 so that we may divide our value by(machine spd*10)
cvtsi2sd xmm5, r11						;convert 26 into floating point and place onto xmm5
vdivpd   ymm4, ymm5						;divide (tics * 10) by known cpu speed (2.6Ghz * 10) to get real ns	
vmovupd  ymm0, ymm4						;output for nanoseconds ready on ymm0

;==== calculate elapsed time (sec) ====				;ns --> sec = ns/1billion
mov r11, 1000000000						;place 1billion onto r11 to prepare for floatpnt conversion on SSE
cvtsi2sd xmm5, r11						;converst 1billion into float number and place on xmm5
vdivpd ymm4, ymm5						;divide ns/1billion = elapsed time in seconds
vmovupd ymm0, ymm4						;place elapsed time in seconds onto ymm1 for output

;==== output elapsed time ====					;elapsed time in tics sits on r14, ns on ymm0, sec on ymm1
xor rax, rax
mov rsi, r14							;place elapsed time in tics on to rsi for output
mov rax, 1							;tell printf to find the first two numbers(ns/sec)on SSE(xmm0,xmm1)
mov rdi, elapsed_time						;format output for elapsed time in tics, ns, and seconds
call printf							;output elapsed time in tics, ns, and seconds


;========== Output Results ========================================================================================================

;==== print output ====
cvtsd2si rsi, xmm12						;convert count from FPU to int and place on int registry for output
vmovupd ymm0, ymm10						;place sum on xmm0 in preparation for output (printf)
mov  rax, 1							;tell printf to expect 1 FPU value on the upcoming print
mov  rdi, results	 					;prepare format for our values on printf
call printf							;print x and e^x values to the terminal

;========== Return Sum to driver ==================================================================================================

vmovsd xmm0, xmm10						;Return sum to the driver program. Note: 'printf' in instructions
								;  above has corrupted xmm0 so we must re-assign our sum before 
								;  returning to the driver if we want the driver to recieve the sum

;=========== Now cleanup and return to the caller =================================================================================

pop r15								;Restore original value
pop r14								;Restore original value
pop r13								;Restore original value
pop r12								;Restore original value
pop r11								;Restore original value
pop r10								;Restore original value
pop r9								;Restore original value
pop r8								;Restore original value
pop rcx								;Restore original value
pop rdx								;Restore original value
pop rsi								;Restore original value
pop rdi								;Restore original value
pop rbp								;Restore original value

ret								;Return to driver program (.cpp)
                                                               
;========== End of program harmonicseries.asm =====================================================================================
