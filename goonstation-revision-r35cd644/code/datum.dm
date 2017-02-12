////////////
// drsinghs grand experiment vol 6
// this pattern might seem redundant but it ensures objects aren't disposed twice.
// it also proides a quick way to check if an object you're using was disposed but never deleted by the garbage collector because of your reference
// the point of this is to reduce code duplication. cleanup code only needs to exist one time in disposing() and it will be called whether the object is deleted with del() or dispose()
//

/datum/var/tmp/disposed = 0
/datum/var/tmp/qdeled = 0
#ifdef DELETE_QUEUE_DEBUG
var/global/list/deletedObjects = new
#endif

#ifdef IMAGE_DEL_DEBUG
var/global/list/deletedImageData = new
var/global/list/deletedImageIconStates = new

/image/Del()
	deletedImageData.len++;
	deletedImageData[deletedImageData.len] = "alpha: [src.alpha] blend_mode: [src.blend_mode] color: [src.color], file: [src.icon] icon: \icon[src.icon] icon_state: [src.icon_state] dir: [src.dir] loc: \ref[src.loc] layer: [src.layer] x: [src.x] y: [src.y] z: [src.z] type: [src.type] parent_type: [src.parent_type] tag: [src.tag]"
	deletedImageIconStates[src.icon_state]++

	..()
#endif

/datum/Del()
	if (!disposed)
		dispose()
	..()

#ifdef DELETE_QUEUE_DEBUG
	if(!("[src.type]" in deletedObjects))
		deletedObjects["[src.type]"] = 0
	deletedObjects["[src.type]"]++
#endif
	..()

// override this in children for your type specific disposing implementation, make sure to call ..() so the root disposing runs too
/datum/proc/disposing()

// don't override this one, just call it instead of delete to get rid of something cheaply
/datum/proc/dispose()
	if (!disposed)
		disposing()
		disposed = 1

// for caching/reusing
/datum/proc/pooled(var/pooltype)
	dispose()
	// If this thing went through the delete queue and was rescued by the pool mechanism, we should reset the qdeled flag.
	qdeled = 0

/datum/proc/unpooled(var/pooltype)
	disposed = 0

// called when a variable is admin-edited
/datum/proc/onVarChanged(variable, oldval, newval)
