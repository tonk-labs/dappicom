![Dappicom Banner of a product box floating, it says "Provable NES emulator"](1_DappicomBox.gif)
# [Dappicom](https://tonk-gg.github.io/dappicom-site) — NES Emulation in Noir

Dappicom is a provable Nintendo Entertainment System emulator written in Noir and Rust. Practically, this is a ZKVM which supports the MOS 6502 instruction set and a few NES specific quirks. The ZKVM is built in Noir (we heard you liked ZKVMs, so we put a ZKVM in your ZKVM).

The project is in its early stages. There is a loose skeleton structure laid out which should make collaboration much easier moving forward. As with all "architecting" there will be gaps that will get filled in as the project matures.

## What does that mean?
Hopefully, it means you can play NES ROMs on your local machine and then prove outcomes of that gameplay onchain to trigger downstream rewards/consequences. That's the end goal.

Using zero knowledge to prove off-chain compute *effectively* brings the result of that compute onto the blockchain when it is verified. Think of what you might want to do with NES gameplay when it's composable, permissionless and trustless. 

##  Why are you doing this?
A whole bunch of reasons!
1. **Dappicom could bootstrap the onchain game catalog with retro games**. Today (and despite enormous industry hype) there’s a dearth of actual onchain gaming content. Onchain games also come with a crypto learning curve. Playing NES games is simple, and there is a large catalog of ROMs. (Legally, we want to flag at this point that any ROMs you play on a NES emulator should be your legitimately-owned ROMs!)
2. **Dappicom widens the appeal of onchain games beyond a crypto-native audience**. Dappicom doesn’t require a token and nor does it fit the play-to-earn model, which has a controversial reputation in gaming. To prove out the fully-onchain gaming category we need to cross the chasm beyond gamers who play games just to earn tokens. Dappicom could appeal to the retro gaming scene beyond crypto.
3. **Dappicom illustrates the power of provable gaming**. Proving speedruns with hidden strategies has never been done before. Speedruns are often contested - for example, Dream’s controversial Minecraft speedrun. You can’t argue with maths, though.
4. **Dappicom can level-up developers in Noir**. Noir and other ZK DSLs will be imporant parts of the future internet stack; it’s important to get developers up to speed. The project comes with plenty of documentation to get someone contributing right away. There will be extra material discussing best practices when writing Noir code.
5. **Dappicom stretches Noir in powerful ways**. Dappicom shows that Noir has ambitions beyond being a DSL for Aztec protocol, and also has significant performance needs for Noir to match.

Also, it's fun - and the MOS 6502 is beautiful & historically significant.

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

Thanks to [Frank Laub](https://github.com/flaub) at Risc0 for discussions on ZKVM design and feedback on proving MOS 6502 execution.

Shoutout to [Paco Bytes'](https://twitter.com/therealbytes/status/1668301322481704960?s=20) version of onchain NES with precompiles and also [Nalin's](https://twitter.com/nibnalin) Game Boy emulation that used fraud proofs.
 
This project is funded by an [Aztec grant](https://aztec.network/grants/). Without them it wouldn't happen :)

Illustration made by [Hi-Bred](https://hi-bred.net) and may only be used in this project.
