/*
(t)
(u)
(*)
*/
/datum/admin_changelog
	var/html = null

	var/changes = {"
(t)fri feb 05 16
(u)Haine
(*)Setting people to arrest is now logged.
(t)fri dec 19 15
(u)SpyGuy
(*)Adding "extended revolution" as a gamemode. In case you want a rev that doesn't kill everyone 55 minutes in.
(*)(Jan 28 addendum: now actually not broken!)
(t)mon oct 26 15
(u)Haine
(*)Edit Variables and Mass Edit Variables have been removed from the right-click menu. They can still be found under the Debug tab if you really want to use them instead of the regular varedit window, I guess.
(*)Varedit window now has quick Rotate/Set Direction and Jump To/Get/Player Options commands at the top if the thing you're looking at supports those.
(t)fri oct 16 15
(u)SpyGuy
(*)The telepad will now log sending / receiving mobs. Can be found in the station log.
(t)wed oct 07 15
(u)Convair
(*)Alien invasion events (if triggered by the game) are no longer limited to the blob, though it's still the most common antagonist role by a considerable margin.
(*)Random event wraiths and such seem to work surprisingly well in moderation, so let's give that a try for the sake of variety.
(t)sun sep 27 15
(u)Convair
(*)Blob random event has been overhauled and renamed to alien invasion. Still defaults to a player-controlled blob, and there are a couple of enemy roles you can select from manually if you so desire.
(*)Player selection was improved as well and AFK blobs should a thing of the past. All eligible ghosts (didn't suicide etc) are notified by a loud sound effect and prompt, and given 2 min to acknowledge the offer, adding them to a list if they do. The RNG then checks whether or not all candidates still meet the criteria and picks somebody from the remainder.
(t)fri sep 25 15
(u)Wire
(*)Added a shame-cube verb. Puts a scrub in a shame cube at your position. Highly useful.
(t)fri sep 18 15
(u)Convair
(*)Canister-related logs now come with an atmospheric readout.
(t)wed sep 09 15
(u)Convair
(*)You can now look up fingerprints on individual items from the mob's inventory screen (player panel -> check contents).
(t)wed aug 26 15
(u)Hull
(*)Coders can promote people to coder from the player panel thing.
(t)sat aug 15 15
(u)Convair
(*)The 'Humanize' command is now available at PA+ instead of SG+. You get to chose if you want to send the target to the arrival shuttle, though it's automatic for AI, blob and wraith mobs.
(*)Wraiths and blobs will be stripped of their antagonist status, given that completing the specialist objectives as a human is impossible. Just make them a traitor or something afterwards.
(t)sun aug 09 15
(u)Convair
(*)Re-added nuclear bomb to the 'Antagonists' panel and the 'Observe' list (ghosts only). Same functionality was ripped out with the auth disk and not replaced for some reason.
(t)mon jul 27 15
(u)Convair
(*)Implemented a periodic auto-refresh (every 2 min) of antagonist overlays for admin ghosts, so you don't have to switch mobs anymore to force an update.
(*)This also works if you're using the 'Observe' verb to follow somebody around.
(t)thu jul 23 15
(u)Convair
(*)Handling of emagged, Syndicate and enthralled robots should be more robust now, for instance with regard to the round end stats.
(*)They're listed in the antagonist menu, making them easier to track. This doesn't affect the frequency of late-join antagonists.
(*)AI shells and AI-controlled cyborgs always use the mainframe's lawset, which means players can't deploy to emagged cyborgs to get around their shackles anymore.
(*)Made the 'Show Laws' verb more flexible. Will list rogue robots in addition to the common lawset.
(*)'Law Reset' is actually feature-complete now and can be used to erase ion storm laws.
(t)sat jul 11 15
(u)Convair
(*)Modifying somebody's DNA by using a genetics research console is now logged, as is locking test subjects into the scanner.
(*)Both can be found in the station log.
(t)wed jul 08 15
(u)Convair
(*)Bomb monitor now supports single tank bombs.
(*)There have also been little improvements made recently that didn't warrant special mention. Relevant for you might be:
(*)Cargo transporter (for mobs in container.contents only), RPG-7, locking mobs into Port-a-Brig, forcing mobs to hibernate in a sleeper, singularity generator & bomb (yes, they're functional), shower head, pod life support (air tank).
(t)sat jul 04 15
(u)Convair
(*)Added search function to the custom job creator. You are no longer forced to scroll through a list of ~2600 items.
(t)fri jun 26 15
(u)Convair
(*)Improved artifact logs significantly.
(t)sun jun 21 15
(u)SpyGuy
(*)Automatic bans for people detected with the computer ID changing dll.
(t)mon jun 08 15
(u)Wire
(*)New verb: dectalk. Sends text as voice to all players using Somepotato's server to generate audio files. Please be respectful with this and deffo don't run it into the ground!!
(*)Chat options now has a (beta) filter messages thing. Can dynamically hide messages of certain types. Of debatable usefulness.
(t)tue may 26 15
(u)SpyGuy
(*)Prayers return
(*)Toggle verb to let you hear them or not (defaults to off)
(*)People who pray agree that they are doing so at their own peril.
(u)Convair
(*)New log entries: trick cigarettes, mops (Excluding water, who cares. It's about heat-delayed fireballs and the like.) and welding fuel tank explosions.
(*)Keep in mind that the last person to touch the tank may not be responsible for the blast. However, refuelling a welder doesn't leave fingerprints - pulling the container does.
(t)sun may 24 15
(u)Convair
(*)Whenever somebody throws or is hit by an open container, you can check the reagents in the combat logs. This addition is brought to you by drinking glass bombs.
(t)sat may 23 15
(u)Convair
(*)Creating and coming into contact with chemical smoke is now logged, as is the precise content of chemical smoke as well as foam.
(*)It's not always possible to directly tie a user to these reactions, but searching the logs for "chemical", beaker bombs etc should point to the culprit under most circumstances.
(t)thu may 14 15
(u)Wire
(*)Added blobsay. Does what it sounds like.
(u)Convair
(*)'Humanize' and 'Remove Antagonist' should work more reliably and for most antagonist roles now.
(*)Among other things, mob-specific ability holders and verbs should be removed as expected. Synthetic and critter mobs aren't fully supported yet, though.
(t)tue may 12 15
(u)Convair
(*)Fartstorm anomaly: made the probability of limb loss customizable. It defaults to 0% (though the button is labelled "Random").
(t)mon may 11 15
(u)Convair
(*)Electropacks and electric chairs are now logged. Remote activations go in the signaller logs, flicking the switch manually goes in the combat category.
(t)sun may 03 15
(u)Wire
(*)New admin context menu for the chat! Right click on a name with a dotted underline and get a fancy menu to do stuff! Yay!
(*)Also a Debug Chat verb for coders that puts a firebug console in the chat window.
(t)wed apr 29 15
(u)SpyGuy
(*)View CompID button now takes ckeys so you can view the data of offline players as well.
(t)mon apr 27 15
(u)SpyGuy
(*)New admin message type - Alert. Displays a messagebox to the target. Notifies you when they dismiss it. Handy.
(*)Usage cases include missing output controls and jerks ignoring adminhelps.
(t)sat apr 25 15
(u)Convair
(*)Vampire thrall/mindslave status should now be removed properly on death, implant removal or expiration.
(t)tue apr 21 15
(u)Wire
(*)<b>MAJOR UPDATE</b>
(*)Browser output is enabled! Check this topic out for the detailed info: <a href=\"http://forum.ss13.co/viewtopic.php?f=10&t=5021\">http://forum.ss13.co/viewtopic.php?f=10&t=5021</a>
(t)wed apr 15 15
(u)Convair
(*)Added pop-ups or HTML notifications for the majority of custom antagonists (excluding blob/wraith; they don't need them).
(*)In practice, players should be less likely to overlook the fact that they've been chosen as a gimmick foe...hopefully.
(t)mon apr 13 15
(u)Convair
(*)For our gimmick-loving admins: under most circumstances, synthetics/heads of staff/security shouldn't be picked as rev leaders anymore.
(t)sat apr 11 15
(u)Haine
(*)more vox
(t)sat apr 04 15
(u)SpyGuy
(*)Tanks (like the small O2 / plasma ones) now add an additional log entry in the bombing log, saying when, where and how powerful the explosion was, along with who touched them last.
(*)This helps when some jerk suicide bombs with a tank and an air pump because they found out this does not get them yelled at.
(t)fri apr 03 15
(u)Haine
(*)Delay is now Delay Round Start.  There's now also a Delay Round End command to go with it.  Disabling the round end delay after the server would have already restarted will trigger an immediate restart.
(u)Convair
(*)Now logged: firing (as opposed to hits only) and reloading pod-mounted weapons. Also reloading handguns, as quite a few projectiles share the generic "bullet" designation (suggested by HukHukHuk).
(t)thu apr 02 15
(u)Haine
(*)New: Auto Stealth Mode.  Check your admin preferences to enable it and set the name.
(*)New: Alternate Key and Auto Alt Key.  Like stealth mode and auto stealth mode, but it still shows you as an admin.
(t)mon mar 30 15
(u)SpyGuy
(*)New verb under the Admin tab for SA+ - Display Bomb Monitor
(*)It shows a list of each tank transfer valve and detonator assembly, including general area and coordinates, it also lets you quickly analyze any tanks attached to it to determine if it's going to be a dud or not.
(*)The main feature, however is a Force Dud button. Toggle it to make the bomb completely inert (and get a notification when it would have gone off, had it not been dudded)
(t)fri mar 27 15
(u)Hull
(*)By request of Pacra players using antag tokens on all modes, except nuke, will not count towards the total number of antagonists that are chosen.
(*)If you have a good idea for how to handle Nuke let me know.
(t)wed mar 18 15
(u)SpyGuy
(*)Adding a Special Verb for PA+ that can grant or revoke access to a limited version of VOX for the AI."Set AI VOX"
(*)Limits: Cooldown. 140 characters. A word filter to get rid of naughtiness (such as vox_login)
(t)thu mar 12 15
(u)Convair
(*)Silicon mob (AI, AI shell, cyborg) fatalities are now logged, as is pulling out their brains and power cells where applicable.
(u)Haine
(*)New Change Admin Preferences thing that currently just auto-toggles some toggles if you set it to, supposedly, hopefully (if I coded it right)
(*)(I probably didn't code it right)
(*)A bit of a shuffle of admin commands, lemme know if this is awful or w/e
(t)tue mar 10 15
(u)SpyGuy
(*)Adding a log entry for when you stop choking someone, including the count of how many cycles you've been choking said someone.
(u)Wire
(*)Finished implementing local bans. Now if goonhub goes down it wont "unban" every player that exists.
(*)This entry is mostly here so I can see what servers have updated.
(t)sun mar 08 15
(u)Convair
(*)Since cryo-related shenanigans are encouraged ('Tip of the Day' list), shoving beakers and people into them is now logged. Also adds fingerprints.
(t)thu mar 05 15
(u)Haine
(*)New command for SA+: Pick Random Player.  Opens the player panel for a random player (you can specify traitors/non-traitors or living only/everyone).
(u)Convair
(*)Another batch of log improvements:
(*)Added temperature to the log_reagents proc and 'Check Reagents' verb. Even otherwise harmless chems can be dangerous at unusually high/low temperatures (suggested by Conor12).
(*)Adding chems to somebody (or -thing) with the 'Add Reagent' verb as opposed to the player panel.
(*)Resolved a couple of inconsistencies: beaker vs. bottle/drinking glass, dropper vs. syringe. As a side-effect, spiking food with poison is now logged.
(*)Added pouring stuff in the floor buffer. I'm looking at you, space lube.
(*)Added pouring stuff in the deep fryer. Also deep-frying faces, which can cause a lot of BURN damage.
(t)thu feb 26 15
(u)Wire
(*)Added a bunch of additional features to the ban panel as well as some minor tweaks and fixes.
(*)You can now search through specific columns, sort by specific columns and switch the view to show removed bans.
(t)wed feb 25 15
(u)Haine feat. Convair
(*)Recent additions to the logs:
(*)Harvesting plants. I'm looking at you, explosive tomatoes.
(*)Planting and feeding man-eaters, which ties in with...
(*)Instakill critters. Might be relevant when dealing with Dr. Telegriefer.
(*)Fixed: Smelting alloys with the ore smelter. Also adds fingerprints.
(*)Reminder: Pulling objects (e.g. gas canisters) now adds fingerprints, thanks to Marquesas.
(t)mon feb 23 15
(u)Hull
(*)Added a system for granting players "Antagonist Tokens" which players can redeem at will for a guaranteed antagonist role. You can add or remove tokens from players by using the "Antag Tokens" option in the player panel.
(t)fri feb 20 15
(u)SpyGuy
(*)A new button under Toggles for PA+. "Toggle Camnet Reciprocity". If the AI complains you can use this button to change how the camera network is constructed.
(*)On means that all camera connections are two-way, more reliable navigation, but also more rigid. Off means that connections are one-way, so less rigid controls in exchange for less reliable navigation.
(*)It's pretty intensive so don't use it needlessly.
(t)wed feb 11 15
(u)SpyGuy
(*)The communications room now houses the announcement computer as an experiment. It's logged in the speech log.
(*)Please let me know if it gets ran into the ground. It will be gone like THAT.
(t)sat feb 7 15
(u)SpyGuy
(*)Added logging to attempting to remove / put things on people
(*)Added logging to flamethrowers, it will give you the vector information along with what's been fired. People hit by the blast will also get a log entry.
(*)Added logging to vampire powers
(*)Added logging to when a gun is fired, including who shot it, the location they shot from, the vector to where they were aiming and the kinda projectile they fired.
(t)fri feb 6 15
(u)Haine
(*)more vox weeee
(t)sun feb 01 15
(u)Marquesas
(*)Respawn-As verb (SG+). Spawn in as any key. Immediately. Where you stand. I'm sure hilarity will come from this.
(t)sat jan 31 15
(u)SpyGuy
(*)Testing a new thing where it will message admins if someone signs up and attacks another player within 2 minutes of spawning. Numbers subject to tweaking.
(*)If this is shit and leads to insane spam let me know and it will go away again
(*)The hope is that this will catch the low-effort shitheads that seem to be appearing recently
(*)Use "Toggle Attack Alerts" if you don't want these messages.
(t)sat jan 24 15
(u)Haine
(*)Some new VOX sounds (150+), check 'em out.
(*)please imagine me making a weird gurgling noise here because I am doing so irl
(t)thu jan 15 15
(u)SpyGuy
(*)People shocking doors with wirecutters are now logged in the station log.
(t)mon jan 12 15
(u)Haine
(*)Medical chems' IDs now changed: meth is now "methamphetamine" rather than "hyperzine", "ryetalyn" is "mutadone", "stoxin" is "morphine", etc etc.  Let me know if you see issues pop up because of this.
(t)wed dec 31 14
(u)Haine
(*)Reagent logging should now be more consistant in style and report the in-game name rather than IDs.  If something's still hanging around that reports IDs, let me know.
(*)Happy new year!
(t)fri dec 26 14
(u)Haine
(*)Scalpels and circular saws now report the intent and targeted area in addition to contents in logs.
(t)wed dec 19 14
(u)Hull
(*)Added Call Proc All command, calls specified proc on all instances of a given type.
(t)wed dec 17 14
(u)Hull
(*)Added the ability to cancel when modifying variables. View Variables window can be refreshed, and you can call procs from it directly.
(t)sat dec 13 14
(u)Haine
(*)Redid the Check Reagents command a little - it now brings up a window that gives a detailed report of the reagents in the thing you checked.
(*)New secret - change all floors and walls to wood.
(t)tue dec 09 14
(u)SpyGuy
(*)Stealth mode now lets you set if you want to display your fake key in DSAY or if you want to be "Denmark"
(*)Why would anyone ever want to be Denmark anyway? *waves a Swedish flag around*
(t)wed dec 04 14
(u)Haine
(*)Changed the Atom verbs so they're less horrific on the server + have more options.
(*)Emag Target and Emag Type moved into Atom verbs.  Also Emag All.
(*)There's now also an EMERGENCY STOP command for them which will break any "do something to everything" loops going on as soon as its able.
(t)sun nov 30 14
(u)SpyGuy
(*)Advanced command report that takes placeholders like %name%, for custom-tailored messages. Found under Special Verbs if you're SA+
(u)Haine
(*)Player mode now lets you choose if you wanna recieve adminsays, adminhelps and/or mentorhelps, rather than the completely useless choice of all or no adminlog things.
(t)sat nov 29 14
(u)Marquesas
(*)Build Mode has been rewritten.
(*)On your end, you will probably not notice anything (although I added some extra features to most modes for convenience)
(*)You might notice that things are broken. The basic modes should be fine, adventure might be horribly broken.
(*)Anyway, if you notice any oddities or mishaps, you know where to find me.
(t)fri nov 28 14
(u)SpyGuy
(*)Swap bodies with now PA+ (because it can be done in a messier way with varedit)
(*)Cat County verb
(*)SG+ can do the great switcharoo!
(t)wed nov 26 14
(u)SpyGuy
(*)Swap Bodies With verb for SG+, pretty self-explanatory.
(t)tue nov 25 14
(u)Haine
(*)You'll now only see messages when someone's forced into the reclaimer while <b>alive</b>.
(t)mon nov 24 14
(u)Haine
(*)On right click: revive critter and kill critter.  Also, revive-all-bees.
(t)sat nov 22 14
(u)SpyGuy
(*)Toggle Popup Verbs
(*)You know the part where you want to right-click a dude for some reason and accidentally turn him into an aylien cluwne horrorbeast thingamabob that farts hellscreams, immediately gibs and writes an admin complaint? This button helps with that.
(t)thu nov 20 14
(u)Haine
(*)The bones of a new bleeding system is in now for testing.  Please let me know if lag suddenly gets worse.
(u)SpyGuy
(*)I forgot to mention this: it's now possible to emag the AI turrets, this will make them switch modes at random, so someone getting lasered might not be the AIs fault.
(*)Logged in the combat and admin logs
(t)sat nov 15 14
(u)Hull
(*)Observing while your mob is alive will no longer count you as dead for things like playing as a wizard.
(t)fri nov 14 14
(u)SpyGuy
(*)Connecting atmos devices to connector ports is now logged in the station log
(*)Opening atmos valves is now logged in the station log
(*)Some atmos valves (repressurisation ports) now send a message when opened due to grief potential.
(t)wed nov 05 14
(u)SpyGuy
(*)Added a \"Popt Key\" verb for SA+ that lets you open the player options for a given key.
(*)Useful when you know the key of a person and want to get their player options without navigating the player panel (nice as it is)
(*)Emag Type is now PA+ because that feels more appropriate for it
(t)mon nov 03 14
(u)SpyGuy
(*)Added an emag everything secret for SG+
(*)Also an Emag Type verb that lets you specify exactly what you want to emag for A+
(t)wed oct 22 14
(u)Hull
(*)Added the ability to ban people from OOC, via a verb in the admins tab and on the player panel.
(t)mon oct 20 14
(u)Haine
(*)Heal All verb.  Will prompt if you want to heal the dead as well.
(*)Get thing (mob or object) on right click.  SG+.  Something I needed, yell at me if you want it gone I guess.
(*)VOX will now show you what input you gave it when it complains about a missing word.
(u)Hull
(*)"Press this button if the server refuses to restart" has been renamed Emergency Restart, and is no longer in any of the tabs. To use it just type it in.
(t)sun oct 19 14
(u)Haine
(*)New option on right clicking something: check reagents.  Available to SA+.
(t)sat oct 18 14
(u)Hull
(*)Animation verbs (the shit in the Atoms tab) is hidden by default, but they can still be toggled on.
(t)thu oct 16 14
(u)Haine
(*)Ehh yeah okay, late-join cyborg and AI job options under the job controls menu, just in case you ever wanted to enable those.
(u)Hull
(*)Removed the requirement to be observing to use a bunch of verbs for lower rank admins.
(t)sat oct 11 14
(u)Haine
(*)If you ever wanted to let people select 'macho man' or 'meatcube' as a job, well boy howdy do I have good news for you!!
(t)thu oct 9 14
(u)Haine
(*)Gold statue gibbing to go with the ice statue gibbing.  Will it ever be used?  Dunno.  But the option is there.
(t)fri oct 3 14
(u)Haine
(*)Reward testing verb for SG+.
(*)AIs, AI shells and cyborgs now have variables for their sounds, like humans do.  Enjoy.
(t)wed sep 24 14
(u)volundr
(*)added a new device, the chemicompiler. it's a programmable chemistry/timebomb device.
(t)sat sep 20 14
(u)Haine
(*)Player mode now will ask you if you want to disable admin log messages or not.
(t)wed sep 17 14
(u)Marquesas
(*)For those who missed all the new features in adventures, we now have lightning, foam and smoke traps.
(*)Also, remote controls (one-state) and sliding walls.
(*)And a long-awaited feature: save and load adventure areas on the client side.
(*)This should work near-perfectly for all adventure elements but most special object vars are NOT saved. So don't complain to me when your pre-created hitler moustaches have the wrong transformation matrix.
(u)Haine
(*)Vampire's thralls will also recieve alert popups like mindslaves will now. Kinda redundant considering how long it takes to enthrall someone, but hey, consist<B>E</B>ncy. THERE SPY ARE YOU HAPPY THERE'S AN E NOW
(t)sat sep 13 14
(u)Marquesas
(*)Puzzle element placement revamp in adventure mode. It should all around be more convenient now.
(*)Pressure pads, dual state buttons and multiple activation doors added.
(*)Light emitters can be turned on/off via triggering.
(*)You now have the ability to link up any triggerable object (light, door, critter spawner) to any trigger object (button, pad, trigger).
(*)More stuff coming rather soon, stay tuned!
(u)Haine
(*)More logging!!  Spraybottles are now logged, chairflipping is now logged, changeling stuff is now logged.  Fixed grabs spamming the logs with a ton of duplicate entries.  Fixed circular saws not declaring their target properly re: reagent transfer.
(*)Spy implanters now give the same kind of alert that normal mindslave implants do.  Whoops.
(t)fri sep 12 14
(u)Haine
(*)IMPORTANT CHANGE TO MINDSLAVE IMPLANTS: they now bring up an alert popup that switches your focus to it and you have to hit 'OK' on to make go away.  If people are still saying they didn't notice they were mindslaved after this, bring down your wrath upon them.  The alert pops up both on implantation and the implant wearing off.
(t)thu sep 11 14
(u)Haine
(*)Gibbing people now prompts you if you really want to, except for gibself.
(*)Primary Admins and above now have an 'Atom' tab, a buncha fun new verbs therein, three new right-click atom-related commands, and a 'Toggle Atom Verbs' toggle to toggle your atom verbs tab.
(*)Make Wraith/Blob/Macho Man are now limited to Primary Admins and above.  Sorry friends.  Such is life in space.
(t)sun sep 07 14
(u)Marquesas
(*)Buildmode variable edit now has a reference picker. Instead of having to browse that fucking list, you can now simply click on an atom to use it as a reference value.
(-)
(t)tue sep 02 14
(u)Marquesas
(*)Added decals and lighting to the adventure mode. Hopefully everything should be simple now. Except portals.
(*)Suggestions about what's missing are still eagerly awaited.
(-)
(t)mon sep 01 14
(u)Haine
(*)Administrators and higher should now have access to the right click verb, 'Add Reagents', since they can do the same thing through the secrets panel anyway.
(-)
(u)Marquesas
(*)Added three more wizards to the adventure mode code!
(*)Possessed non-item objects now can also attack with a force of 5. Go and beat people up as a piss puddle I guess.
(*)Possession is WIP, there are still strangenesses regarding hearing admin logs and your own say. On the upside, I hadn't managed to close my own connection yet.
(-)
(t)sun aug 31 14
(u)Haine
(*)I updated the chem list in the admin chem dispenser in the laziest way possible, so it's still not dynamic but at least it's not missing anything for the moment.  I think.
(*)Replaced the syringe gun function with large beakers instead.
(-)
(u)Marquesas
(*)Adventure mode (in Build Mode) now available. This is still heavily WIP but you should find that building ad-hoc adventure areas for people has become a lot easier.
(*)Possess changed. In preparation of the new wraith mode, the new possession works differently than the old one.
(*)Mob code is hell so it is entirely possible there is some scenario where possession might cause your connection to be closed. Drop me a tell if this happens.
(-)
(t)thu aug 28 14
(u)Wire
(*)Rewrote bans AGAIN. This time we're using a central bans web API.
(*)Spruced up the Ban Panel again.
(*)Added an Add Ban verb.
(*)Kill me
(-)
(t)tue aug 26 14
(u)erotic dad
(*)Removed IRC gibbing.
(-)
(u)Marquesas
(*)You can now mute people temporarily or permanently. Muted people can now adminhelp and respond to PMs.
(-)
(t)mon aug 25 14
(u)Haine
(*)Added a DSAY hotkey to WASD, ALT+T, to go with the ASAY one, CTRL+T
(-)
(t)sun aug 24 14
(u)Marquesas
(*)Added a Modify limbs option to the player panel for human mobs. It's capable of attaching any item as arms, too.
(*)I am really not sure if this is a good idea.
(-)
(t)mon aug 18 14
(u)AngriestIBM
(*)You can probably now view an arbitrary key's playernotes using the "View Player Notes" verb.
(-)
(t)mon aug 04 14
(u)Wire
(*)Ban panel improvements. Click to show the path the Auto Banner took in banning a person (Show chain). Click to auto search for: player ckey, comp ID, IP.
(*)The Auto Banner will now mirror the duration of the original ban rather than applying everything as a permaban.
(-)
(t)sun jul 27 14
(u)Wire
(*)Hyposprays now log all their reagents instead of just the first one.
(*)Searching through bans now searches every field (except duration) instead of just ckey and admin ckey.
(-)
(t)sat jul 26 14
(u)Wire
(*)So I rewrote the entire ban system
(*)It now uses a central database. All bans added/edited/deleted will apply to all servers and apply instantly for every server.
(*)The unban panel has been renamed the ban panel (because I like to keep you on your toes) and been given a facelift.
(*)IMPORTANT: I have tested the everloving shit out of this locally but it's impossible to know how well it will work live!
(*)Things may be broken! Important shit too! I need to know ASAP if so. Almost every error condition is designed to output to the Admins log so please check that regularly.
(*)New logged things: flamethrowers and who they hit. Fixed logged things: bomb valves opening (fingerprints).
(-)
(t)mon jul 07 14
(u)Hull
(*)Admins of rank SA and above can now delete player notes. Added a confirmation dialog prior player note deletion.
(*)Messed with explosion code to try to address the concerns about explosions being very weak. Please let me know if you notice any explosion related things that seem out of balance
(-)
(t)sat jun 14 14
(u)LLJK-Mosheninkov
(*)Fiddled with explosion code again. Admin explosions are now capped at 5 (which takes out all of the security wing, for instance), with 3 equaling a maximum strength tank transfer bomb. Also fixed the issue with small admin explosions fucking up turfs on half the station around the epicenter.
(-)
(t)sat jun 07 14
(u)Wire
(*)Fixed admin/mentor PMs a little more. Should show player details for admins now. Also admins should be able to reply to mentor PMs with mentor PMs (and not admin PMs)
(*)New things that are logged: shuttle recalling, medical patches on application, security (AI) camera snipping. IBM added logging for people being shoved into furnaces a few days ago.
(*)Changed the name of Building Log to Station Log.
(-)
(t)sun jun 01 14
(u)Wire
(*)Fixed up some message admins bugs. Added a LOGS link to the player options menu that allows you to auto-search the logs for that players ckey.
(-)
(t)sat may 31 14
(u)Wire
(*)Added a "whois" verb. Takes any text as an arguement. Use it to quickly search for people and determine their status. Can take partial strings (e.g. "Wi" to return "Wirewraith")
(*)Entirely redid message_admins to roll in some of the logging changes I've done. Now include: inline traitor/death/offline status indicators, jump-to-coord links and more reliable refs for player-options.
(*)Cutting off + reattaching limbs is now logged.
(-)
(t)thu may 29 14
(u)Wire
(*)I'm looking for feedback regarding future admin UI changes, so I posted a thread on the forum, please give me your feedback: http://forum.ss13.co/viewtopic.php?f=10&t=2932
(*)Any coordinates in the logs should now be an actual link you can click to jump to.
(-)
(t)wed may 28 14
(u)Wire
(*)New things that are logged: flipping (on + off chairs), wrestling moves, hyposprays, sleepy pens, paper messages, pod to pod combat and power gloves.
(-)
(t)mon may 26 14
(u)Wire
(*)People entering/exiting pods is now logged to the 'admin' sub category.
(-)
(t)thu may 22 14
(u)Wire
(*)This is here so coders can communicate all the changes to the admin interface that they implement. The admin interface is such a giant clusterfuck that I figure any help I can give to admins trying to wrestle with it is a good thing.
(*)Created the admin changelog
(-)"}

/datum/admin_changelog/New()
	..()
	html = changelog_parse(changes, "Admin Changelog")
