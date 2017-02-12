var/list/matrixPool = list()
var/matrixPoolHitCount = 0
var/matrixPoolMissCount = 0

/matrix
	proc/Reset()
		src.a = 1
		src.b = 0
		src.c = 0
		src.d = 0
		src.e = 1
		src.f = 0
		src.disposed = 0