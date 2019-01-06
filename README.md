# Atari Examples

This project contains a series of example source code files and explanatory documentation to help with learning 6502 assembly language programming--specifically the sort of programming required to write for the Atari VCS (aka 2600). The examples are progressive and build upon each other slowly, starting mainly with assembly language concepts and later gradually including ideas specific to the VCS/2600 platform.

It's designed for those who have programmed in high-level languages such as C, Java, or Python, but who might not have much, if any, experience writing low-level assembly language (and certainly not for a piece of hardware like the VCS). In fact, these examples are based my own notes and practice code that I wrote while learning all of this myself, coming from a similar background at the time.

Many VCS programming guides and tutorials--excellent though they are in the valuable information they contain--tend to start with a crash course in assembly language and then dive **very** deeply into scanline counting and other VCS arcana right off the bat. There's an enormous and daunting information dump before the first example program is ever shown. I once had a teacher who used to call this sort of thing "drinking from the firehose."

The goal here is to drink from a gently trickling stream. The emphasis is on getting things up-and-running as soon as possible with simple, *workable* code.

Enjoy!

#### Assumptions:

* You already have, or can install, a 6502 assembler (such as dasm) and an Atari VCS/2600 emulator (such as Stella)
* You already know, or can [figure out](http://blog.feltpad.net/dasm-on-mac-osx/
 "Mac OS X tips for building Atari binaries"), how to compile an assembly-language file into a binary, then run it in the emulator.
* You will be *not* be running these examples on a real console and TV set.
   * The earlier examples, in particuar, do not fully implement standard methods for "proper" screen display and **have not been verified to safely work on actual hardware**. Caveat lector.

## Recommended Study Order

1. Introduction
   * What You Should Know to Start
   * Enough Assembly to be Dangerous
   * Addressing the Topic of Addresses
1. Bare-Bones Programs
   * bbones1.asm
   * bbones2.asm
   * bbones3.asm
1. Rudimentary Ouput
   * rudout1.asm
   * rudout2.asm
   * rudout3.asm
1. Rudimentary Input
   * rudin1.asm
   * rudin2.asm
1. Dealing Properly with Scanlines
   * scan1.asm
1. Displaying a Single Dot
1. Making the Dot Move by Itself
1. Controlling the Dot
