# .dotfiles

## Requirements

On Mac:
* [XCode](https://itunes.apple.com/us/app/xcode/id497799835?mt=12)
* XCode command line tools: `xcode-select --install` (followed something like `sudo gcc --version` to accept
    the license).
* [Java JDK](http://www.oracle.com/technetwork/java/javase/downloads/index.html)

On Linux:
* git
* sudo

## Installing

```
git clone git@github.com:vrivellino/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./go.sh
```

If on Linux, you need to explicitly specify if it's for a dev environment: `./go.sh dev`
