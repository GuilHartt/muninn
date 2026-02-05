package tests

import "core:testing"
import "../ecs"

Pos :: struct { x, y: f32 }
Vel :: struct { x, y: f32 }
Hp  :: struct { val: int }

Player :: struct {}
Enemy  :: struct {}

Targeting :: struct {}

@(test)
test_query_basic_filtering :: proc(t: ^testing.T) {
	world := ecs.create_world()
	defer ecs.destroy_world(world)

	e1 := ecs.create_entity(world)
	ecs.add(world, e1, Pos{1, 1})

	e2 := ecs.create_entity(world)
	ecs.add(world, e2, Pos{2, 2})
	ecs.add(world, e2, Vel{1, 0})

	e3 := ecs.create_entity(world)
	ecs.add(world, e3, Vel{0, 1})

	q_pos := ecs.query(world, ecs.with(Pos))
	
	testing.expect(t, ecs.count_entites(q_pos) == 2, "Query(Pos) should count 2 entities")
}

@(test)
test_query_composition :: proc(t: ^testing.T) {
	world := ecs.create_world()
	defer ecs.destroy_world(world)

	e1 := ecs.create_entity(world)
	ecs.add(world, e1, Pos{0, 0})

	e2 := ecs.create_entity(world)
	ecs.add(world, e2, Pos{0, 0})
	ecs.add(world, e2, Vel{0, 0})

	q_move := ecs.query(world, ecs.with(Pos), ecs.with(Vel))
	
	testing.expect(t, ecs.count_entites(q_move) == 1, "Query(Pos, Vel) should count 1 entity")
}

@(test)
test_query_exclusion :: proc(t: ^testing.T) {
	world := ecs.create_world()
	defer ecs.destroy_world(world)

	e1 := ecs.create_entity(world)
	ecs.add(world, e1, Pos{0, 0})
	ecs.add(world, e1, Player)

	e2 := ecs.create_entity(world)
	ecs.add(world, e2, Pos{0, 0})
	ecs.add(world, e2, Enemy)

	q_npcs := ecs.query(world, ecs.with(Pos), ecs.without(Player))

	testing.expect(t, ecs.count_entites(q_npcs) == 1, "Query(Pos, !Player) should count 1 entity")
}

@(test)
test_query_pairs :: proc(t: ^testing.T) {
	world := ecs.create_world()
	defer ecs.destroy_world(world)

	p1 := ecs.create_entity(world)
	target_a := ecs.create_entity(world)
	target_b := ecs.create_entity(world)

	ecs.add(world, p1, Targeting, target_a)
	
	p2 := ecs.create_entity(world)
	ecs.add(world, p2, Targeting, target_b)

	q := ecs.query(world, ecs.with(Targeting, target_a))
	
	testing.expect(t, ecs.count_entites(q) == 1, "Should find 1 entity targeting specific entity")
}

@(test)
test_query_wildcard :: proc(t: ^testing.T) {
	world := ecs.create_world()
	defer ecs.destroy_world(world)

	e1 := ecs.create_entity(world)
	t1 := ecs.create_entity(world)
	ecs.add(world, e1, Targeting, t1)

	e2 := ecs.create_entity(world)
	t2 := ecs.create_entity(world)
	ecs.add(world, e2, Targeting, t2)

	e3 := ecs.create_entity(world)
	ecs.add(world, e3, Pos{0,0})

	q := ecs.query(world, ecs.with(Targeting, ecs.Wildcard))

	testing.expect(t, ecs.count_entites(q) == 2, "Wildcard query should count any target relation")
}

@(test)
test_query_wildcard_relation_position :: proc(t: ^testing.T) {
	world := ecs.create_world()
	defer ecs.destroy_world(world)

	target := ecs.create_entity(world)

	e1 := ecs.create_entity(world)
	ecs.add(world, e1, Targeting, target)

	Loving :: struct {} 
	
	e2 := ecs.create_entity(world)
	ecs.add(world, e2, Loving, target)

	other_target := ecs.create_entity(world)
	e3 := ecs.create_entity(world)
	ecs.add(world, e3, Targeting, other_target)

	q := ecs.query(world, ecs.with(ecs.Wildcard, target))

	testing.expect(t, ecs.count_entites(q) == 2, "Query(*, Target) should match any relation type pointing to target")
}

@(test)
test_query_dynamic_update :: proc(t: ^testing.T) {
	world := ecs.create_world()
	defer ecs.destroy_world(world)

	q := ecs.query(world, ecs.with(Pos))
	testing.expect(t, ecs.count_entites(q) == 0, "Initial count should be 0")

	e := ecs.create_entity(world)
	ecs.add(world, e, Pos{10, 10})

	testing.expect(t, ecs.count_entites(q) == 1, "Count should update after adding component")

	ecs.remove(world, e, Pos)

	testing.expect(t, ecs.count_entites(q) == 0, "Count should update after removing component")
}

@(test)
test_query_caching_identity :: proc(t: ^testing.T) {
	world := ecs.create_world()
	defer ecs.destroy_world(world)

	q1 := ecs.query(world, ecs.with(Pos), ecs.with(Vel))
	q2 := ecs.query(world, ecs.with(Pos), ecs.with(Vel))
	
	q3 := ecs.query(world, ecs.with(Vel), ecs.with(Pos))

	testing.expect(t, q1 == q2, "Queries with same terms must be identical")
	testing.expect(t, q1 == q3, "Queries with varied order must be identical")
}