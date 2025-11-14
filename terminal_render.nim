import types
import std/terminal, std/tables, std/strutils

const
    redBg   = "\e[41m"
    greenBg = "\e[42m"
    reset   = "\e[0m"


proc drawField*(field: Field, animals: seq[Animal]) =
    var occupied = initTable[(uint,uint), Animal]()

    # quick lookup for animals
    for a in animals:
        occupied[a.pos.pos] = a

    let cellWidth: uint = 2          # "  "
    let widthChars = field.size * cellWidth

    # top border
    stdout.write("+" & repeat("-", widthChars) & "+\n")

    # draw each row
    for i in 0..<int(field.size):
        stdout.write("|")     # left border

        for j in 0..<int(field.size):
            let cell = field.cells[i][j]

            if occupied.hasKey(cell.pos):
                stdout.write(redBg & "  " & reset)
            elif cell.has_food:
                stdout.write(greenBg & "  " & reset)
            else:
                stdout.write("  ")

        stdout.write("|\n")   # right border

    # bottom border
    stdout.write("+" & repeat("-", widthChars) & "+\n")
    