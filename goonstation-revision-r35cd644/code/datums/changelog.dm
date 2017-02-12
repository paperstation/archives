/*
(t)
(u)
(*)
*/
/datum/changelog
//	var/changelog_path = "icons/changelog.txt"
	var/html = null
/*
New auto-generated changelog:
Format:
Use (t) for the timestamp, (u) for the user, and (*)for the line to add.
Be sure to add a \ before a [
Examples:
Single update for a given day:
(t)mon jan 01 12
(u)Pantaloons
(*)Did a thing.
Multiple updates in a day:
(t)mon jan 01 12
(u)Pantaloons
(*)Did a thing.
(u)Nannek
(*)Also did a thing.

WIRE NOTE: You don't need to use (-) anymore (although doing so doesn't break anything)
OTHER NOTE:
(t)mon dec 1 14
returns "Monday, December 1 th, 204"
so you'll want your single-digit days to have 0s in front
*/

	var/changes = {"
(t)thu feb 18 15
(u)SpyGuy
(*)Fixed some issues with human shields. They should work reliably now.
(t)mon feb 15 15
(u)Wire
(*)Swapped servers #1 and #5. Meaning #1 now runs destiny/RP mode and #5 now runs normal cogmap2 mode. This was done for performance reasons.
(t)fri feb 12 16
(u)Haine
(*)<b>Destiny only</b>: You can now return to cryosleep in the cryotron, if you have to leave for whatever reason. There's a 15 minute wait before you can leave cryosleep again once you enter. That time may be adjusted in the future.
(t)sat jan 30 16
(u)Haine
(*)Fixed the end-of-round nuke animation for successful exploding of the station.
(t)mon jan 25 16
(u)Haine
(*)Hopefully fixed the issues Destiny was having with nuke mode.  Please let me know if it bugs out (on any map, not just Destiny).
(t)fri jan 08 16
(u)Marquesas
(*)Nitroglycerin.
(*)Good luck.
(t)thu jan 07 16
(u)Haine
(*)Throwing people should be working again.
(t)sat dec 12 15
(u)Dr. Cogwerks
(*)woop woop cogmap2 day woop woop
(*)Many thanks to:
(*)-NEW PERSPECTIVE SPRITE PROJECT: Supernorn, SLthePyro, Haine, etc.
(*)-NEW LIGHTING: Tobba (UPDATE TO BYOND 509!!!)
(*)-The coding and administrative staff for all sortsa updates and for helping to keep this goofy old game going
(*)-Our awesome community for a ton of help with playtesting, ideas and process critiques
(*)-All the folks who helped keep me afloat while life was topsy-turvy. <3 <3 <3
(*)Have fun!
(t)thu dec 10 15
(u)Wire
(*)New popups! Sorta. This is an introduction of a brand spanking new popup framework we're testing. As the end-user, you wont see much beyond an initial style change, but trust me some magic is happening behind the scenes.
(*)Yes this changelog looks a little janky with the new theme, will fix. Also if shit goes real south and your changelog can't be closed or whatever, just issue the "Changelog" verb and it will go away.
(*)(New popup framework coded largely by Somepotato)
(t)mon dec 07 15
(u)Haine
(*)<b>Destiny only</b>: Security Officers now have access to everywhere but heads' offices and other command locations (bridge/EVA/AI/etc). HoS now have all access plus their armory access. Please don't abuse this so I don't have to remove it again.
(t)tue dec 01 15
(u)Haine
(*)Merry Spacemas!
(*)To help make new ornaments for the tree, see this thread: http://forum.ss13.co/viewtopic.php?f=5&t=6074
(t)mon nov 30 15
(u)SpyGuy
(*)Mercury no longer a stealth poison.
(*):getin:
(*)Also: paper hats. HAINE NOTE: YOU HAVE TO FOLD THEM NOW WITH A COMMAND BY RIGHT CLICKING ON THEM OR SOMETHING, SPY FORGOT TO MENTION THAT
(t)sun nov 29 15
(u)SpyGuy
(*)Tweaked how conveyor belts work. They should now be significantly faster. As such the cargo routing system can actually be used to deliver things in a timely manner!
(t)fri nov 27 15
(u)SpyGuy
(*)Fixed a long-standing issue with clown car reliability.
(*)This update brought to you by our sponsors, the Tinfoil Hat Society.
(u)Haine
(*)Mentorhelp is now hot pink.  This is partially (mostly) because mentorhelps were getting lost in admin PM messages since they were all the same blue color.
(*)F3 is now a hotkey for mentorhelp.
(t)wed nov 25 15
(u)Haine
(*)New wizard outfit available, made by Gannets!
(*)You can now cut eyeholes into cardboard boxes. You can also now put fake moustaches on them.
(*)Fixed syndicate saws so, when you see one in someone's hand, it's red, not green.
(t)fri nov 20 15
(u)SpyGuy
(*)A brand new interface for the pathology computer. It's cool as heck.
(*)It's also kind of experimental, fitting for a sciencey department.
(u)Haine
(*)New/"New" HUD styles: Classic, the blue and green style from early goonstation days, and Mithril, a HUD style by quiltyquilty.
(*)Fixed: "You're too far away from the left hand to deal a card!"
(t)mon nov 16 15
(u)Haine
(*)New HUD sprites, courtesy of Bartorex! Additional thanks to Somepotato for setting up a dmi with the sprites, and letting me have said dmi, so I could be lazy.
(*)You can still use the old HUD! You'll find a new option in your preferences to use the old style, or you can switch at any time with the Change HUD Style command.
(t)mon nov 09 15
(u)Wire
(*)The highlight string functionality in the chat window will now only highlight matched words rather than the whole line.
(t)mon nov 02 15
(u)Haine
(*)Shocking Grasp is now Shocking Touch. It no longer instantly vaporizes people, and instead instantly puts them in crit, while stunning people nearby. Yes, I do hate fun, why do you ask?
(t)mon oct 26 15
(u)Wire
(*)Enabled tooltips on all the health HUD information (for Humans). They have the same description text as when they're clicked. I am unreasonably pleased with how this turned out.
(t)thu oct 22 15
(u)Haine
(*)Eye surgery! It's janky and awful. Probably also buggy. Let me know on the forums!
(*)It's spoon-scalpel-spoon, and you need to use both tools with the hand on the same side as the eye you want to do surgery on. Right hand for right eye, left for left, like that. It was either this, or pop-up prompts.
(*)Eventually surgery in general will be re-written and this will all be less stupid. For now, though, please enjoy this terrible mess.
(t)wed oct 21 15
(u)Haine
(*)Pills no longer need something to be in a beaker/whatever already to be dissolved. Realistic? No. More fun? Yes.
(t)sat oct 17 15
(u)Convair
(*)Buffed the Staff of Cthulhu a little to hopefully make it a more viable choice, especially when considering that you have to sacrifice a spell slot for the thing.
(*)Use the associated ability and it'll magically show up in your hand (or on the floor if you have both hands full), and the staff is also a slightly better melee weapon than before.
(t)thu oct 08 15
(u)Wire
(*)Tooltip support for pod UI buttons
(t)tue oct 06 15
(u)Wire
(*)Added some swanky tooltips to the game. They appear for most ability buttons in the top left of your screen.
(*)A notable omission are pod buttons. They're a bit more difficult.
(*)This is using some hitherto unknown black magic to pull off and could be either very laggy or just plain broken so uh, we'll see how this goes.
(t)mon oct 05 15
(u)SpyGuy
(*)Guess what. NI3 got ran into the ground. You horrible jerks.
(*)Now it's gone until I can work out what to do with it.
(t)wed sep 30 15
(u)Convair
(*)Given that very little nuke round development took place since May, it seemed appropriate to finally make some simple but significant adjustments based on user feedback.
(*)Added seven new target areas. Some are more in the crew's favour than others, but they're all temporary and will have to be rebalanced for Cogmap 2 anyway.
(*)Timer now defaults to 8 min, and unscrewing the nuke halves the countdown instead of dropping it to 60 seconds. The good ol' auth disk can be inserted to add (crew member) or shave off (nuke ops) 3 min once, but this is entirely optional.
(*)The Syndicate leader spawns with an old-fashioned auth disk pinpointer. His team may want to use it to infiltrate the station stealthily in preparation for the main strike.
(*)Made the nuke invulnerable to explosions (shame on you, suicide bombers). However, it actually takes damage from melee attacks now, and a couple of people with looted eswords will make short work of it. Unchanged: you can also shoot, laser or EMP the nuke.
(*)Removed some 2011-era code that would magically teleport the nuke back to Z1 under certain circumstances. The pod method of dealing with the nuke should be more reliable as a result.
(*)Late-joining antagonists no longer make an appearance in this game mode.
(t)sat sep 26 15
(u)Keelin
(*)Added an option to select your prefered targeting cursor to player preferences.
(*)Ported over number binding for abilities to changelings, wizards and vampires. ctrl+shift click an ability to enable binding mode, then press a number you want bound to that ability. This only works in WASD mode.
(*)Made some changeling and wizard abilities "sticky". This means they will stay on your cursor after using them unless they are on cooldown afterwards. Clikcing their button again or pressing the assigned hotkey again will remove them from your cursor.
(t)fri sep 25 15
(u)SpyGuy + FreshLemon
(*)Mentoring HotawhatBaabhabhiat (did I spell that right? I got no idea)
(t)thu sep 24 15
(u)SpyGuy
(*)Fixed a longstanding issue where monkies would be nonresponsive to rajaijah. This probably pleases a handful of people.
(t)wed sep 23 15
(u)SpyGuy
(*)Fixed explosions doing no damage to people.
(*)Nerfed pipe bombs because by default they should not be able to gib a dude. Sorry guys, you'll just have to make them stronger if you want to do that.
(t)thu sep 17 15
(u)Wire
(*)Reduced the resource file even further (by another 20mb or so) with help from ErikHanson.
(*)Some sounds might be a bit off! There's like 2000+ sound files so we couldn't test them all. If you spot one that does, please post in this topic: http://forum.ss13.co/viewtopic.php?f=7&t=5865
(t)wed sep 16 15
(u)Wire
(*)Ok it's back in (with some additional help from ErikHanson), this time the sprites shouldn't be visibly affected.
(*)HAHA JUST KIDDING OF COURSE THIS FUCKED STUFF UP. OF. COURSE. (Changes reverted)
(*)Reduced the resource filesize by like 25mb or so because I'm freakin' awesome.
(*)Ok it's like, 90% because Somepotato made a thing for me but I'm still taking the credit ok.
(t)mon sep 07 15
(u)Wire
(*)Fixing up a bunch of popups that I probably broke with the CDN introduction. This includes: the Material Recombobulator, the Workbench (smelter) and the Artifact Research Computer.
(*)Fix for the traits popup appearing underneath the top byond titlebar, preventing movement/closing.
(t)wed sep 02 15
(u)Convair
(*)Due to popular demand, wrestling moves don't use manual aiming anymore in case there's only one target nearby.
(*)Inconsistent behavior is unintuitive to some extent (and was the motivation for that particular change), but it's acceptable if you prefer the status quo.
(t)tue sep 01 15
(u)Convair
(*)Sprites for all changeling abilities have been added, courtesy of Sundance420.
(t)mon aug 31 15
(u)Convair
(*)Wrestling belts no longer use the legacy verb-based system.
(t)fri aug 28 15
(u)Haine
(*)Radioactive Blowouts were disabled for a little bit and now have been enabled again after some fixes.
(*)PLEASE LET ME KNOW IF: you get irradiated in an area where you don't think you should get irradiated during a blowout.
(t)wed aug 26 15
(u)Hull
(*)Added some protection for wraiths losing both of their lives too quickly. Added: New genetic effect, chemical, and food.
(t)tue aug 25 15
(u)Convair
(*)Vampire: did away with the legacy verb-based system. Abilities should be easier to use as a result, and provide better feedback to the player.
(t)mon aug 24 15
(u)Wire
(*)Enabled what I'm calling "CDN resource mode". This basically stops byond from sending you files necessary for popups and such, and instead links to where they are hosted on an external server (goonhub).
(*)This replaces the resource preloader thing and will eliminate all popup related lag. Aside from that, you shouldn't notice much difference.
(*)However, if you do spot a popup with a broken image or broken styling or whatever, please let me know.
(t)sun aug 23 15
(u)Haine
(*)Added an AZERTY mode for WASD hotkeys.  Look for the toggles in the Toggles tab and your character preferences.
(u)Daeren
(*)IT'S A WRAITH REBALANCE HOEDOWN, EVERYBODY GET HYPE
(*)After a bunch of testing and discussion I've made a bunch of changes, some major and some minor. If it goes well I might bump up wraith spawn rate.
(*)The Big Change: Absorb Corpse's cooldown starts at 45 seconds and scales exponentially with each use. Much faster early game, much harder to get into scientific notation with your wraith points.
(*)The Big Change 2: Wraiths can only survive one banishment now, instead of two. When banished, Absorb Corpse's scaling and cooldown are reset.
(*)Revenants make a bigger, angrier red message when animated.
(*)Push has apparently had a very long-standing bug where it didnt work right on objects or doors, w h o o p s that's fixed now.
(*)Possess Object's cooldown reduced by 30 seconds.
(*)Salt lines can now be destroyed by careless foot traffic. Walking dramatically reduces the chance to scuff up a salt line, but its still not a great idea to put them in incredibly high traffic areas. Try using walls or redundant layers.
(*)If you notice any added bugs or weirdness dial 1-800-IMC-ODER
(*)These tweaks, as always, are subject to re-tweaking based on further testing and input.
(t)thu aug 20 15
(u)Wire
(*)I know this changelog window is looking a little weird around the titlebar (probably). No need to message me about it, I'll fix it when I'm not hella tired.
(t)sun aug 16 15
(u)SpyGuy
(*)Adding gimmick reasons / details to assassination missions. Make sure your targets know WHY they're on the list!
(*)Huge thanks to, in no particular order, ErikHanson, Nurdock, Azungar, Nitrous, Dabir, Xavieri, oxy and Gannets for the great help in coming up with these!
(u)Haine
(*)Added a command to toggle seeing mentorhelps on or off for mentors.  Somehow we made it this long without having that.  Whoops!
(*)May be buggy, I can't really test it fully by myself.  Let me know if there's a problem!
(t)fri aug 14 15
(u)Convair
(*)Added shortcuts for the AI's internal radios. Prefix your message with ':1', ':2' or ':3' respectively.
(*)AI shells and AI-controlled cyborgs can also use them, assuming you have a mainframe and it isn't incapacitated.
(t)thu aug 13 15
(u)SpyGuy
(*)Modified the resource distribution code to make joining rounds smoother.
(*)In case any web-based interfaces / windows behave strangely, please report it on the forums.
(t)sun aug 09 15
(u)Convair
(*)AI shells and AI-controlled cyborgs now have access to the 'Open nearest door' verb.
(u)SpyGuy
(*)The AI changing its status will now be reflected on the core as well.
(*)It can also set its own colour at will.
(*)Nukeops pinpointers now point to the nuke instead.
(t)sat aug 08 15
(u)SpyGuy
(*)A new attachment for tank transfer valves! Wow!
(*)More pressure = more better.
(t)thu aug 06 15
(u)volundr
(*)Made atmos drain rooms with holes in them much faster. This causes less lag, but has the side effect of making you die. Wear internals when shit gets busted.
(*)Fixed a memory leak related to animation and matrix transforms. Should make for much less round-end lag.
(t)fri jul 31 15
(u)Convair
(*)Fixed click-dragging barcode labels onto crates and stuff. Cyborgs might find it useful.
(*)Also fixed the optical meson upgrade for cyborgs.
(t)thu jul 16 15
(u)Convair
(*)Certain assemblies are somewhat more flexible now:
(*)Mousetrap bomb (+ non-chem grenade), mousetrap car (+ non-chem grenade and pipe bomb), suicide bomb vest (+ non-chem grenade and pipe bomb).
(u)Haine
(*)The ice moon lattice bug should be fixed now. Lemme know if not.
(t)wed jul 15 15
(u)Haine
(*)ProDocs now accept health analyzer upgrades.  This lets them scan people's health from a distance.  Click on the goggles in-hand to toggle it.
(*)Fixed up pens and the like so that they use fancy fonts again.
(*)Everyone now starts with a (probably) unique handwriting style and signature.
(t)tue jul 14 15
(u)Wire
(*)Fiddled with the status tab area a bit. Removed the "Game" tab. Let me know of any formatting issues.
(u)Infinite Monkeys
(*)You can now name your save profiles. The name is displayed instead of a number under the Load menu.
(*)Heads can now be impaled on rods, up to three per rod.
(t)mon jul 13 15
(u)Wire
(*)Three new buttons in the top-right with corresponding verbs. Will open up relevent pages in your browser. No more lazy people mentorhelping for the wiki.
(*)The chat should possibly maybe preserve history on round restart now (instead of clearing). We'll see if this actually works.
(u)Infinite Monkeys
(*)Syndicate and Wizard modes will no longer end instantly if the antagonists die. Instead, once they are all dead late join antagonists may begin to appear. This won't happen if the bad guys are kept alive and locked up somewhere!
(*)You can now chop off people's limbs from the strip menu while holding certain items. This is slower than surgery, but only requires them to be unable to move.
(t)fri jul 10 15
(u)Infinite Monkeys
(*)The power transmission laser's earnings are no longer linear. Feedback is needed on the forums - even just posting data on round duration, peak laser output and your earnings would be helpful!
(*)The PTL beam will now change alpha depending on how much power it is transmitting.
(t)thu jul 09 15
(u)Wire
(*)Prototype popup window reskin thing! Only applied to this very changelog window at the moment.
(*)If it completely messes up for you, just use the "Changelog" verb again to close the window manually.
(*)Major credit to <b>Somepotato</b> for the original idea and code.
(t)wed jul 08 15
(u)Infinite Monkeys
(*)Added a load more object suicides. See if you can find them all!
(t)sat jul 04 15
(u)Haine
(*)Underwear now works like hair and all that other nonsense and your old underwear choices are probably now broken, so go re-clothe yourselves you naked freaks.
(*)The thing that randomizes appearances now works the same regardless of if you're doing it via the character options panel or a DNA scrambler.  It used to be two similar but different sets of code.  Might be a bit buggy from the change, let me know.
(t)mon jun 29 15
(u)Convair
(*)The captain's antique laser gun can now be repaired. How? Up to you to find out.
(*)You may want to use some decent-quality replacement parts, though.
(u)Haine
(*)You can now use an AI interface board in place of a brain when making a cyborg.  This allows the AI to use the borg's body.  This is a terribly hacky mess and it's undoubtedly still buggy for the moment.
(*)AI shells can now be built with any power cell you'd like.  Why would you use a really big cell in a shell?  Who knows, but you can.
(t)thu jun 24 15
(u)Haine
(*)Another stationary chemicompiler in the test chamber itself.
(t)wed jun 24 15
(u)I Said No
(*)Added a handful of new genetics genes.
(t)tue jun 23 15
(u)I Said No
(*)Chameleon and Cloak of Darkness now grant powers that allow you to switch them on and off at will.
(t)mon jun 22 15
(u)I Said No
(*)Additional genetics UI tweaks. Markers will now turn white when you have the correct sequence.
(*)Added Autocomplete feature. If you have already activated a gene once, you can hit autocomplete to get the sequence. Encryption locks must still be broken, however.
(*)Added Booster Gene Y and Booster Gene Z.
(*)High Complexity DNA is easier to unlock now (2 locks instead of 4), and also can be used as a wildcard in gene combination.
(*)Appearance and Body Type are now fully accessible from the beginning.
(*)Removed: Booster Gene Q, Saturated Junk DNA, Hair Follicle Research, Body Type Research
(u)Haine
(*)Removed a bunch of sprites that were no longer needed - if you see something weird happening with clothing like a missing sprite, please let me know.
(t)sun jun 21 15
(u)SpyGuy
(*)Adding an automatic ban for clientside mods that affect data being sent to the server.
(*)In case you are running any sort of mods and still wish to play here you should disable them now.
(*)If you don't know if your client is modded or not it isn't.
(u)Convair
(*)Reworked medical sleepers, which should now be capable of keeping light-crit patients stabilized for a reasonable amount of time (as opposed to being pretty much pointless).
(*)They're still no substitute for a doctor, but it should buy you enough time to grab the right type of medicine from the medical vendor or something.
(u)Hull
(*)Split medbay off into seperate areas for the lobby and operating theater which should spread out the APC drain.
(t)wed jun 17 15
(u)I Said No
(*)Genetics interface changed a bit. Grey genes have not been researched, yellow ones have been researched but not activated, and green ones have been activated.
(*)Fixed a bug that prevented you from adding stored mutations to a subject.
(u)Convair
(*)The experimental generator (available through QM) is now capable of charging APCs, and I also buffed the charge rate.
(t)tue jun 16 15
(u)Convair
(*)Back end changes to porters (Port-a-Brig etc) and old (non-PDA) remotes.
(*)Home turf and remote-to-device link aren't hard-coded anymore. Click-drag the machine onto a floor tile to designate it as the new home location.
(*)You can order additional Port-a-Brigs from the cargo bay if you so desire.
(t)sun jun 14 15
(u)Infinite Monkeys
(*)You can now buy things directly from the Supply Request Console outside the Quartermasters' Office using money from your personal account. It's still delivered to the same place, though, so you'll need the quartermasters to give it to you.
(t)sat jun 13 15
(u)Convair
(*)Added Port-a-NanoMed remote to most medical PDAs, and a Port-a-Sci remote to the RD's PDA.
(u)I Said No
(*)Activators that have successfully activated a power in a human (not monkeys!) can be recycled by putting them back in the genetics terminal.
(*)Doing this yields various rewards, and will decrease research costs and times up to a cap.
(*)One of the new rewards is Chromosomes, which can be used on activated mutations to improve them in various ways.
(*)The research time and cost reduction research articles are gone, as they are obsolete due to activator recycling.
(*)Booster Gene A, B and C are also gone as they were obsoleted by the new chromosomes feature.
(t)wed jun 10 15
(u)Convair
(*)Security and HoS PDAs now come pre-loaded with a Port-a-Brig remote. Also added a few blank PDAs to the sec vending machine, considering that redshirts are a frequent target for PDA bombers.
(u)Wire
(*)New 'Link IRC' verb. Associates your byond username with your irc nickname. Will be useful in the future for certain IRC bot commands.
(u)I Said No
(*)Genetics can now access DNA samples directly from the station's medical database instead to having to scan them.
(*)Activating a gene from someone's latent pool no longer causes any stability loss.
(*)Geneticists can now create Activator syringes, which only activate latent powers.
(*)Fixed a few interface bugs in the genetics computer.
(t)tue jun 09 15
(u)I Said No
(*)Hairstyles and detail options have been merged into one list. Go hog wild.
(*)Your customization choices preview should sync up with what you actually get in game now.
(t)mon jun 08 15
(u)I Said No
(*)Meteor Shield Generators now use far less power. Due to some other unlisted changes, I strongly recommend taking advantage of this buff.
(t)sun jun 07 15
(u)Infinite Monkeys
(*)The power transmission laser can now instantly detonate people at high enough energies.
(*)Improved the controls for input and output of the laser.
(t)fri jun 05 15
(u)Haine
(*)New and improved escape shuttle!  It now spends a bit of time in transit to centcom before arriving.  Buckle up!
(u)SpyGuy
(*)Changes to how human icons are handled. Please report any bugs or strange behaviour you find.
(u)I Said No
(*)Traitor objectives have been messed with. There are now many more combinations of objectives available, in addition to some all-new objectives:
(*)Damage Area: Cause a significant amount of damage to a chosen room.
(*)Destroy Equipment: Destroy all instances of a chosen piece of equipment on the station.
(*)Job Genocide: Kill all crewmembers of a particular job.
(*)Off the Heads: Kill all the head personnel.
(*)No Clones: Make sure no cloned crew survive.
(*)Supremacy: Be the last antagonist standing.
(*)Gimmick and Miscreant objective lists have also been tweaked a bit.
(t)wed jun 03 15
(u)I Said No
(*)Pod changes: You can click-drag yourself onto a pod to board it. There is now also a Leave Pod button in the bottom-right corner when inside a pod.
(*)Pod Cargo Hold change: You can click-drag the pod to a nearby tile to unload stuff there.
(*)New pod secondary system: Ore Scoop. Drive over ore to pick it up, clickdrag the pod to a nearby tile to unload it.
(*)New pod comms system part: Magnet Link Array. Allows you to control the mining magnet from within 7 tiles from inside a pod.
(*)The mining department now starts with a Mineral Accumulator.
(t)tue jun 02 15
(u)SpyGuy
(*)Tweaked critter backend, should significantly reduce lag.
(*)Critters might be lazier as a result. Please report any issues.
(u)I Said No
(*)Pod communication systems are now used to interface with dock controls. If you don't have a comms system or you have the wrong one, you'll be denied access.
(*)Syndicate pods start with a different communications system to station pods. You can't just go in through the pod bays anymore.
(u)Haine
(*)There's now a civilian radio channel, for chefs/botanists/etc.
(t)sun may 31 15
(u)Marquesas
(*)New stock market event type.
(*)Also adjusted the effects events have. Overall, they should leave a larger dent. Or a larger profit in your hands.
(u)Convair
(*)Gun components have finally been updated for the new projectile code.
(u)Infinite Monkeys
(*)Engineers can now sell power with a giant laser. Thanks to Gannets for the awesome sprites! It'll definitely need adjusting so please leave feedback on the forums.
(t)sat may 30 15
(u)I Said No
(*)Cytines have been replaced with a variety of different gemstones.
(*)You can now load mined Viscerite into enzymatic reclaimers.
(u)Haine
(*)Ehh nevermind about the cloning for money thing.
(*)Clowns have functional bank accounts again.
(t)fri may 29 15
(u)Haine
(*)Due to budget cuts, cloning is no longer provided for free from Nanotrasen.
(u)Keelin
(*)Adding, removing and changing various traits. As per usual, nothing is final.
(t)wed may 27 15
(u)Marquesas
(*)Dump out any storage objects by taking them in a hand and click-dragging it onto the ground (or a table).
(u)Convair
(*)Light bulb fixture parts can now be crafted from metal sheets. Also fixed the bug that made it impossible to attach them to reinforced walls.
(u)Keelin
(*)Fixed the fat trait swallowing your PDA and ID and such. They can now be found in your backpack.
(*)Short-sighted trait now spawns you with glasses.
(*)Toned down kleptomaniac slightly and made sure it only fires when you're alive.
(*)Career alcoholic will now only somewhat slur your speech.
(*)Traits are now visible in the medical records.
(*)New traits: Deaf, Adamantium skeleton, Cat eyes, Infravision, Spacephobia, Robust genetics, Good genes, Bad genes.
(*)Removed Trait: Overly soggy
(*)Mutations gained through traits will now show up in your notes.
(u)Haine
(*)Fixed not being able to unlock APCs with a PDA that has an ID in it. Made swapping IDs quicker, just click with the new one and the old one will automatically be ejected.
(t)tue may 26 15
(u)SpyGuy
(*)The pray verb returns. Use it to in an attempt to gain the attention of whatever god happens to be listening.
(*)Note that divine attention may not be something you want and it might not end well for you. Use at your own peril.
(*)Also there's a high chance that nobody is listening, but you never know...
(u)Keelin
(*)First batch of traits.
(*)All traits are subject to change. Especially ones that change damage, health or stamina. They are controversial and we're just gonna test this for a bit.
(t)mon may 25 15
(u)I Said No
(*)The nuke should no longer repeatedly detonate when the timer counts down.
(*)Examining the nuke now shows whether or not it is unsecured, and how much time is left on the bomb if it is armed. It also shows roughly how much damage the bomb has taken.
(u)Keelin
(*)Putting down the framework for selectable traits in your player options. The stuff that's in there is all silly placeholders (but they do work).
(*)It might be a bit unresponsive & look like ass until im done.
(t)sun may 24 15
(u)Marquesas
(*)Adding events to the stock exchange. Good analysts may be able to predict the outcome. Bad analysts will lose a lot of money.
(u)SpyGuy
(*)Refactoring crates into a new standard. Report bugs with crates and crate-like things if you see any.
(u)I Said No
(*)Nuclear Emergency mode has been substantially changed. The operatives must now take the bomb to a specific location on the station, arm it, and then make sure it detonates.
(*)The crew ideally must prevent the bomb from being armed, but if it is it can either be destroyed by various means or unanchored by using a screwdriver and taken off the station map to avoid the station's destruction.
(*)The nuclear bomb can be loaded into pods. Also, the nuclear disk no longer exists. Good riddance.
(*)More changes to come. This stuff is WIP for now.
(t)thu may 21 15
(u)Haine
(*)PUT THE CLAMPS TO YA!
(t)wed may 20 15
(u)Conor12
(*)Some changes to the ID computer.
(*)Jobs and access sorted into sections.
(*)You can set the colour of an ID.
(t)tue may 19 15
(u)Convair
(*)The teleport gun should no longer be unreliable and temperamental.
(u)SpyGuy
(*)Being invisible will no longer make you deaf because the soundwaves can't see you (what)
(*)Cloakers shouldn't turn off in your pocket any more.
(u)Wire
(*)Having the chat area focused and pressing arrow keys will now correctly switch focus.
(*)Screenshot and reconnect commands now send a notification to the chat area.
(*)Added error message for a chat output load-failure (very rare case).
(t)sat may 16 15
(u)Haine
(*)Solars are no longer hotwired by default.
(t)fri may 15 15
(u)Convair
(*)The wizard's spellshield now protects against projectiles as advertised. More of a bug fix, really.
(t)thu may 14 15
(u)Wire
(*)Fixed a shitload of html encoding issues (or lack thereof) affecting newchat.
(*)Fixed a bunch of exploits reported by Somepotato.
(*)Please note I am a terrible coder so I'm not 100% sure that I didn't just break everything. Let me know if the following start screwing up:
(*)Fabricators, vending machines, the HoP ATM computer thing, the PDA Ticketmaster module, pod "Create Wormhole" action, adding power cells to a recharging dock, removing a cyborg's brain and basically every mechanic tool that spits text to chat.
(*)Good luck!
(t)tue may 12 15
(u)Marquesas
(*)Changeling acid spit now functions as a splash of fluorosulfuric acid rather than that illogical knockout biz it did before.
(t)mon may 11 15
(u)Convair
(*)Tweaked electric chairs a little. You can either...
(*)1) Deploy them in a powered area as usual (lethal does around 80 BURN).
(*)2) Wire them directly into the power grid. Don't bother if the engine's output isn't half-decent, though.
(u)Wire
(*)Clickable links in the chat area will now open in your default browser (rather than all IE all the time).
(t)sun may 10 15
(u)Wire
(*)Greatly reduced the spam of "Connection may be closed..." messages.
(*)Now you can choose up to 5 strings to highlight. Also the strings and the color persist through rounds now (they save themselves).
(t)thu may 07 15
(u)Wire
(*)Improved an annoying bit of the chat output with regards to focus stealing. Now, if your focus happens to be on the chat output and you start typing, it will send the first character to the input box (whereas before it skipped the first character you pressed).
(*)Also fixed a mildly rare occurring error for the chat output in cases on blank messages being sent to it. If your output tended to break entirely at random points, this will probably fix that.
(*)New option: Clear all messages. Pretty much what it sounds like.
(u)Marquesas
(*)<b>It's-a me, Marquesas</b> doing more changes which:
(*)- Best case scenario, go completely unnoticed
(*)- Worst case scenario, break people attacking eachother (a p insignificant feature)
(*)All I'm saying is if something is off, please write it down on a paper, go to your nearest DongLabs Customer Support Window, get in line with the 50 other outraged players and hand it to the nice lady with the butt hat.
(*)On the plus side I no longer need a plastic bag while looking at mob attack code so there's a plus.
(t)mon may 04 15
(u)Wire
(*)Fixed ctrl + c on highlighted text in the chat output not actually copying text.
(*)New chat feature: highlight string. Will put a yellow background on a defined string for all future messages. Probably mostly useful to highlight your own name.
(u)Marquesas
(*)Fixed numerous issues with the new changeling ability system.
(*)Everything finally seems to be using this new system. This may have introduced several regressions, however. Keep me posted.
(t)sun may 03 15
(u)Keelin
(*)Rewriting large parts of the material system. Expect wonky behaviour until I'm done.
(*)Quality of asteroids now affects quality of the resulting material. Material quality now changes the maximum of property values (toughness etc.).
(t)sat may 02 15
(u)Conor12
(*)Strawberries!
(*)Strawberry plants, strawberry pies and other strawberry stuff.
(*)Sprites provided by a strawberry clown.
(u)Marquesas
(*)Moved changelings to the ability system that wizards and other very able stuff are using.
(*)Naturally, this might mean a myriad of bugs. As usual, you know where to find me.
(t)fri may 01 15
(u)Wire
(*)Fixed new chat output for those who had issues loading it.
(*)Implemented a new ping meter that displays in the chat area. Updates every 60 seconds and displays visually. We'll see how well this works live.
(*)A bunch of other minor improvements and fixes related to the chat panel.
(*)Added option to disable the ping display. Revamped the options menu UI.
(*)Added option to change the chat font style.
(u)Haine
(*)A few new hairs.
(*)Monkeys behave slightly differently.
(t)thu apr 30 15
(u)Haine
(*)Presents containing dead guys are no longer invisible and named "spresent".
(*)Voice changers are now an item that can be put into masks, rather than a mask iteself.
(*)IV drips/blood packs/etc now hold up to 250u, rather than 100u.
(t)wed apr 29 15
(u)Wire
(*)Some UI improvements to the chat output. Also changed the font. I expect this to fuck with all of you appropriately.
(t)wed apr 29 15
(u)Keelin
(*)Ouija boards are now observable. The cooldown period on ouija boards is now per-person - so you can still use them when there's a bunch of other ghosts.
(t)tue apr 28 15
(u)Wire
(*)Chat output now has an options dropdown menu that contains the text zoom buttons as well as a new "Save Chat Log" button.
(*)The chat log thing opens an IE window containing the css and html of everything in your current chat output. You then have to copy and paste this to save it. No it's not ideal, but it's the best I can do for now.
(u)Keelin
(*)The chapel now has 3 ouija boards to allow the crew to speak to spirits. Kinda. Sorta. Uhhh excuse me.
(t)sat apr 25 15
(u)Conor12
(*)Added a new vehicle to the warehouse. Feel free to tell me what you think of it.
(t)thu apr 23 15
(u)Wire
(*)Blob players now get an alert if any of their nuclei are under attack.
(t)wed apr 22 15
(u)Wire
(*)Added options in the chat window for changing your font size. Increased default font size from 12px to 13px;
(*)Changing the size should save it automatically. Let me know if it doesn't.
(*)Re-added a form of the 'Connection closed.' message back. It isn't perfect and will occur during heavy lag. Further work will be done on it.
(*)Fixed a caching issue momentarily preventing new functionality (and in some cases breaking existing functionality).
(*)Improved 'click tolerance' with regards to the chat window stealing focus. Should help with cases of clicking on the chat window and not being able to input byond commands.
(t)tue apr 21 15
(u)Wire
(*)<b>MAJOR UPDATE</b>
(*)The chat area of your interface has been changed to what is known in shitty byond coding circles as a browser output window.
(*)Initially you won't see much of a change at all, but it allows us to do a lot more things with output in general. I have also tried my best to keep the functionality as identical as possible to the old output.
(*)However! This involved changing code in roughly 800+ files so there is bound to be something fucked up that I missed! Please report it here: <a href=\"http://forum.ss13.co/viewtopic.php?f=7&t=5022\">http://forum.ss13.co/viewtopic.php?f=7&t=5022</a>
(t)mon apr 20 15
(u)Convair
(*)Made a number of backend changes regarding kinetic firearms and ammo handling. Better user feedback, fewer bugs. What this means for you:
(*)Automatic updates (descriptions and icons where applicable) for all ammo boxes. Guns can be examined to check the current ammo type, and also be unloaded at will. The .357 Mag revolver can chamber .38 Spc rounds like in RL.
(*)Spent casings are now a thing. Some guns eject them automatically (shotguns, .22 pistol), others on reload (revolvers, zip gun). And yes, the forensic profile of the gun is taken into account.
(u)Marquesas
(*)Happy 420!
(*)Slightly reorganized how spells are attached to the wizard. This might result in some unexpected behaviour. As usual, you know where to find me.
(t)sun apr 19 15
(u)Convair
(*)Fixed the bullet schematics of the general manufacturer, which were set up improperly for like 6 months. Zip gun users rejoice.
(t)sat apr 18 15
(u)Convair
(*)The bomb VR shouldn't be broken anymore. If the bomb doesn't trigger after ~10 seconds, chances are it's a dud.
(u)Haine
(*)Half of the rewrite of crates/closets is now done - all closets and lockers are now using the new system.  Please let me know if you see weirdness going on with them or if something's broken.
(*)Health monitor implants (the ones from the cloner and medbay/robotics manufacturers) will now alert medical staff when the person implanted drops into crit or dies.
(*)DNA scramblers now make people look kinda sorta a bit more normal and are likely more useful as a result.
(t)thu apr 16 15
(u)Daeren
(*)Wraiths are now hopefully less ridiculously unstoppable in experienced hands due to a slight nerf of Absorb Corpse's scaling.
(*)Additionally, the chaplain has enrolled in a mail-order ghostbuster training program, and can resist many (but not all) of a wraith's powers. Clever wraiths still have several options to fight back.
(*)Bibles now hurt wraiths and revenants.
(*)This update totally didn't disappear for most of a day due to a drive-by imcodering
(t)tue apr 14 15
(u)Daeren
(*)Chaplains are now actually immune to (most) vampire shenanigans a la immunity to (most) wizard shenanigans. There may be Surprises for vampires who try anyway.
(*)This update brought to you by me trying to make the chaplain anything but a permanently enrolled gimmick job, so more changes are in the works.
(t)mon apr 13 15
(u)Daeren
(*)Blobs and wraiths now have their own preference buttons that work in theory.
(*)Alert us if this screws up the selection process or objectives somehow so I can immediately blame Mport.
(t)sun apr 12 15
(u)Wire
(*)Blobs can now talk to each other via a special 'channel'
(*)They can also now hear people within range of the blob overmind
(*)(aaand fixed the bug that allowed everyone to hear the blobchat)
(t)sat apr 11 15
(u)SpyGuy
(*)Bringing some of the limb stuff up to the new standard (mostly robolimb stuff).
(*)Getting augmented should now be a lot more attractive.
(*)Changed ~something~ about item pies and the fryer.
(t)fri apr 10 15
(u)Convair
(*)We're still tweaking vampires, don't panic. Rejuvenate fully replenishes stamina, for instance.
(*)There's been some backend changes regarding eye and ear protection checks. All in all, things should be fairly consistent across the board now.
(*)Can't flash somebody who's blindfolded, a deaf person isn't affected by sonic grenades, sunglasses and welding masks do the same etc. You get the idea.
(t)wed apr 08 15
(u)Haine
(*)Finally made vampires drain actual blood from people rather than just doing 10 points of damage and then saying "welp they have no more blood" when they hit 200 total brute
(*)This will probably change the balance of vampires a bit, I guess.  eh.
(t)tue apr 07 15
(u)Convair
(*)AP ammo for the .38 revolver now comes in a box of three. 1 speedloader for 2 TC was poor value compared to other traitor items.
(*)Added one of those fancy self-charging power cells to the surplus crate pool.
(t)mon apr 06 15
(u)Keelin
(*)You can now switch out the energy cells used by guns. The recipe for this is on the workbench.
(t)sun apr 05 15
(u)Convair
(*)Gibs can now be analyzed for forensic evidence.
(t)wed apr 01 15
(u)SpyGuy
(*)Strawberry the clown thought she'd help the heads by washing their fancy hats. Unfortunately she used too hot water and they shrank! Oh no!
(*)*laugh track*
(u)Marquesas
(*)Disabled motives temporarily as they underwent some fine-tuning.
(*)All-in-all you should be experiencing a richer RP experience from the revised rates of affection.
(t)tue mar 31 15
(u)Marquesas
(*)In an effort to give more utility to some unique jobs, we are introducing a motive system. Keeping your motives high is rewarding on your long run!
(*)Remember, this is a system in beta testing. You know where to find a coder if you find any weird issues.
(t)thu mar 26 15
(u)Wire
(*)Fixed the light given from being on fire from sticking around after the fire is gone.
(*)Those with good memories will know that this is my third attempt at fixing this. :hngh:
(u)Haine
(*)The default-to-WASD thing is back again since it now actually works!  Check your preferences.
(t)wed mar 25 15
(u)Haine
(*)You can put your ID in your PDA now.  Some shit probably be broken from this, yell at me if so.
(t)sun mar 22 15
(u)SpyGuy
(*)Yet another batch of chemistry backend tweaks.
(*)Let me know if I broke everything.
(t)thu mar 19 15
(u)Convair
(*)Somewhat extensive update of forensics:
(*)Every pair of gloves has an unique ID, so detecting "insulative fibers" on a door isn't as useless anymore.
(*)Gunshot residue has been added for kinetic firearms. If you found those on a greyshirt, chances are they were up to something.
(*)Reminder: forensic profiles for guns and projectiles were already a thing.
(*)The fingerprint system should be more robust in general now. Melee attacks, pulling, accessing somebody's inventory etc. all leave prints on the victim.
(*)Forensic scanners have also been updated. Detectives will be pleased to learn that the non-PDA version (new sprite courtesy of Gannets) can search the security records on the go.
(*)How to get rid of implicating evidence? Take a shower or wash the item in question with space cleaner (a sink does the trick as well).
(*)Other misc changes: added user feedback for silenced guns (.22 pistol, crossbow), stungloves are charged by using a power cell on them.
(t)mon mar 16 15
(u)SpyGuy
(*)Throw a thing at disposal outlets. (please note that jerks count as things for the purposes of this exercise)
(t)sun mar 15 15
(u)Haine
(*)Okay the auto wasd thing is going away again for now because it's creating hella runtimes.
(*)IT WORKED IN TESTING YESTERDAY OKAY
(*)IT JUST DOESN'T WORK IN TESTING TODAY
(t)sat mar 14 15
(u)Haine
(*)Check your preferences window: you now have the option to have WASD mode turn itself on by default when you open the game.
(*)It should work.
(*)Maybe.
(*)It worked in testing.
(t)mon mar 09 15
(u)Marquesas
(*)In case you're wondering, it's 12:01 AM so it's the 9th in the <i>significant</i> places of the world.
(*)<b>Update ft. Pacra:</b> Total telecrystal cost reorganization.
(*)Further extending the module research stuff in Robotics. Phasing out powerful modules in favour of future research and assembly.
(t)sun mar 08 15
(u)SpyGuy
(*)New traitor item for roboticists.
(*)The low-effort crimers win. Radium is nerfed. Your prize is radium getting nerfed. I hope you like it.
(u)Convair
(*)Rathen's Secret: reduced the probability of limb loss, added a brief stun to compensate.
(t)tue mar 03 15
(u)Haine
(*)Mousetrap + borg arm + pie. Have fun.
(*)Blood packs are now reagent containers, like beakers or syringes. There are also now IV stands you can hang them on, which can attach to beds or chairs by click-dragging them.
(t)mon mar 02 15
(u)Haine
(*)Click on a die with another die to bunch them together, or click-drag a die onto another die to gather any die around you into a bunch.  There can be up to 20 dice in a handful of them.
(t)sat feb 28 15
(u)SpyGuy
(*)Due to high demand the prices of boogiebots have gone up in the region.
(*)Chemistry reactions instant again. Some other chem related tweaks.
(u)Haine
(*)Some emote changes, mostly backend stuff.
(*)<b>THE ALT EMOTE FOR BIRDWELL IS NO LONGER *flex</b>.  It's now *burp.  This may or may not have anything to do with the hotkey for *burp being CTRL+B.
(*)New hotkeys for pointing: CTRL+P to toggle point mode on or off, P in WASD mode.  Hold down B in WASD to quickly point.
(*)If you manage to open a crate/locker inside of something else (say, a pod), it'll now throw all its contents out on the ground, rather than implanting them into the pod's very being, never to be seen again.
(t)thu feb 26 15
(u)SpyGuy
(*)Expendable borg upgrades will no longer break upgrade slots. Safe to use now.
(t)wed feb 25 15
(u)Haine feat. Convair
(*)Vendor Borg Memorial Update.
(t)sun feb 22 15
(u)Hull
(*)Changed how the blob random event works.
(u)Haine
(*)Changes to surgery: a greater base chance to fuck up a cut, anesthesia/analgetics will reduce this, as well as the over-all damage the patient takes during surgery.  If you fuck up, you gotta redo the cut.  You need to be way more drunk to do self-surgery now.  Glasses no longer get in the way of surgeries that target the head.
(*)Body bags.
(t)sat feb 21 15
(u)Wire
(*)Added the "Reconnect" command to the menu under File
(u)Hull
(*)Changing light bulbs and tubes is easier, just smack a fixture with a bulb or tube in your hand and you'll swap them, including broken ones.
(t)fri feb 20 15
(u)SpyGuy
(*)Changed AI camera behaviour so that cameras match NORTH-SOUTH connections.
(*)What this means in practice is that if you head south from one camera, then north it will lead you back to where you started (in most cases).
(*)There will still be cases where this does not work 100%
(t)thu feb 19 15
(u)SpyGuy
(*)AI Camera backend optimizations. AI play should be a lot smoother now.
(*)Cut cameras will no longer be a confusing jump. They will show static.
(*)Tweaked the camera pathfinding, it should behave a lot more like you would expect now.
(*)If you find bugs please report them.
(u)Haine
(*)Moving rollerbeds. Also moving office chairs (unscrew them from the floor). Also you can tuck sheets into beds and then they move with the bed.
(*)Bugtesting this code last night is the reason I'm exhausted today so you BETTER ENJOY IT (it's still probably buggy and weird)
(t)wed feb 18 15
(u)Haine
(*)Security jobs now start with two new verbs: "Say Miranda Rights" and "Set Miranda Rights".  There's also an emote for those with the verbs, *miranda.
(t)tue feb 17 15
(u)SpyGuy
(*)Telekinesis works by click-dragging items from one tile to another now, sending them flying.
(t)wed feb 11 15
(u)SpyGuy
(*)You can now create announcements using the computer in the communications room.
(*)Here's to the faint hope that it will not get ran into the ground.
(u)Haine
(*)Finally added in some stuff that I've had the sprites for for a while (bucket helmets, skull chalices, surgical shields, wrestling masks, bald caps)
(*)Thanks to SLthePyro, Gannets and Hempuli for the sprites!
(*)Some other stuff.
(t)tue feb 03 15
(u)Haine
(*)CTRL+X now does a thing for borgs.
(*)And AIs and AI shells too, whoops.
(t)sun feb 01 15
(u)Marquesas
(*)Increased damage to blob done by sarin, cyanide, fluorosulfuric acid, polonium and radium.
(*)Poison now does double damage. In addition to its initial damage, it does the same amount of damage over time as well.
(*)Poison damage now propagates. If a blob tile dies, the remaining poison DoT is split evenly between all surrounding blob tiles.
(*)QUITE POSSIBLY fixed the ripping out of your body brain bug. Hopefully. IDK. I think I did.
(*)This might cause some oddities or deviations from old behaviour. Please note these on the bug reports forums.
(t)fri jan 30 15
(u)Marquesas
(*)Blobs are now vulnerable to quite a few poisons. You'll want to spray these, preferably without friendly fire!
(*)Further fiddled with the way fires work.
(u)SpyGuy
(*)Something we've missed for a long time is finally brought back.
(*)It's the O2 indicator.
(t)tue jan 27 15
(u)Haine
(*)Clowns now have a new traitor item available.  Happy pranking!
(*)New under your Commands tab: Stop the Music!  Does what it says: if one of us admin jerks has played something, this'll make it stop.
(t)sat jan 24 15
(u)Marquesas
(*)By cutting someone to Bald in barber shop, you can now retain their hair as a wig. Wow!
(*)The singularity generator should do stuff now.
(t)fri jan 23 15
(u)SpyGuy
(*)Turns out the cloner was running slow because all your healthy organs were MOOCHING on that sweet, sweet healing provided by the machine.
(*)This will probably also boost a lot of healing stuff.
(t)thu jan 22 15
(u)Marquesas
(*)This update is not an essay.
(*)Blobs should have a new tool for fighting fire. MAYBE SOMETIME SOON WE MIGHT REACH AN EQUILIBRUM.
(t)wed jan 21 15
(u)Daeren
(*)After the barrage of genetics nerfs it's time to tweak one that was probably too punishing in retrospect.
(*)This wasn't in the changelog before now (I think) but the feature is this: Powers give you genetic instability. The lower it is, the more Terrible Things happen to you.
(*)The change: BAD mutations now give you MORE stability, and low stability doesn't make you mutate like you gargled with the Ooze from Teenage Mutant Ninja Turtles.
(*)Yes, this means that if you want to activate a bunch of superpowers at once, you will either deal with the Bad Shit that happens with low stability or you need to layer Bad Shit on yourself with bad mutations. IMO this is way more entertaining than just having an arbitrary "fuck you" limit.
(*)The actual stability increases and decreases for certain genes have been tweaked a bit, and may require further balancing after "playtesting" (watching people run shit into the ground), so please give your input on the forums/to admins/whatever if you've got a bone to pick about the new system.
(t)sun jan 18 15
(u)Daeren
(*)You may notice that medbay has been remodeled. We noticed that genetics wasn't really using half of its floor space so they don't get to have it anymore.
(*)We also noticed that genetics would ignore corpses in favor of fetching more monkeys from the monkey pen, so now their access to it goes through the surgical bay so the antisocial fuckers are forced to at least acknowledge the rest of the station.
(*)We took away the Port-A-Genes too while we were at it because wow, THAT experiment backfired!
(*)Nearly forgot, we put safety inhibitors in the enzymatic reclaimer so you can't just stuff living people that have mildly annoyed you inside without emagging it first.
(*)As part of the remodeling to encourage geneticists to do their goddamned jobs, surgery and cryo share their space now to give a more natural flow to treating the critically injured.
(*)This update was brought to you by Roboticists.
(t)thu jan 15 15
(u)Marquesas
(*)Here's a list of things I committed the past few days, because I forgot to update this I guess?
(*)Pod artillery platform now works with 40mm HE grenades. That means you have to resupply. Insert the ammo while the panel is open.
(*)You only have yourself to blame for this change if this bothers you.
(*)Ingesting phlogiston and chlorine trifluoride now should be a much worse idea. Why was this literally harmless in the first place?
(*)Smoke size now scales with the amount of reagents it is composed of. You'll find that your 1-unit smokes are now barely a puff of dust.
(*)Finally, but most importantly: Blob has been released. I'm still working on the balance but it shouldn't be <b>far too biased</b> in favour of one side.
(t)wed jan 14 15
(u)Haine
(*)Okay 3,267 parrots is a bit excessive.  Flaptonium now works like Life, lest we nearly crash a server with an excess of birds again.
(t)sat jan 10 15
(u)Marquesas
(*)RIP Cyborg phantom health.
(*)In theory this means everything should work in a sane way now.
(*)In practice this means I'll be still sifting through your bug reports in two weeks.
(t)fri jan 09 15
(u)SpyGuy
(*)The cyborg teleport upgrade suddenly remembered it needs a telecrystal to work. Oh dear.
(u)Haine
(*)The code for hearts and heart surgery has changed a bit - you shouldn't notice any changes, but if you do, let me know.
(*)Cards can now be tapped and untapped, see the playing card tips & tricks page in the card vendor for more info.
(*)Shuffling a tarot deck will reverse some of the cards now.  Spooky.
(t)wed jan 07 15
(u)SpyGuy
(*)No more mystery reagents in pills.
(*)Fuck you, horrendously obscure bastard bug. I win.
(t)tue jan 06 15
(u)SpyGuy
(*)Updated the materials counter on the genetics modifier to show the current generation rate.
(*)The cloning pod now comes with the ability to disable the granting of this bonus for a slight increase in cloning speed.
(*)In theory this should mean that geneticists should be interested in ensuring they're the ones operating the cloner.
(t)mon jan 05 15
(u)SpyGuy
(*)Genetics now gets a bonus to material generation and equipment cooldown speeds when the cloner is running nominally.
(t)sun jan 04 15
(u)Daeren
(*)im coder
(*)My first order of business: screwing with Poltergeist PDA messages because obviously that's critically important.
(*)Oh yeah, the medal code had a few weird bits that I smoothed out. Four medals are now actually obtainable!
(*)Three of them are crew objectives that now get handed out, the fourth involves poor decisions involving mulebots, alcohol, and innocent bystanders.
(u)SpyGuy
(*)Due to recent scientific breakthroughs the MD has ordered a new kind of dart for their rifle.
(t)sat jan 03 15
(u)SpyGuy
(*)Rebiggified foam. Also made chem machinery update itself properly during extended reactions.
(*)Back to raising hell now, chemists.
(*)An assistant, a chaplain and a clown walked into a bar... they found a dodgy item.
(t)fri jan 02 15
(u)Keelin
(*)Added a new actions system. This will eventually replace all those "wait X seconds with no visible indicator" actions with ones that provide more feedback and options.
(*)Handcuff removal has been ported to this new system. More to follow.
(u)Marquesas
(*)Security has a new toy. All hail the big brother.
(t)wed dec 31 14
(u)Tobba
(*)Chemical reactions are no longer instantaneous (except for reactions such as smoke).
(*)You can affect the reaction speed through heating or cooling.
(*)Pyrosium and cryostylane need to be mixed with oxygen to do anything.
(t)mon dec 29 14
(u)volundr
(*)Added stationary chemicompiler to chemlab. Try not to blow yourselves up.
(t)sat dec 27 14
(u)Haine
(*)Added some cancel buttons to stuff in the chem machines; making pills/patches, the borg chem menu, etc.
(t)wed dec 24 14
(u)SpyGuy
(*)Jenny Antonsson hits the pen with the large beaker!
(*)Fuck that shit. Merry Christmas.
(u)Haine
(*)You now have to wear a labcoat in order to claim the Alchemist Robes or the two department labcoats.  Merry Christmas!!
(t)tue dec 23 14
(u)SpyGuy
(*)Fixed a bug with secure safes causing mechanics to infinitely duplicate their loot.
(*)To make up for this the Captain and Detective now get their own secure safes.
(*)How does this compensate the mechanics? Not at all. RIP your free gold, nerds.
(u)Marquesas
(*)Something is very tasty now. Sure hope it doesn't break on the way down, cause that would be a disaster. Oh, the humanity.
(t)sun dec 21 14
(u)Marquesas
(*)Here's your pod verbs back proper. Enjoy I guess.
(*)Due to popular request, the secondary system and wormhole hotkeys were removed, and the fire hotkey is now Space.
(*)Wormhole HUD button is coming up. Later.
(*)I'm pretty sure I did something else too but I can't remember for the life of me so that's all.
(t)sat dec 20 14
(u)SpyGuy
(*)Genetics backend optimizations. You may not notice a difference. You may notice it's smoother than before.
(*)It also may introduce bugs. It's been tested extensively, but I hope you'll help me hunt down any stragglers.
(u)Haine
(*)Bees can now wear hats.
(t)fri dec 19 14
(u)SpyGuy
(*)MERRY SPACEMAS!
(*)Krampus returns. Better than ever. Make sure to BE NICE!
(*)Miniputts get their phasers back.
(t)tue dec 16 14
(u)I Said No
(*)Facial Hair slot and Detail slot have been changed to Detail 1 and Detail 2 respectivley, as the Beard and Detail lists have been merged. Now the ladies among you have more customization options. Or for the men among you, you can finally realize your dream of having two beards.
(t)sun dec 14 14
(u)I Said No
(*)Cosmetic choice backend has been reworked. This may affect your current hair, facial hair and detail preferences; just set them back up and save to avoid any further fuss.
(t)sat dec 13 14
(u)Tobba
(*)Fixed a bug in the beaker application code, applying directly from the reserve tanks may be a lot less effective.
(u)I Said No
(*)You may notice a little tab in the bottom left corner - this can be used to switch between hotbars at the top of the screen.
(*)Genetics powers are now buttons that appear at the top of the screen. In addition, some of them have been changed so you can click the button and then your target, similar to Wizard spells.
(*)Late changelog entry: Genetics has been messed with. There's a bunch of new powers, and the rarity ratios have been re-adjusted.
(*)There is now a tier 3 research item that allows you to store mutations in the genetics scanner, whereupon they can be inserted back into a different subject, have injectors made of them, or be combined with other mutations to create new ones.
(*)An example recipe for you: combining the Immolate and Glowy mutations gets you Fire Resistance.
(*)You can also view a list of mutations you've researched and make injectors of them.
(t)fri dec 12 14
(u)Haine
(*)Get ready for the best news ever: you can now build and deconstruct operating computers!!!!!!!  WOAH!!!!
(*)Please try to not be too excited
(*)Health analyzers won't detect implants now - only bullets and shrapnel and other stuff you should actually be cutting out.(t)thu dec 11 14
(u)Marquesas
(*)Hello. I completely reorganized projectiles being shot. This might mean things are broken.
(*)If things do turn out to be broken, yell at me in an unaggravated, yet confident, but still relatively quiet manner.
(*)In other news, miniputts no longer start with a weapon, however, normal pod weapons now go into both miniputts and pods.
(*)The Strelka is an exception, it still has its shiny russian laser thing.
(*)Tasers are now a bit more dangerous to pods. Yes. Tasers.
(u)SpyGuy
(*)Changed ling.
(*)No longer immortal. Made of sterner stuff than humans, though.
(*)Horrorform quite strong now, but it costs DNA to maintain it.
(*)Horrorform no longer a picky eater. Will eat things wearing hats and masks now.
(u)Haine
(*)Some old friends finally return.
(*)Health implants are now makable in medical manufacturers.  You can track the health of the subject via MedTrak or the Medical Records program on PDAs.  Will have more neat features once I have more sleep in me.
(*)Beepsky no longer gets confused and can finally make his way to the southern end of the station again. You can't outrun a radio! Unless the next beacon is too far away. Then the radio'll just hang out in the pool instead.
(*)Some medal rewards are now claimable more than once, notably the NT-SO Commander Uniform, since you need specific things to get it anyway.
(*)Cloaking generator: no longer useless due to layer issues.
(*)Stamina icon on your HUD will now report details of your stamina if you click on any part of it, not just the stamina bar itself.
(*)The Robotics operating computer will no longer tie itself to an operating table on Mars.
(*)Implants weren't properly being cut out of people; the implant itself wasn't being relocated, so cutting one out from someone just sorta made an empty case and never actually removed the thing - except from the list of implants in the person, so then you could <b>never</b> get it out.
(t)wed dec 10 14
(u)Aphtonites
(*)Spacemas is almost here!
(*)Want to help us decorate the Spacemas tree? Check out http://forum.ss13.co/viewtopic.php?f=5&t=4128
(u)Haine
(*)Snowballs!
(t)mon dec 08 14
(u)volundr
(*)Rebuilt main loop controller. Enjoy (maybe) less lag.
(u)SpyGuy
(*)Punch a borg. May or may not be a bad idea.
(u)Marquesas
(*)New secondary systems in the colosseum: Force wall (tier 1), Mines (tier 1).
(*)Shield boosts now restore 25 shields instead of 10.
(*)Comms systems have been added to Colosseum Putts. Communicate with each other simply by talking.
(*)Fixed iron curtain being permanent.
(*)4 new drone types have been added for more variety.
(*)Unrelated: Fire hotspots just became far more dangerous.
(t)sun dec 07 14
(u)Marquesas
(*)The Pod Colosseum is now officially released for public beta testing.
(*)1-4 players, located north of the gauntlet (accessible via the CRITTER GAUNTLET chutes in the VR lobby)
(*)It also is a preview of the new pod controls which will soon be applied to all pods.
(*)FIGHT AWAY! BE THE BEST! KILL SOME FUCKING DRONES.
(t)wed dec 03 14
(u)Haine
(*)Both HeadSurgeon the box and HeadSurgeon the medibot count for the staff assistant objective.
(*)The Botanist objective to get rid of all cannabis stuff on the station level is now to get rid of it from just hydroponics.
(t)tue dec 02 14
(u)Haine
(*)Medibots updated to the new perspective.
(*)I messed with the organization and inheritance of a bunch of boxes.  If something's gone weird with them, lemme know.
(t)mon dec 01 14
(u)Marquesas
(*)Added the canned drama sound as requested.
(*)In the form of a dramatic bike horn. Sue me.
(*)It is scannable, and the chef holds the only one.
(*)It also has a secret use similar to that of the bike horn.
(u)Tobba
(*)Observers can now see their targets HUD.
(t)sun nov 30 14
(u)Tobba
(*)Touched up the character randomizer a bit, it's not perfect but you wont like complete gibberish anymore.
(*)Ported the human HUD over to the new HUD backend, this required a lot of modifications to the equipping code.
(*)Please yell at me if you wind up equipping a PDA on your head or something.
(u)Haine
(*)Patches now can repair bleeding as well.
(u)SpyGuy
(*)Some QM bugfixes. Like the belts heading into the warehouse. They go the right way now. Hooray!
(*)View shopping cart straight from the trader order screen!
(*)NPC trader interface optimizations and improvements.
(t)sat nov 29 14
(u)SpyGuy
(*)More chem optimizations. The dispenser should feel a lot smoother to use now.
(*)I have also been optimizing the QM console. It should be a lot nicer to use now.
(*)Let me know if anything seems broken.
(u)Haine
(*)Staples will no longer drain all your blood like some kind of horrific tiny metal vampire living in your body.
(*)OKAY NOW THEY REALLY DON'T DO THAT I'M DUMB SORRY GUYS <3
(*)Fixed broken bottles so when you stab someone with them, it doesn't make, uh, YOU bleed and take damage.  Whoops!!
(*)The butcher's knife now does more brute damage (any at all vs none) because whoops when I was converting things to the bleeding system I accidentally forgot to return the brute damage stuff to it.  Whoops!!
(t)fri nov 28 14
(u)Dr. Cogwerks
(*)Added a bunch of supply carts.
(*)They're just resprited crates but they look distinctive!
(t)thu nov 27 14
(u)Haine
(*)BLOOD SYSTEM NOW ON BY DEFAULT!  Please go to the forums to give me yours thoughts on it.
(*)Centralized AI laws so they're no longer owned by the AI core itself.
(*)What This Means 4 U: You can upload laws regardless of whether or not there's an AI core, and now all present AI cores will have the same set of laws, if there's somehow more than one.
(t)thu nov 27 14
(u)SpyGuy
(*)The telesci perm portal now takes quite a fair bit of power to keep going.
(*)Engineering no longer irrelevant as a result.
(t)tue nov 25 14
(u)Dr. Cogwerks
(*)Rearranged the mining office
(*)Mining magnet gets a barcode printer and launcher
(*)Barcode printer in warehouse smelter
(u)SpyGuy
(*)The highly experimental technology employed by some is now even higher and... experimentaler?
(u)Haine
(*)Non-PDA reagent scanners.
(t)mon nov 24 14
(u)SpyGuy
(*)I did a chemistry backend rewrite and may have broken everything. Let me know if I broke everything.
(*)Turns out I've been killing traitors while I was sleeping. Oops. I'm fix.
(u)I Said No
(*)A new thing for genetics - the Port-A-Gene. It's the genetics computer and scanner rolled into one object. Hopefully the Geneticists will get out a bit more with this. There's still a regular console in there if you want to use that though.
(u)Haine
(*)Clowns can now make balloon animals.  Use a balloon in-hand (only clowns need apply.)  Thanks to monty for the sprites.
(t)sun nov 23 14
(u)Marquesas
(*)The entrance to the Critter Gauntlet is in the VR lobby. It's four disposal units, leading to the same place.
(*)Your high scores are now logged to goonhub and should soon be viewable.
(u)Haine
(*)I'm starting to port things to the new blood/bleeding system.  It's <b>not enabled</b> by default yet, but if you see something related to blood acting weirdly, let me know.
(t)sat nov 22 14
(u)SpyGuy
(*)New toy for chemists.
(*)New item for treasonous clowns.
(u)Haine
(*)I fussed with all of the surgery code, you shouldn't notice much of a change, but if something broke, lemme know.
(*)Relatedly, you'll no longer start heart surgery on someone while just trying to remove an implant from them.
(*)Butts can be put back on now.
(*)I.Sett and Apo123 added to mentors.  The way we set this has changed a little, so please let me know if you guys see this but don't have mentor status, alright?
(t)fri nov 21 14
(u)Haine
(*)Shuffled the order of the Port-A-NanoMed's inventory a bit and fixed that awful bug where it'd appear above the things on the floor below it for a frame.
(*)Atropine Auto-Injectors now dropped to 5u.
(u)Marquesas
(*)The Critter Gauntlet is now available in VR.
(*)No high score recording _yet_.
(t)wed nov 19 14
(u)Hull
(*)The Emergency shuttle console has been coaxed out of hiding from the shuttle wall and should be visible again.
(u)Tobba
(*)Changed the timings on doors so they you can pass through them a whole lot faster.
(t)tue nov 18 14
(u)SpyGuy
(*)Ghost inside containers! #wow #whoa
(*)Cyborgs now see their upgrades in the HUD as they should.
(u)Haine
(*)Fussed with the contents of the Port-A-NanoMed to make it more on-the-spot, emergency medicine kinda stuff.  Tell me what you think of the change.
(t)mon nov 17 14
(u)Hull
(*)Camera viewers and computers should work again.
(u)Haine
(*)Epinephrine syringes in medkits are now emergency auto-injectors.
(*)Cut paper and then add some cable to make a mask.  Color it in with a pen.  Thanks to Gannets for the sprites.
(t)wed nov 12 14
(u)SpyGuy
(*)Key a pod.
(u)Haine
(*)Cable on bedsheet to make a cape.  Thanks to Gannets for the sprites.
(t)mon nov 10 14
(u)SpyGuy
(*)A new reagent: Nitrogen Triiodide
(*)The worrying amalgamation of black powder and chlorine azide.
(t)sat nov 08 14
(u)SpyGuy
(*)You can now use AI modules in-hand to modify them, instead of dropping and picking them back up etc.
(t)fri nov 07 14
(u)Marquesas
(*)You have the right to bear arms.
(*)Quite literally.
(t)thu nov 06 14
(u)Haine
(*)Cyborgs now have a command to lock or unlock their interfaces.
(*)Emagged cyborgs will now show up in the end-of-round info.
(u)I Said No
(*)The work time of looms has been sped up drastically. You can also now load shoes into them to get leather.
(t)wed nov 05 14
(u)Haine
(*)Clown cars now come with a clown costume. This should make them more useful when they show up in surplus crates.
(u)SpyGuy
(*)Houka, Xavieri, Dylanhall34 and ClassyD are now mentors.
(t)mon nov 03 14
(u)Dr. Cogwerks
(*)Added some randomly-available gimmick jobs. Try to play them up interestingly if you get them.
(*)Added a whistle item. HALT!
(t)sun nov 02 14
(u)Tobba
(*)One ingot/block of material counts as 10 within manufacturers now, should bring the balance back to what it was before.
(u)SpyGuy
(*)The emag rewrite is now complete, tested and functional. Probably.
(*)The first steps of an emag backend rewrite. You won't and shouldn't notice anything new.
(*)If you do, please gimme a shout and a van will pick you up shortly.
(u)Marquesas
(*)Dear god I haven't touched this in weeks. WEEKS.
(*)Right, so, some of you may have noticed that #1 is running construction continuously now.
(*)Build your own station! PvE only!
(*)Power shouldn't arbitrarily fuck up anymore. If it does, it is likely to unfuck itself in 90 seconds. If it STILL doesn't work, we have a bigger problem and you should assault our code directly with a flamethrower.
(*)Wired power -- only available in construction. Machines must be powered by leading wire knots to under them. Light fixtures on the walls require a full wire which ends on the border with the wall.
(*)Fast cable laying. Use a cable coil in your active hand and run around. WOO.
(t)sat nov 01 14
(u)Haine
(*)Fixed it so hitting a paramedic suit with an armor vest makes an armored paramedic suit and not a regular armored biosuit.
(u)SpyGuy
(*)Redid some backend stuff. If you suddenly can't steal shoes / IDs / clothes / whatever yell at me
(*)Turns out forcibly ripping a stapled thing off of someone's face hurts them. Go figure.
(*)Staple once. Staple twice. Empty the staple gun.
(u)Dr. Cogwerks
(*)Thermals no longer see through walls. This may be temporary, pending rework if possible.
(*)Kinda sucks for players to get spotted through walls by someone most of a screen away in the hallway.
(*)At least cameras can be snipped to prevent that!
(t)fri oct 31 14
(u)Tobba
(*)Rebalanced the reclaimer so that 10 sheets becomes one bar and 30 pieces of cable becomes one bar (and changed the recipe for manufacturing cables accordingly). No more infinite materials.
(*)You can now fuel furnaces with dead critters.
(u)SpyGuy
(*)Staple. Head. Help. Butt.
(t)thu oct 30 14
(u)Wire
(*)Adminhelp text is now bigger and more obvious.
(t)tue oct 28 14
(u)Hobnob
(*)Re-enable a separate overlay for head damage to humans.
(t)sun oct 26 14
(u)edad
(*)OOC has been re-disabled during rounds because it was a pretty pointless change.
(t)thu oct 23 14
(u)Haine
(*)You can now make miniputts.  Wow!  Woah!  Huge thanks to Hempuli for help with the sprites.
(*)They use the same armor and paintkits as large pods.
(*)Right now they spawn with weapons.  Coming soon: changing miniputt components??
(*)Note to self: actually add things to the manufacturers when adding a new feature that requires manufactured things.
(t)wed oct 22 14
(u)edad
(*)Added an option in Character Setup to toggle your default OOC visibility. It can also be toggled at any time during a round using the (Un)Mute OOC verb.
(u)Haine
(*)You can now make any backpack* into a satchel via medal rewards.  Everyone should have the option since it's from 'Fish'.
(*) * There are a couple special admin-spawn-only backpacks that I didn't bother making satchel versions of, so if you happen to get one of those, too bad!
(u)Hobnob
(*)Gave foods with intrinsic reagents some room for extra stuff to be injected.
(*)Changed behaviour of chem_extractor so reagents are extracted in proportion.
(t)tue oct 21 14
(u)edad
(*)Reenabled OOC during rounds. Rules about OOC conduct brought back from the dead, don't conflate IC in OOC and vice versa.
(*)Fixed an issue where OOC was always visible from mentors/admins.
(t)mon oct 20 14
(u)Haine
(*)Two new medal rewards.
(t)sun oct 19 14
(u)Dr. Cogwerks
(*)Detective revolver starts loaded with stunners
(*)Nobody ever cared about room-temperature nitrogen gas, so...
(*)Nitrogen canisters now default to a frosty 80 degrees Kelvin.
(*)This makes it significantly more dangerous but should give it some new uses.
(*)Might give nitrogen tanks a cold storage room like the meat locker later.
(*)Flipping inside closets and lockers can now damage them and eventually break them open.
(t)sat oct 18 14
(u)Haine
(*)One new medal reward.
(t)thu oct 16 14
(u)Dr. Cogwerks
(*)PDA Forensics Scan will now return the contraband level of illegal items.
(*)That's the same value that makes beepsky yell about infraction levels.
(*)PLAYER SUGGESTION: It would be rad if you folks could punish criminals based on these criteria:
(*)How dangerous is their contraband?
(*)How dangerous or destructive was their behavior?
(*)This would be a lot more interesting than the usual "he's got traitor gear, legit kill time! he has nothing, let him go" stuff.
(*)Changelingchat: I quietly changed health code a few weeks ago. Changelings will only die if their bodies are destroyed. Have fun.
(t)tue oct 15 14
(u)Keelin
(*)New revision of the modular manufacturers as workbenches.
(*)This is VERY much under construction. Expect more items and blueprints soon.
(*)This will allow us to make proper custom items and objects. This can (in part) be seen in the flash and flashlight you can make right now.
(t)tue oct 14 14
(u)Haine
(*)Silver sulfadiazine's recipe has been changed so that it no longer requires oil.
(*)The recipe is now: silver, sulfur, oxygen, chlorine and ammonia.
(t)sun oct 12 14
(u)Haine
(*)Write on walls and the floor and whatever with pens.
(t)thu oct 09 14
(u)Haine
(*)Rename vehicles by hitting them with a champagne bottle on harm intent
(t)wed oct 08 14
(u)Haine
(*)Clown is back.
(*)Any and all complaints regarding this change should be directed at Wonk.
(t)tue oct 07 14
(u)Haine
(*)One new medal reward.
(*)Reagent extractor storage tank size increased.
(t)mon oct 06 14
(u)Haine
(*)Fiddled with the detective's office a bit more - there's now an entrance into the jazz lounge as well.
(*)Interrogation room is back.
(t)sun oct 05 14
(u)Haine
(*)The detective's office has been moved to a more appropriate location.
(*)The brig now has a visitor's area.  Come say hello to all those dirty criminal scum!
(*)As always, hit up my feedback thread in Ideas & Suggestions to tell me what you think, and how to improve things.
(t)sat oct 04 14
(u)Haine
(*)You can now properly shake salt and pepper onto food with the shakers.  Wow!!
(t)fri oct 03 14
(u)Marquesas
(*)Added two new reagents.
(*)One of them is liquid electricity, which has 4 primary components. Think about stuff that could be used to produce power.
(*)The other one is an energy drink. This contains three components and should be mostly self-explanators.
(*)Pathology is coming along nicely. You may have noticed that in the past few weeks. More information coming soon.
(*)And by that I mean if you behave yourselves nicely you might get some toys to play with as soon as possible.
(u)Haine
(*)I didn't notice what the power was for the microbombs you could buy from PDAs and as a result macrobombs were only half the power they shoulda been WHOOPS!!  Fixed now.
(*)Two(!!) reward skins added for one medal.
(t)thu oct 02 14
(u)Haine
(*)Changed airtanks, canisters, and freezers to have an input prompt for what you wanna set them to.  Hit up my feedback thread to suggest other things that should work like this.
(*)Added little buttons to the Pharmacy desk, the MD's office and just inside medbay proper that open the front doors to medbay.  Wee.
(*)I've been replacing the old computer sprites with the new style, and I think I've finally gotten all of the ones that are currently in-use on the map.  Let me know if you find one that's still the old kind.
(u)I Said No
(*)Added an Automatic Mode for the Mining Magnet. It will activate the magnet when the cooldown has finished, if the mining area is clear of anything it couldn't normally transport.
(t)wed oct 01 14
(u)Hull
(*)Unicorn manufacturers should be working now
(*)Did something about flashers behind shrubs
(*)Skull + circular saw = skull mask
(t)mon sep 29 14
(u)volundr
(*)fixed chairflipping, flipping, throwing, and anything else that should not have left you sideways
(*)fixed some sources of extreme lag
(t)sun sep 28 14
(u)Haine
(*)Reworked Medbay's layout a bit.  Let me know how this works out.
(*)Port-A-Medbay is now a Port-A-NanoMed.
(*)New kind of medkit, get all excited!!  WOO NEW MEDKIT!!!
(*)Other misc bits and bobs.  Nothing super exciting (other than the medkit, YESS NEW MEDKIT TYPE YES SO AWESOME)
(*)Thanks to YJHGHTFH and Convair880 for some replacement sprites.
(t)sat sep 27 14
(u)volundr
(*)added some nifty lag-prevention stuff for sounds. sounds may be horribly broken as a result. please report any new sound issues.
(t)fri sep 26 14
(u)volundr
(*)i "fixed" a lot of "lag", but i may or may not have "broken" "everything" "horribly". Please report any new problems on the forums or something.
(t)thu sep 25 14
(u)Haine
(*)Health analyzers can no longer scan reagents on default.  Instead, there's now an upgrade for them that enables that function.
(*)Synth limbs and organs are now much more plant-y than before.  Thanks to AffableGiraffe and YJHGHTFH for the sprites.
(t)wed sep 24 14
(u)volundr
(*)added a new chemistry device maybe probably
(t)tue sep 23 14
(u)Marquesas
(*)A comprehensive documentation of pathology is available at http://wiki.ss13.co/Pathology_Research
(*)You should probably read it for the upcoming release.
(*)Electric shocks were refactored a bit. Let me know if anything doesn't work or kills you far worse or far less than before.
(u)Haine
(*)A bunch of the new drink recipes were totally broken, but should now all be working.  Maybe?  Hopefully?
(*)Cyberhearts now available for creation at robotics fabricators.
(*)Cyberheart item sprite courtesy of AffableGiraffe, mob sprite courtesy of YJHGHTFH.
(t)mon sep 22 14
(u)Haine
(*)I should be asleep but instead I gave the MD a secure locker.
(*)Oculine now a touch-based chem.
(*)<i>zzz</i>
(*)Big ol' cocktail update thanks to Daeren.  Go out and get drunk, friends.
(*)Health 100% indicator is now a cheerful green rather than grey.
(t)sun sep 21 14
(u)Haine
(*)I'm half asleep still cause I jut woke up and I've reached the required amount of convincing needed in order to remove the RD's medbay access
(*)rip
(*)Borgs are now affected by sonic and flash powder.
(*)also rip
(u)Hull
(*)Changeling regens will now remove implanted bullets upon completion.
(t)sat sep 20 14
(u)AngriestIBM
(*)Fixed light fixture assemblies requiring you to click a wall with your hand simultaneously empty and holding the parts.
(t)fri sep 19 14
(u)Haine
(*)Equip hotkey changed to V, toggle throw is back on X.
(t)thu sep 18 14
(u)Haine
(*)WASD users have a new hotkey: X for 'equip', which will equip the item in your active hand, if possible.
(*)Couple new cocktail doodads.
(*)Some pod paint jobs can now be bought from the regular guy for podstuff.  Bot.  Whatever.
(*)Keep it on the DL, you hear?  Don't ask where he got that stuff from.  You don't need to know.  You don't <i>wanna</i> know.  Aight?  Aight.
(t)wed sep 17 14
(u)AngriestIBM
(*)Beakers don't explode into gouts of death fire every time you look at them funny.
(*)I'm not sure what that was even meant to achieve.
(t)tue sep 16 14
(u)Haine
(*)Barmen will want to check out the new boxes in their booze stores: you now have the tools to fancy up drinks quite a bit more!
(u)AngriestIBM
(*)You can PDA message departments now.  Wow!! Whoa!!!
(t)sun sep 14 14
(u)Haine
(*)ChemMasters are now more masterful re: chems as they can now isolate and remove them.
(t)sat sep 13 14
(u)Haine
(*)You can now smash bottles on any table.  They also break faster.
(*)Uh, okay, NOW you can smash bottles on any table.
(*)Macrobombs for macrofun!
(*)Hairs.
(t)fri sep 12 14
(u)Haine
(*)Fancy beer!  Ask the barman to look in his booze closet for some of it!
(*)Harm intent with a bottle in your hand on the bar table.  Have fun!
(*)Fixed up some of the kinds of booze so their bottles can be smashed, too.  Unfortunately, this wiped the map of all of those items, and I had to re-add them.  Also unfortunately, I'm not sure I got them all where they were supposed to go.  If there's hobo wine or some other alcohol missing from some place it ought to be, let me know!
(t)thu sep 11 14
(u)Dr. Cogwerks
(*)Expanded the *dance emote with some animations. Context-sensitive dances are planned. Wizard dance skills have been improved. .
(u)Haine
(*)What do you mean, "filling a beaker with helium and then transferring that helium to a balloon makes no sense, why can't you just fill the balloon from the helium tank?"?  Shut up, jerk.  That's why not.
(*)I fixed that anyway, even though the very concept of sensible physics makes me angry.  Haine mad.  Haine smash.  Haine need sleep.
(*)Fuck there was some other thing that got cleared out of the changelog accidentally earlier today, what the fuck was it?  Oh, right, fliptonium animates nicer now.  Flip flip flip.
(*)Holy fuck I need more sleep.
(t)wed sep 10 14
(u)Haine
(*)Update to health analyzers: colors fiddled with more.  Standard, non-PDA scanners now scan for reagents in mobs as well.  This functionality can be toggled by clicking on the analyzer in your hand.
(*)A couple slight updates to specific traitor objectives.  You probably won't notice this change very much.
(*)Few more hairstyles.  Nothing huge.
(u)Keelin
(*)Infused mops work now
(*)Plates and all atmos objects use more of the materials system
(*)On-attack effects of infusions deplete by using them now - they will be buffed to compensate for that.
(*)Walls and turfs use the materials properly now and can be damaged by attacks (provided they are powerful enough).
(*)Many critters can be skinned for materials now. (Most sharp items will work for this. It even works on skeletons OKAY)
(*)Because people seem to miss this: There is definitely cotton in hydroponics. You can use that as cheap cloth material.
(t)tue sep 09 14
(u)Haine
(*)You can now make more AI shells.
(t)mon sep 08 14
(u)Haine
(*)Very important update: HoP and MD now have bedsheets.  I know you're all just giddy with joy about this.
(*)New chair sprites courtesy of ClockworkCupcake.  I totally meant to commit them, anyone who tells you otherwise is a dirty liar.
(*)Be a sneaky doctor.  Sneaky sneaky.  Make sure to clean your surgical tools.
(*)My brain has slowly melted out of my skull as I try to figure out just what code is.  I don't know anymore.  Letters and numbers or something.  Point is, misc fixes.  My head hurts.
(t)sun sep 07 14
(u)Haine
(*)New medal reward for AIs.
(*)Drag-drop transfer for beakers works like you'd expect now, instead of the opposite.
(*)*hatstomp or *stomphat for those with HoS headwear.
(t)sat sep 06 14
(u)Haine
(*)I swear to fucking god this better fix the drag-drop issues with hydroponics stuff
(*)(endless screaming)
(*)Skullbots now can be more special if you find a special skull to make them out of
(*)scalpel-saw-scalpel-saw-scalpel-saw
(t)fri sep 05 14
(u)Haine
(*)Okay I broke some stuff with my port of Razage's seed-hydro tray drag-drop code.  Should be fixed now.
(t)thu sep 04 14
(u)Haine and SARazage
(*)Click-drag beakers and other such things onto other other such things to transfer reagents.
(*)Fixed click-drag messages for planting seeds in hydro trays, so you actually get feedback if you're doing something wrong now.
(t)wed sep 03 14
(u)Marquesas
(*)Nothing happened in the diagonal movement department. Carry on.
(u)Haine
(*)Updates to balloons: if you can get some helium, you can blow 'em up now!
(*)beep bop, ai is rouge, haine is a good coder while drunk, bep boop
(u)Haine and YJHGHTFH
(*)Vending machine sprites in the new perspective.  All fifty gajillion of them.  An <b>immense</b> thank you to YJHGHTFH for all the work he put into them!
(t)mon sep 01 14
(u)Wire and YJHGHTFH
(*)Salt now makes piles when dumped out of a beaker. You can also connect piles of salt when dumping to an adjacent tile. I fully expect salt lines all over the place.
(*)Special credit to YJHGHTFH for the salt spriting work
(u)Haine
(*)Water balloons!
(*)Clown starts with a couple new things (one of the things is ballons)
(*)Huge thanks to YJHGHTFH for all his help with sprites lately!
(t)sun aug 31 14
(u)Marquesas
(*)Hello, mediborgs. You'll find that your patches no longer do anything other than their intended purpose.
(*)Added a hypospray anyway.
(-)
(u)Haine
(*)You can now drag & drop seeds into hydroponics trays to plant them.  Thanks to SARazage for the code snippet!
(-)
(t)sat aug 30 14
(u)Haine
(*)OR tables now scannable with device analyzers, I'm sure this is a good idea and nothing bad will happen to anyone because of this.
(-)
(t)fri aug 29 14
(u)Haine
(*)Updated the HoS and mentor lists.  Congrats guys!
(*)Reverted the animation change I made yesterday cause it caused Extreme Server Grump and the fix will take a bit to get working right.
(*)Tourists now start with fanny packs instead of backpacks.
(-)
(u)Infinite Monkeys
(*)You can now perform surgery on yourself while drunk.
(*)Some objects (like glass shards and botany saws) can be used to perform ghetto surgery.
(-)
(u)Marquesas
(*)Updated the new critter arm a bit.
(*)By popular demand, the canister bomb now has another noisy attachment.
(-)
(u)Hull
(*)Low pop servers will automatically initiate a shuttle call if a player dies after the round has been going for a while.
(*)The current settings are 20+ minutes and less than 5 or less living players after the death, feedback is encouraged if this is an issue though.
(*)Chaplains have finally admitted that corruption doesn't exist, and will stop trying to sense it.
(-)
(t)thu aug 28 14
(u)Haine
(*)Fixed it so synthlimbs can be stored in produce satchels.
(*)Revolutionary costume is now a set of two pieces of clothing, thank you to AffableGiraffe for the sprites!
(*)One of the new chems now works more like I wanted it to, animation-wise. Progress!
(-)
(u)Marquesas
(*)Ice creams no longer quadruple the input reagent.
(*)Most disease reagents now require a minimum of 5 units to infect someone. Relaxed this requirement on some less incurable diseases.
(*)Decomposing corpse sprites now work. Also added a new disease related to this.
(*)Added a recipe for the rotting reagent. It contains some weird disgusting things. Also some formerly living organisms.
(*)Added a new type of arm. It comes off a humanoid critter with the usual scalpel-saw-scalpel process.
(-)
(t)wed aug 27 14
(u)Wonk
(*)To help clarify, we have simplified what used to be the "creepiness" rule. Please check http://wiki.ss13.co/Rules#Absolutely_no_sexual_content_.28Added_27.2F08.29 for more information.
(-)
(u)Marquesas
(*)Bunch of sprite update fixes!
(*)Cloaking field generators are no longer bad and broken.
(-)
(u)Haine
(*)ALT+C for OOC in WASD.
(*)*raisehand is now Ctrl+H, and *flip is Ctrl+R for both WASD and arrow key modes.
(*)Added a 'Hotkeys' verb in the Commands tab that'll list all the various keys you can press to do things.
(*)Fixed a bug where removing a heart didn't cure people of cardiac arrest/cardiac failure WHOOPS MY BAD
(*)Toggling WASD mode on now brings focus away from the input bar.  No more trying to move only to end up with dddddddddsss in the input bar, yay!!!
(*)Mailman is now available as a daily job again on wednesdays.
(*)Traitor clowns can get clown cars through their PDAs once again.
(-)
(t)tue aug 26 14
(u)Haine
(*)Port-a-Med remote moved to the MD's office, Port-a-Sci remote moved to the RD's.
(*)Added a couple goofy new chems.
(-)
(u)I Said No
(*)You can now put sheets, rods and tiles into portable reclaimers.
(*)You can drag and drop ore or bars onto the floor to sort them into piles now.
(*)Sheet, rod and tile stacking should be fixed.
(-)
(t)mon aug 25 14
(u)Haine
(*)You can roll joints with money instead of paper now. Go ahead and literally smoke the budget or whatever.
(*)PDA health scanner program now fancified as well.
(*)Removed the blood monitor implant from manufacturers and stuff for now since it literally does nothing.
(*)Added a new emote hotkey, CTRL+Q for *wave
(*)Fixed a couple wiring errors: pathology and the starboard solars should both be working properly, power-wise, now.
(*)There's a new thingy in Research. Said thingy will go away very quickly if people are dumb with it. So don't be dumb!!
(-)
(u)Marquesas
(*)Burning stuff should actually turn into ash now.
(-)
(t)sun aug 24 14
(u)Marquesas
(*)Thermite breaching charges no longer arbitrarily fail to take down walls.
(*)Changeling mimic voice no longer reveals the dude through intercoms.
(-)
(u)I Said No
(*)Replaced Recycling Units with new Portable Reclaimers. They turn ore into bars as well as scrap and shards. You can drag them around too.
(*)Fabricator units only accept processed materials now. With the reclaimers it's not as bad as it sounds, trust me.
(*)The miners now have their own refinery out by the magnet area.
(*)Process some Miracle Matter and watch what you get. You'll like it guaranteed or you have no soul.
(*)Shoving a jumpsuit in an auto-loom yields some cotton. Cotton grown in Hydro can also be used in looms now too.
(-)
(u)Haine
(*)Fancified the health analyzer's results a bit.
(*)Removed the scimaster cart from the MD's office since they start with one now.
(*)Gave chemistry some large beakers so they can stop breaking into medbay and dumping out the reseerve tanks, okay you guys can stop that now you have all the large beakers you could ever want so STOP
(-)
(t)sat aug 23 14
(u)Spoogemonster
(*)Unfucked lights
(-)
(u)Haine
(*)The MD now starts with their own PDA and a scimaster cart IN said PDA
(*)Satchels now available in Personal Closets
(*)Couple costumes added
(*)Thanks to YJHGHTFH for the sprites!
(*)Heart surgery! Scalpel-saw-scalpel-saw on chest. Not having a heart is bad. More heart-related features to be added once I'm not half asleep.
(*)Hearts were temporarily inedible but that is fixed now too so please go and eat all the hearts you can stuff in your faces.
(*)Thanks to AffableGiraffe for the heart sprite!
(-)
(u)Marquesas
(*)Headspiders can finally be removed via surgery.
(*)Cutting out parasites can go horribly wrong, make sure only qualified personnel do it!
(*)Synthlimb and synthorgan plants are now in. Surplus organs are important.
(-)
(t)wed aug 20 14
(u)Wire
(*)Pixel bullets are now IN (basically bullets that can shoot in any direction).
(*)You can shoot wherever the fuck you want now.
(*)This was coded almost entirely by Marquesas (I helped port it in to gooncode). Seriously, give him a pat on the back for this (or a fart on the face, whichever).
(-)
(t)sat aug 16 14
(u)Tobba
(*)Modified the lighting system slightly, lets see how this turns out.
(*)Adjusted explosions, again. This should theoretically be a lot better.
(*)Adjusted artillery and AEX ammo.
(-)
(t)thu aug 14 14
(u)I Said No
(*)Reinforcing sheet metal has been changed. You just hit a sheet with rods now.
(-)
(t)tue aug 12 14
(u)Wire
(*)New attachment for canister bombs. Write something on some paper, stick it to your detonator, slap the detonator on a canister, whoa your note is like, *right there*.
(*)Truly we live in the modern age.
(*)(As per usual with any canister bomb related code change, Marquesas coded this and I ported it in)
(-)
(t)tue aug 05 14
(u)Wire
(*)Fixed the new mob burning lighting from eventually making you into a human sun.
(*)Cakehats emit light again w h o a.
(-)
(t)sun aug 03 14
(u)I Said No
(*)Removed the hands, feet, eyes, mouth and groin targeting zones. They are now considered part of the arms, legs, head and chest respectively.
(*)Smoother targeting UI icon, with text feedback.
(*)Butt removals have been changed slightly. You now target the torso and use harm intent.
(-)
(t)wed jul 30 14
(u)Wire
(*)Fixed vampire mist form for real this time. It was counting the vampire as viewing themselves (lol).
(*)You can longer use the new 'me' verb to use emotes from your corpse when dead, despite how hilarious that was.
(-)
(u)Keelin
(*)Powernet-networking component will now literally just dump every packet it sees onto the component side.
(-)
(u)AngriestIBM
(*)Um I guess I replaced sigcraft with SigPal, which is kinda like sigcraft but less bad.
(*)Like you can send the signals directly from it? That's a thing.
(*)The number of people who care can probably be counted on one hand.
(-)
(t)tue jul 29 14
(u)Keelin
(*)More undocumented components that were requested. What fun!
(-)
(t)sun jul 27 14
(u)Wire
(*)Added a 'me' verb for doing emotes. Syntax is just 'me (emote)'. No  silly asterix or whatever.
(*)People on fire now light up. There is a quirk with byond related to this if you can figure it out.
(*)Canister bomb explosions tweaked. Now it is much harder to get very large explosions (although the 'small' size explosion is still easy to get and still bigger than tank transfer bombs).
(*)'Attachments' concept implemented to detonators. They now add wires to the resulting bomb for each attachment that control their actions and confuse the defuser.
(*)Three new detonator attachments added to commemorate this new system. Can you find them all??
(*)Oh and vampire mist form should work properly now (and not count every mob in the entire game as in your view)
(-)
(t)sun jul 27 14
(u)Keelin
(*)A few new mechanics components that were requested on the forums. Ideas and sprites by BadClown.
(*)They don't have a manual entry yet. WELP.
(-)
(t)sat jul 26 14
(u)Wire
(*)Ghosts will hear nearby conversations in ATTENTION GRABBING BOLD (not caps, this was a trick, you fell for it).
(*)Also I fixed the Toggle Deadchat Range thing which was apparently broken??
(*)Wizards/Ghosts will no longer be able to teleport into the VR bomb testing area by selecting the "Research Sector".
(*)Also that whole "I crashed every server" thing earlier today never happened. You saw nothing. Carry on.
(-)
(t)sat jul 19 14
(u)Keelin
(*)More updates to the materials backend. Some more materials.
(*)Most of the work today went into material bullets. Yeah you can make LSD bullets or telecrystal bullets or WHATEVER.
(*)Currently only available as .22 cal! You gotta be smart about what you use to fire them.
(*)Don't be shit with this or it's gonna be removed faster than you can say "NO KEELIN DON'T".
(*)Material handcuffs now also apply effects from their materials. Quality and such influence how long it takes to get out of them.
(*)Additive effects have been revised. Go find out what that means. It's nuts, i promise you.
(-)
(t)fri jul 18 14
(u)Keelin
(*)Large-ish materials system update. Stay tuned for more details and more updates.
(-)
(t)thu jul 17 14
(u)Wire
(*)Canister bombs now have a configurable detonation timer. The minimum time has however been raised to 90 seconds.
(*)The timer is reliable and real-time (for those who remember the bad timers of yore).
(*)The detonator assembly will now update its sprite correctly when done in-hand.
(*)Added a bunch of flashy lights and noises to the detonation process.
(*)Also there is a new ~thing~ you can attach to detonators now. Have fun finding it.
(-)
(t)mon jul 14 14
(u)Dr. Cogwerks
(*)Moved the mining magnet further from the station a bit.
(*)This change would make space OSHA very unhappy
(-)
(t)sat jul 12 14
(u)Dr. Cogwerks
(*)Messed with taser bolt behaviors again. Player feedback would be useful.
(*)Reminder: armor and distance both reduce up-front stun effects
(*)Drugs reduce duration, but won't counter the confusion effect.
(-)
(t)fri jul 11 14
(u)Wire
(*)Canister bombs are now in. Have fun figuring out how to make them!
(*)Marquesas coded them by the way I just ported them in finally.
(*)Spruced up the canister bomb detonator display panel.
(-)
(u)Dr. Cogwerks
(*)rest in peace mining level
(*)World size has been changed from 200x200x5 to 300x300x3
(*)Telesci level (z2) now has room for probably six more lavamoon-sized things
(*)Station level has some asteroids and hidey-holes floating around near the edges now
(*)Mining station is more or less abandoned but shares shuttle-access with the Diner
(*)Solar panels on-station are now direct-wired instead of running through SMES cells
(*)Not sure yet if this is a good or a bad idea, welp
(-)
(t)thu jul 10 14
(u)Dr. Cogwerks
(*)Added a pair of paramedic suits to medbay.
(*)Their protective stats are kinda halfway between biosuits and firesuits
(-)
(t)tue jul 08 14
(u)Wire
(*)Added a Set-DNR verb (found under the commands tab). It's one-use only per round and it prevents you from being revived in any way.
(-)
(t)mon jul 07 14
(u)Hull
(*)Messed around with explosions to try and address concerns about them being very weak. Please report any weirdness related to explosions in the bug report forum or yell at me on IRC.
(-)
(t)sat jul 05 14
(u)I Said No
(*)New tool for miners: The Ore Scoop. Put a satchel in it and then walk over ore to collect it automatically. Click on a tile to eject all the ore out when it gets full.
(*)A conveyor belt for the magnet control room.
(*)Updated the graphics on asteroids a bit; now featuring new ore sprites by Clockwork Cupcake!
(*)Mining charges were nerfed a bit.
(*)Reduced the volume of digging sounds.
(*)Removed extractor rigs as there is no real need for them anymore.
(-)
(t)thu jul 03 14
(u)Hull
(*)Major random events will no longer occur on low population servers. This is set to below 15 players for the moment.
(*)No more TK over cameras bullshit.
(*)Canada Day is now over.
(-)
(t)mon jun 30 14
(u)I Said No
(*)Weakening rock now halves its hardness rather than decreasing it by 1.
(*)You now have a small chance to attract some odd stuff with the magnet. More to come.
(*)Added two new ores. Go find em!
(*)Changed the backend for how explosions, concussion blasts and mining pod equipment damages asteroids. Please report bugs.
(-)
(t)sun jun 29 14
(u)I Said No
(*)The Mining Magnet is now mostly complete. More content will be added to it soon enough.
(*)Miners now start in the Magnet Control Room, and the job cap has been reduced to 3. The mining outpost is still there if you want to go to it.
(-)
(t)fri jun 27 14
(u)Dr. Cogwerks
(*)Most critters now have a chance to random quality-derived names
(*)An awful wendigo or a fancy bee won't do anything different yet, but SOON
(*)Crew backpacks will now have some goofy personalized trinkets
(-)
(t)sat jun 21 14
(u)I Said No
(*)New asteroid shapes, more ore available in general in the mining field. Two new ores to dig up. Ore is now named differently depending on the quality..
(*)Got rid of the delay time when digging asteroids manually. Now it's a chance based thing, starting at 100% and decreasing the greater the difference between tool strength and rock hardness. (shut up)
(*)Hulks are now able to punch asteroids to destroy them. People with the Strong or Hulk genetic effects also get extra strength when digging with tools.
(-)
(t)thu jun 19 14
(u)Dr. Cogwerks
(*)Cleared a few default lanes through the random mining field.
(*)Smelter is a bit more rugged now.
(*)Mining has its own smelter now back near the furnaces, might redo the central fabrication area later to accomodate it.
(-)
(t)sun jun 15 14
(u)I Said No
(*)The asteroid field is now randomized.
(*)Major mining backend changes. Please report any bugs.
(-)(t)sat jun 14 14
(u)LLJK-Mosheninkov
(*)Fiddled with explosions some more. Now they shouldn't be super weak but also shouldn't have a stupidly wide radius.
(-)(t)mon jun 09 14
(u)Infinite Monkeys
(*)Vampire changes:
(*)Shapeshift removed.
(*)Blood gain halved.
(*)Mist form only works when nobody can see you.
(*)Chiropteran Screech confuses rather than stuns.
(*)Cooldown changes: Rejuvenate (20 to 30), Glare (30 to 60).
(*)Blood cost changes: Enthrall (300 to 200), Call Bats (75 to 100), Hypnotise (10 to 0).
(-)
(t)mon may 26 14
(u)Keelin
(*)Punching should now ACTUALLY trigger on-hit effects.
(*)Getting hit by thrown effects will now trigger on-hit effects.
(*)Radiation protection should now work properly.
(*)Being exposed to high temperatures will no longer trigger on-temperature procs several times.
(*)Support for on-entered trigger for materials. Think radioactive floor.
(*)Added some better feedback to the smelter and barrel.
(-)
(t)sun may 25 14
(u)Keelin
(*)A whole bunch more additive/flux effects for reagents in the smelter.
(*)You can make gloves using the fabricator now.
(*)Gloves now count as weapons in empty-handed attacks (punches etc)
(*)Erebite materials now have a chance to explode when struck. YOU people wanted this. Always remember that.
(*)Clarks contributed new sprites for the additive barrel. Woop!
(-)
(t)sat may 24 14
(u)Keelin
(*)You can now put reagents into the barrel next to the smelter to use them as additives for you material.
(*)One bar uses the entire contents of the barrel. The barrel can only hold one reagent. You can only use additives once on a material.
(*)This is subject to change.
(*)The rarer / more exotic the reagent, the more dramatic the effect on the material.
(*)Not all reagents have an effect on the materials yet and the ones that do aren't final. This is still very rough.
(*)Reagent name should now influence the name of the material.
(-)
(t)fri may 23 14
(u)Keelin
(*)Added explosion protection and damage properties to materials.
(*)Put a very rough manual on material properties in the smelter room.
(-)
(t)tue may 22 14
(u)Keelin
(*)Added material support for more objects. Most notably windows and grilles as well explosion resistance on clothes on humans.
(*)Some internal fixes and changes, nothing interesting.
(*)Do try the custom pod armor and let me know about any problems. It's got the most complex material interactions so far.
(-)
(t)wed may 21 14
(u)AngriestIBM
(*)Treads are back for surgery!! The whole single leg dealy didn't play well with the changed limb system and that's why they were gone from surgery.
(*)Treads are now two piece.  They're manufactured together for the same price as before (Unless I FUCKED UP) and you can mix and match them with normal legs I guess.
(-)
(u)Keelin
(*)Material scanner near the smelter. This is a very basic thing to allow you to get a basic idea of what materials do.
(*)Diversified materials a bit. Added more special and unique effects. Gold and stuff made from gold sparkles now. Just because.
(-)
(t)tue may 20 14
(u)Keelin
(*)Preliminary support for material traits (like erebite explosions) for the arc smelter / sheet press stuff.
(*)Material transparency now influences opacity of resulting obj. Go make some see-through molitz walls.
(*)Whole bunch of fixes and internal upgrades.
(*)Uhm. There's also another machine near the smelter now that produces a different item. Yep.
(*)Chemicals and drugs should no longer randomly permanently buff your stamina.
(*)Igniter combos might or might not work properly with chemicals again.
(-)
(t)mon may 19 14
(u)Keelin
(*)Sheets produced by the sheet press using the arc smelter should now correctly work in constructing things.
(*)Many objects now support material properties. Uqill armor would be pretty tough. Too bad you can't actually make that right now. But i guess you can make some fancy/tough walls?!
(-)
(t)sun may 18 14
(u)Keelin
(*)The Arc smelter above the central warehouse can now be used (with ores and bars - try 2 different ones). And uhhh ... i guess you can make a crowbar with the thing next to it.
(-)
(t)tue may 5 14
(u)Tobba
(*)This should fix cardiac arrest being a consistent piece of shit.
(-)
(t)mon may 5 14
(u)Tobba
(*)Added speech bubbles over people when they talk.
(-)
(u)Keelin
(*)Trying out some changes to stamina based on feedback.
(*)One example would be being unable to speak on less than a third of max stamina. Numbers always subject to change.
(*)Adjusted the point at which attacks become free. Might or might not drop costs entirely. We'll see.
(-)
(t)sun may 4 14
(u)Keelin
(*)Now new but important to know: Armor has varying amounts if stamina damage protection. Numbers are not final and need balancing.
(*)Items also have varying amounts of crit chance and stamina damage / cost.
(*)In general, pointy or sharp objects will have a higher crit chance and heavy or large objects more stamina damage. Numbers not final.
(*)Expect to see some items have stupid values that make no sense, probably because i missed them.
(*)Attacks on borgs have been adjusted. Numbers not final.
(*)Kicking someone on the ground will no longer endlessly stun them.
(-)
(t)sat may 3 14
(u)Keelin
(*)Attacking only costs stamina up to a certain level of stamina - after that it is free.
(*)Getting a crit on someone who is low on stamina will always knock them out.
(*)Blocking works better against grabs.
(*)Can't block with an active weapon in-hand (Turned disarm into harm on steroids).
(*)Fixed an issue where kicking someone on the ground would not do stamina damage to them.
(*)Fixed some circumstances that could lead to mysterious stamina loss.
(*)Various number tweaks.
(*)Farts are free once again. Joke is over. Too many people thought it was gonna stay like this.
(*)Things that will be adjusted: Cyborgs, guns.
(*)Thanks to all the people who helped test things and gave usable feedback.
(-)
(u)Supernorn
(*)Added a bunch of Clarks' kitchen sprites to the game. The gibber is now animated!
(*)Added Triggerhappypilot (Sigmund Droid) to HOS, and SpyGuy (Jenny Antonsson) to Mentor. Welcome them!
(-)
(t)fri may 2 14
(u)Tobba
(*)Cloaker will turn off if you attack anything outside of where you are standing, price reduced to 5 TC to compensate.
(*)Hopefully this makes uses actually creative and not consistent bullshit murder sprees.
(*)Teleporter will no longer randomly decide it wants to kill you.
(-)
(u)Keelin
(*)After gathering some feedback we're gonna try some new stuff for stamina:
(*)Hitting 0 stamina will no longer knock you out instantly - instead you will become increasingly more vulnerable to stuns as your stamina goes into the negative. This is highly experimental..
(*)However, hitting the negative stamina cap (indicated by a full, blinking stamina bar) will still knock you out.
(*)Melee attacks now have a chance to cause critical stamina damage.
(*)Disarm mode now gives you a chance to block attacks.
(*)Not new but important: The chance of knocking someone down with disarm depends on how much stamina they have. (actual disarming is unaffected)
(*)Increased the stamina cost of farting based on feedback to 50.
(*)If you don't like these changes complain to your fellow players and then post on the forums about it.
(-)
(t)thu may 1 14
(u)Keelin
(*)Stamina system. Yes this will definitely upset some people and make others happy.
(*)Nothing is set in stone - things can and will change and if you have worries or complaints feel free to put them on the forums.
(*)It's a bit too much to explain in the changelog but this is meant to get rid of some of the RNG in combat as well as provide a new resource to work with.
(*)Yes that means that most objects don't have a random knockout chance anymore - instead things damage stamina and you get knocked out when you run out of it.
(*)Farting costs 6 stamina. I just wanted to say that here.
(-)
(t)mon apr 28 14
(u)Keelin
(*)Microphone component for mechanic's lab.
(*)RegEx Find components should work as intended now.
(-)
(t)sat apr 26 14
(u)Tobba
(*)Took microbombs down a notch, I should have done this a long time ago. Dont worry, they still make quite a mess.
(-)(t)wed apr 23 14
(u)Tobba
(*)This should fix the issues with AI camera tracking breaking.
(-)
(t)fri apr 18 14
(u)Tobba
(*)Entirely rewrote AI shells, they currently suffer from a handful of problems I'll be working to fix, but they should be more pleasant to use than the older shells.
(*)<b>If you have issues returning to core, hit cancel camera view, this is due to a BYOND bug.</b>
(-)
(t)thu apr 17 14
(u)Tobba
(*)Replaced the borg HUD entirely, sprites courtesy of clarks.
(*)Added the ProDoc borg upgrade to the robotics manufacturer.
(*)Chainsaw arms work again.
(-)
(t)tue apr 8 14
(u)Tobba
(*)Even more explosion tuning, these values should be pretty good
(-)
(t)mon apr 7 14
(u)Tobba
(*)Tuning the explosions a bit, for the better or worse.
(-)
(t)sun apr 6 14
(u)Tobba
(*)Some new explosion code, walls will block off explosions with different effectiveness.
(*)This will also proably alter the effective explosive power of many items, yell at me in IRC if you think any adjustments should be made.
(-)
(t)tue mar 26 14
(u)Keelin
(*)Selection Component now has various randomization Options.
(*)Selection Component now has Inputs for adding, removing and direct selection of Items.
(*)Descriptions and Information on Components has been moved into the Manual.
(*)Examining a Component now shows you detailed Information about that Component.
(-)
(u)AngriestIBM
(*)Are we adding nerd request items to mechanics now?  Um okay well here is a WIP super nerd object I guess.
(-)
(t)wed mar 26 14
(u)Wire
(*)Goonhub v2.0 is live today! Come check out all your favorite bees and more! http://goonhub.com
(-)
(u)Tobba
(*)This should fix debraining/cloning after using the observe verb, I'm not sure how that remained broken for so long (yell at me about this shit next time okay).
(-)
(u)Keelin
(*)Wifi Signal Splitter for mechanics Lab.
(*)Signal Check Component can now trigger when it does NOT find the specified String.
(*)AND Components should no longer mysteriously break.
(-)
(u)AngriestIBM
(*)<strike>Apparently soulguard is broken? Probably because of Hitler?  Anyway it's not buyable until this is fixed sorry SORRY</strike>
(-)
(u)Tobba
(*)Put Soul Guard back in, function is mostly identical to the shield of souls, except that its single use and respawns you on the shuttle like usual, also works against gibbings. Oh and you'll be naked, I might change that later.
(-)
(t)tue mar 25 14
(u)Keelin
(*)Signal Builder Component for the mechanics Lab.
(*)2 RegEx Components for the mechanics Lab.
(*)Wifi Component now has a few more toggles to adjust its Behaviour.
(*)Various Bugfixes
(*)If your Component Connection Indicators look wrong, update to the Beta Version of BYOND. The current Stable one is bugged.
(-)
(t)mon mar 24 14
(u)Tobba
(*)Experiment: CheMasters, reagent heaters and dispensers are now scannable through mechanics. Lets see how long it takes before I realize this was a bad idea.
(*)RCD now holds 50 ammo, wall construction is cheaper, airlock cost cut in half. Deconstruction costs raised to compensate, this may take some tweaking. Also cut down the time the cartridges take to manufacture slightly..
(*)Cut the manual construction time of walls and grilles to be less godawful.
(-)
(u)Keelin
(*)Signal-checking Component for the mechanics Lab. Allows you to check if a Signal has a given String within it somewhere.
(*)Wifi Component for the mechanics Lab. Allows you to make use of the Radio Network the Station uses. Wanna control your contraptions with your PDA? Now you can.
(*)Relay Components can now change the Signal before forwarding it.
(*)LED Components now have an Input that allows you to change their Color.
(*)Possibly other small changes i've forgotten about.
(-)
(t)wed mar 19 14
(u)Tobba
(*)Mousetraps in boxes/backpacks should work again.
(-)
(t)tue mar 18 14
(u)Keelin
(*)Improved Visibility for the Connection Indicators of Mechanic Components.
(*)Telepads can now be set to "Send only". In this mode they can not recieve incoming teleports - only send things to other pads. Useful if you want a bunch of pads to lead to a single exit Location.
(-)
(t)mon mar 17 14
(u)Keelin
(*)Telepads for Mechanics Lab. You also need to have a Multitool to change most Components and their Connections now.
(*)Added Toggle and Selection Components.
(*)LED Components now change their own Color to the set Color when activated. This should make it easier to tell if they are on or not.
(*)Various other fixes and Changes.
(-)
(t)tue mar 11 14
(u)Tobba
(*)This is why we cant have nice things.
(-)
(t)sun mar 09 14
(u)Tobba
(*)Attacking pods with melee weapons now behaves the way you'd expect
(-)
(t)wed mar 05 14
(u)Cogwerks
(*)Removed the AWOL round-ending condition from nuke mode
(*)If it drags on forever, just call the shuttle, or don't, whatever
(-)
(t)sun mar 02 14
(u)Tobba
(*)Intended to re-work some HUD code, turns out the whole thing was the worlds worst jenga possible, reworked the code for all storage items (+ their HUD) and grabs.
(*)As usual bug me in IRC/adminhelp if anything behaves unusually, with the code managable I'm hoping to be able to land a few feature goodies however.
(-)
(t)sat mar 01 14
(u)Wire
(*)Made the Who list a little different. No more red highlighting for goons.
(*)This continues my Goon Special Treatment Purge (tm).
(-)
(t)fri feb 28 14
(u)Tobba
(*)The WASD mode hotkeys 1-4 (selects intents) should work much better for humans.
(*)Soldering irons are now in the general manefacturers instead of being in the mechanics fab (you no longer need a soldering iron to make soldering irons)
(-)
(t)thu feb 27 14
(u)Tobba
(*)Borgs can load blueprints into manufacturers via drag-drop now, this should help engineering borgs do mechanics
(-)
(t)tue feb 25 14
(u)Tobba
(*)Gave engineering borgs a device analyzer and soldering iron
(*)Replaced a lot of old eye code, this should solve all issues where your camera gets stuck on something, if there are any camera related problems, bitch at me in adminhelp/IRC
(-)
(t)mon feb 24 14
(u)Tobba
(*)Tore out the remaining click code with my bare hands, expect bugs.
(*)Number keys 0-3 will now select module for borgs in WASD mode (swapping module with E has also been fixed), 4 will deselect, for humans, number keys 1-4 select intents
(*)Touched up the wizard mode a bit, targeting is now non-awful, fireball can also now target arbitary objects.
(-)
(t)sun feb 23 14
(u)Tobba
(*)More fancy (crappy) cursors to help newer players to figure out certain hotkeys.
(*)Shift+clicking will now throw, holding shift also works for catching.
(-)
(t)sat feb 22 14
(u)Tobba
(*)Applying a machete to some nastier parts of the game internals. If anything ineveitably breaks, please yell at me in adminhelp/IRC.
(*)Also; try using alt+left click to examine things.
(-)
(t)thu feb 20 14
(u)Wire
(*)Turned goonsay off by default. Deal with it.
(*)Also some pie science updates. Put a beaker of something horrible in a pie, sounds like a great idea!
(-)
(t)wed feb 19 14
(u)Dr. Cogwerks
(*)Swapped the RD's special traitor weapon from adv. laser to the telegun
(*)Added a new gasmask/injector-belt hybrid mask that you can buy from Thrifty B.O.B.
(-)
(t)sun feb 16 14
(u)I Said No
(*)You can now drag-and-drop someone onto an operating table.
(-)
(t)sat feb 08 14
(u)I Said No
(*)You can now examine artifacts to get a small hint as to how you're supposed to use them, if you can activate them.
(-)
(t)tue feb 04 14
(u)I Said No
(*)Added a button to recyclers that will automatically process any metal sheets, glass sheets and cable coil in the recycler's contents.
(-)
(t)sun feb 02 14
(u)I Said No
(*)Various changes made over the past few days:
(*)Mechanics and the Chief Engineer now get a Deconstruction Device that can deconstruct anything a mechanic has deployed.
(*)Mechanics have been switched over to using manufacturers rather than circuitry pieces for construction.
(*)Cargo Pads for Mechanic's Lab and Robotics.
(*)The Artifact Lab heater pad now gives a little more useful information.
(*)Artifacts now display small hints when you touch them. This mostly determines their origin, but can sometimes give hints as to their function.
(*)A bunch of new artifacts. What do they do? Find out for yourself!
(*)Radiation Storm random event redone. You now have to dodge radioactive pulses rather than getting unavoidably irradiated.
(*)Black Hole event tweaked a bit. There will be a few seconds warning in the vincinity when a black hole is about to spawn.
(*)Computer consoles now give feedback if you're doing something wrong when trying to construct them.
(*)The old teleporter (the one in a closet near the owlery) is now a bit more modular and doesn't need to be built in a specific order or layout, as long as all pieces are within two tiles of each other.
(*)One portal generator and computer can also support multiple portal rings at once.
(-)
(t)tue jan 21 14
(u)Dr. Cogwerks
(*)Security locker room now has some lockers with alternate uniforms
(*)Slight changes to the room behind disposals to encourage more petty crime there
(-)
(t)fri jan 17 14
(u)Wire
(*)Now you can make pies with any item! Egg + Sweet Dough + Item on high for 2 seconds,
(*)I fully expect this to end badly.
(-)
(t)tue jan 14 14
(u)AngriestIBM with special guest Clarks
(*)You can now attach an empty pipe bomb frame to a mousetrap/grenade assembly to make a little cart. Use it in hand and it will scoot off in whichever direction you're facing.  Then it will hit things and blow up.
(-)
(t)sat jan 11 14
(u)I Said No
(*)Messed around with Meteor Shield Generators a bit. They have snazzy new icons, can have their shield range set by using the right click menu, and will tell you about their power consumption rates when examined.
(*)Recycling units can be set to retain any resources they output internally. This should be very convenient when combined with communal pooling.
(*)You can drag and drop any manufacturing unit onto a floor, table, rack, openable crate, or functioning manufacturing unit to make it output anything manufactured or ejected there.
(*)A recycling unit for the Mechanic's Workshop.
(-)
(t)wed jan 08 14
(u)I Said No
(*)Sped up drag-loading items into a manufacturing unit. Note: Doing it from a closed crate is instant and always has been.
(*)Manufacturers that start the round in the same room now pool their resources communally between each other. This can be toggled on or off per unit.
(*)Robotics Manufacturers now have two new recipes that essentially combine all the robot part recipes into one, for convenience. There's one for Standard and Light model cyborgs.
(-)
(t)sun jan 05 14
(u)I Said No
(*)The repeat function in manufacturing units will now go onto the next queue item rather than stopping once it runs out of resources.
(*)Click-drag the manufacturer onto a nearby crate or turf, and it will output any ejected or manufactured items there until it no longer can, at which point it reverts to its own tile.
(-)
(t)sat jan 04 14
(u)Infinite Monkeys
(*)Made the initropidril recipe a bit easier so that it's a viable alternative to sarin.
(-)
(t)thu jan 02 14
(u)Keelin
(*)Mechanics have a limited selection of new Toys to play with.
(*)They and a book containing Instructions have been dumped right next to the door.
(*)Again, this is highly experimental - try not to be idiots with it or you won't get new toys.
(-)
(u)I Said No
(*)Added the ability to print Blueprints from scanned Ruckingenur Kit entries. These blueprints can be used in new Reverse-Engineering Fabricators as an alternate method to the old circuit board stuff in Mechanics.
(-)
(t)wed jan 01 14
(u)I Said No
(*)Manufacturing Units can now be damaged and destroyed by beating, shooting or generally just abusing them.
(*)They can also be repaired or deconstructed. To repair, open the panel and use wiring for severe damage, or welding for light damage.
(*)To deconstruct, start by using a wrench on the unit. Examining the unit each step will tell you what to do from there.
(-)
(t)tue dec 31 13
(u)Infinite Monkeys
(*)CHAINSAW ARMS
(*)The mob sprites are by Iamgoofball, thanks!
(-)
(u)Keelin
(*)Boxes of fireworks in the crew quarters. For new years'. It's also still christmas, i don't know what that is about.
(-)
(u)I Said No
(*)Tweaked around with the Manufacturing Units a whole bunch. Most important change: Metal sheets, wire and so forth can't be stuffed into any old unit, you have to use the Recycling Unit for that now. Same with Miracle Matter.
(-)
(t)mon dec 30 13
(u)Dr. Cogwerks
(*)Forensics scanners can now match dug-out bullets to specific guns. Will this ever matter? Up to you.
(-)
(t)sat dec 28 13
(u)I Said No
(*)Using an empty hand on the AI upload console will show the AI's current laws.
(*)Added a new verb for AIs that opens the nearest door to someone, so you can do that without interrupting your current camera feed.
(-)
(t)wed dec 25 13
(u)Dr. Cogwerks
(*)Added some goofy new freeform traitor objectives
(*)Removed the station nuke again, rip
(*)It's back in space again, should any nefarious jerks feel the need to rebuild it on the station.
(-)
(t)mon dec 23 13
(u)aphtonites
(*)Some of the Janitor's equipment now have fancy new icons!
(-)
(t)fri dec 20 13
(u)aphtonites
(*)The Passive Gate and other various atmos equipment now have new icons.
(*)The Escape Arm has been redesigned!
(-)
(t)mon dec 16 13
(u)stuntwaffle
(*)New robust chair options: Set intent to grab and climb a chair.
(*)Flip on a chair with folks around for interesting results.
(-)
(u)Dr. Cogwerks
(*)Medical Director has a new unique traitor kit, aw gosh
(*)Staplers can now shoot staples into people if you hit them on harm intent
(*)Robotics manufacturers can make more staplers
(*)Most belts can now hold a wire variety of tiny/small-sized items instead of super-specific boring lists
(*)See some jerk standing on a chair? Try folding it under them.
(*)Hard counter added for meth/stim-addled wrestler rampages:
(*)MD and Armory now have tranq rifles. Welp.
(*)Haloperdol was always meant to be the tool of choice against drug-fueled rampages, but it was too hard to dose them
(*)These darts contain that stuff, 10u per shot divided by target's armor class.
(*)It's less obnoxious than the old sleeptox syringe gun vigilantes, I hope - shorter naptime.
(*)Try not to make me regret adding these.
(*)Also the guards have a smoke launcher now, use it for mildly-hazardous area denial against crowds I guess? w/e
(*)That's pretty much the role pepperfoam was meant for, as a step towards this thing.
(-)
(t)sun dec 15 13
(u)Dr. Cogwerks
(*)Added a new traitor item: WRESTLING BELT
(*)It may have a few things left to iron out, but it should be mostly functional now.
(*)Slam and Throw actions with the wrestling belt require an active grab on someone
(*)Action cooldown delays for the wrestling actions can be reduced by coffee, sugar, nicotine, meth, crank, bathsalts, etc.
(*)Zipguns can now be assembled
(*)Pipebombs can be packed with: fuel, black powder, plasmastone, or erebite
(-)
(t)sat dec 14 13
(u)HullCrushDepth
(*)Clicking on a reagent container (beakers, buckets, medicine bottles, etc.) in the active hand will switch between a firm and loose grip on them.
(*)Switching to firm grip will cause you to pour out the container's transfer volume when you click on something while loose grip will splash the entire contents.
(*)There is now a confirmation for emptying out plant pots with viable plants in them.
(*)Clicking on equipped stacks of metal, glass, and rods with an empty hand will now allow you to specify the number to take from the existing stack, instead of grabbing one at a time.
(-)
(u)stuntwaffle
(*)Flipmode.
(*)Equippable chairs.
(-)
(t)sat dec 14 13
(u)Aphtonites
(*)There are now a couple of closets with fire fighting equipment on the station.
(-)
(t)thu dec 12 13
(u)Dr. Cogwerks
(*)Rearranged some borg module stuff
(*)Cyborgs can use a PDA module now
(*)The blob can actually be hurt by fire now, whoa
(*)Shot glasses in the bar now hold 15u instead of 10, and transfer 15u in one big gulp instead of lame little baby sips
(-)
(t)mon dec 09 13
(u)AngriestIBM
(*)I guess that luggable computer has a wired card now that should link to whatever data terminal you deploy over.
(*)I'm only changelogging this because people were talking about it, ok.
(-)
(t)sun dec 08 13
(u)I Said No
(*)Manufacturer Unit production can now be paused manually. It will also show the time left until completion in the queue page.
(-)
(t)sat dec 07 13
(u)Aphtonites
(*)Ho ho ho! Merry Spacemas!
(-)
(u)BurntCornMuffin
(*)Redid a bunch of area definitions.  Please report any rooms that might be behaving oddly.
(-)
(t)fri dec 06 13
(u)Dr. Cogwerks
(*)All PDAs now have a cargo request utility on their storage drive.
(-)
(t)thu dec 05 13
(u)Dr. Cogwerks
(*)ChemMaster machines can now dispense medical patches.
(*)Added a handful of new botany mutations.
(*)Syndicate floor closets will now match the turf under them.
(*)Detective has a few new PDA programs now- reagent scan, health scan, medical records
(*)Mechanic PDAs now have all the network diagnostic apps
(*)The comments field in QM crate ordering now works as a destination barcode, but ONLY IF you write the proper destination format.
(*)Derringer bullets now pierce armor.
(*)Speaking of armor, I changed a lot of armor stuff a couple weeks ago to use variable armor class multipliers instead of hardcoded amounts
(*)Some things in the suit slot will do slightly different amounts of projectile protection now. Industrial armor is better than ever.
(*)Syndicate space suits, captain's space suit, captain's armor, and some other stuff like that are now a little better than before.
(*)Some suits that aren't armor will soak up a little bit of projectile damage now, even if they aren't bullet-stoppers.
(-)
(u)BurntCornMuffin
(*)Experimenting with Creative EAX 3D sound and environment functionality!
(*)This means that you all should hook up surround sound systems for the ultimate highly visceral 2D spaceman multimedia experience!
(*)Some areas may sound strange as we are tweaking the environments.
(*)Positional audio not fully implemented, so expect longer sounds to not update their position as they are playing.
(*)Sound ranges may be higher or lower than expected, we are tweaking that, too.
(-)
(t)wed dec 04 13
(u)Dr. Cogwerks
(*)Randomly-generated goofy cyberpunk drug cocktails can be found scattered around in those ??? pill bottles.
(*)Die a Glorious Death objective returns.
(*)Nuclear self-destruct objective returns. Nuke charge is in the mainframe core below the AI.
(*)Setting off the self-destruct erases the mainframe room, AI core, most of engineering, and wrecks a fairly wide area.
(*)Derringers will fit into a pocket now if you want a quieter way to retrieve them, although *wink is still cooler.
(*)NEW HOTKEYS FOR EMOTES #WOW #WHOA
(*)Ctrl-A: Salute | Ctrl-W: Wink
(*)Ctrl-E: Eyebrow | Ctrl-N: Nod
(*)Ctrl-S: Scream | Ctrl-L: Laugh
(*)Ctrl-D: Dance | Ctrl-R: Raisehand
(*)Ctrl-X: Flex, | Crtl-G: Gasp
(*)A bunch of other ctrl-letter combinations too, you'll probably stumble onto them. More coming soon probably.
(-)"}

/proc/changelog_parse(var/changes, var/title)
	var/html=""
	var/text = changes
	if (!text)
		diary << "Failed to load changelog."
	else
		html += "<ul class=\"log\"><li class=\"title\"><i class=\"icon-bookmark\"></i> [title] as of [svn_revision]</li>"

		var/list/lines = dd_text2list(text, "\n")
		for(var/line in lines)
			if (!line)
				continue

			if (copytext(line, 1, 2) == "#")
				continue

			switch(copytext(line, 1, 4))
				if("(t)")
					var/day = copytext(line, 4, 7)
					html += "<li class=\"date\">"
					switch(day)
						if("sun")
							html += "Sunday, "
						if("mon")
							html += "Monday, "
						if("tue")
							html += "Tuesday, "
						if("wed")
							html += "Wednesday, "
						if("thu")
							html += "Thursday, "
						if("fri")
							html += "Friday, "
						if("sat")
							html += "Saturday, "
						else
							html += "Whoopsday, "
					var/month = copytext(line, 8, 11)
					switch(month)
						if("jan")
							html += "January "
						if("feb")
							html += "February "
						if("mar")
							html += "March "
						if("apr")
							html += "April "
						if("may")
							html += "May "
						if("jun")
							html += "June "
						if("jul")
							html += "July "
						if("aug")
							html += "August "
						if("sep")
							html += "September "
						if("oct")
							html += "October "
						if("nov")
							html += "November "
						if("dec")
							html += "December "
						else
							html += "Whoops"
					var/date1 = copytext(line, 12, 13)
					var/date2 = copytext(line, 13, 14)
					switch(date1)
						if("0")
							html += date2
							switch(date2)
								if("1")
									html += "st, "
								if("2")
									html += "nd, "
								if("3")
									html += "rd, "
								else
									html += "th, "
						else if("1")
							html += "[date1][date2]th, "
						else
							html += date1
							html += date2
							switch(date2)
								if("1")
									html += "st, "
								if("2")
									html += "nd, "
								if("3")
									html += "rd, "
								else
									html += "th, "
					html += "20[copytext(line, 15, 17)]</li>"
				if("(u)")
					html += "<li class=\"admin\"><span><i class=\"icon-check\"></i> [copytext(line, 4, 0)]</span> updated:</li>"
				if("(*)")
					html += "<li>[copytext(line, 4, 0)]</li>"
				else continue

		html += "</ul>"
		return html

/datum/changelog/New()
//<img alt="Goon Station 13" src="[resource("images/changelog/postcardsmall.jpg")]" class="postcard" />

	html = {"
<h1>Goon Station 13 <a href="#license"><img alt="Creative Commons License" src="[resource("images/changelog/somerights20.png")]" /></a></h1>

<ul class="links cf">
    <li>Official Wiki<br><strong>http://wiki.ss13.co</strong><span></span></li>
    <li>Official Forums<br><strong>http://forum.ss13.co</strong></li>
</ul>"}
	html += changelog_parse(changes, "Changelog")
	html += {"
<h3>GoonStation 13 Development Team</h3>
<p class="team">
    <strong>Hosts:</strong> Rick (#1, #2), Pantaloons (#3, Wiki, Forums), Tobba (#4)<br>

    <strong>Coders:</strong> stuntwaffle, Showtime, Pantaloons, Nannek, Keelin, Exadv1, hobnob, 0staf, sniperchance, AngriestIBM, BrianOBlivion, I Said No, Harmar, Dropsy, ProcitizenSA, Pacra, LLJK-Mosheninkov, JackMassacre, Jewel, Dr. Singh, Infinite Monkeys, Cogwerks, Aphtonites, Wire, BurntCornMuffin, Tobba, Haine, Marquesas, SpyGuy, Conor12, Daeren<br>

    <strong>Spriters:</strong> Supernorn, Haruhi, Stuntwaffle, Pantaloons, Rho, SynthOrange, I Said No, Cogwerks, Aphtonites, Hempuli, Gannets, Haine, SLthePyro, and a bunch of awesome people from the forums!
</p>

<p class="lic">
    <a href="http://creativecommons.org/licenses/by-nc-sa/3.0/" name="license"><img alt="Creative Commons License" src="[resource("images/changelog/88x31.png")]" /></a><br/>

    <em>
    	Except where otherwise noted, Goon Station 13 is licensed under a <a href="http://creativecommons.org/licenses/by-nc-sa/3.0/">Creative Commons Attribution-Noncommercial-Share Alike 3.0 License</a>.<br>
    	Rights are currently extended to SomethingAwful Goons only.
    </em>
</p>"}
