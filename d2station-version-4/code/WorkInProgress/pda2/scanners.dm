//CONTENTS:
//Base scanner stuff
//Health scanner
//Forensic scanner
//Reagent scanner

/datum/computer/file/pda_program/scan
	return_text()
		return src.return_text_header()

	proc/scan_atom(atom/A as mob|obj|turf|area)

		if( !A || (!src.holder) || (!src.master))
			return 1

		if((!istype(holder)) || (!istype(master)))
			return 1

		if(!(holder in src.master.contents))
			if(master.scan_program == src)
				master.scan_program = null
			return 1

		return 0

	//Health analyzer program
	health_scan
		name = "Health Scan"
		size = 8.0

		scan_atom(atom/A as mob|obj|turf|area)
			if(..())
				return

			var/mob/living/carbon/C = A
			if(!istype(C))
				return

			var/dat = "<meta HTTP-EQUIV='REFRESH' content='0; url="
			dat += "http://vps.d2k5.com/d2station/medscanner/?name=[C]&health=[C.stat > 1 ? "dead" : "[C.health]% healthy"]&bloodlevel=300&suffocation=[C.oxyloss]&toxin=[C.toxloss]&burn=[C.fireloss ]&brute=[C.bruteloss]&btemp=[C.bodytemperature-T0C]&deg;C ([C.bodytemperature*1.8-459.67]&deg;F&oxystatus=1&toxstatus=1&burnstatus=1&brutestatus=1&r_armbrute=1&l_armbrute=1&l_handbrute=1&r_handbrute=1&headbrute=1&neckbrute=1&torsobrute=1&crotchbrute=1&l_legbrute=1&r_legbrute=1&l_footbrute=1&r_footbrute=1
			if(C.virus)
				dat += "&virus="
				dat += "\red \n<b>Warning: Ailment Detected.</b>\nName: [C.virus.name].\nType: [C.virus.spread].\nStage: [C.virus.stage]/[C.virus.max_stages].\nPossible Cure: [C.virus.cure]"

			dat += "'>Scanning..."
			user << browse("[dat]","window=healthscan;size=600x360")
			onclose(user, "healthscan")

			return dat

	//Forensic scanner
	forensic_scan
		name = "Forensic Scan"
		size = 8.0

		scan_atom(atom/A as mob|obj|turf|area)
			if(..())
				return
			var/dat = null

			if(istype(A,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = A
				if (!istype(H.dna, /datum/dna) || !isnull(H.gloves))
					dat += "\blue Unable to scan [A]'s fingerprints.\n"
				else
					dat += "\blue [H]'s Fingerprints: [md5(H.dna.uni_identity)]\n"
				if ( !(H.blood_DNA) )
					dat += "\blue No blood found on [H]\n"
				else
					dat += "\blue Blood type: [H.blood_type]\nDNA: [H.blood_DNA]\n"

			if (!A.fingerprints)
				dat += "\blue Unable to locate any fingerprints on [A]!\n"
			else
				var/list/L = params2list(A:fingerprints)
				dat += "\blue Isolated [L.len] fingerprints.\n"
				for(var/i in L)
					dat += "\blue \t [i]\n"

			return dat


	//Reagent scanning program
	reagent_scan
		name = "Reagent Scan"
		size = 6.0

		scan_atom(atom/A as mob|obj|turf|area)
			if(..())
				return
			var/dat = null
			if(!isnull(A.reagents))
				if(A.reagents.reagent_list.len > 0)
					var/reagents_length = A.reagents.reagent_list.len
					dat += "\blue [reagents_length] chemical agent[reagents_length > 1 ? "s" : ""] found.\n"
					for (var/datum/reagent/re in A.reagents.reagent_list)
						dat += "\blue \t [re] - [re.volume]\n"
				else
					dat = "\blue No active chemical agents found in [A]."
			else
				dat = "\blue No significant chemical agents found in [A]."

			return dat
