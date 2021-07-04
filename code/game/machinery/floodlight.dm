//these are probably broken

/obj/machinery/floodlight
	name = "Emergency Floodlight"
	icon = 'icons/obj/machines/floodlight.dmi'
	icon_state = "flood00"
	density = TRUE
	light_power = 2
	interact_offline = TRUE
	var/on = FALSE
	var/obj/item/weapon/stock_parts/cell/high/cell = null
	var/use = 5
	var/unlocked = FALSE
	var/open = FALSE
	var/brightness_on = 7

/obj/machinery/floodlight/atom_init()
	cell = new(src)
	. = ..()

/obj/machinery/floodlight/update_icon()
	icon_state = "flood[open ? "o" : ""][open && cell ? "b" : ""]0[on]"

/obj/machinery/floodlight/process()
	if(on)
		if(cell && cell.charge >= use)
			cell.use(use)
		else
			on = FALSE
			update_icon()
			set_light(0)
			visible_message("<span class='warning'>[src] shuts down due to lack of power!</span>")
			return


/obj/machinery/floodlight/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	if(open && cell)
		if(ishuman(user))
			if(!user.get_active_hand())
				user.put_in_hands(cell)
				cell.loc = user.loc
		else
			cell.loc = loc

		cell.add_fingerprint(user)
		cell.updateicon()

		cell = null
		on = FALSE
		to_chat(user, "You remove the power cell")
		update_icon()
		return

	if(on)
		on = FALSE
		to_chat(user, "<span class='notice'>You turn off the light</span>")
		set_light(0)

		user.SetNextMove(CLICK_CD_INTERACT)
		playsound(src, 'sound/machines/floodlight.ogg', VOL_EFFECTS_MASTER, 40)
	else
		if(!cell)
			return
		if(cell.charge <= 0)
			return
		on = TRUE
		to_chat(user, "<span class='notice'>You turn on the light</span>")
		set_light(brightness_on)

		user.SetNextMove(CLICK_CD_INTERACT)
		playsound(src, 'sound/machines/floodlight.ogg', VOL_EFFECTS_MASTER, 40)
		playsound(src, 'sound/machines/lightson.ogg', VOL_EFFECTS_MASTER, null, FALSE)

	update_icon()


/obj/machinery/floodlight/attackby(obj/item/weapon/W, mob/user)
	if (isscrewdriver(W))
		if (!open)
			if(unlocked)
				unlocked = FALSE
				to_chat(user, "You screw the battery panel in place.")
			else
				unlocked = TRUE
				to_chat(user, "You unscrew the battery panel.")

	if (iscrowbar(W))
		if(unlocked)
			if(open)
				open = FALSE
				cut_overlays()
				to_chat(user, "You crowbar the battery panel in place.")
			else
				if(unlocked)
					open = TRUE
					to_chat(user, "You remove the battery panel.")

	if (istype(W, /obj/item/weapon/stock_parts/cell))
		if(open)
			if(cell)
				to_chat(user, "There is a power cell already installed.")
			else
				user.drop_from_inventory(W, src)
				cell = W
				to_chat(user, "You insert the power cell.")
	update_icon()
