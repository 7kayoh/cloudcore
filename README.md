[![Publish docs via GitHub Pages](https://github.com/7kayoh/cloudcore/actions/workflows/main.yml/badge.svg?branch=master)](https://github.com/7kayoh/cloudcore/actions/workflows/main.yml)

# CloudCore
CloudCore is an efficient and reliable MVC-based game framework for Roblox experiences.

## CloudCore not >= Knit
CloudCore share a few similarities from Knit, but CloudCore should never be compared to Knit because they both are a game framework. In deeper structure, CloudCore is not alike Knit.

## Required tools
- Rojo

If you use Foreman but you do not have Rojo installed systemwide, use command `foreman install`

You can install Rojo in other methods, check out [the documentation](https://rojo.space)

## Installation
### Rojo Serve
Read `Building from source`

### RBXMX
Use command `rojo build` to build into a RBXMX file
```
rojo build --output "export.rbxmx"
```

and then import `export.rbxmx` into your game, and put it inside `ReplicatedStorage`

## Building from source
If you are coming from an *NIX operating system, the command `make` usually should come with your operating system or distribution. If you have installed `Rojo`, you can execute `make` within the project directory, which should build a `.rbxlx` file.

For your information, the `.gitignore` file has already ignored the `.rbxlx` file, you do not really need to remove the built file when you are about to publish your change.

However, if you are using Windows, you have to install a variation of `make` that works with Windows, such as the one provided by GNUWin32, or via Chocolately (`choco install make`). You can also use WSL/WSL2 if you prefer it that way.
