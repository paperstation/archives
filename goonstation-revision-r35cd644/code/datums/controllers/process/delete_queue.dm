datum/controller/process/delete_queue
	var/tmp/delcount = 0
	var/tmp/gccount = 0
	var/tmp/deleteChunkSize = MIN_DELETE_CHUNK_SIZE
	//var/tmp/delpause = 1

	// Timing vars
	var/tmp/start = 0
	var/tmp/list/timeTaken = new

	setup()
		name = "DeleteQueue"
		schedule_interval = 1
		sleep_interval = 1

	doWork()
		if(!global.delete_queue)
			boutput(world, "Error: there is no delete queue!")
			return 0

		//var/datum/dynamicQueue/queue =
		if(global.delete_queue.isEmpty())
			return

		start = world.timeofday

		var/list/toDeleteRefs = delete_queue.dequeueMany(deleteChunkSize)
		var/numItems = toDeleteRefs.len
		#ifdef DELETE_QUEUE_DEBUG
		var/t
		#endif
		for(var/r in toDeleteRefs)
			var/datum/D = locate(r)

			if (!istype(D) || !D.qdeled)
				// If we can't locate it, it got garbage collected.
				// If it isn't disposed, it got garbage collected and then a new thing used its ref.
				gccount++
				continue

			#ifdef DELETE_QUEUE_DEBUG
			t = D.type
			// If we have been forced to delete the object, we do the following:
			detailed_delete_count[t]++
			detailed_delete_gc_count[t]--
			// Because we have already logged it into the gc count in qdel.
			#endif

			// Delete that bitch
			delcount++
			D.qdeled = 0
			del(D)

			scheck(0)

			//if (delpause)
				//sleep(delpause)

		// The amount of time taken for this run is recorded only if
		// the number of items considered is equal to the chunk size
		if(numItems == deleteChunkSize)
			timeTaken.len++
			timeTaken[timeTaken.len] = world.timeofday - start

		// If the number of items processed is equal to the chunk size
		// and the average time taken by the delete queue is greater than the scheduled interval
		if (numItems == deleteChunkSize && averageTimeTaken() > schedule_interval && deleteChunkSize > MIN_DELETE_CHUNK_SIZE)
			deleteChunkSize--
		else if (numItems == deleteChunkSize && averageTimeTaken() < schedule_interval)
			deleteChunkSize++

	proc
		averageTimeTaken()
			var/t = 0
			var/c = 0
			for(var/time in timeTaken)
				t += time
				c++

			if (timeTaken.len > 10)
				timeTaken.Cut(1, 2)

			if(c > 0)
				return t / c
			return c

	tickDetail()
		#ifdef DELETE_QUEUE_DEBUG
		if (detailed_delete_count && detailed_delete_count.len)
			var/stats = "<b>Delete Stats:</b><br>"
			var/count
			for (var/thing in detailed_delete_count)
				count = detailed_delete_count[thing]
				stats += "[thing] deleted [count] times.<br>"
			for (var/thing in detailed_delete_gc_count)
				count = detailed_delete_gc_count[thing]
				stats += "[thing] gracefully deleted [count] times.<br>"
			boutput(usr, "<br>[stats]")
		#endif
		boutput(usr, "<b>Current Queue Length:</b> [delete_queue.count()]")
		boutput(usr, "<b>Total Items Deleted:</b> [delcount] (Explictly) [gccount] (Gracefully GC'd)")