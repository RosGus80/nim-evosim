import types
import std/random, std/sequtils, std/deques


proc distance*(a: (uint,uint), b: (uint,uint)): int =
    abs(int(a[0]) - int(b[0])) + abs(int(a[1]) - int(b[1]))


proc clampCoord(x, max: uint): uint =
    if x > max: max else: x


# & Function to find next closest step to target considering that some cells are is_occpuied. 
proc dijkstraNextStep*(animal: Animal, field: Field, target: (uint, uint)): (bool, (uint,uint)) =   
    # TODO: Will add meaningful weighing so that if there are (detected) carnivors in sight, 
    # TODO: adjacent tiles become more costly, etc.
    let size = int(field.size)

    let startX = int(animal.pos.pos[0])
    let startY = int(animal.pos.pos[1])
    let goalX  = int(target[0])
    let goalY  = int(target[1])

    const directions = [
        (0'i32, 1'i32),
        (1'i32, 0'i32),
        (0'i32, -1'i32),
        (-1'i32, 0'i32)
    ]

    var dist = newSeqWith(size, newSeqWith(size, 999999))
    dist[startX][startY] = 0

    var parent = newSeqWith(size, newSeqWith(size, (-1, -1)))

    var dq = initDeque[(int, int)]()
    dq.addLast((startX, startY))

    while dq.len > 0:
        let (x, y) = dq.popFirst()

        if x == goalX and y == goalY:
            break

        for d in directions:
            let nx = x + d[0]
            let ny = y + d[1]

            if nx < 0 or ny < 0 or nx >= size or ny >= size:
                continue

            if field.cells[nx][ny].is_occupied and not (nx == goalX and ny == goalY):
                continue

            let newCost = dist[x][y] + 1
            if newCost < dist[nx][ny]:
                dist[nx][ny] = newCost
                parent[nx][ny] = (x, y)
                dq.addLast((nx, ny))

    if dist[goalX][goalY] == 999999:
        return (false, (0,0))

    var cx = goalX
    var cy = goalY

    while parent[cx][cy] != (startX, startY):
        let p = parent[cx][cy]
        cx = p[0]
        cy = p[1]

        if cx == -1:
            return (false, (0,0))

    return (true, (uint(cx), uint(cy)))


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


proc shuffleAnimals*(animals: var seq[Animal]) =
    var r = initRand(67)

    r.shuffle(animals)
    