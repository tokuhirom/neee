OSX.require_framework 'WebKit'
require 'osx/cocoa'
require 'uri'

$src = <<'EOF'
//	以下、GreaseMonkey版。
//	識別ヘッダにTAB挿入禁止。
// ==UserScript==
// @name         ニコニコ大画面
// @namespace    http://www.nicovideo.jp/
// @description  β4 : ニコニコ動画を大画面で再生します。
// @include      http://www.nicovideo.jp/watch/*
// ==/UserScript==
//
//	更新履歴
//		2008/03/03 α
//		2008/03/07 β1
//		2008/03/09 β2
//		2008/04/12 β3
//			・大画面時、Window Resizeイベントで自動再レイアウトするようにした。
//			・無条件自動大画面表示ではなく、ブックマークレットで自動大画面表示を
//			　するか切り替わるようにした。
//			　初回起動時は自動大画面表示しないようにした。
//			　切り替えはCookieを見て判断。賞味期限は1日。
//			　大画面表示切り替え毎に新しいCookieを焼いています。
//		2008/04/13 β4
//			・InternetExplorer 7に対応した。
//			　InternetExplorer 6はブックマークレットの文字数制限により不可。
//			　別スクリプトで対応する。
//
//	Special Thanks
//		・ニコニコ動画(RC2)＆(SP1)
//		　http://www.nicovideo.jp/
//		・JavaScriptな日々 | ニコニコ動画サイズ変更+画質向上ブックマークレット
//		　http://m035.blog61.fc2.com/blog-entry-66.html
//
alert("HA");
function getCookie(key)  {
	var buf = document.cookie + ';';
	var i   = buf.indexOf(key, 0);
	var st, ed;
	if(i > -1)  {
		buf = buf.substring(i, buf.length);
        st = buf.indexOf('=', 0);
        ed = buf.indexOf(';', st);
        return(unescape(buf.substring(st+1, ed)));
    }
    return('');
}
function dai()  {
	unsafeWindow.toggleMaximizePlayer();
	var a = document.getElementById('flvplayer').wrappedJSObject,
		b = document.getElementById('flvplayer_container').wrappedJSObject,
		w = document.body.clientWidth,
		h = (document.documentElement.clientHeight ? document.documentElement.clientHeight : document.body.clientHeight),
		c = w / 544 < 1 ? 1 : w / 544,
		d = h / 384 < 1 ? 1 : h / 384,
		e = c <= d ? c : d;
	a.SetVariable('videowindow.video_mc.video.smoothing' , 1);
	a.SetVariable('videowindow.video_mc.video.deblocking', 5);
	document.body.style.background = '#000 url()';
	if(c >= d)  {
		a.style.width      = Math.floor(544 * d) + 'px';
		a.style.height     = h + 'px';
		a.style.marginLeft = (( w - 544 * d) / 2) + 'px';
		a.style.marginTop  = '0px';
	}  else  {
		a.style.width      = w + 'px';
		a.style.height     = Math.floor(384 * c) + 'px';
		a.style.marginLeft = '0px';
		a.style.marginTop  = (( h - 384 * c) / 2) + 'px';
	}
	a.SetVariable('videowindow._xscale', 100*e);
	a.SetVariable('videowindow._yscale', 100*e);
	a.SetVariable('videowindow._x'     ,   0  );
	a.SetVariable('videowindow._y'     ,   0  );
	a.SetVariable('controller._x'      ,-550  );
	a.SetVariable('inputArea._x'       ,-550  );
	//
	a.SetVariable('controller._visible',   1  );
	a.SetVariable('inputArea._visible' ,   1  );
	a.SetVariable('waku._visible'      ,   0  );
	a.SetVariable('header._visible'    ,   0  );
	a.SetVariable('tabmenu._visible'   ,   0  );
	//
	var dt = new Date();
	dt.setHours(dt.getHours() + 24);
	document.cookie = 'nicodai' + '=' + escape('true') + '; expires=' + dt.toGMTString() + ';';
	unsafeWindow.onresize = function()  {
		setTimeout(dai_resize, 500);
		function dai_resize()  {
			var a = document.getElementById('flvplayer').wrappedJSObject,
				b = document.getElementById('flvplayer_container').wrappedJSObject,
			w = document.body.clientWidth,
			h = (document.documentElement.clientHeight ? document.documentElement.clientHeight : document.body.clientHeight),
			c = w / 544 < 1 ? 1 : w / 544,
			d = h / 384 < 1 ? 1 : h / 384,
			e = c <= d ? c : d;
			a.SetVariable('videowindow.video_mc.video.smoothing' , 1);
			a.SetVariable('videowindow.video_mc.video.deblocking', 5);
			document.body.style.background = '#000 url()';
			if(c >= d)  {
				a.style.width      = Math.floor(544 * d) + 'px';
				a.style.height     = h + 'px';
				a.style.marginLeft = (( w - 544 * d) / 2) + 'px';
				a.style.marginTop  = '0px';
			}  else  {
				a.style.width      = w + 'px';
				a.style.height     = Math.floor(384 * c) + 'px';
				a.style.marginLeft = '0px';
				a.style.marginTop  = (( h - 384 * c) / 2) + 'px';
			}
			a.SetVariable('videowindow._xscale', 100*e);
			a.SetVariable('videowindow._yscale', 100*e);
			a.SetVariable('videowindow._x'     ,   0  );
			a.SetVariable('videowindow._y'     ,   0  );
			a.SetVariable('controller._x'      ,-550  );
			a.SetVariable('inputArea._x'       ,-550  );
			//
			a.SetVariable('controller._visible',   1  );
			a.SetVariable('inputArea._visible' ,   1  );
			a.SetVariable('waku._visible'      ,   0  );
			a.SetVariable('header._visible'    ,   0  );
			a.SetVariable('tabmenu._visible'   ,   0  );
		}
	};
}
(function()  {
	if(getCookie('nicodai') == 'true')  {
		setTimeout(dai, 3000);
	}
	//'\→%5C%27
	var a = "javascript:function nicodai(){if(playerMaximized){var a=$('flvplayer'),b=$('flvplayer_container'),w=document.body.clientWidth,h=(document.documentElement.clientHeight?document.documentElement.clientHeight:document.body.clientHeight),c=w/544<1?1:w/544,d=h/384<1?1:h/384,e=c<=d?c:d;a.SetVariable('videowindow.video_mc.video.smoothing',1);a.SetVariable('videowindow.video_mc.video.deblocking',5);document.body.style.background='#000 url()';if(c>=d){a.style.width=Math.floor(544*d)+'px';a.style.height=h+'px';a.style.marginLeft=((w-544*d)/2)+'px';a.style.marginTop='0px';}else{a.style.width=w+'px';a.style.height=Math.floor(384*c)+'px';a.style.marginLeft='0px';a.style.marginTop=((h-384*c)/2)+'px';}a.SetVariable('videowindow._xscale',100*e);a.SetVariable('videowindow._yscale',100*e);a.SetVariable('videowindow._x',0);a.SetVariable('videowindow._y',0);a.SetVariable('controller._x',-550);a.SetVariable('inputArea._x',-550);a.SetVariable('controller._visible',1);a.SetVariable('inputArea._visible',1);a.SetVariable('waku._visible',0);a.SetVariable('header._visible',0);a.SetVariable('tabmenu._visible',0);}}(function(){toggleMaximizePlayer();if(playerMaximized){nicodai();var dt=new Date();dt.setHours(dt.getHours()+24);document.cookie='nicodai'+'='+escape('true')+'; expires='+dt.toGMTString()+';';window.onresize=function(){setTimeout(nicodai,1000);};}else{var a=$('flvplayer');document.body.style.background='#FFF url(%5C%27../img/tpl/bg_rc2.gif%5C%27) repeat-x';a.style.marginLeft='';a.style.marginTop='';a.SetVariable('videowindow._xscale',100);a.SetVariable('videowindow._yscale',100);a.SetVariable('videowindow._x',6);a.SetVariable('videowindow._y',65);a.SetVariable('controller._x',6);a.SetVariable('inputArea._x',4);a.SetVariable('controller._visible',1);a.SetVariable('inputArea._visible',1);a.SetVariable('waku._visible',1);a.SetVariable('header._visible',1);a.SetVariable('tabmenu._visible',1);document.cookie='nicodai'+'=;';window.onresize=function(){};}})();";
	var d = document.createElement('div');
	d.style.cssText = 'position:absolute;overflow:hidden;left:0px;top:1px;width:22px;height:10px;font:bold 10px/100% sans-serlf;';
	d.innerHTML = "<a href=\""+a+"\" title=\"ニコニコ大画面\" style=\"color:#ddd;text-decoration:none;\">切替</a>";
	document.body.appendChild(d);
})();


//	以下、ブックマークレット版。
//	http://subsimple.com/bookmarklets/jsbuilder.htm でブックマークレット化する。
//	1960 characters
/**
javascript:
function nicodai()  {
	if(playerMaximized)  {
		var a = $('flvplayer'),
			b = $('flvplayer_container'),
			w = document.body.clientWidth,
			h = (document.documentElement.clientHeight ? document.documentElement.clientHeight : document.body.clientHeight),
			c = w / 544 < 1 ? 1 : w / 544,
			d = h / 384 < 1 ? 1 : h / 384,
			e = c <= d ? c : d;
		a.SetVariable('videowindow.video_mc.video.smoothing' , 1);
		a.SetVariable('videowindow.video_mc.video.deblocking', 5);
		document.body.style.background = '#000 url()';
		if(c >= d)  {
			a.style.width      = Math.floor(544 * d) + 'px';
			a.style.height     = h + 'px';
			a.style.marginLeft = (( w - 544 * d) / 2) + 'px';
			a.style.marginTop  = '0px';
		}  else  {
			a.style.width      = w + 'px';
			a.style.height     = Math.floor(384 * c) + 'px';
			a.style.marginLeft = '0px';
			a.style.marginTop  = (( h - 384 * c) / 2) + 'px';
		}
		a.SetVariable('videowindow._xscale', 100*e);
		a.SetVariable('videowindow._yscale', 100*e);
		a.SetVariable('videowindow._x'     ,   0  );
		a.SetVariable('videowindow._y'     ,   0  );
		a.SetVariable('controller._x'      ,-550  );
		a.SetVariable('inputArea._x'       ,-550  );
		//
		a.SetVariable('controller._visible',   1  );
		a.SetVariable('inputArea._visible' ,   1  );
		a.SetVariable('waku._visible'      ,   0  );
		a.SetVariable('header._visible'    ,   0  );
		a.SetVariable('tabmenu._visible'   ,   0  );
	}
}
(function()  {
	toggleMaximizePlayer();
	if(playerMaximized)  {
		nicodai();
		//
		var dt = new Date();
		dt.setHours(dt.getHours() + 24);
		document.cookie = 'nicodai' + '=' + escape('true') + '; expires=' + dt.toGMTString() + ';';
		window.onresize = function()  {  setTimeout(nicodai, 1000);  };
	}  else  {
		var a = $('flvplayer');
		document.body.style.background = '#FFF url(\'../img/tpl/bg_rc2.gif\') repeat-x';
		a.style.marginLeft = '';
		a.style.marginTop  = '';
		a.SetVariable('videowindow._xscale', 100);
		a.SetVariable('videowindow._yscale', 100);
		a.SetVariable('videowindow._x'     ,   6);
		a.SetVariable('videowindow._y'     ,  65);
		a.SetVariable('controller._x'      ,   6);
		a.SetVariable('inputArea._x'       ,   4);
		//
		a.SetVariable('controller._visible',   1);
		a.SetVariable('inputArea._visible' ,   1);
		a.SetVariable('waku._visible'      ,   1);
		a.SetVariable('header._visible'    ,   1);
		a.SetVariable('tabmenu._visible'   ,   1);
		//
		document.cookie = 'nicodai' + '=;';
		window.onresize = function()  {  };
	}
})();
**/
EOF

class AppController < OSX::NSObject
	include OSX
	# STARTUP_URL = "http://www.nicovideo.jp/watch/sm5637829"
	STARTUP_URL = "http://localhost/"
	ib_outlet :window, :webview
	ib_action :onDaigamen
	
	# 画面表示完了後フック
	def awakeFromNib()
		@is_fullscreen = false
		
		p ScreenManager.doFullScreen()
		# p @window.zoom(self)
		# @window.setShowsToolbarButton(false)
		@window.setTitle("HOGEHOGE")
		@window.toggleToolbarShown(self)
		@window.performZoom(self)

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
			p @webview.windowScriptObject.evaluateWebScript(@js + "\n;\nrun_neee(0);\n'OK'")
			@is_fullscreen = false
		else
			puts "ENABLE FULLSCREEN"
			p @webview.windowScriptObject.evaluateWebScript(@js + "\n;\nrun_neee(1);\n'OK'")
			@is_fullscreen = true
		end
	end
end
