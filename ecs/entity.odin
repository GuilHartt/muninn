package ecs

import "core:slice"

create_entity :: proc(world: ^World) -> Entity {
    idx: u32
    gen: u16

    if len(world.free_indices) == 0 {
        idx = u32(len(world.entity_index))
        append(&world.entity_index, EntityRecord{})
    } else {
        idx = pop(&world.free_indices)
        gen = world.entity_index[idx].gen
    }

    return entity_id(idx, gen)
}

destroy_entity :: proc(world: ^World, entity: Entity) {
    if !is_alive(world, entity) do return

    idx := entity_id_idx(entity)
    record := &world.entity_index[idx]

    if record.archetype != nil {
        remove_entity_row(world, record.archetype, record.row)
    }

    record.gen += 1
    record.archetype = nil
    record.row = -1

    append(&world.free_indices, idx)
}

is_alive :: proc(world: ^World, entity: Entity) -> bool {
    if entity == 0 || id_is_pair(entity) do return false

    idx := entity_id_idx(entity)
    gen := entity_id_gen(entity)

    if int(idx) >= len(world.entity_index) {
        return false
    }

    return world.entity_index[idx].gen == gen
}

add :: proc {
    add_value,
    add_type,
    add_id,
    add_pair,
}

remove :: proc {
    remove_type,
    remove_id,
    remove_pair,
}

set :: proc {
    add_value,
    add_type,
    add_id,
    set_pair,
}

get :: proc {
    get_component,
    get_id,
}

has :: proc {
    has_type,
    has_id,
    has_pair,
}

get_target :: proc {
    get_target_type,
    get_target_id,
}

get_components :: proc(world: ^World, entity: Entity) -> []Entity {
    if !is_alive(world, entity) do return nil

    record := &world.entity_index[entity_id_idx(entity)]
    if record.archetype == nil {
        return nil
    }

    return record.archetype.types
}

pair :: proc {
    pair_id_id,
    pair_type_id,
    pair_id_type,
    pair_type_type,
}

@private
pair_id_id :: #force_inline proc "contextless" (r, t: Entity)  -> Pair {
    return {r, t}
}

@private
pair_type_id :: #force_inline proc "contextless" ($Rel: typeid, t: Entity) -> Pair {
    rel: typeid = Rel
    return Pair{ relation = rel, target = t }
}

@private
pair_id_type :: #force_inline proc "contextless" (r: Entity, $Tgt: typeid) -> Pair {
    tgt: typeid = Tgt
    return Pair{ relation = r, target = tgt }
}

@private
pair_type_type :: #force_inline proc "contextless" ($Rel, $Tgt: typeid) -> Pair {
    rel: typeid = Rel
    tgt: typeid = Tgt
    return Pair{ relation = rel, target = tgt }
}

@private
add_value :: proc(world: ^World, entity: Entity, value: $T) where T != Pair {
    val := value
    add_raw(world, entity, get_component_id(world, T), &val)
}

@private
add_type :: proc(world: ^World, entity: Entity, $T: typeid) {
    add_raw(world, entity, get_component_id(world, T))
}

@private
add_id :: proc(world: ^World, entity: Entity, id: Entity) {
    add_raw(world, entity, id)
}

@private
add_pair :: proc(world: ^World, entity: Entity, pair: Pair) {
    add_raw(world, entity, pair_id(world, pair))
}

@private
set_pair :: proc(world: ^World, entity: Entity, pair: Pair) {
    rel := resolve_id(world, pair.relation)
    tgt := resolve_id(world, pair.target)

    old_tgt, found := get_target_id(world, entity, rel)
    if found {
        if old_tgt == tgt do return

        remove_raw(world, entity, id_make_pair(rel, old_tgt))
    }

    add_raw(world, entity, id_make_pair(rel, tgt))
}

@private
remove_type :: proc(world: ^World, entity: Entity, $T: typeid) {
    id := get_component_id(world, T)
    remove_raw(world, entity, id)
}

@private
remove_id :: proc(world: ^World, entity: Entity, id: Entity) {
    remove_raw(world, entity, id)
}

@private
remove_pair :: proc(world: ^World, entity: Entity, p: Pair) {
    remove_raw(world, entity, pair_id(world, p))
}

@private
get_component :: proc(world: ^World, entity: Entity, $T: typeid) -> ^T {
    ptr := get_raw(world, entity, get_component_id(world, T))
    return (^T)(ptr)
}

@private
get_id :: proc(world: ^World, entity: Entity, id: Entity) -> rawptr {
    return get_raw(world, entity, id)
}

@private
has_type :: proc(world: ^World, entity: Entity, $T: typeid) -> bool {
    return has_id(world, entity, get_component_id(world, T))
}

@private
has_id :: proc(world: ^World, entity: Entity, id: Entity) -> bool {
    if !is_alive(world, entity) do return false

    record := &world.entity_index[entity_id_idx(entity)]
    arch := record.archetype
    if arch == nil do return false

    _, found := slice.binary_search(arch.types, id)
    return found
}

@private
has_pair :: proc(world: ^World, entity: Entity, p: Pair) -> bool {
    return has_id(world, entity, pair_id(world, p))
}

@private
entity_id :: #force_inline proc "contextless" (index: u32, gen: u16) -> Entity {
    return Entity((u64(gen) << 32) | u64(index))
}

@private
entity_id_idx :: #force_inline proc "contextless" (entity: Entity) -> u32 {
    return u32(entity)
}

@private
entity_id_gen :: #force_inline proc "contextless" (entity: Entity) -> u16 {
    return u16(entity >> 32)
}

@(private, require_results)
id_is_pair :: #force_inline proc "contextless" (id: Entity) -> bool {
    return (u64(id) & ID_PAIR_FLAG) != 0
}

@private
resolve_id :: #force_inline proc(world: ^World, component: Component) -> Entity {
    switch v in component {
    case Entity: return v
    case typeid: return get_component_id(world, v)
    }
    return 0
}

@private
pair_id :: #force_inline proc(world: ^World, pair: Pair) -> Entity {
    assert(pair.relation != nil, "ECS: Pair relation cannot be nil")
    assert(pair.target != nil,   "ECS: Pair target cannot be nil")

    rel := resolve_id(world, pair.relation)
    tgt := resolve_id(world, pair.target)
    
    return id_make_pair(rel, tgt)
}

@(private, require_results)
id_make_pair :: #force_inline proc "contextless" (relation, target: Entity) -> Entity {
    return Entity(ID_PAIR_FLAG | (u64(relation) << 32) | u64(target))
}

@(private, require_results)
id_pair_first :: #force_inline proc "contextless" (id: Entity) -> Entity {
    return Entity((u64(id) & ~u64(ID_PAIR_FLAG)) >> 32)
}

@(private, require_results)
id_pair_second :: #force_inline proc "contextless" (id: Entity) -> Entity {
    return Entity(u64(id) & 0xFFFFFFFF)
}

@private
get_target_type :: proc(world: ^World, entity: Entity, $Rel: typeid) -> (Entity, bool) {
    return get_target_id(world, entity, get_component_id(world, Rel))
}

@private
get_target_id :: proc(world: ^World, entity: Entity, relation: Entity) -> (Entity, bool) {
    if !is_alive(world, entity) do return 0, false

    record := &world.entity_index[entity_id_idx(entity)]
    arch := record.archetype
    if arch == nil do return 0, false

    for type in arch.types {
        if id_is_pair(type) {
            rel := id_pair_first(type)
            if rel == relation {
                return id_pair_second(type), true
            }
        }
    }

    return 0, false
}