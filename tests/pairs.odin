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

@(test)
test_parent_basics :: proc(t: ^testing.T) {
    world := ecs.create_world()
    defer ecs.destroy_world(world)

    parent := ecs.create_entity(world)
    child := ecs.create_entity(world)

    ecs.set_parent(world, child, parent)

    has_p := ecs.has_parent(world, child)
    testing.expect(t, has_p, "Child must have a parent")

    p, found := ecs.get_parent(world, child)
    testing.expect(t, found, "Get parent must return true")
    testing.expect(t, p == parent, "Parent entity must match")

    ecs.remove_parent(world, child)
    testing.expect(t, !ecs.has_parent(world, child), "Child must not have parent after removal")
}

@(test)
test_reparenting :: proc(t: ^testing.T) {
    world := ecs.create_world()
    defer ecs.destroy_world(world)

    parent_a := ecs.create_entity(world)
    parent_b := ecs.create_entity(world)
    child := ecs.create_entity(world)

    ecs.set_parent(world, child, parent_a)
    ecs.set_parent(world, child, parent_b)

    curr_parent, _ := ecs.get_parent(world, child)
    
    testing.expect(t, curr_parent == parent_b, "Parent should be B")
    
    has_old := ecs.has(world, child, ecs.pair(ecs.ChildOf, parent_a))
    testing.expect(t, !has_old, "Should not have relation with old parent")
}

@(test)
test_get_children :: proc(t: ^testing.T) {
    world := ecs.create_world()
    defer ecs.destroy_world(world)

    parent := ecs.create_entity(world)
    
    c1 := ecs.create_entity(world)
    c2 := ecs.create_entity(world)
    c3 := ecs.create_entity(world)

    ecs.set_parent(world, c1, parent)
    ecs.set_parent(world, c2, parent)
    ecs.set_parent(world, c3, parent)

    ecs.add(world, c3, Likes{}) 

    archs := ecs.get_children(world, parent)
    
    count := 0
    for arch in archs {
        count += arch.len
    }

    testing.expect(t, count == 3, "Must find exactly 3 children across archetypes")
}

@(test)
test_cascade_delete_simple :: proc(t: ^testing.T) {
    world := ecs.create_world()
    defer ecs.destroy_world(world)

    parent := ecs.create_entity(world)
    child := ecs.create_entity(world)

    ecs.set_parent(world, child, parent)

    ecs.destroy_entity(world, parent)

    testing.expect(t, !ecs.is_alive(world, parent), "Parent must be dead")
    testing.expect(t, !ecs.is_alive(world, child), "Child must be dead (cascade)")
}

@(test)
test_cascade_delete_deep :: proc(t: ^testing.T) {
    world := ecs.create_world()
    defer ecs.destroy_world(world)

    grandparent := ecs.create_entity(world)
    parent      := ecs.create_entity(world)
    child       := ecs.create_entity(world)
    grandchild  := ecs.create_entity(world)

    ecs.set_parent(world, parent, grandparent)
    ecs.set_parent(world, child, parent)
    ecs.set_parent(world, grandchild, child)

    ecs.destroy_entity(world, grandparent)

    testing.expect(t, !ecs.is_alive(world, grandparent), "Grandparent dead")
    testing.expect(t, !ecs.is_alive(world, parent), "Parent dead")
    testing.expect(t, !ecs.is_alive(world, child), "Child dead")
    testing.expect(t, !ecs.is_alive(world, grandchild), "Grandchild dead")
}

@(test)
test_cascade_delete_branching :: proc(t: ^testing.T) {
    world := ecs.create_world()
    defer ecs.destroy_world(world)

    root := ecs.create_entity(world)
    
    a := ecs.create_entity(world); ecs.set_parent(world, a, root)
    b := ecs.create_entity(world); ecs.set_parent(world, b, root)

    a1 := ecs.create_entity(world); ecs.set_parent(world, a1, a)
    a2 := ecs.create_entity(world); ecs.set_parent(world, a2, a)
    
    b1 := ecs.create_entity(world); ecs.set_parent(world, b1, b)

    ecs.destroy_entity(world, root)

    testing.expect(t, !ecs.is_alive(world, root), "Root dead")
    testing.expect(t, !ecs.is_alive(world, a), "A dead")
    testing.expect(t, !ecs.is_alive(world, b), "B dead")
    testing.expect(t, !ecs.is_alive(world, a1), "A1 dead")
    testing.expect(t, !ecs.is_alive(world, a2), "A2 dead")
    testing.expect(t, !ecs.is_alive(world, b1), "B1 dead")
}