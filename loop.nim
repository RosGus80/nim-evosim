# ^ Game loop will be as follows: 
# ^    1) Food generation (get random food number and add this amount of food to available cells)
# ^    2) Animal activity (animals wander around eating, fulfiling their need for food)
# ^    3) Animal reproduction (those animals who ate enough food get to reproduce) and mutation (new animals get a slight mutation to their characteristics)
# ?    4) Probably some user interference - dk what exactly though
# * Game goal would be chooseable - either most points after n turns (points are calculated as: sum of each animal's genome traits multiplied by their weight (defined in win-condition json file)) or get n points first or just eliminate all opponent's animals (probably insanely long idk)

import types, service
import std/random

proc generateFood*(field: var Field) =
    randomize()

    # ! Later computate it based on animal amount and weather and stuff. Left it for now
    let foodNum: int = rand(2) + 1
    var foodAdded: int = 0

    while foodAdded < foodNum:
        let row = rand(int(field.size - 1))
        let col = rand(int(field.size - 1))
        if not field.cells[row][col].has_food and not field.cells[row][col].is_occupied:
            field.cells[row][col].has_food = true

            inc(foodAdded)


