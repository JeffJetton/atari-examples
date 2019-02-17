# Atari Examples

This project contains a series of example source code files and explanatory documentation for programming the Atari VCS (aka 2600) in 6502 assembly language.

The examples are progressive and build upon each other slowly. In fact, they're essentially my own notes and practice code that I'm putting together while learning all of this myself.

Enjoy!

#### Assumptions:

* Ideally, you have some previous experience programming in a high-level language such as C, Java, Python, etc.
* You have at least a passing acquaintance with hexadecimal and binary number systems (even if you might need a [refresher](https://learn.sparkfun.com/tutorials/hexadecimal/hex-basics "Hexadecimal basics") or [two](https://www.youtube.com/watch?v=I8V4kVSO5Ns "Video demonstration of counting in binary on your fingers")).
* You already have, or can install, a 6502 assembler (such as [dasm](http://dasm-dillon.sourceforge.net/ "dasm homepage")) and an Atari VCS/2600 emulator (such as [Stella](https://stella-emu.github.io/ "Home page for the Stella emulator"))
* You already know, or can [figure out](http://blog.feltpad.net/dasm-on-mac-osx/
 "Mac OS X tips for building Atari binaries"), how to compile an assembly-language file into a binary, then run it in the emulator.
* You will be *not* be running these examples on a real console and TV set.
   * The earlier examples, in particuar, do not fully implement standard methods for "proper" screen display and **have not been verified to safely work on actual hardware**. Caveat lector.
   
> **Note:** You don't need to worry about those last three points if you plan on writing and running all your code over at [8bitworkshop](https://8bitworkshop.com/).

## Ordered List of Examples

1. Bare-Bones Programs
   * `bbones1` [[code](./bbones/bbones1.asm)] [[documentation](./bbones/bbones1.md)]
   * `bbones2` [[code](./bbones/bbones2.asm)] [[documentation](./bbones/bbones2.md)]
   * `bbones3` [[code](./bbones/bbones3.asm)] [[documentation](./bbones/bbones3.md)]
   * `bbones4` [[code](./bbones/bbones4.asm)] [[documentation](./bbones/bbones4.md)]
   * `bbones5` [[code](./bbones/bbones5.asm)] [[documentation](./bbones/bbones5.md)]
1. Rudimentary Ouput
   * `rudout1` [[code](./rudout/rudout1.asm)]
   * `rudout2` [[code](./rudout/rudout2.asm)]
   * `rudout3` [[code](./rudout/rudout3.asm)]
   * `rudout4` [[code](./rudout/rudout4.asm)]
   * `rudout5` [[code](./rudout/rudout5.asm)]
1. Rudimentary Input
   * `rudin1` [[code](./rudin/rudin1.asm)]
   * `rudin2` [[code](./rudin/rudin2.asm)]
1. Dealing Properly with Scanlines
   * `scan1` [[code](./scan/scan1.asm)]
   * `scan2` [[code](./scan/scan2.asm)]
1. Displaying a Player Graphic at a Specific Vertical Position
   * `player1` [[code](./player/player1.asm)]
   * `player2` [[code](./player/player2.asm)]
   * `player3` [[code](./player/player3.asm)]
   * `player4` [[code](./player/player4.asm)]

