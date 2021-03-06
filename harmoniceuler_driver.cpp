//Author information
//  Author name: Art Grichine
//  Author email: ArtGrichine@gmail.com
//Course information
//  Course number: CPSC240
//  Assignment number: 6
//  Due date: 2014-May-08
//Project information
//  Project title: Harmonic Series (Assignment 6)
//  Purpose: Preform summation of harmonic series until the user's input is less than or equal to the sum and return the number of
//		terms added. The number of terms added, clock speed (pre/post calc) are returned to the user.
//  Status: No known errors
//  Project files: harmoniceuler_driver.cpp, harmoniceuler.asm, debug.inc, debug.asm
//Module information
//  This module's call name: harmoniceuler_driver.  This module is invoked by the user.
//  Language: C++
//  Date last modified: 2014-May-06
//  Purpose: This module is the top level driver: it will call harmonicseries()
//  File name: harmoniceuler_driver.cpp
//  Status: In production.  No known errors.
//  Future enhancements: None planned
//Translator information (Tested in Linux (Ubuntu) shell)
//  Gnu compiler: g++ -c -m64 -Wall -l harmoniceuler_driver.lis -o harmoniceuler_driver.o harmoniceuler_driver.cpp
//  Gnu linker:   g++ -m64 -o harmoniceuler.out harmoniceuler_driver.o harmoniceuler.o debug.o
//  Execute:      ./harmoniceuler.out
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

extern "C" double harmonicseries(); 

int main(){
  double return_code = -99.99;
  
  return_code = harmonicseries();
  printf("\n%s%2.2lf\n","The driver received this value: ",return_code);
  printf("%s","The driver will return 0 to the operating system. Enjoy your programming.\n");
  printf("%s","There's no fun greater than X86-64 programming\n");

return 0;
}
