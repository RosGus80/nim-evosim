import types
import std/terminal, std/tables, std/strutils

const
    redBg   = "\e[41m"
    greenBg = "\e[42m"
    reset   = "\e[0m"


proc drawField*(field: Field, animals: seq[Animal]) =
    var occupied = initTable[(uint,uint), Animal]()

    for a in animals:
        occupied[a.pos.pos] = a

    let cellWidth: uint = 2
    let widthChars = field.size * cellWidth

    stdout.write("+" & repeat("-", widthChars) & "+\n")

    for i in 0..<int(field.size):
        stdout.write("|")

        for j in 0..<int(field.size):
            let cell = field.cells[i][j]

            if occupied.hasKey(cell.pos):
                stdout.write(redBg & " ".repeat(cellWidth) & reset)
            elif cell.has_food:
                stdout.write(greenBg & " ".repeat(cellWidth) & reset)
            else:
                stdout.write(" ".repeat(cellWidth))

        stdout.write("|\n")

    stdout.write("+" & repeat("-", widthChars) & "+\n")
    