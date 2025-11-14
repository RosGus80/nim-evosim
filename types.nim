type 
    Genome* = object
        # ^ Add new features gradually. Now test on these. Ideas for features: size, aggressivness, age cap, maybe some special traits (i think they'll be a separate obj)
        speed*: float
        energy*: float
        vision*: uint

    Player* = object
        name*: string
        color*: string
        points*: uint # ? Spent on stronger genomes, more species, more animals

    Species* = object
        name*: string
        genome*: Genome

    Animal* = object
        species*: Species
        owner*: Player

        pos*: Cell

        food_needed*: int
        food_eaten*: int

    Cell* = object
        pos*: (uint, uint)
        has_food*: bool
        is_occupied*: bool

    Field* = object
        size*: uint
        cells*: seq[seq[Cell]]


# & Currently just populate cells
proc initField*(field: var Field) = 
    for i in 1..field.size:
        var new_row: seq[Cell] = @[]
        for ii in 1..field.size:
            new_row.add(
                Cell(
                    pos: (i, ii), 
                    has_food: false
                )
            )

        field.cells.add(new_row)
