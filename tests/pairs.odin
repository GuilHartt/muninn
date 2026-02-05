package tests

import "core:testing"
import "../ecs"

Likes :: struct {}
Eats  :: struct {}
Fruit :: struct {}

@(test)
test_add_pair_entity_entity :: proc(t: ^testing.T) {
	world := ecs.create_world()
	defer ecs.destroy_world(world)

	e1 := ecs.create_entity(world)
	target := ecs.create_entity(world)
	relation := ecs.create_entity(world)

	ecs.add(world, e1, relation, target)

	testing.expect(t, ecs.has(world, e1, relation, target), "Entity must have (Relation, Target) pair")
	
	other := ecs.create_entity(world)
	testing.expect(t, !ecs.has(world, e1, relation, other), "Entity must not have (Relation, Other)")
}

@(test)
test_add_pair_type_entity :: proc(t: ^testing.T) {
	world := ecs.create_world()
	defer ecs.destroy_world(world)

	e := ecs.create_entity(world)
	target := ecs.create_entity(world)

	ecs.add(world, e, Likes, target)

	testing.expect(t, ecs.has(world, e, Likes, target), "Entity must have (Type, Entity) pair")
}

@(test)
test_add_pair_type_type :: proc(t: ^testing.T) {
	world := ecs.create_world()
	defer ecs.destroy_world(world)

	e := ecs.create_entity(world)
	ecs.add(world, e, Eats, Fruit)

	testing.expect(t, ecs.has(world, e, Eats, Fruit), "Entity must have (Type, Type) pair")
}

@(test)
test_get_target :: proc(t: ^testing.T) {
	world := ecs.create_world()
	defer ecs.destroy_world(world)

	e := ecs.create_entity(world)
	target := ecs.create_entity(world)

	ecs.add(world, e, Likes, target)

	found_target, ok := ecs.get_target(world, e, Likes)

	testing.expect(t, ok, "Get target must succeed")
	testing.expect(t, found_target == target, "Target must match the added entity")
	
	_, found := ecs.get_target(world, e, Eats)
	testing.expect(t, !found, "Should not find target for non-existent relation")
}

@(test)
test_remove_pair :: proc(t: ^testing.T) {
	world := ecs.create_world()
	defer ecs.destroy_world(world)

	e := ecs.create_entity(world)
	target := ecs.create_entity(world)

	ecs.add(world, e, Likes, target)
	testing.expect(t, ecs.has(world, e, Likes, target), "Pre-condition: Pair exists")

	ecs.remove(world, e, Likes, target)
	testing.expect(t, !ecs.has(world, e, Likes, target), "Pair must be removed")
}

@(test)
test_set_pair_override :: proc(t: ^testing.T) {
	world := ecs.create_world()
	defer ecs.destroy_world(world)

	e := ecs.create_entity(world)
	t1 := ecs.create_entity(world)
	t2 := ecs.create_entity(world)
	
	ecs.set(world, e, Likes, t1)
	testing.expect(t, ecs.has(world, e, Likes, t1), "Initial target set")

	ecs.set(world, e, Likes, t2)
	testing.expect(t, ecs.has(world, e, Likes, t2), "New target set")
	testing.expect(t, !ecs.has(world, e, Likes, t1), "Old target should be removed by set")
}