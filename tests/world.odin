package tests

import "core:testing"
import "../ecs"

@(test)
test_world_creation :: proc(t: ^testing.T) {
    world := ecs.create_world()
    defer ecs.destroy_world(world)

    testing.expect(t, world != nil, "World pointer must not be nil")
}

@(test)
test_initial_capacity :: proc(t: ^testing.T) {
	capacity := 2000
	world := ecs.create_world(capacity)
	defer ecs.destroy_world(world)

	testing.expect(t, cap(world.entity_index) == capacity, "Entity index capacity must match initial capacity")
}

@(test)
test_wildcard_not_alive :: proc(t: ^testing.T) {
	world := ecs.create_world()
	defer ecs.destroy_world(world)

	testing.expect(t, !ecs.is_alive(world, ecs.Wildcard), "Wildcard entity must not be alive")
}