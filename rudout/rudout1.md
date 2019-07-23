# Rudimentary Output #1

* **Code file: [rudout1.asm](./rudout1.asm)**
* [Run in-browser](https://8bitworkshop.com/v3.3.0/embed.html?p=vcs&r=TFpHAAAQAAAAAGUphBP6AQECAwR42KIAiqjKmkjQ%2B6kGhQmpRoUIqbeFDkwT8P8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQeBBcA8ADw "Link to in-browser emulation of bbones1.asm") at 8bitworkshop


The VCS has no built-in text display capability, which makes the traditional "Hello, World!" program an absurdly complicated undertaking. So for now, we're just going to display a single number on the screen. And we're doing to represent that number in **binary**, using vertical lines.

Sure, it's not much. But it's easy to do, and it *is* technically output!

> **Fun Fact:** This is sort of a throwback to early personal computers like the [Altair 8800](http://oldcomputers.net/altair-8800.html). It didn't initially ship with a monitor, so users would commonly read output in binary, via rows of red LED lights on the front panel.


## The Playfield

The VCS was originally designed to run the sorts of games that were popular in arcades at the time, in particular, [Pong](https://en.wikipedia.org/wiki/Pong) and [Tank](https://en.wikipedia.org/wiki/Tank_(video_game)). You can plainly see the legacy of those games in the features they decided to put into the TIA video chip.

For example, some of the TIA registers are dedicated to drawing the "playfield", which was intended for static game backgrounds, often of a single color, such as the court walls in [Video Olympics](https://en.wikipedia.org/wiki/Video_Olympics) and the various mazes and clouds in [Combat](https://en.wikipedia.org/wiki/Combat_(Atari_2600)).

The playfield divides the screen evenly into 40 vertical **columns**, which can be either set (showing the playfield color) or not set (allowing the background color to "show through").

Actually, you can only *directly* set the left 20 columns. The right half is designed to either repeat (copy) or reflect (mirror) whatever the left side is showing.

To set the pattern of the 20 left-side columns, you simply write values to three registers. Where a bit is 1, the playfield is drawn. Where a bit is 0, it's not:

* `PF0` - Playfield 0
    * Draws the first four columns
    * Only the four highest (leftmost) bits of the register are used
    * Columns are drawn "backwards" compared to the bit pattern. That is, the first column is set by the fifth bit, the second column by the sixth bit, and so on.
* `PF1` - Playfield 1
    * Draws columns 5-12
    * The displayed columns match the bit pattern
* `PF2` - Playfield 2
    * Draws the final eight columns
    * Bits are "backwards" like PF0

The playfield color is set using `COLUPF`, which works just like the background color register (`COLUBK`).


## Wait a Second...

Am I really saying that the playfield just lets you define **vertical columns**? Just solid lines running all the way down the screen?

Technically, yes. That's all it knows how to do: Draw or not draw at certain specific horizontal positions. It's like a robot with a rubber stamp, mindlessly stamping the same pattern all the way down TV screen.

Displaying anything more complicated involves writing new values to the registers *very* quickly, while each frame of the screen is being drawn! In other words, you have to wait until the robot is "between stamps" (with its robot arm briefly lifted), then quickly grab the stamp and replace it with a different one before it ever notices.

> **Fun Fact:** Programming graphics on the VCS is really, really weird.


## The Code

Since PF1 is the only playfield register that's not "backwards", we'll use that one to display our binary vaue.

First we define a new constant to represent the playfield color.

```{assembly}
        MyPFCol equ $46
```

A few lines down, we set that color, similar to setting the background:

```{assembly}
        lda #MyPFCol
        sta COLUPF
```

Finally, we load a value into A and then back out to PF1 pattern register:

```{assembly}
        lda #%10110111
        sta PF1
```

## Extra Credit

1. By default (assuming you've initialized the VCS correctly), the playfield will use "copy" mode and just repeat the left side on the right. Try changing to "reflect" mode by storing a 1 in bit zero of the `CTRLPF` (**C**on**TR**o**L P**lay**F**ield) register.
2. Try loading A (and thus PF1) with different numbers.
    * Be sure to use the `#` symbol! (What would happen if you didn't?)
    * For example:
        * How does (decimal) 10 look when displayed in binary, compared to 20? Compared to 5?
        * What does this demonstrate about multiplying and dividing binary numbers by two?
3. Insert a `nop` (no operation) instruction right before the `jmp`. Using a label, change your `jmp` so that it jumps to the `nop` instead of all the way back up to `LoadA`.
    * How many times does the program now write to PF1?
    * Does PF1 "remember" that initial setting, or does it need to be constantly reset?



## Review

* The playfield registers let you draw patterns on the screen and are typically used for game backgrounds
* Registers PF0 and PF2 are mapped backwards, and only the highest four bits of PF0 are used
* By default, the playfield consists of columns. The pattern you set the playfield registers to is drawn all the way down the screen (for now!)
    

Now that we can display a number, we'll do some simple math next...


#### Next example: [rudout2.asm](../rudout/rudout2.md)