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
			@webview.enterFullScreenMode_withOptions_(NSScreen.mainScreen(), {})
			p @webview.windowScriptObject.evaluateWebScript(@js + "\n;\nrun_neee(1);\n'OK'")
			@is_fullscreen = true
		end
	end
end
