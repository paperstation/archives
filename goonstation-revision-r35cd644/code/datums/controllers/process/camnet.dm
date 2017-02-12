datum/controller/process/camnets

	setup()
		name = "Camera Networks"
		schedule_interval = 30
		sleep_interval = 0.5

	doWork()
		rebuild_camera_network() //Will only actually do something if it needs to.