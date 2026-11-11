# xl-color

ANSI color library for [xlang](https://github.com/hasirciogluhq/xlang).

## Install

```bash
xl add github.com/hasircioglu/xl-color
# or
xl add @hasircioglu/xl-color
```

## Usage

```xl
import Red, Green, Yellow, Cyan from "github.com/hasircioglu/xl-color"
import String from "std/str/string"

@entry fn main() {
    Red(String("error: something failed"))
    Green(String("success"))
    Yellow(String("warning"))
    Cyan(String("info"))
}
```

### String versions

```xl
import RedString, GreenString from "github.com/hasircioglu/xl-color"

local msg := RedString(String("error"))
println("{}", msg.asStr())
```

### Custom color

```xl
import Color, Attribute from "github.com/hasircioglu/xl-color"

local c := Color.new([Attribute.FgHiMagenta, Attribute.Bold])
c.Print(String("bold magenta"))
```

## Colors

| Function   | Color          |
|------------|----------------|
| `Red`      | Red            |
| `Green`    | Green          |
| `Yellow`   | Yellow         |
| `Blue`     | Blue           |
| `Cyan`     | Cyan           |
| `Magenta`  | Magenta        |
| `White`    | White          |
| `HiRed`    | Bright Red     |
| `HiGreen`  | Bright Green   |
| ...        | ...            |

## Notes

- Always emits ANSI codes (no `NO_COLOR` or TTY detection yet)
- Windows color support not included
- RGB / background colors not in this release

## License

Apache 2.0
