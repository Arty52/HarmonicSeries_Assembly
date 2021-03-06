//Author information
//  Author name: Art Grichine
//  Author email: ArtGrichine@gmail.com
//Course information
//  Course number: CPSC240
//  Assignment number: 3
//  Due date: 2014-Feb-25
//Project information
//  Project title: The Powers Of e (Assignment 3)
//  Purpose: Preform Taylor Series (e^x) calculations on 4 user inputs to a user defined amount of iterations, output initial user
//	    'x' values, result of Taylor Series for each given e^x solution, and elapsed time of the calculations from the system 
//	    clock in tics, nanoseconds, and seconds.
//  Status: No known errors
//  Project files: ThePowersOfeDriver.cpp, ThePowersOfe.asm, debug.inc, debug.asm
//Module information
//  This module's call name: ThePowersOfe.  This module is invoked by the user.
//  Language: C++
//  Date last modified: 2014-Feb-06
//  Purpose: This module is the top level driver: it will call ThePowersOfe()
//  File name: ThePowersOfeDriver.cpp
//  Status: In production.  No known errors.
//  Future enhancements: None planned
//Translator information (Tested in Linux (Ubuntu) shell)
//  Gnu compiler: g++ -c -m64 -Wall -l driver4way.lis -o driver4way.o driver4way.cpp
//  Gnu linker:   g++ -m64 -o harmonicseries4way.out driver4way.o harmonicseries.o debug.o
//  Execute:      ./ThePowersOfe.out
//References and credits
//  References: CSUF/Professor Floyd Holliday: http://holliday.ecs.fullerton.edu
//  Module: this module is standard C++ language
//Format information
//  Page width: 132 columns
//  Begin comments: N/A
//  Optimal print specification: Landscape, 8 points or smaller, monospace, 81⁄2x11 paper
//
//===== Begin code area ===========================================================================================================
//
#include <stdio.h>
#include <stdint.h>

extern "C" long int ThePowersOfe(); 

int main(){
  long int return_code = -99.99;
  
  return_code = ThePowersOfe();
  printf("\n%s%2ld\n","The driver received this value: ",return_code);
  printf("%s","The driver will return 0 to the operating system. Enjoy your programming.\n");
  printf("%s","There's no fun greater than X86-64 programming\n");

return 0;
}
