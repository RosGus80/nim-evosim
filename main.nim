import service, types, terminal_render, loop


# echo repr findClosestFood(animal)

var field = Field(
    size: 20,
)

initField(field)


let p1 = Player(
    name: "me", points: 0, color: ""
)

let g1 = Genome(
    speed: 0.1, energy: 10, vision: 100
)

let s1 = Species(
    genome: g1, name: "s1"
)

var a1 = Animal(
    species: s1, owner: p1, food_needed: 1, food_eaten: 0, pos: field.cells[0][0]
)

var a2 = Animal(
    species: s1, owner: p1, food_needed: 1, food_eaten: 0, pos: field.cells[field.size-1][field.size-1]
)

# ? Maybe make a helper to automatically make cell occupied when animal steps on it so i cant mes up
field.cells[0][0].is_occupied = true


var animals: seq[Animal] = @[a1, a2]


generateFood(field)

drawField(field, animals)

for i in 0..12:
    for i in 0..animals.len-1:
        animalMakeDecision(animals[i], field)

    eatFood(field)

    drawField(field, animals)

    shuffleAnimals(animals) # ^ So that no particular animal have a recurring head start because it taks a turn first
    