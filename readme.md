# xl-color

ANSI colors and styles for terminal output in [xlang](https://github.com/hasirciogluhq/xlang): the basic and bright colors,
backgrounds, text styles, the 256-color palette and 24-bit RGB or hex colors. It switches itself off when the output is not a
terminal or the user asks for no color, and `strip` removes the sequences again.

[![ci](https://github.com/hasirciogluhq/xl-color/actions/workflows/ci.yml/badge.svg)](https://github.com/hasirciogluhq/xl-color/actions/workflows/ci.yml)

## Install

```bash
xl pkg add github.com/hasirciogluhq/xl-color
xl pkg install
```

or by hand in `xlang.toml`:

```toml
[dependencies]
"github.com/hasirciogluhq/xl-color" = "v0.1.1"
```

## Usage

```xlang
from "std" import println
from "github.com/hasirciogluhq/xl-color" import red, green, yellow, bold

@entry fn main() -> i32 {
    println(red("error: something failed").asStr())
    println(green("ok").asStr())
    println(yellow("warning").asStr())
    println(bold("done").asStr())
    return 0
}
```

Every helper takes a `str` and returns a `String`: the text between the color's sequence and a reset (`ESC[0m`). Pass a
`String` as `s.asStr()`.

### Several attributes

```xlang
from "github.com/hasirciogluhq/xl-color" import Attribute, style

local title = style(Attribute.Bold, Attribute.Underline, Attribute.FgHiMagenta)
title.println("bold, underlined, bright magenta")
local line = title.wrap("as a String")
```

### 256 colors, RGB and hex

```xlang
from "github.com/hasirciogluhq/xl-color" import Attribute, Color

local orange = Color()
orange.hex("#ff8800")              // also "ff8800", "#f80", "f80"; false for anything else
orange.println("24-bit orange")

local badge = Color(Attribute.Bold)
badge.fg256(16)                    // palette index 0-255
badge.bg256(214)
badge.println(" badge ")

local custom = Color()
custom.rgb(30, 144, 255)
custom.bgRgb(20, 20, 20)
```

### Removing colors

```xlang
from "github.com/hasirciogluhq/xl-color" import red, strip

local colored = red("text")
local plain = strip(colored.asStr())   // "text": for logs, files and width calculations
```

## API

| Name | What it does |
|---|---|
| `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, `white` | basic foreground colors |
| `gray`, `hiRed`, `hiGreen`, `hiYellow`, `hiBlue`, `hiMagenta`, `hiCyan`, `hiWhite` | bright foreground colors |
| `bold`, `faint`, `italic`, `underline`, `reverse`, `strike` | text styles |
| `style(..attrs) -> Color` | a `Color` with several attributes |
| `strip(s) -> String` | `s` without escape sequences |
| `Color()`, `Color(a)` | an empty color, or one with attribute `a` |
| `c.add(a)` | adds an attribute |
| `c.fg256(n)`, `c.bg256(n)` | 256-color palette foreground / background |
| `c.rgb(r, g, b)`, `c.bgRgb(r, g, b)` | 24-bit foreground / background |
| `c.hex(code)`, `c.bgHex(code)` | 24-bit color from `#rrggbb` or `#rgb`; `false` when malformed |
| `c.wrap(s) -> String` | `s` between the sequence and a reset (`str` or `*String`) |
| `c.print(s)`, `c.println(s)` | writes the wrapped text to standard output |
| `c.sequence() -> String` | the sequence alone, empty when colors are off |
| `c.isEmpty()` | true when nothing was added |
| `enabled()` | true when sequences are written |
| `setEnabled(on)`, `resetEnabled()` | forces colors on or off, or goes back to detection |

`Attribute` holds every SGR code: `Reset`, `Bold`, `Faint`, `Italic`, `Underline`, `Blink`, `Reverse`, `Hidden`, `Strike`,
`FgBlack`..`FgWhite`, `FgDefault`, `BgBlack`..`BgWhite`, `BgDefault`, `FgHiBlack`..`FgHiWhite` and `BgHiBlack`..`BgHiWhite`.

## When colors are written

Decided once, on first use, unless `setEnabled` forces it:

1. `FORCE_COLOR` set and not empty: on ([force-color.org](https://force-color.org)).
2. `NO_COLOR` set and not empty: off ([no-color.org](https://no-color.org)).
3. `TERM=dumb`: off.
4. Standard output is a file or a pipe: off.
5. Windows: on when the console accepts virtual terminal processing, which xl-color turns on (the classic console window
   on Windows 10 1511 and later), and in terminals that interpret the sequences themselves (Windows Terminal, VS Code,
   ConEmu, ANSICON, MSYS2, Cygwin, Git Bash).

## Development

```bash
xl test                              # unit tests
xl run examples/demo.xl              # every kind of color once
test/run.sh <xlc> <stdlib dir>       # what CI runs: the unit tests, then the demo with and without a terminal
```

The tests and the demo import the library relatively (`"../index"`); in a project that depends on xl-color, import
`"github.com/hasirciogluhq/xl-color"` instead.

CI runs the tests on Linux and macOS (x86-64, arm64) and Windows x86-64 with the newest `xlc` and stdlib releases. A `v*` tag
publishes a release once they pass.

## License

Apache 2.0
