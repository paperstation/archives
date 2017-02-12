/datum/subsystem/jobs
	name = "Jobs"
	wait = 0

/datum/subsystem/jobs/Initialize()
	set background = 1
	..()
	if(!job_master)
		job_master = new /datum/controller/occupations()
		job_master.SetupOccupations()
		job_master.LoadJobs("config/jobs.txt")