
use @CFStringCreateWithCString[ObjectPtr](alloc:ObjectPtr, cStr:Pointer[U8] tag, encoding:U32)

primitive CFStringEncoding
	fun utf8():U32 => 0x08000100


class NSString
	let id:ObjectPtr
	
	fun _final() =>
		@CFRelease[None](id)
		
	new init()? =>
		id = @CFStringCreateWithCString(ObjectPtr, "".cstring(), CFStringEncoding.utf8())
		if id.is_null() then error end
	
	new initWithString(string:String)? =>
		id = @CFStringCreateWithCString(ObjectPtr, string.cstring(), CFStringEncoding.utf8())
		if id.is_null() then error end

	