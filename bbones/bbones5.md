# Bare-Bones Program #5

* **Code file: [bbones4.asm](./bbones5.asm "Link to source code file for bbones4.asm")**
* [Run in-browser](https://8bitworkshop.com/v3.3.0/embed.html?p=vcs&r=TFpHAAAQAAAAAF8fVxEPAQECAwR42KIAiqjKmkjQ%2B6mIhQlMC%2FD%2FBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHgQbBAIA8ADw "Link to in-browser emulation of bbones4.asm") at 8bitworkshop


Pretty much every VCS program you'll write is going to want to set the background color. And they'll almost certainly need to set other video registers (background patterns, player graphics, etc.) and read from input registers (joystick, reset switch, etc.).

Are you really going to have to figure out the addresses for each of those things and then define them in every one of your programs with a bunch of equates?

Hope! Well, you could if you really wanted to be a masochist about it. But most VCS programmers use a common "include" file that already has every VCS register defined and given a standard label.

By using the `include` pseudo-op, you can instruct the compiler to automatically *include* the definitions in that file in your program.

## Choose Your Inclusion

Three ways to include these files:

1. Just specify the name of the file after your `include` instruction. The compiler will look for the file in the current working directory, so you'll have to be sure that a copy of the file exists there.
2. Specify the exact path to the include file after the `include`, either as an absolute path or (ideally) relative to the current working directory.
   * Since this repository keeps the include files in `_includes`, you could do something like `include ../_includes/vcs.h`, for example.
   * The advantage is that you don't have fool with multiple copies of your include files.
   * The disadvantage is that, if you move your source code, you'll have to update all of your `include` statements.
3. Specify the directory for your include files as a compile-time option.

## vcs.h

TBD



## macro.h

Under construction


## Review

* The backwards loop is your friend. Learn it. Know it. Live it.

Well that's it for the Bare-Bones Program. (If we refined it any further, we'd have to start calling it "Fancy-Bones"!)

Our next mission is to figure out some way to convey some information to the user. Don't get your hopes up--it won't be much. But at least we won't have a blank screen...



#### Next example: [rudout1.asm](../rudout/rudout1.md)
