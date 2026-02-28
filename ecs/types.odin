package ecs

ID_PAIR_FLAG :: 0x8000_0000_0000_0000

Entity   :: distinct u64

Wildcard :: Entity(0)
ChildOf  :: Entity(0x7FFFFFFF)

Component :: union { Entity, typeid }

Pair :: struct {
    relation: Component,
    target:   Component,
}

TypeInfo :: struct {
    id:    Entity,
    size:  int,
    align: int,
}

EntityRecord :: struct {
    archetype: ^Archetype,
    row:       int,
    gen:       u16,
}

Iter :: struct {
    world:  ^World,
    data:   rawptr,
    entity: Entity,
    arch:   ^Archetype,
    row:    int,
    count:  int,
}