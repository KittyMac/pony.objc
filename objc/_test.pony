use "framework:Foundation"

use "ponytest"
use "files"

actor Main is TestList
	new create(env: Env) => PonyTest(env, this)
	new make() => None

	fun tag tests(test: PonyTest) =>
	test(_TestObjC1)
		
	
 	fun @runtime_override_defaults(rto: RuntimeOptions) =>
		rto.ponyminthreads = 2
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

