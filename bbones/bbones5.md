# Bare-Bones Program #5

* **Code file: [bbones5.asm](./bbones5.asm "Link to source code file for bbones4.asm")**
* [Run in-browser](https://8bitworkshop.com/v3.3.0/embed.html?p=vcs&r=TFpHAAAQAAAAAF8fVxEPAQECAwR42KIAiqjKmkjQ%2B6mIhQlMC%2FD%2FBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHgQbBAIA8ADw "Link to in-browser emulation of bbones4.asm") at 8bitworkshop


Every VCS program you'll write is going to need to set the background color. And you'll eventually wind up setting other video registers (background patterns, player graphics, etc.) and read from input registers (joystick, reset switch, etc.)

Are you really going to have to figure out the addresses for each of these things and define them in every one of your programs with a bunch of equates?

Nope! VCS programmers typically use a common "include" file that already has every VCS register defined and given a standard label. It's similar to the sort of standard header files you might use in a language like C or C++.

By using the `include` pseudo-op, you can instruct the compiler to automatically *include* the definitions in that file in your program, just as if you typed them in yourself.

## Choose Your Inclusion

There are (at least) three ways to reference an included file:

1. Just type the name of the file after your `include` instruction. The compiler will look for the file in the current working directory, so you'll have to be sure that copies of your include files exist there.
2. Specify the exact path to the include file after the `include`, either as an absolute path or (ideally) relative to the current working directory.
   * Since this particular repository keeps the include files in `_includes`, you could do something like `include ../_includes/vcs.h`, for example.
   * This saves you from having to fool with multiple copies of your include files.
3. Use just the file names (as in option #1), but give the directory for your include files as a compile-time option. In dasm, that would look like this:
   * `dasm mygame.asm -f3 -omygame.bin -I../_includes`
   
The examples in this project do not specify paths in the `include` statements, so you'll have to either use methods 1 or 3, or edit the code to add the path in.

## vcs.h

TBD



## macro.h

Under construction


## Review

* The backwards loop is your friend. Learn it. Know it. Live it.

Well that's it for the Bare-Bones Program. (If we refined it any further, we'd have to start calling it "Fancy-Bones"!)

Our next mission is to figure out some way to convey some information to the user. Don't get your hopes up--it won't be much. But at least we won't have a blank screen...



#### Next example: [rudout1.asm](../rudout/rudout1.md)
