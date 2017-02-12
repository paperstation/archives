//currently only used for library, intended to replace godawful sql system usage

#define CURRENT_SAVEFILE_VERSION 1

var/datum/server_db/server_db = new()

/datum/server_db
	var/path = "data/server_db.sav"
	var/savefile_version

/datum/server_db/proc/access(directory="/")
	var/savefile/S = new(path,SAVEFILE_TIMEOUT)
	if(!S)	return

	if(savefile_version != CURRENT_SAVEFILE_VERSION)
		update(S)

	S.cd = directory
	return S

/datum/server_db/proc/update(savefile/S)
	S.cd = "/version"
	S >> savefile_version

	if(savefile_version != CURRENT_SAVEFILE_VERSION)
		S.dir.Cut()
		savefile_version = CURRENT_SAVEFILE_VERSION
		S << savefile_version

/datum/server_db/proc/upload_book(obj/item/weapon/book/B, force_upload)
	var/savefile/S = access("/book_id")
	if(!S)
		return "Error: Unable to access database"

	if(!B)
		return "Error: No book data found"

	if(!B.title)
		return "Error: Book has no title"

	if(!B.author)
		return "Error: Book has no author"

	if(!B.category)
		return "Error: Book has no category"

	if(B.bookid && !force_upload)
		return "Error: Book already in database"

	S >> B.bookid
	S << ++B.bookid

	S.cd = "/books"
	S["[B.bookid]"] << B

	log_game("[usr.name]/[usr.key] has uploaded the book titled [B.name], [length(B.dat)] characters")

	return

/datum/server_db/proc/download_book(bookid, loc)
	if(!bookid)
		return "Error: Invalid book id"

	var/savefile/S = access("/books")
	if(!S)
		return "Error: Unable to access database"

	var/obj/item/weapon/book/B
	S["[bookid]"] >> B
	if(!istype(B))
		return "Error: No book found for that book id"
	B.loc = loc


#undef CURRENT_SAVEFILE_VERSION