package tests

import "core:testing"
import "../ecs"

Position :: struct {
	x, y: f32,
}

Tag :: struct {}

@(test)
test_entity_lifecycle :: proc(t: ^testing.T) {
	world := ecs.create_world()
	defer ecs.destroy_world(world)

	e := ecs.create_entity(world)
	testing.expect(t, ecs.is_alive(world, e), "Entity must be alive immediately after creation")

	ecs.destroy_entity(world, e)
	testing.expect(t, !ecs.is_alive(world, e), "Entity must be dead after destruction")
}

@(test)
test_entity_generation :: proc(t: ^testing.T) {
	world := ecs.create_world()
	defer ecs.destroy_world(world)

	e1 := ecs.create_entity(world)
	ecs.destroy_entity(world, e1)

	e2 := ecs.create_entity(world)

	testing.expect(t, e1 != e2, "New entity must have a different ID (generation) even if reusing index")
	testing.expect(t, !ecs.is_alive(world, e1), "Old entity handle must remain invalid")
	testing.expect(t, ecs.is_alive(world, e2), "New entity handle must be valid")
}

@(test)
test_component_add_get :: proc(t: ^testing.T) {
	world := ecs.create_world()
	defer ecs.destroy_world(world)

	e := ecs.create_entity(world)
	ecs.add(world, e, Position{10, 20})

	testing.expect(t, ecs.has(world, e, Position), "Entity must have Position component")

	pos := ecs.get(world, e, Position)
	testing.expect(t, pos != nil, "Get should return a valid pointer")
	testing.expect(t, pos.x == 10 && pos.y == 20, "Component data must match initial value")
}

@(test)
test_component_set :: proc(t: ^testing.T) {
	world := ecs.create_world()
	defer ecs.destroy_world(world)

	e := ecs.create_entity(world)
	ecs.add(world, e, Position{10, 20})

	ecs.set(world, e, Position{30, 40})

	pos := ecs.get(world, e, Position)
	testing.expect(t, pos.x == 30 && pos.y == 40, "Component data must be updated after set")
}

@(test)
test_component_remove :: proc(t: ^testing.T) {
	world := ecs.create_world()
	defer ecs.destroy_world(world)

	e := ecs.create_entity(world)
	ecs.add(world, e, Position{10, 20})
	
	ecs.remove(world, e, Position)

	testing.expect(t, !ecs.has(world, e, Position), "Entity must not have Position component after remove")
	
	record := world.entity_index[u32(e)]
	testing.expect(t, record.archetype == nil, "Entity archetype must be nil when empty")
}

@(test)
test_add_tag_type :: proc(t: ^testing.T) {
	world := ecs.create_world()
	defer ecs.destroy_world(world)

	e := ecs.create_entity(world)
	
	ecs.add(world, e, Tag)

	val := ecs.get(world, e, Tag)
	testing.expect(t, val == nil, "Get must return nil for tags (zero-sized components)")

	testing.expect(t, ecs.has(world, e, Tag), "Has must return true for tag")
}

@(test)
test_add_zero_sized_value :: proc(t: ^testing.T) {
	world := ecs.create_world()
	defer ecs.destroy_world(world)

	e := ecs.create_entity(world)

	ecs.add(world, e, Tag{})

	val := ecs.get(world, e, Tag)
	testing.expect(t, val == nil, "Get must return nil for zero-sized value")

	testing.expect(t, ecs.has(world, e, Tag), "Has must return true for zero-sized value")
}

@(test)
test_remove_tag :: proc(t: ^testing.T) {
	world := ecs.create_world()
	defer ecs.destroy_world(world)

	e := ecs.create_entity(world)
	ecs.add(world, e, Tag)

	testing.expect(t, ecs.has(world, e, Tag), "Entity must have tag initially")

	ecs.remove(world, e, Tag)

	testing.expect(t, !ecs.has(world, e, Tag), "Has must return false after removing tag")
}