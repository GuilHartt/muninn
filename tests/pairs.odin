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
	other := ecs.create_entity(world)
	target := ecs.create_entity(world)
	relation := ecs.create_entity(world)

	ecs.add(world, e1, ecs.pair(relation, target))

	has_pair := ecs.has(world, e1, ecs.pair(relation, target))
	has_wrong := ecs.has(world, e1, ecs.pair(relation, other))

	testing.expect(t, has_pair, "Entity must have (Relation, Target) pair")
	testing.expect(t, !has_wrong, "Entity must not have (Relation, Other)")
}

@(test)
test_add_pair_type_entity :: proc(t: ^testing.T) {
	world := ecs.create_world()
	defer ecs.destroy_world(world)

	e := ecs.create_entity(world)
	target := ecs.create_entity(world)

	ecs.add(world, e, ecs.pair(Likes, target))
	
	has_pair := ecs.has(world, e, ecs.pair(Likes, target))
	testing.expect(t, has_pair, "Entity must have (Type, Entity) pair")
}

@(test)
test_add_pair_type_type :: proc(t: ^testing.T) {
	world := ecs.create_world()
	defer ecs.destroy_world(world)

	e := ecs.create_entity(world)
	ecs.add(world, e, ecs.pair(Eats, Fruit))

	has_pair := ecs.has(world, e, ecs.pair(Eats, Fruit))
	testing.expect(t, has_pair, "Entity must have (Type, Type) pair")
}

@(test)
test_get_target :: proc(t: ^testing.T) {
	world := ecs.create_world()
	defer ecs.destroy_world(world)

	e := ecs.create_entity(world)
	target := ecs.create_entity(world)

	ecs.add(world, e, ecs.pair(Likes, target))

	tgt, ok := ecs.get_target(world, e, Likes)
	_, found := ecs.get_target(world, e, Eats)

	testing.expect(t, ok, "Get target must succeed")
	testing.expect(t, tgt == target, "Target must match the added entity")
	testing.expect(t, !found, "Should not find target for non-existent relation")
}

@(test)
test_remove_pair :: proc(t: ^testing.T) {
	world := ecs.create_world()
	defer ecs.destroy_world(world)

	e := ecs.create_entity(world)
	target := ecs.create_entity(world)

	ecs.add(world, e, ecs.pair(Likes, target))
	exists_before := ecs.has(world, e, ecs.pair(Likes, target))

	ecs.remove(world, e, ecs.pair(Likes, target))
	exists_after := ecs.has(world, e, ecs.pair(Likes, target))

	testing.expect(t, exists_before, "Pre-condition: Pair exists")
	testing.expect(t, !exists_after, "Pair must be removed")
}

@(test)
test_set_pair_override :: proc(t: ^testing.T) {
	world := ecs.create_world()
	defer ecs.destroy_world(world)

	e := ecs.create_entity(world)
	t1 := ecs.create_entity(world)
	t2 := ecs.create_entity(world)

	ecs.set(world, e, ecs.pair(Likes, t1))
	has_t1 := ecs.has(world, e, ecs.pair(Likes, t1))

	ecs.set(world, e, ecs.pair(Likes, t2))
	has_t2 := ecs.has(world, e, ecs.pair(Likes, t2))
	has_t1_old := ecs.has(world, e, ecs.pair(Likes, t1))

	testing.expect(t, has_t1, "Initial target set")
	testing.expect(t, has_t2, "New target set")
	testing.expect(t, !has_t1_old, "Old target should be removed by set")
}