import types
import std/random


proc distance*(a: (uint,uint), b: (uint,uint)): int =
    abs(int(a[0]) - int(b[0])) + abs(int(a[1]) - int(b[1]))


proc clampCoord(x, max: uint): uint =
    if x > max: max else: x


# & Function to find next closest step to target considering that some cells are is_occpuied. 
# proc djikstraNextStep(animal: Animal, target: (uint, uint), field: Field): (uint, uint) = 


proc animalRest*(animal: var Animal) =
    animal.species.genome.energy += 1


# & proc for draining energy from animals after they walked 
proc animalFatigue*(animal: var Animal) =
    # ! 1 for now. Later calculate based on speed, size, etc.
    animal.species.genome.energy -= 1


proc stepTowards*(animal: var Animal, field: var Field, target: (uint,uint)) =
    var (ax, ay) = animal.pos.pos
    let (tx, ty) = target

    let max = field.size - 1

    var newX = ax
    var newY = ay

    if ax < tx: inc(newX)
    elif ax > tx: dec(newX)

    if ay < ty: inc(newY)
    elif ay > ty: dec(newY)

    newX = clampCoord(newX, max)
    newY = clampCoord(newY, max)

    if not field.cells[newX][newY].is_occupied:
        field.cells[ax][ay].is_occupied = false

        animal.pos.pos = (newX, newY)
        field.cells[newX][newY].is_occupied = true

        animal.animalFatigue()
    else:
        animal.animalRest()


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



proc eatFood*(field: var Field) = 
    for i in 0..field.size-1:
        for j in 0..field.size-1:
            if field.cells[i][j].is_occupied:
                # echo "Food eaten! " &  repr(field.cells[i][j].has_food) & " " &  $i & " " & $j

                # ! If occupied will not neccessairly mean that there is an animal (maybe its terrain or something), change this and check if this is an animal here!
                field.cells[i][j].has_food = false

                # echo "Food eaten! " &  repr(field.cells[i][j].has_food) & " " &  $i & " " & $j

