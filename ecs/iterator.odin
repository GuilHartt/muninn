package ecs

each :: proc {
    each_1, each_1_ctx,
    each_2, each_2_ctx,
    each_3, each_3_ctx,
    each_4, each_4_ctx,
    each_5, each_5_ctx,
    each_6, each_6_ctx,
}

@private
each_1 :: #force_inline proc(world: ^World, q: ^Query, task: proc(Entity, ^$A)) {
    for arch in q.archetypes {
        view_a := get_view(world, arch, A)
        if view_a != nil {
            #no_bounds_check for i in 0..<arch.len {
                task(arch.entities[i], &view_a[i])
            }
        } else {
            #no_bounds_check for i in 0..<arch.len {
                task(arch.entities[i], nil)
            }
        }
    }
}

@private
each_1_ctx :: #force_inline proc(world: ^World, q: ^Query, task: proc(Entity, ^$A, $Ctx), ctx: Ctx) {
    for arch in q.archetypes {
        view_a := get_view(world, arch, A)
        if view_a != nil {
            #no_bounds_check for i in 0..<arch.len {
                task(arch.entities[i], &view_a[i], ctx)
            }
        } else {
            #no_bounds_check for i in 0..<arch.len {
                task(arch.entities[i], nil, ctx)
            }
        }
    }
}

@private
each_2 :: #force_inline proc(world: ^World, q: ^Query, task: proc(Entity, ^$A, ^$B)) {
    for arch in q.archetypes {
        view_a := get_view(world, arch, A)
        view_b := get_view(world, arch, B)

        if view_a != nil && view_b != nil {
            #no_bounds_check for i in 0..<arch.len {
                task(arch.entities[i], &view_a[i], &view_b[i])
            }
        } else {
            ptr_a := raw_data(view_a) if view_a != nil else nil
            ptr_b := raw_data(view_b) if view_b != nil else nil
            #no_bounds_check for i in 0..<arch.len {
                val_a := &ptr_a[i] if ptr_a != nil else nil
                val_b := &ptr_b[i] if ptr_b != nil else nil
                task(arch.entities[i], val_a, val_b)
            }
        }
    }
}

@private
each_2_ctx :: #force_inline proc(world: ^World, q: ^Query, task: proc(Entity, ^$A, ^$B, $Ctx), ctx: Ctx) {
    for arch in q.archetypes {
        view_a := get_view(world, arch, A)
        view_b := get_view(world, arch, B)

        if view_a != nil && view_b != nil {
            #no_bounds_check for i in 0..<arch.len {
                task(arch.entities[i], &view_a[i], &view_b[i], ctx)
            }
        } else {
            ptr_a := raw_data(view_a) if view_a != nil else nil
            ptr_b := raw_data(view_b) if view_b != nil else nil
            #no_bounds_check for i in 0..<arch.len {
                val_a := &ptr_a[i] if ptr_a != nil else nil
                val_b := &ptr_b[i] if ptr_b != nil else nil
                task(arch.entities[i], val_a, val_b, ctx)
            }
        }
    }
}

@private
each_3 :: #force_inline proc(world: ^World, q: ^Query, task: proc(Entity, ^$A, ^$B, ^$C)) {
    for arch in q.archetypes {
        view_a := get_view(world, arch, A)
        view_b := get_view(world, arch, B)
        view_c := get_view(world, arch, C)

        if view_a != nil && view_b != nil && view_c != nil {
            #no_bounds_check for i in 0..<arch.len {
                task(arch.entities[i], &view_a[i], &view_b[i], &view_c[i])
            }
        } else {
            ptr_a := raw_data(view_a) if view_a != nil else nil
            ptr_b := raw_data(view_b) if view_b != nil else nil
            ptr_c := raw_data(view_c) if view_c != nil else nil
            #no_bounds_check for i in 0..<arch.len {
                val_a := &ptr_a[i] if ptr_a != nil else nil
                val_b := &ptr_b[i] if ptr_b != nil else nil
                val_c := &ptr_c[i] if ptr_c != nil else nil
                task(arch.entities[i], val_a, val_b, val_c)
            }
        }
    }
}

@private
each_3_ctx :: #force_inline proc(world: ^World, q: ^Query, task: proc(Entity, ^$A, ^$B, ^$C, $Ctx), ctx: Ctx) {
    for arch in q.archetypes {
        view_a := get_view(world, arch, A)
        view_b := get_view(world, arch, B)
        view_c := get_view(world, arch, C)

        if view_a != nil && view_b != nil && view_c != nil {
            #no_bounds_check for i in 0..<arch.len {
                task(arch.entities[i], &view_a[i], &view_b[i], &view_c[i], ctx)
            }
        } else {
            ptr_a := raw_data(view_a) if view_a != nil else nil
            ptr_b := raw_data(view_b) if view_b != nil else nil
            ptr_c := raw_data(view_c) if view_c != nil else nil
            #no_bounds_check for i in 0..<arch.len {
                val_a := &ptr_a[i] if ptr_a != nil else nil
                val_b := &ptr_b[i] if ptr_b != nil else nil
                val_c := &ptr_c[i] if ptr_c != nil else nil
                task(arch.entities[i], val_a, val_b, val_c, ctx)
            }
        }
    }
}

@private
each_4 :: #force_inline proc(world: ^World, q: ^Query, task: proc(Entity, ^$A, ^$B, ^$C, ^$D)) {
    for arch in q.archetypes {
        view_a := get_view(world, arch, A)
        view_b := get_view(world, arch, B)
        view_c := get_view(world, arch, C)
        view_d := get_view(world, arch, D)

        if view_a != nil && view_b != nil && view_c != nil && view_d != nil {
            #no_bounds_check for i in 0..<arch.len {
                task(arch.entities[i], &view_a[i], &view_b[i], &view_c[i], &view_d[i])
            }
        } else {
            ptr_a := raw_data(view_a) if view_a != nil else nil
            ptr_b := raw_data(view_b) if view_b != nil else nil
            ptr_c := raw_data(view_c) if view_c != nil else nil
            ptr_d := raw_data(view_d) if view_d != nil else nil
            #no_bounds_check for i in 0..<arch.len {
                val_a := &ptr_a[i] if ptr_a != nil else nil
                val_b := &ptr_b[i] if ptr_b != nil else nil
                val_c := &ptr_c[i] if ptr_c != nil else nil
                val_d := &ptr_d[i] if ptr_d != nil else nil
                task(arch.entities[i], val_a, val_b, val_c, val_d)
            }
        }
    }
}

@private
each_4_ctx :: #force_inline proc(world: ^World, q: ^Query, task: proc(Entity, ^$A, ^$B, ^$C, ^$D, $Ctx), ctx: Ctx) {
    for arch in q.archetypes {
        view_a := get_view(world, arch, A)
        view_b := get_view(world, arch, B)
        view_c := get_view(world, arch, C)
        view_d := get_view(world, arch, D)

        if view_a != nil && view_b != nil && view_c != nil && view_d != nil {
            #no_bounds_check for i in 0..<arch.len {
                task(arch.entities[i], &view_a[i], &view_b[i], &view_c[i], &view_d[i], ctx)
            }
        } else {
            ptr_a := raw_data(view_a) if view_a != nil else nil
            ptr_b := raw_data(view_b) if view_b != nil else nil
            ptr_c := raw_data(view_c) if view_c != nil else nil
            ptr_d := raw_data(view_d) if view_d != nil else nil
            #no_bounds_check for i in 0..<arch.len {
                val_a := &ptr_a[i] if ptr_a != nil else nil
                val_b := &ptr_b[i] if ptr_b != nil else nil
                val_c := &ptr_c[i] if ptr_c != nil else nil
                val_d := &ptr_d[i] if ptr_d != nil else nil
                task(arch.entities[i], val_a, val_b, val_c, val_d, ctx)
            }
        }
    }
}

@private
each_5 :: #force_inline proc(world: ^World, q: ^Query, task: proc(Entity, ^$A, ^$B, ^$C, ^$D, ^$E)) {
    for arch in q.archetypes {
        view_a := get_view(world, arch, A)
        view_b := get_view(world, arch, B)
        view_c := get_view(world, arch, C)
        view_d := get_view(world, arch, D)
        view_e := get_view(world, arch, E)

        if view_a != nil && view_b != nil && view_c != nil && view_d != nil && view_e != nil {
            #no_bounds_check for i in 0..<arch.len {
                task(arch.entities[i], &view_a[i], &view_b[i], &view_c[i], &view_d[i], &view_e[i])
            }
        } else {
            ptr_a := raw_data(view_a) if view_a != nil else nil
            ptr_b := raw_data(view_b) if view_b != nil else nil
            ptr_c := raw_data(view_c) if view_c != nil else nil
            ptr_d := raw_data(view_d) if view_d != nil else nil
            ptr_e := raw_data(view_e) if view_e != nil else nil
            #no_bounds_check for i in 0..<arch.len {
                val_a := &ptr_a[i] if ptr_a != nil else nil
                val_b := &ptr_b[i] if ptr_b != nil else nil
                val_c := &ptr_c[i] if ptr_c != nil else nil
                val_d := &ptr_d[i] if ptr_d != nil else nil
                val_e := &ptr_e[i] if ptr_e != nil else nil
                task(arch.entities[i], val_a, val_b, val_c, val_d, val_e)
            }
        }
    }
}

@private
each_5_ctx :: #force_inline proc(world: ^World, q: ^Query, task: proc(Entity, ^$A, ^$B, ^$C, ^$D, ^$E, $Ctx), ctx: Ctx) {
    for arch in q.archetypes {
        view_a := get_view(world, arch, A)
        view_b := get_view(world, arch, B)
        view_c := get_view(world, arch, C)
        view_d := get_view(world, arch, D)
        view_e := get_view(world, arch, E)

        if view_a != nil && view_b != nil && view_c != nil && view_d != nil && view_e != nil {
            #no_bounds_check for i in 0..<arch.len {
                task(arch.entities[i], &view_a[i], &view_b[i], &view_c[i], &view_d[i], &view_e[i], ctx)
            }
        } else {
            ptr_a := raw_data(view_a) if view_a != nil else nil
            ptr_b := raw_data(view_b) if view_b != nil else nil
            ptr_c := raw_data(view_c) if view_c != nil else nil
            ptr_d := raw_data(view_d) if view_d != nil else nil
            ptr_e := raw_data(view_e) if view_e != nil else nil
            #no_bounds_check for i in 0..<arch.len {
                val_a := &ptr_a[i] if ptr_a != nil else nil
                val_b := &ptr_b[i] if ptr_b != nil else nil
                val_c := &ptr_c[i] if ptr_c != nil else nil
                val_d := &ptr_d[i] if ptr_d != nil else nil
                val_e := &ptr_e[i] if ptr_e != nil else nil
                task(arch.entities[i], val_a, val_b, val_c, val_d, val_e, ctx)
            }
        }
    }
}

@private
each_6 :: #force_inline proc(world: ^World, q: ^Query, task: proc(Entity, ^$A, ^$B, ^$C, ^$D, ^$E, ^$F)) {
    for arch in q.archetypes {
        view_a := get_view(world, arch, A)
        view_b := get_view(world, arch, B)
        view_c := get_view(world, arch, C)
        view_d := get_view(world, arch, D)
        view_e := get_view(world, arch, E)
        view_f := get_view(world, arch, F)

        if view_a != nil && view_b != nil && view_c != nil && view_d != nil && view_e != nil && view_f != nil {
            #no_bounds_check for i in 0..<arch.len {
                task(arch.entities[i], &view_a[i], &view_b[i], &view_c[i], &view_d[i], &view_e[i], &view_f[i])
            }
        } else {
            ptr_a := raw_data(view_a) if view_a != nil else nil
            ptr_b := raw_data(view_b) if view_b != nil else nil
            ptr_c := raw_data(view_c) if view_c != nil else nil
            ptr_d := raw_data(view_d) if view_d != nil else nil
            ptr_e := raw_data(view_e) if view_e != nil else nil
            ptr_f := raw_data(view_f) if view_f != nil else nil
            #no_bounds_check for i in 0..<arch.len {
                val_a := &ptr_a[i] if ptr_a != nil else nil
                val_b := &ptr_b[i] if ptr_b != nil else nil
                val_c := &ptr_c[i] if ptr_c != nil else nil
                val_d := &ptr_d[i] if ptr_d != nil else nil
                val_e := &ptr_e[i] if ptr_e != nil else nil
                val_f := &ptr_f[i] if ptr_f != nil else nil
                task(arch.entities[i], val_a, val_b, val_c, val_d, val_e, val_f)
            }
        }
    }
}

@private
each_6_ctx :: #force_inline proc(world: ^World, q: ^Query, task: proc(Entity, ^$A, ^$B, ^$C, ^$D, ^$E, ^$F, $Ctx), ctx: Ctx) {
    for arch in q.archetypes {
        view_a := get_view(world, arch, A)
        view_b := get_view(world, arch, B)
        view_c := get_view(world, arch, C)
        view_d := get_view(world, arch, D)
        view_e := get_view(world, arch, E)
        view_f := get_view(world, arch, F)

        if view_a != nil && view_b != nil && view_c != nil && view_d != nil && view_e != nil && view_f != nil {
            #no_bounds_check for i in 0..<arch.len {
                task(arch.entities[i], &view_a[i], &view_b[i], &view_c[i], &view_d[i], &view_e[i], &view_f[i], ctx)
            }
        } else {
            ptr_a := raw_data(view_a) if view_a != nil else nil
            ptr_b := raw_data(view_b) if view_b != nil else nil
            ptr_c := raw_data(view_c) if view_c != nil else nil
            ptr_d := raw_data(view_d) if view_d != nil else nil
            ptr_e := raw_data(view_e) if view_e != nil else nil
            ptr_f := raw_data(view_f) if view_f != nil else nil
            #no_bounds_check for i in 0..<arch.len {
                val_a := &ptr_a[i] if ptr_a != nil else nil
                val_b := &ptr_b[i] if ptr_b != nil else nil
                val_c := &ptr_c[i] if ptr_c != nil else nil
                val_d := &ptr_d[i] if ptr_d != nil else nil
                val_e := &ptr_e[i] if ptr_e != nil else nil
                val_f := &ptr_f[i] if ptr_f != nil else nil
                task(arch.entities[i], val_a, val_b, val_c, val_d, val_e, val_f, ctx)
            }
        }
    }
}