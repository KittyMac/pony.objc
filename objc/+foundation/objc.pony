use @class_createInstance[ObjectPtr](cls:ClassPtr, extraBytes:USize)

use @sel_registerName[SelectorPtr](name:ObjectPtr)

use @objc_getClass[ClassPtr](class_name:ObjectPtr)

type ObjectPtr is Pointer[None] tag
type ClassPtr is Pointer[None] tag
type SelectorPtr is Pointer[None] tag

type IntArgs is (ISize|USize|U32|I32)
type Args is (ISize|USize|U32|I32|F32)

interface CPointer
	fun cpointer(offset: USize = 0): Pointer[U8] tag
	fun size(): USize

class ObjC
  var id:ObjectPtr = ObjectPtr
  
  new ref create() =>
    None
    
  fun ref apply(name:String, args:Array[Args]=[]):ObjC? =>
    // if id is null, then we're asking for a class
    if id.is_null() then
      let res = ObjC
    	res.id = @objc_getClass(name.cstring())
      if res.id.is_null() then error end      
      return res
    end
    
    // if id is not null, then we have a class/object/thing and we're calling methods on it
    if (name == "alloc") then
      // alloc is both a command to create a new instance of a class, and a selector call
      let res = ObjC
  		res.id = @class_createInstance(id, 0)
  		if res.id.is_null() then error end
      return res
    end
    
    callObj(name, args)?
  
  fun ref sel(name:String):ObjectPtr? =>
    let selector:ObjectPtr = @sel_registerName(name.cstring())
    if selector.is_null() then error end
    selector
  
  fun ref callObj(name:String, args:Array[Args]=[]):ObjC? =>  
    let res = ObjC
    match args.size()
    | 1 => res.id = @objc_msgSend[ObjectPtr](id, sel(name)?, args(0)?.usize())
    | 2 => res.id = @objc_msgSend[ObjectPtr](id, sel(name)?, args(0)?.usize(), args(1)?.usize())
    | 3 => res.id = @objc_msgSend[ObjectPtr](id, sel(name)?, args(0)?.usize(), args(1)?.usize(), args(2)?.usize())
    | 4 => res.id = @objc_msgSend[ObjectPtr](id, sel(name)?, args(0)?.usize(), args(1)?.usize(), args(2)?.usize(), args(3)?.usize())
    | 5 => res.id = @objc_msgSend[ObjectPtr](id, sel(name)?, args(0)?.usize(), args(1)?.usize(), args(2)?.usize(), args(3)?.usize(), args(4)?.usize())
    | 6 => res.id = @objc_msgSend[ObjectPtr](id, sel(name)?, args(0)?.usize(), args(1)?.usize(), args(2)?.usize(), args(3)?.usize(), args(4)?.usize(), args(5)?.usize())
    else
      res.id = @objc_msgSend[ObjectPtr](id, sel(name)?)
    end
    res
  
  fun ref callInt(name:String, args:Array[Args]=[]):USize? =>  
    match args.size()
    | 1 => @objc_msgSend[USize](id, sel(name)?, args(0)?.usize())
    | 2 => @objc_msgSend[USize](id, sel(name)?, args(0)?.usize(), args(1)?.usize())
    | 3 => @objc_msgSend[USize](id, sel(name)?, args(0)?.usize(), args(1)?.usize(), args(2)?.usize())
    | 4 => @objc_msgSend[USize](id, sel(name)?, args(0)?.usize(), args(1)?.usize(), args(2)?.usize(), args(3)?.usize())
    | 5 => @objc_msgSend[USize](id, sel(name)?, args(0)?.usize(), args(1)?.usize(), args(2)?.usize(), args(3)?.usize(), args(4)?.usize())
    | 6 => @objc_msgSend[USize](id, sel(name)?, args(0)?.usize(), args(1)?.usize(), args(2)?.usize(), args(3)?.usize(), args(4)?.usize(), args(5)?.usize())
    else
      @objc_msgSend[USize](id, sel(name)?)
    end
  
  fun ref callFloat(name:String, args:Array[Args]=[]):F32? =>  
    match args.size()
    | 1 => @objc_msgSend_fpret[F32](id, sel(name)?, args(0)?.usize())
    | 2 => @objc_msgSend_fpret[F32](id, sel(name)?, args(0)?.usize(), args(1)?.usize())
    | 3 => @objc_msgSend_fpret[F32](id, sel(name)?, args(0)?.usize(), args(1)?.usize(), args(2)?.usize())
    | 4 => @objc_msgSend_fpret[F32](id, sel(name)?, args(0)?.usize(), args(1)?.usize(), args(2)?.usize(), args(3)?.usize())
    | 5 => @objc_msgSend_fpret[F32](id, sel(name)?, args(0)?.usize(), args(1)?.usize(), args(2)?.usize(), args(3)?.usize(), args(4)?.usize())
    | 6 => @objc_msgSend_fpret[F32](id, sel(name)?, args(0)?.usize(), args(1)?.usize(), args(2)?.usize(), args(3)?.usize(), args(4)?.usize(), args(5)?.usize())
    else
      @objc_msgSend_fpret[F32](id, sel(name)?)
    end
  
    /*
  fun ref call1(name:String, arg1:(I32|F32)):ObjC? =>  
    let res = ObjC
    res.id = @objc_msgSend[ObjectPtr](id, sel(name)?, arg1.i32())
    res
*/
  /*
primitive ObjC
  
  fun c(name:String):ClassPtr? =>
  	let ptr:ClassPtr = @objc_getClass(name.cstring())
  	if ptr.is_null() then error end
  	ptr
  
	fun apply(obj:ObjectPtr, op:SelectorPtr):ObjectPtr =>
		@objc_msgSend[ObjectPtr](obj, op)
  
  
  
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
	
	*/