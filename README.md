# KeepingYouAwake #

KeepingYouAwake is a small menu bar utility for macOS Yosemite *(Version 10.10)* and newer that can prevent your Mac from entering sleep mode for a predefined duration or as long as it is activated.

## Installation

**[Download the latest version here.](https://github.com/newmarcel/KeepingYouAwake/releases)**

or install it via [cask](http://caskroom.io/): `brew cask install keepingyouawake`.

![Screenshots](./Screenshots.jpg)

## Why does this project exist, Caffeine.app works perfectly fine? ##

*[Caffeine](http://lightheadsw.com/caffeine/)* from *Lighthead Software* is a great utility and I used it for many years, but it hasn't been updated in a while. Its icons are not Retina-compatible and do not look nice in the dark themed menu bar.

## How do you prevent my Mac from sleeping? ##

This utility is just a small wrapper around Apple's caffeinate command line utilty. Any modern Mac ships this tool by default. You can read the manpage [here](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man8/caffeinate.8.html).

## Is this dangerous? ##

Just to make it clear: this utility shouldn't harm your Mac because it is using an official command line tool from Apple, **BUT** I cannot guarantee anything, so use this tool **AT YOUR OWN RISK**.

## Help Wanted! ##

Do you want to improve the app or add any useful features? Please go ahead and create pull requests. I'm thankful for any help.

## Building the Source Code ##

*KeepingYouAwake* uses [Carthage](https://github.com/Carthage/Carthage) as dependency manager. You can install Carthage with [Homebrew](http://brew.sh). Type `brew update && brew install carthage` and call `carthage bootstrap` in the *KeepingYouAwake* source code folder to download and build all dependencies.

## License ##

Everything in this project is licensed under the [MIT license](http://opensource.org/licenses/MIT). I even included the Sketch files for all image assets in this project.
