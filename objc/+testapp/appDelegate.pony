use @UIApplicationMain[U32](argc:U32, argv:Pointer[None], principalClassName:Pointer[None], delegateClassName:Pointer[None]) if ios
use @NSApplicationMain[I32](argc:U32, argv:Pointer[None]) if osx


actor AppDelegate
  fun _use_main_thread():Bool => true
  
  
  
  new create(env:Env) =>
    
    try
      // Create an app delegate class
      let appDelegateClass = ObjC.beginImplementation("AppDelegate")?
      appDelegateClass.addMethod("applicationDidFinishLaunching:", "v@:@", @{(self:ObjectPtr, _cmd:ObjectPtr, notification:ObjectPtr)? => 
        @fprintf[I32](@pony_os_stdout[Pointer[U8]](), "application did finish launching\n".cstring())
        
        
        // NSWindow * window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 300, 300)
        //                                            styleMask:(NSWindowStyleMaskResizable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskClosable | NSWindowStyleMaskTitled)
        //                                              backing:NSBackingStoreBuffered
        //                                                defer:false];
        // [window makeKeyAndOrderFront:nil];
        // Yes, you read that right folks. The next 52 lines is just to make the above call!
        
        let windowClass = ObjC("NSWindow")?
        let windowInitSel = windowClass.sel("initWithContentRect:styleMask:backing:defer:")?
        let methodSig = windowClass("instanceMethodSignatureForSelector:", [ windowInitSel.usize() ] )?
        let invocation = ObjC("NSInvocation")?("invocationWithMethodSignature:", [  methodSig.id.usize()  ])?
        let window = windowClass("alloc")?

        invocation("setTarget:", [ window.id.usize() ] )?
        invocation("setSelector:", [ windowInitSel.usize() ] )?
        
        var rect = CGRect(0,0,500,400)
        var style = USize(0xF)
        var backing = USize(2)
        var defer = false
        @objc_msgSend[USize](invocation.id, invocation.sel("setArgument:atIndex:")?, rect,              USize(2))?
        @objc_msgSend[USize](invocation.id, invocation.sel("setArgument:atIndex:")?, addressof style,   USize(3))?
        @objc_msgSend[USize](invocation.id, invocation.sel("setArgument:atIndex:")?, addressof backing, USize(4))?
        @objc_msgSend[USize](invocation.id, invocation.sel("setArgument:atIndex:")?, addressof defer,   USize(5))?
        
        @fprintf[I32](@pony_os_stdout[Pointer[U8]](), "invoke\n".cstring())
        @objc_msgSend[USize](invocation.id, invocation.sel("invoke")?)?
        
        @fprintf[I32](@pony_os_stdout[Pointer[U8]](), "description\n".cstring())
        @NSLog[None](window("description")?.id)
        
        @fprintf[I32](@pony_os_stdout[Pointer[U8]](), "makeKeyAndOrderFront:\n".cstring())
        window("makeKeyAndOrderFront:", [ window.id.usize() ])?
        
      })?
      appDelegateClass.addMethod("applicationWillTerminate:", "v@:@", @{(self:ObjectPtr, _cmd:ObjectPtr, notification:ObjectPtr) => 
        @fprintf[I32](@pony_os_stdout[Pointer[U8]](), "application will terminate\n".cstring())
      })?
      appDelegateClass.endImplementation()?
    
      ifdef osx then
    
        // Create an application delegate and add it to the sharedApplication
        let appDelegate = ObjC("AppDelegate")?("alloc")?("init")?
                
        ObjC("NSApplication")?("sharedApplication")?("setDelegate:", [ appDelegate.id.usize() ] )?
      
        @NSApplicationMain(env.argc, env.argv)
      end

      ifdef ios then
        var null:Pointer[None] = Pointer[None]
        @UIApplicationMain(env.argc, env.argv, null, null)
      end
    else
      @printf[I32]("FATAL ERROR: \n".cstring(), __error_loc)
  		@exit[None](I32(99))
    end