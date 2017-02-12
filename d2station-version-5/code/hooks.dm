/datum/hook
	var/name = "DefaultHookName"
	proc/Called(var/list/args) // When the hook is called
		return 0
	proc/Setup() // Called when the setup things is ran for the hook, objs contain all objects with that is hooking
	var/list/handlers = list()
/datum/hook_handler
var/list/hooks = list()

/proc/SetupHooks()
	for (var/hook_path in typesof(/datum/hook))
		var/datum/hook/hook = new hook_path
		hooks[hook.name] = hook
		//world.log << "Found hook: " + hook.name
	for (var/hook_path in typesof(/datum/hook_handler))
		var/datum/hook_handler/hook_handler = new hook_path
		for (var/name in hooks)
			if (hascall(hook_handler, "Hook" + name))
				var/datum/hook/hook = hooks[name]
				hook.handlers += hook_handler
				//world.log << "Found hook handler for: " + name
	for (var/datum/hook/hook in hooks)
		hook.Setup()

/proc/CallHook(var/name as text, var/list/args)
	var/datum/hook/hook = hooks[name]
	if (!hook)
		//world.log << "WARNING: Hook with name " + name + " does not exist"
		return
	if (hook.Called(args))
		return
	for (var/datum/hook_handler/hook_handler in hook.handlers)
		call(hook_handler, "Hook" + hook.name)(args)