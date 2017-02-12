/proc/AStar(start, end, adjacent, heuristic, maxtraverse = 30, adjacent_param = null, exclude = null)
	var/list/open = list(start), list/nodeG = list(), list/nodeParent = list(), P = 0
	while (P++ < open.len)
		var/T = open[P], TG = nodeG[T]
		if (T == end)
			var/list/R = list()
			while (T)
				R.Insert(1, T)
				T = nodeParent[T]
			return R
		var/list/other = call(T, adjacent)(adjacent_param)
		for (var/next in other)
			if (open.Find(next) || next == exclude) continue
			var/G = TG + other[next], F = G + call(next, heuristic)(end)
			for (var/i = P; i <= open.len;)
				if (i++ == open.len || open[open[i]] >= F)
					open.Insert(i, next)
					open[next] = F
					break
			nodeG[next] = G
			nodeParent[next] = T

		if (P > maxtraverse)
			return