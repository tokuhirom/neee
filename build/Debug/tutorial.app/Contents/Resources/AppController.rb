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
	ib_outlet :window, :webview
	ib_action :onDaigamen

	# 画面表示完了後フック
	def awakeFromNib()
		@webview.mainFrame.loadRequest(NSURLRequest.requestWithURL(
			NSURL.URLWithString("http://www.nicovideo.jp/watch/sm5637829")
		))
	end

	# 大画面にする
	def onDaigamen
		p "DAIGAMEN!"

		
		foo =	<<'OOO'
	dbg = []
	function D (msg) { dbg.push(msg); document.getElementById("WATCHFOOTER").innerHTML = dbg.join("<br />\n") }
	D("START");

function nicodai() {
		var a = $('flvplayer'),
			b = $('flvplayer_container'),
			w = document.body.clientWidth,
			h = (document.documentElement.clientHeight ? document.documentElement.clientHeight : document.body.clientHeight),
			c = w / 544 < 1 ? 1 : w / 544,
			d = h / 384 < 1 ? 1 : h / 384,
			e = Math.min(c, d);
		a.SetVariable('videowindow.video_mc.video.smoothing' , 1);
		a.SetVariable('videowindow.video_mc.video.deblocking', 5);
		document.body.style.background = '#000 url()';
		if(c >= d)  {
			a.style.width      = Math.floor(544 * d) + 'px';
			D(a.style.width)
			a.style.height     = h + 'px';
			a.style.marginLeft = (( w - 544 * d) / 2) + 'px';
			a.style.marginTop  = '0px';
		}  else  {
			a.style.width      = w + 'px';
			a.style.height     = Math.floor(384 * c) + 'px';
			a.style.marginLeft = '0px';
			a.style.marginTop  = (( h - 384 * c) / 2) + 'px';
		}
		D(a)
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
		document.body.style.background = "white"
		var elems = ['PAGEHEADER', 'PAGEFOOTER', 'WATCHHEADER', 'WATCHFOOTER']
//		var elems = ['PAGEHEADER', 'PAGEFOOTER', 'WATCHHEADER'];
		D("HMM")
		for (i=0; i<elems.length; i++) {
			document.getElementById(elems[i]).style.display = "none"
		}
		D("FIN")
}

nicodai();

		"OK"
OOO
#		foo = foo.gsub(/\*e/, "* #{e.to_f}")
# 		foo = foo.gsub(/^a/, "document.getElementById('flvplayer')")
		p @webview.windowScriptObject.evaluateWebScript(foo)


		#p @webview.stringByEvaluatingJavaScriptFromString("window")
		# bookmarklet = "javascript:function%20nicodai(){if(playerMaximized){var%20a=$('flvplayer'),b=$('flvplayer_container'),w=document.body.clientWidth,h=(document.documentElement.clientHeight?document.documentElement.clientHeight:document.body.clientHeight),c=w/544%3C1?1:w/544,d=h/384%3C1?1:h/384,e=c%3C=d?c:d;a.SetVariable('videowindow.video_mc.video.smoothing',1);a.SetVariable('videowindow.video_mc.video.deblocking',5);document.body.style.background='#000%20url()';if(c%3E=d){a.style.width=Math.floor(544*d)+'px';a.style.height=h+'px';a.style.marginLeft=((w-544*d)/2)+'px';a.style.marginTop='0px';}else{a.style.width=w+'px';a.style.height=Math.floor(384*c)+'px';a.style.marginLeft='0px';a.style.marginTop=((h-384*c)/2)+'px';}a.SetVariable('videowindow._xscale',100*e);a.SetVariable('videowindow._yscale',100*e);a.SetVariable('videowindow._x',0);a.SetVariable('videowindow._y',0);a.SetVariable('controller._x',-550);a.SetVariable('inputArea._x',-550);a.SetVariable('controller._visible',1);a.SetVariable('inputArea._visible',1);a.SetVariable('waku._visible',0);a.SetVariable('header._visible',0);a.SetVariable('tabmenu._visible',0);}}(function(){toggleMaximizePlayer();if(playerMaximized){nicodai();var%20dt=new%20Date();dt.setHours(dt.getHours()+24);document.cookie='nicodai'+'='+escape('true')+';%20expires='+dt.toGMTString()+';';window.onresize=function(){setTimeout(nicodai,1000);};}else{var%20a=$('flvplayer');document.body.style.background='%23FFF%20url(\'../img/tpl/bg_rc2.gif\')%20repeat-x';a.style.marginLeft='';a.style.marginTop='';a.SetVariable('videowindow._xscale',100);a.SetVariable('videowindow._yscale',100);a.SetVariable('videowindow._x',6);a.SetVariable('videowindow._y',65);a.SetVariable('controller._x',6);a.SetVariable('inputArea._x',4);a.SetVariable('controller._visible',1);a.SetVariable('inputArea._visible',1);a.SetVariable('waku._visible',1);a.SetVariable('header._visible',1);a.SetVariable('tabmenu._visible',1);document.cookie='nicodai'+'=;';window.onresize=function(){};}})();"
		# bookmarklet.gsub!(/^javascript:/, '')
		# bookmarklet = URI.unescape(bookmarklet)
	#	p "HOHOE"
	#	p @webview.windowScriptObject.evaluateWebScript('document.body')
	#	p @webview.windowScriptObject.evaluateWebScript('document.body.style.color="red"')


#		puts "flvplayer"
#		p @webview.windowScriptObject.evaluateWebScript(%q{document.evaluate("id('flvplayer')", document, null, 7, null).snapshotLength})
#		p @webview.windowScriptObject.evaluateWebScript(%q{document.evaluate("//embed[@id='flvplayer']", document, null, 7, null).snapshotItem(0)})
#		p @webview.windowScriptObject.evaluateWebScript('document')
#		bookmarklet = "(function (document) { document.getElementById('flvplayer_container').removeElement(); \n })"
		# bookmarklet = "(function (document) { \n #{ $src } \n })"
#		func = @webview.windowScriptObject.evaluateWebScript(bookmarklet)
#		p func
#		document = @webview.mainFrame.DOMDocument
#		jsthis = func.evaluateWebScript('this')
#		p jsthis
#		p document
#		func.callWebScriptMethod_withArguments("call", [jsthis, document])
#		puts "O_________________"
		# @webview.windowScriptObject().evaluateWebScript(bookmarklet)
		# @webview.windowScriptObject.
#		@webview.mainFrame.loadRequest(NSURLRequest.requestWithURL(
#			NSURL.URLWithString("javascript:alert('ho')")
#		))
		puts "FINISHED"
	end

#	private
#	def _getid(id)
#		@webview.windowScriptObject.evaluateWebScript("window.document.getElementById('#{id}')")
#	end
end
__END__

		document = @webview.mainFrame.DOMDocument
		a = document.getElementById('flvplayer')
		b = document.getElementById('flvplayer_container')
		w = document.body.clientWidth.to_f
		h = document.documentElement.clientHeight.to_f
		c = w / 544 < 1 ? 1 : w / 544
		d = h / 384 < 1 ? 1 : h / 384
		e = c <= d ? c : d
		p [a, b, w, h, c, d, e]
		# a.SetVariable('videowindow.video_mc.video.smoothing' , 1);
		# a.SetVariable('videowindow.video_mc.video.deblocking', 5);
		document.body.style.background = '#000 url()'
		if (c >= d)
			a.style.width      = (544 * d).floor.to_s + 'px'
			a.style.height     = h.to_s + 'px'
			a.style.marginLeft = (( w - 544 * d) / 2).to_s + 'px'
			a.style.marginTop  = '0px'	
		else
			a.style.width      = w.to_s + 'px'
			a.style.height     = (384 * c).floor.to_s + 'px'
			a.style.marginLeft = '0px'
			a.style.marginTop  = (( h - 384 * c) / 2).to_s + 'px'
		end
