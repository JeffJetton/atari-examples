# Bare-Bones Program #4

* **Code file: [bbones4.asm](./bbones4.asm "Link to source code file for bbones4.asm")**
* [Run in-browser](https://8bitworkshop.com/v3.3.0/embed.html?p=vcs&r=TFpHAAAQAAAAAGGrqxObAQECAwR42KL%2FmqkAlQDK0PuFAKnQhQlMDvD%2FBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHgQb%2FwDwAPA%3D "Link to in-browser emulation of bbones4.asm") at 8bitworkshop

In the previous example, we used a fairly straightforward loop to assign zeros to a chunk of address space. It worked just fine, but no native-speaker of assembly language would ever write it that way.

Sort of like a beginning French student who says "Je suis faim!" (I am hunger!) instead of the idiomatically-correct French phrase "J'ai faim" (I *have* hunger!), we were obviously trying to take a pattern we knew from one language and apply it to a language where it doesn't *quite* fit.

So in this example we'll do the same initialization using a more "assembly style" looping method. It's not too different. The key is to **loop backwards**!



## The Standard Set-Up

We haven't changed the beginning of our initialization routine at all. We're still disabling interrupts (`sei`), ensuring binary mode (`cld`), and setting our stack pointer to `$FF`:

```assembly
Start   sei
        cld
        ldx #$FF
        txs
```

As before, we're going to use X as the index of our loop. But we'll count *down* from `$FF` to `$00` instead of going up from `$00` to `$FF`. The nice thing is that, after the above lines of code have finished executing, X is still set to `$FF`, which happens to be exactly where we want it to be!



## Looping Backwards

Recall that, in the previous example, our `cmp` ("compare") instruction actually worked by subtracting the given number from A. It didn't store the result anywhere, but it *did* set the "zero flag" based on the outcome of this "secret subtraction".

The `bne` (**B**ranch if **N**ot **E**qual) then just looks at the zero flag. If it's not set, the numbers weren't equal, so the branch occurs. If it is set, the numbers were equal, no branch occurs, and execution "falls through" to the next instruction.

Well the `dex` instruction (decrement X) also sets the zero flag to on or off. If the decrement left X at zero, the flag will be set. Any other X value after the decrement will clear (turn off) the zero flag.

We can use this nifty fact in our loop:

```assembly
        lda  #0     ; Keep a zero in the A register
                    
Init    sta  0,x    ; Put A's zero into address $00 + X
        dex         ; Decrement X
        bne  Init   ; Loop as long as X isn't zero
        
        sta  $00    ; A final zero into address $00
```

Notice that we no longer need any sort of "compare" step now. We also don't need the step of transferring the contents of X into A in order to do the comparison. That saves five bytes of code.

Wait, really? All that trouble for five measly bytes? 

Hey, don't knock it! When you're facing the memory contraints of the VCS, those five bytes are considered a pretty big win!

> Spoiler Alert: We also save a lot of processor cycles too. In later examples, when we get more and more into the precise timing required for graphics display, that sort of time savings will become very important.



## Review

* The backwards loop is your friend. Learn it. Know it. Live it.

Next, we'll use the `INCLUDE` pseudo-op to tidy things up even more...

#### Next example: [bbones5.asm](./bbones4.md)
