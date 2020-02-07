use @class_createInstance[ObjectPtr](cls:ClassPtr, extraBytes:USize)

use @sel_registerName[SelectorPtr](name:ObjectPtr)

use @objc_getClass[ClassPtr](class_name:ObjectPtr)

type ObjectPtr is Pointer[None] tag
type ClassPtr is Pointer[None] tag
type SelectorPtr is Pointer[None] tag

interface CPointer
	fun cpointer(offset: USize = 0): Pointer[U8] tag
	fun size(): USize

primitive ObjC
	fun getClass(name:String):ClassPtr? =>
		let ptr:ClassPtr = @objc_getClass(name.cstring())
		if ptr.is_null() then error end
		ptr
	
	fun newClass(name:String):ObjectPtr? =>
		let nsClass = ObjC.getClass("NSString")?
		let nsObject = @class_createInstance(nsClass, 0)
		if nsObject.is_null() then error end
		nsObject
	
	fun selector(name:String):SelectorPtr =>
		@sel_registerName(name.cstring())
	
	fun performSelector0(obj:ObjectPtr, op:SelectorPtr):ObjectPtr =>
		@objc_msgSend[ObjectPtr](obj, op)
	
	fun performSelector1(obj:ObjectPtr, op:SelectorPtr, arg1:CPointer box):ObjectPtr =>
		@objc_msgSend[ObjectPtr](obj, op, arg1.cpointer())
	
	