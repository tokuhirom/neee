OSX.require_framework 'WebKit'
require 'osx/cocoa'
require 'uri'

class AppController < OSX::NSObject
	include OSX
	STARTUP_URL = "http://www.nicovideo.jp/watch/sm5637829"
	# STARTUP_URL = "http://localhost/"
	ib_outlet :window, :webview
	ib_action :onDaigamen
	
	# 画面表示完了後フック
	def awakeFromNib()
		@is_fullscreen = false

		# load code
		@js = open(NSBundle.mainBundle.resourcePath.fileSystemRepresentation + "/daigamen.js") {|io| io.read }

		# load url
		@webview.mainFrame.loadRequest(NSURLRequest.requestWithURL(
			NSURL.URLWithString(STARTUP_URL)
		))
	end

	# 大画面にする
	def onDaigamen
		if @is_fullscreen
			puts "DISABLE FULLSCREEN"
			@webview.exitFullScreenModeWithOptions({})
			p @webview.windowScriptObject.evaluateWebScript(@js + "\n;\nrun_neee(0);\n'OK'")
			@is_fullscreen = false
		else
			puts "ENABLE FULLSCREEN"
			@window.setShowsResizeIndicator(false)
			@webview.enterFullScreenMode_withOptions_(NSScreen.mainScreen(), {})
			p @webview.windowScriptObject.evaluateWebScript(@js + "\n;\nrun_neee(1);\n'OK'")
			@is_fullscreen = true
		end
	end
	
	# leopard より前の OS でもつかえるというフルスクリーンにする方法
	def _goFullScreen
		mainScreen = NSScreen.mainScreen()
		screenInfo = mainScreen.deviceDescription()
		screenID = screenInfo['NSScreenNumber']
		displayID = screenID.longValue
		err = CGDisplayCapture(displayID)
		if err == CGDisplayNoErr
			@captured = displayID
			if !@myScreenWindow
				winRect = mainScreen.frame
				@myScreenWindow = NSWindow.alloc.initWithContentRect_styleMask_backing_defer_screen(
					winRect,
					NSBorderlessWindowMask,
					NSBackingStoreBuffered,
					false,
					NSScreen.mainScreen
				)
				@myScreenWindow.setReleasedWhenClosed(false)
				@myScreenWindow.setDisplaysWhenScreenProfileChanges(true)
				@myScreenWindow.setDelegate(self)

				shieldLevel = CGShieldingWindowLevel()
				@myScreenWindow.setLevel(shieldLevel)
				@myScreenWindow.makeKeyAndOrderFront(self)
			end
			@myScreenWindow.setContentView(@webview)
		end
	end
end

__END__
メモ:
	@webview.enterFullScreenMode_withOptions_() は、なぜかリロードがはしってしまうので駄目。
	setContentView で他のウィンドウに webview をつけかえるとリロードがはしるようだ
	
        // Make the screen window the current document window.
        // Be sure to retain the previous window if you want to  use it again.
        NSWindowController* winController = [[self windowControllers]
                                                 objectAtIndex:0];
        [winController setWindow:myScreenWindow];

 

        // The window has to be above the level of the shield window.

        int32_t     shieldLevel = CGShieldingWindowLevel();

        [myScreenWindow setLevel:shieldLevel];

 

        // Show the window.

        [myScreenWindow makeKeyAndOrderFront:self];

    }

}

