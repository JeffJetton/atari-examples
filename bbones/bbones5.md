# Bare-Bones Program #5

* **Code file: [bbones5.asm](./bbones5.asm "Link to source code file for bbones4.asm")**
* [Run in-browser](https://8bitworkshop.com/v3.3.0/embed.html?p=vcs&r=TFpHAAAQAAAAAF8fVxEPAQECAwR42KIAiqjKmkjQ%2B6mIhQlMC%2FD%2FBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHgQbBAIA8ADw "Link to in-browser emulation of bbones4.asm") at 8bitworkshop


Every VCS program you'll write is going to need to set the background color. And you'll eventually wind up setting other video registers (background patterns, player graphics, etc.) and read from input registers (joystick, reset switch, etc.)

Are you really going to have to figure out the addresses for each of these things and define them in every one of your programs with a bunch of equates?

Nope! VCS programmers typically use a common "include" file that already has every VCS register defined and given a standard label. It's similar to the sort of standard header files you might use in a language like C or C++.

By using the `include` pseudo-op, you can instruct the compiler to automatically *include* the definitions in that file in your program, just as if you typed them in yourself.

That's what's going in in the first part of our program:

```assembly
        processor 6502

        include vcs.h

        include macro.h


MyBGCol equ $88

        org $F000
```
There are just a few differences from the previous version:
    * We have two new `include` statements
    * We no longer have an equate for `COLUBK` (even though we still reference `COLUBK` later in the program)


## Choose Your Inclusion

There are (at least) three ways to reference an included file:

1. Just type the name of the file after your `include` instruction. The compiler will look for the file in the current working directory, so you'll have to be sure that copies of your include files exist there.
2. Specify the exact path to the include file after the `include`, either as an absolute path or (ideally) relative to the current working directory.
   * Since this particular repository keeps the include files in `_includes`, you could do something like `include ../_includes/vcs.h`, for example.
   * This saves you from having to fool with multiple copies of your include files.
3. Use just the file names (as in option #1), but give the directory for your include files as a compile-time option. In dasm, that would look like this:
   * `dasm mygame.asm -f3 -omygame.bin -I../_includes`
   
The examples in this project do not specify paths in the `include` statements, so you'll have to either use methods 1 or 3, or edit the code to add the path in.

(If you're using [8bitworkshop](https://8bitworkshop.com/), the two standard include files are always available in your "virtual" working directory, so you don't need to specify a path.)


## vcs.h

The `vcs.h` file is why we no longer have to explicitly define `COLUBK`, or any of the other VCS registers we'll use later. That's all taken care of for us in this file.

It also serves as a handy reference to the available registers, as you can see if you [take a look at it yourself](../_includes/vcs.h). Here's an excerpt:

```assembly
			SEG.U TIA_REGISTERS_WRITE
			ORG TIA_BASE_WRITE_ADDRESS

	; DO NOT CHANGE THE RELATIVE ORDERING OF REGISTERS!
    
VSYNC       ds 1    ; $00   0000 00x0   Vertical Sync Set-Clear
VBLANK		ds 1	; $01   xx00 00x0   Vertical Blank Set-Clear
WSYNC		ds 1	; $02   ---- ----   Wait for Horizontal Blank
RSYNC		ds 1	; $03   ---- ----   Reset Horizontal Sync Counter
NUSIZ0		ds 1	; $04   00xx 0xxx   Number-Size player/missle 0
NUSIZ1		ds 1	; $05   00xx 0xxx   Number-Size player/missle 1
COLUP0		ds 1	; $06   xxxx xxx0   Color-Luminance Player 0
COLUP1      ds 1    ; $07   xxxx xxx0   Color-Luminance Player 1
COLUPF      ds 1    ; $08   xxxx xxx0   Color-Luminance Playfield
COLUBK      ds 1    ; $09   xxxx xxx0   Color-Luminance Background
CTRLPF      ds 1    ; $0A   00xx 0xxx   Control Playfield, Ball, Collisions
```
Rather than specifying the exact address value for each label, as we've been doing for our own equates, the technique used in `vcs.h` is a bit more flexible:

* It sets an origin address using `org`, in a similar fashion to how we've been doing it in our own program. (The `TIA_BASE_WRITE_ADDRESS`, defined earlier in the file, is zero by default, so our origin starts at address $00.)
* The statements then only specify *size* of each address being defined. The compiler keeps track of which address each of these will correspond to.
    * `ds` means "define space"
    * The number after it gives the amount of space, in bytes
    * By the time the compiler gets to the `COLUBK` label we know and love, it knows to assign it to the next available byte, which is `$09`
    * (The comments on each line also show the resulting address, but that was put there by the creaters of the file, for human readability. The compiler didn't generate that and doesn't pay attention to it.)
* The whole thing is kicked off with a `seg.u` instruction. **This is very important!**
    * It tells the compiler that the following is an "uninitialized segment"
    * That is, the bytes being labeled are *mere definintions*., used only for reference by our program. These definitions, by themselves, will not generate any machine code or create any data in the output .bin file.
    
Of course, you don't *have* to use `vcs.h`. There's nothing stopping you from creating your own file and even using different labels for all the addresses. But `vcs.h` has become the de facto standard for VCS programmers for many years, and the address names have been standard [since at least 1979](https://archive.org/details/StellaProgrammersGuide).

> **Fun Fact:** The comments in `vcs.h` also identify the bits that are used for each register. Note that `COLUBK` only pays attention to the highest seven bits--bit zero is ignored. As far as it's concerned, there's no difference between $00 and $01, for example. You effectively have only 128 unique values to set the color


## macro.h

I'm afraid that, after all that work creating two different versions of the initialization loop, we're now going to replace the whole thing *one more time*. Only this time, we're going to use a **macro**.

```assembly
Start   CLEAN_START
```

You might've used macros in other languages, and they work similarly here. They're not too different from equates and address location marker labels, except instead of replacing a symbol with a single value, macros replace it with a chunk of pre-defined program code.

Most programs need an initialization section, and it's not going to be very different each time, so using a macro here makes perfect sense.

The `macro.h` file contains a handful of useful, reusable macros, including a nifty one written by [Andrew Davie](http://atariage.com/forums/user/214-andrew-davie/) called `CLEAN_START`. It performs an improved version of the initialization we've already been doing:

* Disables interrupts
* Turns off decimal mode
* Clears out the entire "Zero Page" (TIA registers and RAM)
* Resets the stack pointer
* Sets all the microprocessor registers (A, X, and Y) to zero

Amazingly, it manages to do all this using two fewer bytes that the bbones4 init routine (and therefore seven fewer bytes than the version in bbones3).



## Extra Credit

1. If you're using dasm, add the `-s` option when you compile this program.
    * For example: `dasm bbones5.asm -f3 -obbones5.bin -sbbones5.sym`
    * This generates a **symbol file**, showing the values of every label (symbol) encountered by the compiler, in both your main .asm file and any included files. It also shows whether the symbol actually wound up being referenced in the final program.
    * Open the file with any text editor to verify that the `vcs.h` labels wound up getting assigned the address that the comments say they would. Which ones did our program refer to?
    * Are the symbols we used in the main program (`MyBGCol`, `Start`, and `SetTIA`) there? Do they have the values you'd expect them to have?
2. Create a version of `vcs.h` that is missing the line with the `seg.u` instruction and include this file in your program instead of the normal version.
    * What happens? Will the program run in an emulator?
    * How big is the resulting .bin file? (Note that our .bin files have only been 4K up until now!) Refer back to the [discussion of lines 6-8](./bbones1.md) in bbones1 for a clue as to what's going on here...
3. Open `macro.h` and check out what other macros are available in there.


--------

## Review

* Including external files lets you reuse common definitions and macros
* The `vcs.h` file (for address labels) and `macro.h` file (for commonly-used functions) are the de facto standards for VCS programmers
* And don't forget these important points from previous discussions:
    * Simple assignment in assembly is often a two-step process:
        * Load something into the Accumulator (the A register... our "clipboard")
        * Then store it back out to its destination
    * Conditional branching is also a two-step process:
        * Do some sort of operation (a decrement, a compare, etc.)
        * Branch based on the *flags* that the operation caused to be set
    * By default, a "load" instruction will read in data from the address of the value you specify.
        * If you want it to instead read in that actual value, you have to use the `#` in front of it
        * Lack of careful attention to this is a common source of bugs
    * It's typically more efficient and "assembly-like" to loop backwards down to zero rather than up from zero
    

Well that's it for the Bare-Bones Program. (If we refined it any further, we'd have to start calling it "Fancy-Bones"!)

Our next mission is to figure out some way to convey some information to the user. Don't get your hopes up--it won't be much. But at least we won't have a blank screen...



#### Next example: [rudout1.asm](../rudout/rudout1.md)