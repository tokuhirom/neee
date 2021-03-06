OSX.require_framework 'WebKit'
require 'osx/cocoa'
require 'uri'

class AppController < OSX::NSObject
	include OSX
	STARTUP_URL = "http://www.nicovideo.jp/watch/sm5637829"
	# STARTUP_URL = "http://localhost/"
	ib_outlet :window, :webview

	# 画面表示完了後フック
	def awakeFromNib()
		@is_fullscreen = false
		
		@webview.setResourceLoadDelegate(self)

		# load javascript code
		@js = open(NSBundle.mainBundle.resourcePath.fileSystemRepresentation + "/daigamen.js") {|io| io.read }

		_loadURL(STARTUP_URL)
	end
	
	def webView_resource_didFinishLoadingFromDataSource(sender, identifier, dataSource)
		@window.setTitle("#{dataSource.pageTitle} - Neee")
	end

	# 大画面にする
	ib_action(:onDaigamen) {|sender|
		@is_daigamen = !@is_daigamen

		wso = @webview.windowScriptObject()
		p wso.setValue_forKey_(
			@is_daigamen,
			"neee_maximized"
		)
		ret = wso.evaluateWebScript(@js)
		
		# debugging stuff
		puts wso.evaluateWebScript('dbg.join("\n")').to_s.split(/\n/).map {|x| "JS DEBUG: #{x}\n"}

		if ret != 'OK'
			puts "ERROR: #{ ret }"
		end
	}
	
	ib_action(:onFullScreen) {|sender|
		@is_fullscreen = !@is_fullscreen

		if @is_fullscreen
			@webview.reload(self) # 大画面とこれとで相性わるい。なぜか。MegaZoomer だと問題ないのになあ
			@webview.enterFullScreenMode_withOptions_(NSScreen.mainScreen(), {})
		else
			@webview.exitFullScreenModeWithOptions({})
		end
	}
	
	ib_action(:onCopyURL) {|sender|
		url = @webview.mainFrameURL()

		pboard = NSPasteboard.generalPasteboard
		pboard.declareTypes_owner([NSStringPboardType], self)
		pboard.setString_forType(url, NSStringPboardType) 
	}
	
	ib_action(:onPasteURL) {|sender|
		pboard = NSPasteboard.generalPasteboard
		url = pboard.stringForType(NSStringPboardType) 
		_loadURL(url)
	}
	
	ib_action(:onGotoMyListDailyRanking) {|sender|
		_loadURL("http://www.nicovideo.jp/ranking/mylist/daily/all")
	}
	ib_action(:onGotoHateb) {|sender|
		_loadURL("http://b.hatena.ne.jp/video?src=nicovideo")
	}
	
	private
	def _loadURL(url)
		@webview.mainFrame.loadRequest(NSURLRequest.requestWithURL(
			NSURL.URLWithString(url)
		))
	end
end

__END__
メモ:
	@webview.enterFullScreenMode_withOptions_() は、なぜかリロードがはしってしまうのがいかん
	setContentView で他のウィンドウに webview をつけかえるとリロードがはしるようだ
	megazoomer だと、はしらないんだよな
	ページ遷移した時点で @is_daigamen をクリアするべき?
	イヤ、モウイッカイハシラスベキカ。
TODO:
	履歴表示
