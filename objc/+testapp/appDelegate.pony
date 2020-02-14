use @UIApplicationMain[U32](argc:U32, argv:Pointer[None], principalClassName:Pointer[None], delegateClassName:Pointer[None]) if ios
use @NSApplicationMain[I32](argc:U32, argv:Pointer[None]) if osx


actor AppDelegate
  fun _use_main_thread():Bool => true
  
  
  
  new create(env:Env) =>
    ifdef osx then
    
      // we want to be like:
      //[[NSApplication sharedApplication] setDelegate:[[AppDelegate alloc] init]];
      // that could break down to
      //ObjC.c("NSApplication").("sharedApplication").("setDelegate", ObjC.c("AppDelegate").("alloc").("init"))
      
      @NSApplicationMain(env.argc, env.argv)
    end

    ifdef ios then
      var null:Pointer[None] = Pointer[None]
      @UIApplicationMain(env.argc, env.argv, null, null)
    end
    
        
    // TODO:
    // 1. Generate an app delegate Objc/Swift class
    // 2. app delegate class creates a timer
    // 3. timer calls pony code callback (ie C function pointer), which will then call @ponyint_poll_self[None]()
    //
    // At this point we will have the ability to call behaviors on any
    // _use_main_thread() actor and they will execute on the main thread
    // (ie the one locked down by the hard loop UIApplicationMain())
    // enters when it is called.
    
    

