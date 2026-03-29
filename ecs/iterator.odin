package ecs

Iter :: struct {
    world:    ^World,
    query:    ^Query,
    entity:   Entity,

    _arch_idx: int,
    _row:      int,
}

Iter1 :: struct($A: typeid) {
    using iter: Iter,
    _view_a: []A,
}

Iter2 :: struct($A, $B: typeid) {
    using iter: Iter,
    _view_a: []A,
    _view_b: []B,
}

Iter3 :: struct($A, $B, $C: typeid) {
    using iter: Iter,
    _view_a: []A,
    _view_b: []B,
    _view_c: []C,
}

Iter4 :: struct($A, $B, $C, $D: typeid) {
    using iter: Iter,
    _view_a: []A,
    _view_b: []B,
    _view_c: []C,
    _view_d: []D,
}

Iter5 :: struct($A, $B, $C, $D, $E: typeid) {
    using iter: Iter,
    _view_a: []A,
    _view_b: []B,
    _view_c: []C,
    _view_d: []D,
    _view_e: []E,
}

Iter6 :: struct($A, $B, $C, $D, $E, $F: typeid) {
    using iter: Iter,
    _view_a: []A,
    _view_b: []B,
    _view_c: []C,
    _view_d: []D,
    _view_e: []E,
    _view_f: []F,
}

iter :: proc {
    iter_1, iter_1_auto,
    iter_2, iter_2_auto,
    iter_3, iter_3_auto,
    iter_4, iter_4_auto,
    iter_5, iter_5_auto,
    iter_6, iter_6_auto,
}

next :: proc {
    next_1,
    next_2,
    next_3,
    next_4,
    next_5,
    next_6,
}

@(private)
iter_1 :: #force_inline proc(world: ^World, q: ^Query, $A: typeid) -> Iter1(A) {
    return Iter1(A){ iter = { world = world, query = q } }
}

@(private)
iter_1_auto :: #force_inline proc(world: ^World, $A: typeid) -> Iter1(A) {
    return iter_1(world, query(world, with(A)), A)
}

@(private)
next_1 :: proc(it: ^Iter1($A)) -> (^A, bool) {
    for it._arch_idx < len(it.query.archetypes) {
        arch := it.query.archetypes[it._arch_idx]

        if it._row == 0 {
            it._view_a = get_view(it.world, arch, A)
        }

        if it._row < arch.len {
            it.entity = arch.entities[it._row]
            ptr_a: ^A = it._view_a != nil ? &it._view_a[it._row] : nil
            it._row += 1
            return ptr_a, true
        }

        it._arch_idx += 1
        it._row = 0
    }
    return nil, false
}

@(private)
iter_2 :: #force_inline proc(world: ^World, q: ^Query, $A, $B: typeid) -> Iter2(A, B) {
    return Iter2(A, B){ iter = { world = world, query = q } }
}

@(private)
iter_2_auto :: #force_inline proc(world: ^World, $A, $B: typeid) -> Iter2(A, B) {
    return iter_2(world, query(world, with(A), with(B)), A, B)
}

@(private)
next_2 :: proc(it: ^Iter2($A, $B)) -> (^A, ^B, bool) {
    for it._arch_idx < len(it.query.archetypes) {
        arch := it.query.archetypes[it._arch_idx]

        if it._row == 0 {
            it._view_a = get_view(it.world, arch, A)
            it._view_b = get_view(it.world, arch, B)
        }

        if it._row < arch.len {
            it.entity = arch.entities[it._row]
            ptr_a: ^A = it._view_a != nil ? &it._view_a[it._row] : nil
            ptr_b: ^B = it._view_b != nil ? &it._view_b[it._row] : nil
            it._row += 1
            return ptr_a, ptr_b, true
        }

        it._arch_idx += 1
        it._row = 0
    }
    return nil, nil, false
}

@(private)
iter_3 :: #force_inline proc(world: ^World, q: ^Query, $A, $B, $C: typeid) -> Iter3(A, B, C) {
    return Iter3(A, B, C){ iter = { world = world, query = q } }
}

@(private)
iter_3_auto :: #force_inline proc(world: ^World, $A, $B, $C: typeid) -> Iter3(A, B, C) {
    return iter_3(world, query(world, with(A), with(B), with(C)), A, B, C)
}

@(private)
next_3 :: proc(it: ^Iter3($A, $B, $C)) -> (^A, ^B, ^C, bool) {
    for it._arch_idx < len(it.query.archetypes) {
        arch := it.query.archetypes[it._arch_idx]

        if it._row == 0 {
            it._view_a = get_view(it.world, arch, A)
            it._view_b = get_view(it.world, arch, B)
            it._view_c = get_view(it.world, arch, C)
        }

        if it._row < arch.len {
            it.entity = arch.entities[it._row]
            ptr_a: ^A = it._view_a != nil ? &it._view_a[it._row] : nil
            ptr_b: ^B = it._view_b != nil ? &it._view_b[it._row] : nil
            ptr_c: ^C = it._view_c != nil ? &it._view_c[it._row] : nil
            it._row += 1
            return ptr_a, ptr_b, ptr_c, true
        }

        it._arch_idx += 1
        it._row = 0
    }
    return nil, nil, nil, false
}

@(private)
iter_4 :: #force_inline proc(world: ^World, q: ^Query, $A, $B, $C, $D: typeid) -> Iter4(A, B, C, D) {
    return Iter4(A, B, C, D){ iter = { world = world, query = q } }
}

@(private)
iter_4_auto :: #force_inline proc(world: ^World, $A, $B, $C, $D: typeid) -> Iter4(A, B, C, D) {
    return iter_4(world, query(world, with(A), with(B), with(C), with(D)), A, B, C, D)
}

@(private)
next_4 :: proc(it: ^Iter4($A, $B, $C, $D)) -> (^A, ^B, ^C, ^D, bool) {
    for it._arch_idx < len(it.query.archetypes) {
        arch := it.query.archetypes[it._arch_idx]

        if it._row == 0 {
            it._view_a = get_view(it.world, arch, A)
            it._view_b = get_view(it.world, arch, B)
            it._view_c = get_view(it.world, arch, C)
            it._view_d = get_view(it.world, arch, D)
        }

        if it._row < arch.len {
            it.entity = arch.entities[it._row]
            ptr_a: ^A = it._view_a != nil ? &it._view_a[it._row] : nil
            ptr_b: ^B = it._view_b != nil ? &it._view_b[it._row] : nil
            ptr_c: ^C = it._view_c != nil ? &it._view_c[it._row] : nil
            ptr_d: ^D = it._view_d != nil ? &it._view_d[it._row] : nil
            it._row += 1
            return ptr_a, ptr_b, ptr_c, ptr_d, true
        }

        it._arch_idx += 1
        it._row = 0
    }
    return nil, nil, nil, nil, false
}

@(private)
iter_5 :: #force_inline proc(world: ^World, q: ^Query, $A, $B, $C, $D, $E: typeid) -> Iter5(A, B, C, D, E) {
    return Iter5(A, B, C, D, E){ iter = { world = world, query = q } }
}

@(private)
iter_5_auto :: #force_inline proc(world: ^World, $A, $B, $C, $D, $E: typeid) -> Iter5(A, B, C, D, E) {
    return iter_5(world, query(world, with(A), with(B), with(C), with(D), with(E)), A, B, C, D, E)
}

@(private)
next_5 :: proc(it: ^Iter5($A, $B, $C, $D, $E)) -> (^A, ^B, ^C, ^D, ^E, bool) {
    for it._arch_idx < len(it.query.archetypes) {
        arch := it.query.archetypes[it._arch_idx]

        if it._row == 0 {
            it._view_a = get_view(it.world, arch, A)
            it._view_b = get_view(it.world, arch, B)
            it._view_c = get_view(it.world, arch, C)
            it._view_d = get_view(it.world, arch, D)
            it._view_e = get_view(it.world, arch, E)
        }

        if it._row < arch.len {
            it.entity = arch.entities[it._row]
            ptr_a: ^A = it._view_a != nil ? &it._view_a[it._row] : nil
            ptr_b: ^B = it._view_b != nil ? &it._view_b[it._row] : nil
            ptr_c: ^C = it._view_c != nil ? &it._view_c[it._row] : nil
            ptr_d: ^D = it._view_d != nil ? &it._view_d[it._row] : nil
            ptr_e: ^E = it._view_e != nil ? &it._view_e[it._row] : nil
            it._row += 1
            return ptr_a, ptr_b, ptr_c, ptr_d, ptr_e, true
        }

        it._arch_idx += 1
        it._row = 0
    }
    return nil, nil, nil, nil, nil, false
}

@(private)
iter_6 :: #force_inline proc(world: ^World, q: ^Query, $A, $B, $C, $D, $E, $F: typeid) -> Iter6(A, B, C, D, E, F) {
    return Iter6(A, B, C, D, E, F){ iter = { world = world, query = q } }
}

@(private)
iter_6_auto :: #force_inline proc(world: ^World, $A, $B, $C, $D, $E, $F: typeid) -> Iter6(A, B, C, D, E, F) {
    return iter_6(world, query(world, with(A), with(B), with(C), with(D), with(E), with(F)), A, B, C, D, E, F)
}

@(private)
next_6 :: proc(it: ^Iter6($A, $B, $C, $D, $E, $F)) -> (^A, ^B, ^C, ^D, ^E, ^F, bool) {
    for it._arch_idx < len(it.query.archetypes) {
        arch := it.query.archetypes[it._arch_idx]

        if it._row == 0 {
            it._view_a = get_view(it.world, arch, A)
            it._view_b = get_view(it.world, arch, B)
            it._view_c = get_view(it.world, arch, C)
            it._view_d = get_view(it.world, arch, D)
            it._view_e = get_view(it.world, arch, E)
            it._view_f = get_view(it.world, arch, F)
        }

        if it._row < arch.len {
            it.entity = arch.entities[it._row]
            ptr_a: ^A = it._view_a != nil ? &it._view_a[it._row] : nil
            ptr_b: ^B = it._view_b != nil ? &it._view_b[it._row] : nil
            ptr_c: ^C = it._view_c != nil ? &it._view_c[it._row] : nil
            ptr_d: ^D = it._view_d != nil ? &it._view_d[it._row] : nil
            ptr_e: ^E = it._view_e != nil ? &it._view_e[it._row] : nil
            ptr_f: ^F = it._view_f != nil ? &it._view_f[it._row] : nil
            it._row += 1
            return ptr_a, ptr_b, ptr_c, ptr_d, ptr_e, ptr_f, true
        }

        it._arch_idx += 1
        it._row = 0
    }
    return nil, nil, nil, nil, nil, nil, false
}