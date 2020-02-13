use "framework:Foundation"
use "framework:AppKit" if osx

use "stringext"

use "ponytest"

actor Main is TestList
  let env:Env
  
	new create(env': Env) =>
    env = env'
    PonyTest(env, this)

	fun tag tests(test: PonyTest) =>
    test(_TestObjC1)
  
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

	fun apply(h: TestHelper) =>
		try			
			let helloWorld = NSString.initWithString("hello world")?
			@NSLog[None](helloWorld.id)
			h.complete(true)
		else
			h.complete(false)
		end

