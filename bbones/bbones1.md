# Bare-Bones Program #1

* **Code file: [bbones1.asm](./bbones1.asm "Link to source code file for Bare-Bones Program #1")**
* ([Run in-browser](https://8bitworkshop.com/v3.3.0/embed.html?p=vcs&r=TFpHAAAQAAAAAFT8Igq1AQECAwSpzoUJTADw%2FwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB4EHAQHAPAA8A%3D%3D "Link to in-browser emulation of Bare-Bones Program #1"))

Here’s an extremely basic program. How basic? It just displays a single color, filling up the entire screen. You can't do much other than look at it. Your joysticks won’t work, for example.

*Booooring!*

But for a first program, it’ll do.

Let’s walk through [the code](./bbones1.asm "Code for Bare-Bones Program #1") piece-by-piece and talk about what’s going on...

## Lines 1 and 2

```assembly
        processor 6502

        org  $F000
```

The first two lines are instructions to the compiler and don’t generate any actual code that will be run on the VCS. These sorts of instructions are often called pseudo-ops (literally, “fake operations”).

In assembly code, you typically indent your instructions by some consistent number of spaces. Many compilers require at least one space, but you'll want more than that (eight is common) to leave room for the descriptive labels that we'll eventually add.

The `processor` instruction tells the compiler that the code we’re writing is meant to be run on a MOS Technologies 6502 microprocessor chip. Or, more correctly, that it’s meant to be run on any chip that can understand the same set of instructions that the 6502 was designed to understand.

> **Fun Fact:** The production version of the Atari VCS actually used the less-expensive 6507 chip, which is basically the 6502 in a smaller form with fewer pins, and thus with certain capabilities blocked from use. Nonetheless, the 6507 can read and at least attempt to carry out any code the 6502 can, even if some of the instructions don’t wind up doing anything. (Think of the 6507 like an automated power strip that has tape over some of the outlets. It can still respond to commands to switch any of the outlets on and off, even if you can't plug a lamp into all of them.)

The `org` pseudo-op sets the *origin* address of the code that follows. When the assembler compiles your code, it constantly keeps track of the destination address of each byte of compiled code. By which I mean the address that *the system running the code* will use to find each particular byte. I used italics because that’s an important distinction! While the first instruction in our code will actually live in the very first byte of the assembled file (and, at least virtually, in the first byte of the cartridge’s ROM), the VCS will actually see it as the 61,441st byte in its world. Which means that the VCS will have to use address `$F000` to access that so-called "first" byte, due to the way the cartridge ROM is mapped. By setting our origin to `$F000`, we let the compiler know the address at which the next bit of code will ultimately be found by the microprocessor, and subsequently where all the following bits of code will wind up too. (We’ll soon see why that’s important...)

By the way, I put a blank line between those two lines of code, but that’s just for clarity. You don’t have to separate them like that.

## Let’s Address the Topic of Addresses

If you’re new to assembler but have programmed in higher-level languages, you might be used to thinking of **addresses** as referring to memory locations in RAM somwhere.

To an extent, it can work that way on the VCS too. Addresses can indeed refer to some sort of memory. It’s not entirely straightforward, since that memory might reside in either RAM (on the 2600 itself) or ROM (in the cartridge), but hey... memory is memory, right? We’re still operating in a zone of some comfort here.

But really, addresses can refer to any sort of hardware access point. Writing a value to an address just pokes a bit of external hardware--which can be RAM but can also be, say, another IC chip on the motherboard--and tells it to do something or behave in a certain way. Conversely, reading from one of these addresses gives your program the ability to respond to something the hardware is telling you to do or to discover a state the hardware is telling you it’s in.

On the VCS, some addresses are *mapped* (connected), to memory (ROM and RAM) and some addresses are mapped to other hardware, such as the "TIA"--the VCS's video chip.

Let that sink in a bit.

I don't give it a second thought now, and maybe it's obvious to you right off the bat. But for me, when I was starting out, this idea of addresses referring to things other tham memory took a bit of getting used to.

## Lines 3 and 4

The next two lines are (finally!) genuine instructions for the VCS’s microprocessor:

```assembly
        lda #$CE
        sta $09
```

Let's start with that last hexadecimal number. (In dasm, hex numbers must start with $). It turns out that `$09` is an address on the TIA video chip that controls the background color used on the screen. The 6502 can change the current color by simply sending some value (one byte) into that address.

The color you wind up with for any particular value depends on the type of TV set the console is plugged into. For example, sets that abide by the [NTSC color standard](https://en.wikipedia.org/wiki/NTSC "Wikipedia article on NTSC"), which was used on analog TVs throughout North America and Japan (plus a few other countries), will interpret `$CE` as a sort of lime green color. TVs using the [PAL color standard](https://en.wikipedia.org/wiki/PAL "Wikipedia article on PAL") (most of Europe, China, India, etc.) will instead display a lovely shade of lilac. There's also the SECAM standard, but it's not as common for Atari games.

> **Fun Fact:** Most VCS emulators can display video using at least the NTSC and PAL standards, and they'll usually give you a way to switch between them. Many will even attempt to figure out what standard the cartridge being run was written for and automatically switch to it for you. This example program is so basic, it will almost certainly throw off that sort of automatic detection. So you might see a message like "AUTO: FAILED", and it will default to one or the other.

Anyway, I don’t know about you, but the high-level-language programmer part of me instinctively wants to put a color value into that background color register address in one step. I'm used to assignment statement looking something like this:

```Java
    System.bgColor = myColor;
```

Or mabye this:
```Python
    SetBGColor(myColor)
```

But in Assembly World, this simple assignment is a **two-step** process.

On the 6502 chip itself are a few specialized, internal storage areas called *registers*. The main register is the *Accumulator*, often just called "A". It only holds one byte, but it's where most of the work is done.

To assign a value to an address, we must use A as a temporary holding tank for the value:

* `lda` (load A) means "load the Accumulator register (A) with this next value"
* `sta` (store A) means "write whatever’s in the Accumulator to the following address"

Specifically, in our program:
* `lda #$CE`    <- Put the value `$CE` into A
* `sta $09`    <- Copy what's in A (which is still `$CE`) into address `$09`

There is no assembly language instruction that directly loads an arbitrary value into an arbitrary address. While that may seem weird (or even annoying) at first, it’s not too different from using copy and paste on your computer. **Think of the A register as the "clipboard"**. First you copy to the clipboard with `lda`, then you paste from the clipboard with `sta`.

And just as you can paste the same text into your word processing document in multiple places as long as you don’t overwrite what’s on the clipboard with another copy (or cut), you can store the same value into multiple addresses as long as you don’t change what’s in A.

What’s up with the `#` in front of the `$CD`? By default, lda will load the value that’s found at the address you provide. If we typed the instruction as `lda $CE`, without the all-important pound symbol, we would be telling the microprocessor to grab *whatever value happens to be at address `$CE`* and copy that value into A. The pound symbol is shorthand for “don’t look at this address to find the value… use this actual value!”

(If you've wrangled pointers or references in languages like C, you can think of the arguments in assembly as being dereferenced by default. The `#` turns off the dereferencing.)

> **Note:** The difference between specifying a direct *value* for an operation and specifying an *address* for an operation is important thing to remember! Lots of frustrating bugs are due to leaving out a`#` or not having one where it should be.

## Line 5

Next we have a “jump” instruction. If you grew up writing old-school BASIC or FORTAN, you can think of it as a GOTO statement.

```assembly
        jmp $F000
```

In this case, we’re telling the processor to “jump” to address `$F000`, which we know to be the first byte of our program (because that's how we set things up with that first `org` instruction).

As you'd probably guess, the result is an endless loop. After we first set the background color, we go back and needlessly set it to the same thing over and over again, until someone has mercy on the processor’s Sisyphean struggle and switches off the power (or quits the emulator).

On a regular computer, a typical program simply exits to the operating system when it finishes. But here *there is no operating system*! if we didn't include some sort of looping construct here, execution would blithely continue on past the parts of the cartridge ROM that we've explicitly written code for, causing things to quickly get... weird. And not in a good way.

Bottom line: All VCS programs should to implement some sort of main loop.

## Lines 6-8

We wind everything up with another “origin” command, followed by two identical lines of interesting code:

```assembly
        org $FFFC
        .word $F000
        .word $F000
```

Wait, didn’t we already set the address origin? Why do it again? To a different address?

It’s because the first thing the 6502 (and, by extension, the 6507 chip used in the VCS) does when it is powered on, or after it is reset, is try to pull in data from the highest portion of memory it can address.

The bytes found at addresses `$FFFC` and `$FFFD` are combined together into a single, two-byte value (four hexadecimal digits) that tells the chip the address at which it should look to start executing the main portion of code. We know, of course, that it's found at address `$F000`, since we explicitly set it there with our first `org` instruction.

By updating our origin to `$FFFC` in the code, we're telling the compiler that the next byte it "assembles" for us should live at that address location. Remember that it knows where the *first* instruction was supposed to live (due to the first `org` we used), and it has been quietly keeping track of the locations of every byte it has assembled since then. This second `org` will cause it to generate as many new bytes as it needs to (all with value of zero) so that the *next* bytes start where we tell it at `$FFFC`. Thus, we ensure that the reset address we specify winds up exactly where it should be.

The `.word` code is not a microprocessor instruction, but rather a directive to the compiler to just write the following word (two-byte value) to the assembled binary file "as is". You can also specify single bytes with the (you guessed it!) `.byte` directive.

> **Fun Fact:** We could, in fact, write any of the actual microprocessor instructions in a similar fashion if we knew the machine code byte values that the operations corresponded to. Instead of `jmp`, we could type `.byte $4C` and get the same compiled program. It sort of defeats the main purpose of using an assembler, but it's possible!

The last two bytes, at `$FFFE` and `$FFFF`, combine to form another target address. This tells the chip where it should jump to in the case of an event known as an *interrupt*. An interrupt is some external bit of hardware tapping the processor on the shoulder and literally “interrupting” the execution of whatever program code that happens to be running at that time. Normally, the chip would respond by jumping to this special interrupt address, where it would presumably find instructions on how to respond to that rude shoulder-tap.

But, as mentioned above, the chip used in the VCS is a “feature limited” version of the 6502. It doesn’t have a pin on the external body of the chip for the interrupt signal to come in on, nor are there the proper connections within the circuitry of the chip itself that would allow it to notice such a signal even if the pin were there. So it doesn't really matter what we put in the last two bytes of address space. We do have to put *something* there though, so we might as well just reiterate the address of the beginning of our main program.

## A Quick Review

* Out of the eight lines of code in this program, most are just instructions to the compiler:
   * We tell it what microprocessor family we're targeting
   * We then tell it the expected address of the first byte of instructions
   * Finally, we wind up with a couple of words of special address data, which we have it place at the very end of address space for us
* Only three of the lines are actually telling the VCS what to do:
   * Load a value into the A register (our "clipboard")
   * Store that value into the address that controls the background color
   * Go back and keep doing it over and over

Pretty simple, eh? 

Next, we'll take advantage of some compiler features to spiff up our code a little bit!

#### Next example: [bbones2.asm](./bbones2.md)
