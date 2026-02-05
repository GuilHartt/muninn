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

	ecs.each(world, q, proc(e: ecs.Entity, a: ^ValA, c: ^Ctx) {
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

	ecs.each(world, q, proc(e: ecs.Entity, a: ^ValA, b: ^ValB, c: ^ValC, ctx: ^bool) {
		ctx^ = true
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
	ecs.each(world, q, proc(e: ecs.Entity, a: ^ValA, ctx: ^int) {
		ctx^ += 1
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

	ecs.each(world, q, proc(e: ecs.Entity, a: ^ValA, b: ^ValB, c: ^Check) {
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

	ecs.each(world, q, proc(e: ecs.Entity, a: ^ValA) {
		a.x = 999
	})

	val := ecs.get(world, e, ValA)
	testing.expect(t, val.x == 999, "Iterator without context should work")
}