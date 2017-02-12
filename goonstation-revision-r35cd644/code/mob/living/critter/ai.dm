/datum/aiHolder
	var/mob/living/critter/owner = null
	var/datum/aiTask/current_task = null  // what the critter is currently doing
	var/datum/aiTask/default_task = null  // what behavior the critter will fall back on
	var/list/task_cache = list()

	var/enabled = 1

	proc/tick()
		if (!current_task)
			current_task = default_task
		if (current_task)
			current_task.tick()

			var/datum/aiTask/T = current_task.next_task()
			if (T)
				current_task = T
				T.reset()

	proc/get_instance(taskType, list/nparams)
		if (taskType in task_cache)
			return task_cache[taskType]
		task_cache[taskType] = new taskType(arglist(nparams))
		return task_cache[taskType]

/datum/aiTask
	var/name = "task"
	var/datum/aiHolder/holder = null

	New(parentHolder)
		..()
		holder = parentHolder

		reset()

	proc/on_tick()


	proc/next_task()
		return null

	proc/on_reset()

	proc/evaluate() // evaluate the current environment and assign priority to switching to this task
		return 0

	//     do not override procs below this line
	// --------------------------------------------
	// unless you are building a new direct subtype

	proc/tick()
		
		on_tick()

	proc/reset()
		on_reset()		

/datum/aiTask/prioritizer
	var/list/transition_tasks = list()

	proc/add_transition(transTask)
		transition_tasks[transTask] = 0

	next_task()
		var/mp = -100
		var/mT = null
		for (var/T in transition_tasks)
			if (!mT || transition_tasks[T] > mp || (transition_tasks[T] == mp && prob(50)))
				mT = T
				mp = transition_tasks[mT]
		reset()
		return mT

	reset()
		..()
		for (var/T in transition_tasks)
			transition_tasks[T] = 0

	tick()
		..()
		for (var/datum/aiTask/T in transition_tasks)
			transition_tasks[T] = T.evaluate()

/datum/aiTask/timed
	var/minimum_task_ticks = 20
	var/maximum_task_ticks = 40
	var/elapsed_ticks = 0
	var/current_target_ticks = 20
	var/frustration = 0
	var/frustration_threshold = 10
	var/datum/aiTask/transition_task = null

	New(parentHolder, transTask)
		transition_task = transTask
		..()

	proc/frustration_check()
		return 0

	next_task()
		if (current_target_ticks <= elapsed_ticks || frustration >= frustration_threshold)
			return transition_task
		return null

	tick()
		..()
		if (frustration_check())
			frustration++
		else
			frustration = 0
			elapsed_ticks++

	reset()
		..()
		elapsed_ticks = 0
		current_target_ticks = rand(minimum_task_ticks, maximum_task_ticks)