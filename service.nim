import types
import std/random


proc distance*(a: (uint,uint), b: (uint,uint)): int =
    abs(int(a[0]) - int(b[0])) + abs(int(a[1]) - int(b[1]))


proc clampCoord(x, max: uint): uint =
    if x > max: max else: x


# & Function to find next closest step to target considering that some cells are is_occpuied. 
# proc djikstraNextStep(animal: Animal, target: (uint, uint), field: Field): (uint, uint) = 



proc stepTowards(animal: var Animal, field: var Field, target: (uint,uint)) =
    var (ax, ay) = animal.pos.pos
    let (tx, ty) = target

    if ax < tx: inc(ax)
    elif ax > tx: dec(ax)

    if ay < ty: inc(ay)
    elif ay > ty: dec(ay)

    let max = field.size - 1

    field.cells[ax][ay].is_occupied = false

    ax = clampCoord(ax, max)
    ay = clampCoord(ay, max)

    animal.pos.pos = (ax, ay)

    field.cells[ax][ay].is_occupied = true


proc findClosestFood*(animal: Animal, field: Field): (bool, (uint,uint)) =
    var found: bool = false
    var closestPos: (uint,uint) = (0,0)
    var minDist: int = 9999 # ? Just a big number

    for i in 0..<int(field.size):
        for j in 0..<int(field.size):
            let cell: Cell = field.cells[i][j]
            if cell.has_food:
                let d: int = distance(animal.pos.pos, cell.pos)
                if d <= int(animal.species.genome.vision) and d < minDist:
                    minDist = d
                    closestPos = cell.pos
                    found = true

    return (found, closestPos)


# & Probably a proc for all animal decision making. Currently just goes one step a call towards the closest food or just wandering
proc animalMakeDecision*(animal: var Animal, field: var Field) = 
    randomize()

    let (foundFood, closestFood) = findClosestFood(animal, field)

    # ^ Step or wander. If new decision making is added, first decide if its worth moving at allf
    if foundFood:
        stepTowards(animal, field, closestFood)
    else:
        let directionX: uint = uint(rand(1)) + 1
        let directionY: uint = uint(rand(1)) + 1
        
        let target: (uint, uint) = (directionX, directionY)

        stepTowards(animal, field, target)

