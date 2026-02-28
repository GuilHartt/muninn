package ecs

set_parent :: #force_inline proc(world: ^World, child, parent: Entity) {
    set(world, child, ChildOf, parent)
}

remove_parent :: #force_inline proc(world: ^World, child: Entity) {
    if parent, ok := get_target(world, child, ChildOf); ok {
        remove(world, child, ChildOf, parent)
    }
}

get_parent :: #force_inline proc(world: ^World, child: Entity) -> (Entity, bool) {
    return get_target(world, child, ChildOf)
}

has_parent :: #force_inline proc(world: ^World, child: Entity) -> bool {
    _, found := get_target(world, child, ChildOf)
    return found
}

get_children :: #force_inline proc(world: ^World, parent: Entity) -> []^Archetype {
    return get_archetypes(world, ChildOf, parent)
}