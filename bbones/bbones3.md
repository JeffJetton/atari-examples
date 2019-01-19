# Bare-Bones Program #3

* **Code file: [bbones3.asm](./bbones3.asm "Link to source code file for bbones3.asm")**
* [Run in-browser](https://8bitworkshop.com/v3.3.0/embed.html?p=vcs&r=TFpHAAAQAAAAAFTPFAojAQECAwSpPIUJTADw%2FwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB4EHAQHAPAA8A%3D%3D "Link to in-browser emulation of bbones2.asm") at 8bitworkshop

Confession time: We haven’t been being good 2600 citizens so far. There’s a certain amount of setup we really should be doing at the beginning of our program. Like a trained chef who gets his or her [*mise en place*](https://en.wikipedia.org/wiki/Mise_en_place "Wikipedia article on mise en place") arranged before cooking a meal, we have to prepare our virtual working area and make sure everything is in its place.

On an emulator, this isn’t super-important. Typically, the microprocessor and the entire memory map start as a blank slate. But on a real 2600, those registers and addresses could be set to who-knows-what. That can cause trouble down the line. We need to take care of things by doing this:

## Typical Initialization Steps

1. Make sure the chip is ignoring interrupts (even though it probably won’t get any, as discussed earlier).
1. Ensure that the processor is in the normal, binary math mode.
   * The 6502 family can operate in a special "Binary-Coded Decimal" mode that can be quite useful in certain situations.
   * This is not one of those situations. So we *really* want to make sure that BCD mode is off if we want addition and subtraction to behave as expected.
1. Set the “stack pointer” to its highest value. We’ll talk more about this later, but for now, these are the two things to know:
   * The stack pointer marks the *bottom* of a special section of RAM called the "stack". This location can vary as the stack changes in size.
   * Nearly every program you write will also be using RAM for storing what are essentially "variables".
   * Since we don't want our variables area and the stack area to stomp all over each other, we'd prefer that the stack start out as far "out of our way" as possible.
1. Set every register in the TIA chip to zero.
1. Set every byte in RAM to zero.

## Basic Set Up

The first part of our program takes care of steps 1-3:

```assembly
; Basic set-up

Start   sei         ; Prevent interrupts
        cld         ; Clear "binary-coded decimal" mode
        ldx #$FF    ; Take the highest address in RAM...
        txs         ; ...and put it in the stack pointer
```

The first two instructions are pretty straightforward. They're both single-byte codes that do one specific task and don't require any value to follow them--akin to a function that takes no arguments:

   * `sei` - **SE**t **I**nterrupt disable
   * `cld` - **CL**ear binary-coded **D**ecimal mode

The next two lines set the stack pointer. In the previous two versions, we used the microprocessor’s A register (aka the Accumulator) as our “clipboard” to transfer a value to a specific place. Here we’re doing basically the same thing, but we're using a different register on the chip: The X register. The instruction itself is almost identical, only it's `ldx` (**L**oa**D** **X**) instead of `lda`.

The X register (along with its sibling, the Y register) is not as full-featured as the primary A register. But you can put things into it, take things out, and increment or decrement it. It works great as an index or counter register, which is what you'll mostly use it for.

But one thing X can do that that A cannot is transfer its contents to the stack pointer (via `txs`: **T**ransfer **X** to the **S**tack pointer). That's why we're using X here instead of A... we don't really have any other choice!

Also notice that we’re not “storing” X in the stack pointer, but rather “transferring” it. And we don't need to specify an address. That’s because the stack pointer is not at an external location--it's a register living right on the microprocessor, just like A, X, and Y. Moving data between local microprocessor registers is, in the jargon of the 6502 instruction set, a *transfer* rather than a *store*.

## Initializing the "Zero-Page"

[explain zero page and clearing it out. Uses a loop to do the whole thing.]

For our first stab at this, we'll use an approach similar to what you're probably used to in a high-level langauage. (Spoiler alert: We'll rewrite this in the next version.)

[Code goes here]



## Review

* It's (usually) a good idea to start your VCS programs by initializing the system and clearing out the TIA and RAM.
* In addition to the Accumulator, the registers on the 6502-family microprocessors include X, Y, and SP (the stack pointer).
* "Branching" is the assembly-language equivalent of a conditional ("if") statement (although the logic will typically be "flipped around")

Next, we'll re-write that zero-page loop to a more efficient form that's more idiomatic to assembly language.

#### Next example: [bbones4.asm](./bbones4.md)
