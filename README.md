# Atari Examples
This project contains a series of example source code files, along with explanatory documentation, to help with learning 6502 assembly language programming--specifically the sort of programming required to write for the Atari VCS (aka 2600). The
examples build upon each other slowly, starting mainly with assembly language concepts and later gradually including ideas specific to the VCS/2600 platform. Documentation will err on the side of overexplaining, if anything.

It's designed for those who have programmed in high-level languages such as C, Java, or Python, but who maybe don't have a lot of (or any) experience writing low-level assembly language (and certainly not for a piece of hardware this... well, *unique*). In fact, it's based on my own notes and practice code that I wrote while learning all of this myself, coming from a similar background at the time.

Many VCS programming guides and tutorials--excellent though they are--start with a crash course in assembly language and then dive **very** deeply into scanline counting and other VCS arcana right off the bat. By the time the first example program is shown, most newbies (if they're anything like I was), are completely bewildered.

The main idea here is to get things up-and-running with simple, *workable* code as soon as possible. Experimentation is encouraged. 

Enjoy!

## Contents

1. Introduction
   * What You Should Know to Start
   * Enough Assembly to be Dangerous
   * Addressing the Topic of Addresses
1. Bare-Bones Programs
   * Specifying Color on the VCS
   * bbones1.asm
   * bbones2.asm
   * bbones3.asm
1. Rudimentary Ouput Using Playfield Graphics
   * rudout1.asm
   * rudout2.asm
1. Rudimentary Input From the Joystick and Console
   * rudin1.asm
   * rudin2.asm
1. Okay, *Now* We're Going to Talk About Scanlines
1. Displaying a Single Dot
1. Making the Dot Move by Itself
1. Controlling the Dot
