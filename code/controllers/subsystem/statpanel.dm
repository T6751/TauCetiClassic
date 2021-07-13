SUBSYSTEM_DEF(statpanels)
	name = "Stat Panels"
	wait = 4
	init_order = SS_INIT_STATPANELS
	priority = SS_PRIORITY_STATPANEL
	flags = SS_TICKER | SS_FIRE_IN_LOBBY
	var/list/currentrun = list()
	var/encoded_global_data
	var/mc_data_encoded
	var/list/cached_images = list()

/datum/controller/subsystem/statpanels/fire(resumed = FALSE)
	if (!resumed)
		var/datum/map_config/cached = SSmapping.next_map_config
		var/list/global_data = list(
			"Round ID: [global.round_id ? global.round_id : "NULL"]",
			"Server Time: [time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")]",
			"Map: [SSmapping.config?.map_name || "Loading..."]",
			cached ? "Next Map: [cached.map_name]" : null,
		)
		if(SSshuttle.online && SSshuttle.location < 2)
			global_data += "ETA-[shuttleeta2text()]"
		encoded_global_data = url_encode(json_encode(global_data))
		src.currentrun = global.clients.Copy()
		mc_data_encoded = null
	var/list/currentrun = src.currentrun
	while(length(currentrun))
		var/client/target = currentrun[length(currentrun)]
		currentrun.len--
		if(!target.statbrowser_ready)
			continue
		if(target.stat_tab == "Status")
			var/other_str = url_encode(json_encode(target.mob.get_status_tab_items()))
			target << output("[encoded_global_data];[other_str]", "statbrowser:update")
		if(!target.holder)
			target << output("", "statbrowser:remove_admin_tabs")
		else
			target << output("1", "statbrowser:update_split_admin_tabs")
			if(!("MC" in target.panel_tabs) || !("Tickets" in target.panel_tabs))
				target << output("", "statbrowser:add_admin_tabs") // [url_encode(target.holder.href_token)]
			if(target.stat_tab == "MC")
				var/turf/eye_turf = get_turf(target.eye)
				var/coord_entry = url_encode(COORD(eye_turf))
				if(!mc_data_encoded)
					generate_mc_data()
				target << output("[mc_data_encoded];[coord_entry]", "statbrowser:update_mc")
			if(target.stat_tab == "Tickets")
				var/list/ahelp_tickets = global.ahelp_tickets.stat_entry()
				target << output("[url_encode(json_encode(ahelp_tickets))];", "statbrowser:update_tickets")
		if(target.mob)
			var/mob/M = target.mob
			if((target.stat_tab in target.spell_tabs)) // || !length(target.spell_tabs) && (length(M.mob_spell_list) || length(M.mind?.spell_list)))
				var/list/proc_holders = list() // M.get_proc_holders()
				target.spell_tabs.Cut()
				for(var/phl in proc_holders)
					var/list/proc_holder_list = phl
					target.spell_tabs |= proc_holder_list[1]
				var/proc_holders_encoded = ""
				if(length(proc_holders))
					proc_holders_encoded = url_encode(json_encode(proc_holders))
				target << output("[url_encode(json_encode(target.spell_tabs))];[proc_holders_encoded]", "statbrowser:update_spells")
			if(M?.listed_turf)
				var/mob/target_mob = M
				if(!target_mob.TurfAdjacent(target_mob.listed_turf))
					target << output("", "statbrowser:remove_listedturf")
					target_mob.listed_turf = null

		if(MC_TICK_CHECK)
			return


/datum/controller/subsystem/statpanels/proc/generate_mc_data()
	var/list/mc_data = list(
		list("CPU:", world.cpu),
		list("Instances:", "[num2text(world.contents.len, 10)]"),
		list("World Time:", "[world.time]"),
		list("[config]:", config.stat_entry(), "\ref[config]"),
		list("Byond:", "(FPS:[world.fps]) (TickCount:[world.time/world.tick_lag]) (TickDrift:[round(Master.tickdrift,1)]([round((Master.tickdrift/(world.time/world.tick_lag))*100,0.1)]%))"),
		list("Master Controller:", Master.stat_entry(), "\ref[Master]"),
		list("Failsafe Controller:", Failsafe.stat_entry(), "\ref[Failsafe]"),
		list("","")
	)
	for(var/ss in Master.subsystems)
		var/datum/controller/subsystem/sub_system = ss
		mc_data[++mc_data.len] = list("\[[sub_system.state_letter()]][sub_system.name]", sub_system.stat_entry(), "\ref[sub_system]")
	mc_data[++mc_data.len] = list("Camera Net", "Cameras: [global.cameranet.cameras.len] | Chunks: [global.cameranet.chunks.len]", "\ref[global.cameranet]")
	mc_data_encoded = url_encode(json_encode(mc_data))

/atom/proc/remove_from_cache()
	SIGNAL_HANDLER
	SSstatpanels.cached_images -= ref(src)

/// verbs that send information from the browser UI
/client/verb/set_tab(tab as text|null)
	set name = "Set Tab"
	set hidden = TRUE

	stat_tab = tab

/client/verb/send_tabs(tabs as text|null)
	set name = "Send Tabs"
	set hidden = TRUE

	panel_tabs |= tabs

/client/verb/remove_tabs(tabs as text|null)
	set name = "Remove Tabs"
	set hidden = TRUE

	panel_tabs -= tabs

/client/verb/reset_tabs()
	set name = "Reset Tabs"
	set hidden = TRUE

	panel_tabs = list()

/client/verb/panel_ready()
	set name = "Panel Ready"
	set hidden = TRUE

	statbrowser_ready = TRUE
	init_verbs()

/client/verb/update_verbs()
	set name = "Update Verbs"
	set hidden = TRUE

	init_verbs()

