# Bare-Bones Program #2

* **Code file: [bbones2.asm](./bbones2.asm "Link to source code file for bbones2.asm")**
* [Run in-browser](https://8bitworkshop.com/v3.3.0/embed.html?p=vcs&r=TFpHAAAQAAAAAFTPFAojAQECAwSpPIUJTADw%2FwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB4EHAQHAPAA8A%3D%3D "Link to in-browser emulation of bbones2.asm") at 8bitworkshop

Not much new here. But we are now taking advantage of a couple of handy features of assembler programs:

1. The ability to add comments, like any other civilized programming language
   * In dasm comments start with a semi-colon and continue to the end of the line
1. The ability to define *symbols* or labels that we can use to name things
   * Symbol definitions start in the very first column, with no indenting

## Defining Equates

The code starts with a comment, follwed by the `processor` directive we know and love. But then we see this:

```assembly
; Create a new label (COLUBK) that "equates" to value $09
COLUBK  equ $09
; Do the same for our color value
MyBGCol equ $3C
```
The `equ` instruction is for the compiler only. The 6502 doesn't know anything about it. But now we can use the word `COLUBK` anywhere in our code whenever we want to refer to the background color register. The assembler will translate from `COLUBK` to `$09` at compile time.

Same for our background color (which is different from the value used in the previous example, just so you can tell you're running a different program!)

These equates are similar to constants you'd define in any other language, and they have the same benefits: More readble code that's easier to modify.

We could use nearly any name for these two equates we want. By convention, `COLUBK` is used for the background color (more on that to come).

## The Rest of the Program

```assembly
Start   lda #MyBGCol    ; Load a new color value into register A
                        ; Note that we've marked the location of this
                        ; instruction with the label "Start".

        sta COLUBK      ; Store A in whatever address COLUBK refers to

        jmp Start       ; Jump to whatever address Start refers to


        org $FFFC
        .word Start     ; Begin at the "Start" location when reset
        .word Start     ; Use that same address for interrupts
```

The processor instructions in our loop haven't really changed much. But we are marking our first `lda` with a label. There's no special meaning to the word `Start`. We could've called it `Fred` for all the compiler cares.

In this situation the label isn't identifying a value that we provide, but rather the address of a particular location in our code, which the compiler figures out for us. Specifically, we're marking the location of the `lda`--the beginning of our program. We reference this name later in the `jmp` instruction instead of explicitly jumping to `$F000`. We also use the label in the last two lines.

Like the equates, this adds a helpful layer of abstraction. We can change our code origin or add additional code in front of where we want to jump to or start from, but not have to rewrite any of our various destination addresses. The compiler (which, remember, is keeping track of the addresses of every byte it compiles) will take care of everything for us.

For the `lda` and `sta` instructions themselves, we're taking advantage of the equates we defined earlier. Note that we still have to "un-dereference" our color value with the `#`. As a reminder, without it, `lda` would try to load the contents of address `MyBGCol` instead of the actual value of `MyBGCol`.


## Review

* Comments in assembly language start with `;`
* We can (and should!) create symbols or labels for constant values and code locations

Next, we'll use a non-infinite loop to do some sorely-needed initialization...

#### Next example: [bbones3.asm](./bbones3.md)
