use "framework:Foundation"
use "framework:AppKit" if osx

use "stringext"

use "ponytest"

actor Main
  new create(env:Env) =>
    MainThreadTests(env)


actor MainThreadTests is TestList
  let env:Env
  
  fun _use_main_thread():Bool => true
    
	new create(env': Env) =>
    env = env'
    PonyTest(env, this)

	fun tag tests(test: PonyTest) =>
    test(_TestObjC1)
    test(_TestObjC2)
    test(_TestObjC3)
  
  be testsFinished(test: PonyTest, success:Bool) =>
    if success then
      // check if we're running on the CI. If we are, we don't want to continue
      // with running ourself an a mac app
      for v in env.vars.values() do
        if StringExt.startswith(v, "CI=") then
          return
        end
      end
      
      @fprintf[I32](@pony_os_stdout[Pointer[U8]](), "All tests completed, starting the app\n".cstring())
      AppDelegate(env)
    end
	
 	fun @runtime_override_defaults(rto: RuntimeOptions) =>
		rto.ponynoscale = true
		rto.ponynoblock = true
		rto.ponygcinitial = 0
		rto.ponygcfactor = 1.0


class iso _TestObjC1 is UnitTest
	fun name(): String => "print hello world using NSLog"
  fun exclusion_group(): String => "sequential"

	fun apply(h: TestHelper) =>
		try			
			let helloWorld = NSString.initWithString("hello world")?
			@NSLog[None](helloWorld.id)
			h.complete(true)
		else
			h.complete(false)
		end

class iso _TestObjC2 is UnitTest
	fun name(): String => "[NSNumber numberWithInt:75]; [NSNumber numberWithFloat:0.75];"
  fun exclusion_group(): String => "sequential"

	fun apply(h: TestHelper) =>
		try			
      let n0 = ObjC("NSNumber")?("numberWithInt:", [ USize(25) ] )?
      @NSLog[None](n0("description")?.id)
      let n1 = n0.callInt("intValue")?
      
      let m0 = ObjC("NSNumber")?("numberWithFloat:", [ F32(0.25) ] )?
      @NSLog[None](m0("description")?.id)
      
      let m1 = m0.callFloat("floatValue")?
              
			h.complete( (n1 == 25) and (m1 == 0.25) )
		else
			h.complete(false)
		end

class iso _TestObjC3 is UnitTest
	fun name(): String => "Define a new class, create instance of class, call method on the class"
  fun exclusion_group(): String => "sequential"

	fun apply(h: TestHelper) =>
		try			
      
      ObjC.beginImplementation("AppDelegate")?.endImplementation()?
      
      let d = ObjC("AppDelegate")?("alloc")?("init")?
      
      @NSLog[None](d("description")?.id)
      
      
			h.complete(true)
		else
			h.complete(false)
		end
