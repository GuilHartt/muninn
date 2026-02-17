package ecs

each :: proc {
    each_1, each_1_auto,
    each_2, each_2_auto,
    each_3, each_3_auto,
    each_4, each_4_auto,
    each_5, each_5_auto,
    each_6, each_6_auto,
}

@(private="file")
each_1_auto :: #force_inline proc(world: ^World, task: proc(Iter, ^$A), data: rawptr = nil) {
    each_1(world, query(world, with(A)), task, data)
}

@(private="file")
each_2_auto :: #force_inline proc(world: ^World, task: proc(Iter, ^$A, ^$B), data: rawptr = nil) {
    each_2(world, query(world, with(A), with(B)), task, data)
}

@(private="file")
each_3_auto :: #force_inline proc(world: ^World, task: proc(Iter, ^$A, ^$B, ^$C), data: rawptr = nil) {
    each_3(world, query(world, with(A), with(B), with(C)), task, data)
}

@(private="file")
each_4_auto :: #force_inline proc(world: ^World, task: proc(Iter, ^$A, ^$B, ^$C, ^$D), data: rawptr = nil) {
    each_4(world, query(world, with(A), with(B), with(C), with(D)), task, data)
}

@(private="file")
each_5_auto :: #force_inline proc(world: ^World, task: proc(Iter, ^$A, ^$B, ^$C, ^$D, ^$E), data: rawptr = nil) {
    each_5(world, query(world, with(A), with(B), with(C), with(D), with(E)), task, data)
}

@(private="file")
each_6_auto :: #force_inline proc(world: ^World, task: proc(Iter, ^$A, ^$B, ^$C, ^$D, ^$E, ^$F), data: rawptr = nil) {
    each_6(world, query(world, with(A), with(B), with(C), with(D), with(E), with(F)), task, data)
}

@(private="file")
each_1 :: #force_inline proc(world: ^World, q: ^Query, task: proc(Iter, ^$A), data: rawptr = nil) {
    it := Iter{ world = world, data = data }

    for arch in q.archetypes {
        it.arch = arch
        it.count = arch.len
        view_a := get_view(world, arch, A)

        if view_a != nil {
            #no_bounds_check for i in 0..<arch.len {
                it.row = i
                it.entity = arch.entities[i]
                task(it, &view_a[i])
            }
        } else {
            #no_bounds_check for i in 0..<arch.len {
                it.row = i
                it.entity = arch.entities[i]
                task(it, nil)
            }
        }
    }
}

@(private="file")
each_2 :: #force_inline proc(world: ^World, q: ^Query, task: proc(Iter, ^$A, ^$B), data: rawptr = nil) {
    it := Iter{ world = world, data = data }

    for arch in q.archetypes {
        it.arch = arch
        it.count = arch.len
        view_a := get_view(world, arch, A)
        view_b := get_view(world, arch, B)

        if view_a != nil && view_b != nil {
            #no_bounds_check for i in 0..<arch.len {
                it.row = i
                it.entity = arch.entities[i]
                task(it, &view_a[i], &view_b[i])
            }
        } else {
            ptr_a := raw_data(view_a) if view_a != nil else nil
            ptr_b := raw_data(view_b) if view_b != nil else nil
            #no_bounds_check for i in 0..<arch.len {
                it.row = i
                it.entity = arch.entities[i]
                val_a := &ptr_a[i] if ptr_a != nil else nil
                val_b := &ptr_b[i] if ptr_b != nil else nil
                task(it, val_a, val_b)
            }
        }
    }
}

@(private="file")
each_3 :: #force_inline proc(world: ^World, q: ^Query, task: proc(Iter, ^$A, ^$B, ^$C), data: rawptr = nil) {
    it := Iter{ world = world, data = data }

    for arch in q.archetypes {
        it.arch = arch
        it.count = arch.len
        view_a := get_view(world, arch, A)
        view_b := get_view(world, arch, B)
        view_c := get_view(world, arch, C)

        if view_a != nil && view_b != nil && view_c != nil {
            #no_bounds_check for i in 0..<arch.len {
                it.row = i
                it.entity = arch.entities[i]
                task(it, &view_a[i], &view_b[i], &view_c[i])
            }
        } else {
            ptr_a := raw_data(view_a) if view_a != nil else nil
            ptr_b := raw_data(view_b) if view_b != nil else nil
            ptr_c := raw_data(view_c) if view_c != nil else nil
            #no_bounds_check for i in 0..<arch.len {
                it.row = i
                it.entity = arch.entities[i]
                val_a := &ptr_a[i] if ptr_a != nil else nil
                val_b := &ptr_b[i] if ptr_b != nil else nil
                val_c := &ptr_c[i] if ptr_c != nil else nil
                task(it, val_a, val_b, val_c)
            }
        }
    }
}

@(private="file")
each_4 :: #force_inline proc(world: ^World, q: ^Query, task: proc(Iter, ^$A, ^$B, ^$C, ^$D), data: rawptr = nil) {
    it := Iter{ world = world, data = data }

    for arch in q.archetypes {
        it.arch = arch
        it.count = arch.len
        view_a := get_view(world, arch, A)
        view_b := get_view(world, arch, B)
        view_c := get_view(world, arch, C)
        view_d := get_view(world, arch, D)

        if view_a != nil && view_b != nil && view_c != nil && view_d != nil {
            #no_bounds_check for i in 0..<arch.len {
                it.row = i
                it.entity = arch.entities[i]
                task(it, &view_a[i], &view_b[i], &view_c[i], &view_d[i])
            }
        } else {
            ptr_a := raw_data(view_a) if view_a != nil else nil
            ptr_b := raw_data(view_b) if view_b != nil else nil
            ptr_c := raw_data(view_c) if view_c != nil else nil
            ptr_d := raw_data(view_d) if view_d != nil else nil
            #no_bounds_check for i in 0..<arch.len {
                it.row = i
                it.entity = arch.entities[i]
                val_a := &ptr_a[i] if ptr_a != nil else nil
                val_b := &ptr_b[i] if ptr_b != nil else nil
                val_c := &ptr_c[i] if ptr_c != nil else nil
                val_d := &ptr_d[i] if ptr_d != nil else nil
                task(it, val_a, val_b, val_c, val_d)
            }
        }
    }
}

@(private="file")
each_5 :: #force_inline proc(world: ^World, q: ^Query, task: proc(Iter, ^$A, ^$B, ^$C, ^$D, ^$E), data: rawptr = nil) {
    it := Iter{ world = world, data = data }

    for arch in q.archetypes {
        it.arch = arch
        it.count = arch.len
        view_a := get_view(world, arch, A)
        view_b := get_view(world, arch, B)
        view_c := get_view(world, arch, C)
        view_d := get_view(world, arch, D)
        view_e := get_view(world, arch, E)

        if view_a != nil && view_b != nil && view_c != nil && view_d != nil && view_e != nil {
            #no_bounds_check for i in 0..<arch.len {
                it.row = i
                it.entity = arch.entities[i]
                task(it, &view_a[i], &view_b[i], &view_c[i], &view_d[i], &view_e[i])
            }
        } else {
            ptr_a := raw_data(view_a) if view_a != nil else nil
            ptr_b := raw_data(view_b) if view_b != nil else nil
            ptr_c := raw_data(view_c) if view_c != nil else nil
            ptr_d := raw_data(view_d) if view_d != nil else nil
            ptr_e := raw_data(view_e) if view_e != nil else nil
            #no_bounds_check for i in 0..<arch.len {
                it.row = i
                it.entity = arch.entities[i]
                val_a := &ptr_a[i] if ptr_a != nil else nil
                val_b := &ptr_b[i] if ptr_b != nil else nil
                val_c := &ptr_c[i] if ptr_c != nil else nil
                val_d := &ptr_d[i] if ptr_d != nil else nil
                val_e := &ptr_e[i] if ptr_e != nil else nil
                task(it, val_a, val_b, val_c, val_d, val_e)
            }
        }
    }
}

@(private="file")
each_6 :: #force_inline proc(world: ^World, q: ^Query, task: proc(Iter, ^$A, ^$B, ^$C, ^$D, ^$E, ^$F), data: rawptr = nil) {
    it := Iter{ world = world, data = data }

    for arch in q.archetypes {
        it.arch = arch
        it.count = arch.len
        view_a := get_view(world, arch, A)
        view_b := get_view(world, arch, B)
        view_c := get_view(world, arch, C)
        view_d := get_view(world, arch, D)
        view_e := get_view(world, arch, E)
        view_f := get_view(world, arch, F)

        if view_a != nil && view_b != nil && view_c != nil && view_d != nil && view_e != nil && view_f != nil {
            #no_bounds_check for i in 0..<arch.len {
                it.row = i
                it.entity = arch.entities[i]
                task(it, &view_a[i], &view_b[i], &view_c[i], &view_d[i], &view_e[i], &view_f[i])
            }
        } else {
            ptr_a := raw_data(view_a) if view_a != nil else nil
            ptr_b := raw_data(view_b) if view_b != nil else nil
            ptr_c := raw_data(view_c) if view_c != nil else nil
            ptr_d := raw_data(view_d) if view_d != nil else nil
            ptr_e := raw_data(view_e) if view_e != nil else nil
            ptr_f := raw_data(view_f) if view_f != nil else nil
            #no_bounds_check for i in 0..<arch.len {
                it.row = i
                it.entity = arch.entities[i]
                val_a := &ptr_a[i] if ptr_a != nil else nil
                val_b := &ptr_b[i] if ptr_b != nil else nil
                val_c := &ptr_c[i] if ptr_c != nil else nil
                val_d := &ptr_d[i] if ptr_d != nil else nil
                val_e := &ptr_e[i] if ptr_e != nil else nil
                val_f := &ptr_f[i] if ptr_f != nil else nil
                task(it, val_a, val_b, val_c, val_d, val_e, val_f)
            }
        }
    }
}