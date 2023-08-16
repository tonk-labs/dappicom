![Dappicom Banner of a product box floating, it says "Provable NES emulator"](1_DappicomBox.gif)
# [Dappicom](tonk-gg.github.io/dappicom-site) — NES Emulation in Noir

Dappicom is a provable Nintendo Entertainment System emulator written in Noir and Rust. Practically, this is a zkvm which supports the MOS 6502 instruction set and a few NES specific quirks. The zkvm is built in Noir (we heard you liked zkvms, so we put a zkvm in your zkvm).

The project is in its early stages. There is a loose skeleton structure laid out which should make collaboration much easier moving forward, however like any kind of "architecting" there will be oversights and gaps. As the project matures those gaps will be filled in and oversights corrected.

## What does that mean?
Hopefully, it means you can play NES ROMs on your local machine and then prove outcomes of that gameplay onchain to trigger downstream rewards/consequences. That's the end goal.

Using zero knowledge to prove off-chain compute *effectively* brings the result of that compute onto the blockchain when it is verified. Think of what you might want to do with NES gameplay when it's composable, permissionless and trustless. We call it the "retro gaming universe".

##  Why are you doing this?
1. Because it's fun!
2. This is a great way to make discoveries about performant zkvm design, especially in the context of onchain games. Good zkvm design is important both for twitchy gamefeel for fully onchain games, and also to facilitate hidden information. Neither of these are trivially possible within a vanilla blockchain execution environment.
3. The MOS 6502 processor is beautiful and historically significant. While this project aims to emulate the NES, one can adapt it to play games from other computer systems which used the MOS 6502 (Commodore 64, Apple II etcetera). 
4. There is a homebrew community which still writes programs for these systems. We are interested to see what happens when you blend retro gaming with onchain "metagame" affordances and extensions. 


## How does it work?

[See roadmap and product flow technical explainer](TECHNICAL.md)

## I want to contribute

That's great! We are actively seeking contributions and are grateful for your support. Please see the [contribution guidelines](CONTRIBUTING.md) to get started. 

## How to run

The NES emulator will require modifications to output the transcript and snapshot its state in a format most suitable for proving. In the interest of developer velocity, we have gone ahead and forked the tetanes project. For now, it's a submodule. 

Performance is nearly 60fps when using the release build. When running the binary, you can load a test_rom or play the freeware roms in play_rom
```
cd tetanes

# make sure you have these installed
brew install sdl2 sdl2_gfx sdl2_image sdl2_mixer sdl2_ttf

cargo build
cargo run
```

Noir circuits should have tests being written for them. For those circuits that do have tests you can run them by [installing Noir](https://noir-lang.org/getting_started/nargo_installation) and then in the root folder for example ([/circuits/cpu](/circuits/cpu)) run:
```
nargo test
```

## Credits

Thanks to [lukexor](https://lukeworks.tech/) for open-sourcing their tetanes project, which is a feature rich NES emulator written in Rust.

Thanks to [nesdev.org](https://nesdev.org) — an incredible resource, practically the single resource for all things NES.

Thanks to bugzmanov for their wonderful [write-up](https://bugzmanov.github.io/nes_ebook/index.html) on NES emulation in Rust and provided example code. This is a great beginners guide into writing a NES emulator in Rust.

Thanks to [Frank Laub](https://github.com/flaub) at Risc0 for discussions on zkvm design and feedback on proving MOS 6502 execution.

This project is funded by an [Aztec grant](https://aztec.network/grants/). Without them it wouldn't happen :)

Illustration made by [Hi-Bred](https://hi-bred.net) and may only be used in this project.