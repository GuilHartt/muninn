package tests

import "core:testing"
import "../ecs"

ValA :: struct { x: int }
ValB :: struct { x: int }
ValC :: struct { x: int }

@(test)
test_iterator_single :: proc(t: ^testing.T) {
    world := ecs.create_world()
    defer ecs.destroy_world(world)

    for i in 0..<10 {
        e := ecs.create_entity(world)
        ecs.add(world, e, ValA{i})
    }

    q := ecs.query(world, ecs.with(ValA))
    
    Ctx :: struct {
        count, sum: int,
    }
    ctx := Ctx{0, 0}

    ecs.each(world, q, proc(it: ecs.Iter, a: ^ValA) {
        c := cast(^Ctx)it.data
        c.count += 1
        c.sum   += a.x
    }, &ctx)

    testing.expect(t, ctx.count == 10, "Should iterate 10 entities")
    testing.expect(t, ctx.sum == 45, "Sum of 0..9 should be 45")
}

@(test)
test_iterator_multiple_components :: proc(t: ^testing.T) {
    world := ecs.create_world()
    defer ecs.destroy_world(world)

    e := ecs.create_entity(world)
    ecs.add(world, e, ValA{10})
    ecs.add(world, e, ValB{20})
    ecs.add(world, e, ValC{30})

    q := ecs.query(world, ecs.with(ValA), ecs.with(ValB), ecs.with(ValC))

    called := false

    ecs.each(world, q, proc(it: ecs.Iter, a: ^ValA, b: ^ValB, c: ^ValC) {
        data := cast(^bool)it.data
        data^ = true
        a.x += 1
        b.x += 1
        c.x += 1
    }, &called)

    testing.expect(t, called, "Iterator callback must be called")

    val_a := ecs.get(world, e, ValA)
    testing.expect(t, val_a.x == 11, "Value A must be updated")
    
    val_b := ecs.get(world, e, ValB)
    testing.expect(t, val_b.x == 21, "Value B must be updated")

    val_c := ecs.get(world, e, ValC)
    testing.expect(t, val_c.x == 31, "Value C must be updated")
}

@(test)
test_iterator_multiple_archetypes :: proc(t: ^testing.T) {
    world := ecs.create_world()
    defer ecs.destroy_world(world)

    for i in 0..<5 {
        e := ecs.create_entity(world)
        ecs.add(world, e, ValA{1})
    }

    for i in 0..<5 {
        e := ecs.create_entity(world)
        ecs.add(world, e, ValA{1})
        ecs.add(world, e, ValB{2})
    }

    q := ecs.query(world, ecs.with(ValA))

    count := 0
    ecs.each(world, q, proc(it: ecs.Iter, a: ^ValA) {
        data := cast(^int)it.data
        data^ += 1
    }, &count)

    testing.expect(t, count == 10, "Iterator should cover all archetypes containing ValA")
}

@(test)
test_iterator_optional_component :: proc(t: ^testing.T) {
    world := ecs.create_world()
    defer ecs.destroy_world(world)

    e1 := ecs.create_entity(world)
    ecs.add(world, e1, ValA{10})

    e2 := ecs.create_entity(world)
    ecs.add(world, e2, ValA{20})
    ecs.add(world, e2, ValB{30})

    q := ecs.query(world, ecs.with(ValA))

    Check :: struct {
        found_nil, found_val: bool
    }

    ctx := Check{false, false}

    ecs.each(world, q, proc(it: ecs.Iter, a: ^ValA, b: ^ValB) {
        c := cast(^Check)it.data
        
        if b == nil {
            c.found_nil = true
        } else {
            c.found_val = true
            b.x += 1
        }
    }, &ctx)

    testing.expect(t, ctx.found_nil, "Should handle missing optional component as nil")
    testing.expect(t, ctx.found_val, "Should handle existing optional component correctly")
}

@(test)
test_iterator_no_context :: proc(t: ^testing.T) {
    world := ecs.create_world()
    defer ecs.destroy_world(world)

    e := ecs.create_entity(world)
    ecs.add(world, e, ValA{1})

    q := ecs.query(world, ecs.with(ValA))

    ecs.each(world, q, proc(it: ecs.Iter, a: ^ValA) {
        a.x = 999
    })

    val := ecs.get(world, e, ValA)
    testing.expect(t, val.x == 999, "Iterator without context should work")
}

@(test)
test_iterator_auto_simple :: proc(t: ^testing.T) {
    world := ecs.create_world()
    defer ecs.destroy_world(world)

    e := ecs.create_entity(world)
    ecs.add(world, e, ValA{100})

    ecs.each(world, proc(it: ecs.Iter, a: ^ValA) {
        a.x += 1
    })

    val := ecs.get(world, e, ValA)
    testing.expect(t, val.x == 101, "Auto query should work for single component")
}

@(test)
test_iterator_auto_multiple_with_data :: proc(t: ^testing.T) {
    world := ecs.create_world()
    defer ecs.destroy_world(world)

    e := ecs.create_entity(world)
    ecs.add(world, e, ValA{10})
    ecs.add(world, e, ValB{20})
    
    e2 := ecs.create_entity(world)
    ecs.add(world, e2, ValA{99})

    count := 0

    ecs.each(world, proc(it: ecs.Iter, a: ^ValA, b: ^ValB) {
        ctx := cast(^int)it.data
        ctx^ += 1
        
        a.x += b.x
    }, &count)

    testing.expect(t, count == 1, "Auto query should strictly match all components (AND logic)")
    
    val := ecs.get(world, e, ValA)
    testing.expect(t, val.x == 30, "Logic inside auto-query callback should execute")
}

@(test)
test_iterator_auto_filter_logic :: proc(t: ^testing.T) {
    world := ecs.create_world()
    defer ecs.destroy_world(world)

    e1 := ecs.create_entity(world)
    ecs.add(world, e1, ValA{1})
    ecs.add(world, e1, ValB{1})
    ecs.add(world, e1, ValC{1})

    e2 := ecs.create_entity(world)
    ecs.add(world, e2, ValA{1})
    ecs.add(world, e2, ValB{1})

    e3 := ecs.create_entity(world)
    ecs.add(world, e3, ValA{1})
    ecs.add(world, e3, ValC{1})

    matches := 0

    ecs.each(world, proc(it: ecs.Iter, a: ^ValA, b: ^ValB, c: ^ValC) {
        ctx := cast(^int)it.data
        ctx^ += 1
    }, &matches)

    testing.expect(t, matches == 1, "Auto query should implicitly create an intersection (AND) of all components")
}