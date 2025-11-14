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
    let foodNum: int = rand(10) + 1
    var foodAdded: int = 0

    while foodAdded < foodNum:
        let row = rand(int(field.size - 1))
        let col = rand(int(field.size - 1))
        if not field.cells[row][col].has_food and not field.cells[row][col].is_occupied:
            field.cells[row][col].has_food = true

            inc(foodAdded)


# & Probably a proc for all animal decision making. Currently just goes one step a call towards the closest food or just wandering
proc animalMakeDecision*(animal: var Animal, field: var Field) = 
    
    # ! Later make it a meaningful number
    if animal.species.genome.energy < 1:
        animal.animalRest()
        return

    randomize()

    if animal.food_eaten < animal.food_needed:
        let (foundFood, closestFood) = findClosestFood(animal, field)

        # ^ Step or wander. If new decision making is added, first decide if its worth moving at all
        if foundFood:
            stepTowards(animal, field, closestFood)
        else:
            let directionX: uint = uint(rand(1)) + 1
            let directionY: uint = uint(rand(1)) + 1
            
            let target: (uint, uint) = (directionX, directionY)

            stepTowards(animal, field, target)
    else:
        animal.animalRest()
