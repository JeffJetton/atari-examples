# Rudimentary Output #1

* **Code file: [rudout1.asm](./rudout1.asm)**
* [Run in-browser](https://8bitworkshop.com/v3.3.0/embed.html?p=vcs&r=TFpHAAAQAAAAAGUphBP6AQECAwR42KIAiqjKmkjQ%2B6kGhQmpRoUIqbeFDkwT8P8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQeBBcA8ADw "Link to in-browser emulation of bbones1.asm") at 8bitworkshop


The VCS has no built-in text display capability, which makes the traditional "Hello, World!" program a surprisingly complicated undertaking. So for now, we're just going to display a single number on the screen. And we're doing to represent that number in **binary**, using vertical lines.

Sure, it's not much. But it's easy to do, and it *is* technically output!

> **Fun Fact:** You can think of this as a throwback to early personal computers like the [Altair 8800](http://oldcomputers.net/altair-8800.html). It didn't initially ship with a monitor, so users would commonly read binary output via rows of red LED lights on the front panel.


## The Playfield

The VCS was originally designed to run the sorts of games that were popular in arcades at the time, in particular, [Pong](https://en.wikipedia.org/wiki/Pong) and [Tank](https://en.wikipedia.org/wiki/Tank_(video_game)). You can plainly see the legacy of those games in the features they decided to put into the TIA video chip.

For example, some of the TIA registers are dedicated to drawing the "playfield"--static game backgrounds, often of a single color, such as the court walls in [Video Olympics](https://en.wikipedia.org/wiki/Video_Olympics) and the various mazes and clouds in [Combat](https://en.wikipedia.org/wiki/Combat_(Atari_2600)). Of course, like all the display registers we'll learn about, you can use them for something other than their intended purpose. Starting with some of the very first VCS cartridges, for example, programmers would often rig the playfield to show the score at the top or bottom of the screen.

The playfield divides the screen evenly into 40 vertical columns, which can be either set (showing the playfield color) or not set (allowing the background color to "show through"). Actually, you can only *directly* set the left 20 columns. The right half is designed to either repeat (copy) or reflect (mirror) whatever the left side is showing.

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

Two other registers control how the playfield pattern is displayed:

* `COLUPF` - Playfield Color
    * Works just like the background color register (`COLUBK`)
* `CTRLPF` - Playfield Control
    * Set the first bit to one to turn on mirror/reflection mode
    * Other bits do other things that we don't need to worry about right now...
    
## Wait a Second...

Am I really saying that the playfield just lets you define **vertical columns**? Just solid lines running all the way down the screen?

Technically, yes. That's all it knows how to do: Draw or not draw at certain specific horizontal positions. It's like someone with a rubber stamp, mindlessly stamping the same pattern all the way down a piece of paper.

Displaying anything more complicated than that involves re-setting the registers *very* quickly, while each frame of the screen is being drawn! In other words, you have to wait until the doofus with a rubber stamp raises his arm, then quickly grab the stamp and replace it with a different one before he ever notices.

> **Fun Fact:** Programming graphics on the VCS is really, really weird.




```{assembly}
        MyPFCol equ $46
```

And later, we're 
## Extra Credit

1. As mentioned above, the default behavior for the playfield is to simply copy the left side over onto the right side. But you also have the option to *reflect* a mirror-image of the left side instead, by setting bit zero of the `CTRLPF` (**C**on**TR**o**L P**lay**F**ield) register.
    * Try it out!
2. Try loading A with different numbers. (Be sure to use the `#` symbol!)
    * For example, how does (decimal) 10 look compared to 20? Compared to 5?
    * What does this demonstrate about multiplying and dividing binary numbers by two?



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



#### Next example: [rudout2.asm](../rudout/rudout2.md)