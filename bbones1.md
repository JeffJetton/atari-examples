# Bare-Bones Program #1

* **Code file: [bbones1.asm](./bbones1.asm "Link to source code file for Bare-Bones Program #1")**
* ([Run in-browser](https://8bitworkshop.com/v3.3.0/embed.html?p=vcs&r=TFpHAAAQAAAAAFT8Igq1AQECAwSpzoUJTADw%2FwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB4EHAQHAPAA8A%3D%3D "Link to in-browser emulation of Bare-Bones Program #1"))

Here’s an extremely basic program. How basic? It just displays a solid-colored screen (either light purple or light green, depending on the type of TV the emulator is simulating). You can't do much other than look at it. Your joysticks won’t work, for example.

*Booooring!*

But for a first program, it’ll do.

Let’s walk through [the code](./bbones1.asm "Code for Bare-Bones Program #1") piece-by-piece and talk about what’s going on...

## Lines 1 and 2

```assembly
        processor 6502

        org  $F000
```

The first two lines are instructions to the compiler and don’t generate any actual code that will be run on the VCS. These sorts of instructions are often called pseudo-ops (literally, “fake operations”).

In assembly code, you usually indent your instructions by some consistent number of spaces (eight, sixteen, etc.) We'll see why that's helpful when we refine this program later.

The `processor` instruction tells the compiler that the code we’re writing is meant to be run on a MOS Technologies 6502 microprocessor chip. Or, more correctly, that it’s meant to be run on any chip that can understand the same set of instructions that the 6502 was designed to understand. The production version of the Atari VCS actually used the less-expensive 6507 chip, which is basically the 6502 in a smaller form with fewer pins, and thus with certain capabilities blocked from use. Nonetheless, the 6507 can read and carry out any code the 6502 can, even if some of the instructions don’t wind up doing anything. (Think of the 6507 like an automated power strip that has tape over some of the outlets. It can still respond to commands to switch any of the outlets on and off, even if you can't plug a lamp into all of them.)

The `org` pseudo-op sets the *origin* address of the code that follows. When the assembler compiles your code, it constantly keeps track of the destination address of each byte of compiled code. By which I mean the address that *the system running the code* will use to find each particular byte. I used italics because that’s an important distinction! While the first instruction in our code will actually live in the very first byte of the assembled file (and, at least virtually, in the first byte of the cartridge’s ROM), the VCS will actually see it as the 61,441st byte in its world. Which means that the VCS will have to use address $F000 to access that so-called "first" byte, due to the way the cartridge ROM is mapped. By setting our origin to `$F000`, we let the compiler know the address at which the next bit of code will ultimately be found by the microprocessor, and subsequently where all the following bits of code will wind up too. (We’ll soon see why that’s important...)

By the way, I put a blank line between those two lines of code, but that’s just for clarity. You don’t have to separate them like that.

## Lines 3 and 4

The next two lines are (finally!) genuine instructions for the VCS’s microprocessor:

```assembly
        lda #$CE
        sta $09
```

Let's start with that last hexadecimal number. It turns out that `$09` happens to be the address of a hardware register in the VCS’s TIA chip that controls the background color used on the screen. The value you put into that address can range from `$00` to `$FF`, although the right-most bit of that value is ignored. For example, `$CE` (`11001110` in binary) and `$CF` (`11001111`) will give you the same color.

The color you wind up with for any particular value depends on the type of TV set the console is plugged into. Sets that abide by the [NTSC color standard](https://en.wikipedia.org/wiki/NTSC "Wikipedia article on NTSC"), which was used on analog TVs throughout North America and Japan (plus a few other countries), will interpret $CE as a sort of lime green color. TVs using the [PAL color standard](https://en.wikipedia.org/wiki/PAL "Wikipedia article on PAL") (most of Europe, China, India, etc.) will display a lovely shade of lilac.

Less common is the SECAM standard, which mainly applied to France and the Soviet Union back in the VCS's day. Only bits 1-3 were used for color values, giving you a limited palette of just eight colors. `$CE` will give you white, as will all values with an E or F as the last hexadecimal digit.

Glenn Saunder's [color chart]{http://www.qotile.net/minidig/docs/tia_color.html "Charts of TIA colors on different standard sytems") is a handy one to refer to, although there are plenty of other good ones out there in the internet.

Most VCS emulators can display video using at least the NTSC and PAL standards, and they'll usually give you a way to switch between them. Many will even attempt to figure out what standard the cartridge being run was written for and automatically switch to it for you.

This code is so basic, it will almost certainly throw off that sort of automatic detection. So you might see a message like "AUTO: FAILED", and it will probably default to PAL.

Anyway, I don’t know about you, but the high-level-language programmer part of me instinctively wants to put a color value into that background color register address in one step, sort of like this (if we were using a high-level language):

```Java
    System.bgColor = myColor;
```

Or better yet, like this:
```Python
    SetBGColor(myColor)
```

But in Assembly World, this simple assignment is a **two-step** process that uses a processor register as a temporary holding tank for the value:

* `lda` (load A) means "load the A register with this next value"
* `sta` (store A) means "write whatever’s in the A register to the following address"

Specifically, in our program:
* `lda #$CE`    <- Put the value `$CE` into register A
* `sta $09`    <- Copy what's in A (which is still `$CE`) into address `$09`

There is no assembly language instruction that directly loads an arbitrary value into an arbitrary address. While that may seem weird (or even annoying) at first, it’s not too different from using copy and paste on your computer. **Think of the A register as the "clipboard"**. First you copy to the clipboard with `lda`, then you paste from the clipboard with `sta`.

And just as you can paste the same text into your word processing document in multiple places as long as you don’t overwrite what’s on the clipboard with another copy (or cut), you can store the same value into multiple addresses as long as you don’t change what’s in A.

What’s up with the `#` in front of the `$CD`? By default, lda will load the value that’s found at the address you provide. If we typed the instruction as `lda $CE`, without the all-important pound symbol, we would be telling the microprocessor to grab *whatever value happens to be at address `$CE`* and copy that value into A. The pound symbol is shorthand for “don’t look at this address to find the value… use this actual value!”

> **This is an important thing to remember**, and you probably *will* mostly remember it but still make the mistake anyway an embarrassingly large number of times, leading to more frustrating bugs that you’ll want to admit. Join the club.

## Line 5

Next we have a “jump” instruction. If you grew up writing old-school BASIC or FORTAN, you can think of it as a GOTO statement.

```assembly
        jmp $F000
```

In this case, we’re telling the processor to “jump” to address `$F000`, which we know to be the first byte of our program. The result is an endless loop. After we first set the background color, we go back and needlessly set it to the same thing over and over again, until someone has mercy on the processor’s Sisyphean struggle and switches off the power (or quits the emulator).

> You might be familiar with Edsger Dijkstra’s famous 1968 polemic against this sort of jumping around, titled “[Go To Statement Considered Harmful](http://www.u.arizona.edu/~rubinson/copyright_violations/Go_To_Considered_Harmful.html "Text of original Dijkstra letter")”. He wasn’t wrong--you can really get yourself into a tangled mess if you’re not careful. But it’s worth noting that he specifically allowed for an exception when it came to low-level programming. Probably because, well, without those high-level-language luxuries like delimited code blocks, what other choice do we have?

On a regular computer, a typical program simply exits to the operating system when it finishes. But here *there is no operating system*! if we didn't include some sort of looping construct here, execution would blithely continue on past the parts of the cartridge ROM that we've explicitly written code for, causing things to quickly get... weird. And not in a good way.

Bottom line: All VCS programs should to implement some sort of main loop.

## Lines 6-8

We wind everything up with another “origin” command, followed by two identical lines of interesting code:

```assembly
        org $FFFC
        .word $F000
        .word $F000
```

Wait, didn’t we already set the address origin? Why do it again?

It’s because the first thing the 6502 (and, by extension, the 6507 chip used in the VCS) does when it is powered on, or after it is reset, is try to pull in data from the highest portion of memory it can address.

The bytes found at addresses `$FFFC` and `$FFFD` are combined together into a single, two-byte value (four hexadecimal digits) that tells the chip the address at which it should look to start executing the main portion of code. We know, of course, that it's found at address `$F000`.

By updating our origin to `$FFFC` in the code, we're telling the compiler that the next byte it "assembles" for us should live at that address location. Remember that it knows where the *first* instruction was supposed to live (due to the first `org` we used), and it has been quietly keeping track of the locations of every byte it has assembled since then. This second `org` will cause it to generate as many new bytes as it needs to (all with value of zero) so that the *next* bytes start where we tell it at `$FFFC`. Thus, we ensure that the reset address we specify winds up exactly where it should be.

The `.word` code is not a microprocessor instruction, but rather a directive to the compiler to just write the following word (two-byte value) to the assembled binary file "as is". You can also specify single bytes with the (you guessed it!) `.byte` directive.

> Trivia Corner: We could, in fact, write any of the actual microprocessor instructions in a similar fashion if we knew the machine code byte values that the operations corresponded to. It sort of defeats the purpose of using an assembler, but it's possible!)

The last two bytes, at `$FFFE` and `$FFFF`, combine to form another target address. This tells the chip where it should jump to in the case of an event known as an *interrupt*. Think of an interrupt as some external bit of hardware tapping the processor on the shoulder and literally “interrupting” the execution of whatever program code that happens to be running at that time. Normally, the chip would respond by jumping to this special interrupt address, where it would presumably find instructions on how to respond to that rude shoulder-tap.

However the 6507 chip used in the VCS is a “feature limited” version of the 6502. It doesn’t have a pin on the external body of the chip for the interrupt signal to come in on, nor are there the proper connections within the circuitry of the chip itself that would allow it to notice such a signal even if the pin were there. We really could put anything in the last two bytes of address space. It doesn’t matter. Our program will never receive an interrupt and this address information will never be used. We do have to put *something* here though, so we might as well just reiterate the address of the beginning of our main program.

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
