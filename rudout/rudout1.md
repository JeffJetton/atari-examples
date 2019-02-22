# Rudimentary Output #1

* **Code file: [rudout1.asm](./rudout1.asm)**
* [Run in-browser](https://8bitworkshop.com/v3.3.0/embed.html?p=vcs&r=TFpHAAAQAAAAAF8fVxEPAQECAwR42KIAiqjKmkjQ%2B6mIhQlMC%2FD%2FBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHwQfBB8EHgQbBAIA8ADw "Link to in-browser emulation of bbones4.asm") at 8bitworkshop


My well-worn (autographed!) copy of Kernigan and Ritchie's *The C Programming Language* starts out with an example program that displays the message "hello, world!" That started a tradition that's been held by just about every programming language tutorial since then. Heck, there's even [a GitHub repository](https://github.com/leachim6/hello-world) that is trying to collect "Hello, World!" examples in every conceivable computer language.

The VCS has no built-in text display functionality though.




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