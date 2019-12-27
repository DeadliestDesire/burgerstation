/obj/structure/
	name = "structure"
	desc = "Some kind of strange structure."
	collision_flags = FLAG_COLLISION_NONE
	anchored = 1

	var/density_north = TRUE
	var/density_south = TRUE
	var/density_east  = TRUE
	var/density_west  = TRUE

	var/bullet_block_chance = 0 //Chance to block bullets.

	var/mob/living/buckled

/obj/structure/proc/on_active(var/mob/living/advanced/player/P)
	return TRUE

/obj/structure/proc/on_inactive(var/mob/living/advanced/player/P)
	return TRUE

/obj/structure/proc/buckle(var/mob/living/victim,var/mob/caller,var/silent = FALSE)

	if(!silent)
		if(!caller || caller == victim)
			victim.visible_message("\The [caller.name] buckles themselves to \the [src.name].")
		else
			victim.visible_message("\The [caller.name] buckles \the [victim.name] into \the [src.name].")

	buckled = victim
	buckled.buckled_object = src

	return TRUE

/obj/structure/proc/unbuckle(var/mob/caller,var/silent=FALSE)

	if(!buckled)
		return FALSE

	if(!silent)
		if(!caller || caller == buckled)
			buckled.visible_message("\The [buckled.name] unbuckles themselves from \the [src.name].")
		else
			buckled.visible_message("\The [buckled.name] is unbuckled from \the [src.name] by \the [caller.name].")

	buckled.buckled_object = null
	buckled = null

	return TRUE

/obj/structure/projectile_should_collide(var/obj/projectile/P,var/turf/new_turf,var/turf/old_turf)

	var/projectile_dir = get_dir(old_turf,new_turf)

	if(prob(max(0,100-bullet_block_chance)))
		return FALSE

	if((projectile_dir & NORTH) && src.density_south)
		return src
	else if((projectile_dir & SOUTH) && src.density_north)
		return src

	if((projectile_dir & EAST) && src.density_west)
		return src
	else if((projectile_dir & WEST) && src.density_east)
		return src

	return FALSE

/obj/structure/Cross(var/atom/movable/O,var/atom/NewLoc,var/atom/OldLoc)

	if(O.collision_flags & src.collision_flags)

		var/direction = get_dir(OldLoc,NewLoc)

		if((direction & NORTH) && density_south)
			return FALSE

		if((direction & SOUTH) && density_north)
			return FALSE

		if((direction & EAST) && density_west)
			return FALSE

		if((direction & WEST) && density_east)
			return FALSE

	return TRUE

/obj/structure/Uncross(var/atom/movable/O,var/atom/NewLoc,var/atom/OldLoc)

	if(O.collision_flags & src.collision_flags)

		var/direction = get_dir(OldLoc,NewLoc)

		if((direction & NORTH) && density_north)
			return FALSE

		if((direction & SOUTH) && density_south)
			return FALSE

		if((direction & EAST) && density_east)
			return FALSE

		if((direction & WEST) && density_west)
			return FALSE

	return TRUE