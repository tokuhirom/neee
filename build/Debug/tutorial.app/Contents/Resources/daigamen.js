dbg = []
function D (msg) { dbg.push(msg); document.getElementById("WATCHFOOTER").innerHTML = dbg.join("<br />\n") }
D("START");

var neee_elems = ['PAGEHEADER', 'PAGEFOOTER', 'WATCHHEADER', 'WATCHFOOTER']

function enable_neee_fullscreen() {
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
	b.style.width = a.style.width;
	b.style.height = a.style.height;
	b.style.padding = "0px";	
	b.style.overflow = "visible"
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
	//		var elems = ['PAGEHEADER', 'PAGEFOOTER', 'WATCHHEADER'];
	D("HMM")
	for (i=0; i<neee_elems.length; i++) {
		document.getElementById(neee_elems[i]).style.display = "none"
	}
	D("FIN")
}

function disable_neee_fullscreen () {
	var a = document.getElementById('flvplayer');
	var b = $('flvplayer_container');
	document.body.style.background = '#FFFFFF url(/img/base/head/topline.gif) no-repeat scroll center top';
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
	b.style.width = "952px";
	b.style.height = "540px";
	b.style.padding = "4px";
	//
	window.onresize = function()  {  };

	for (i=0; i<neee_elems.length; i++) {
		document.getElementById(neee_elems[i]).style.display = "block"
	}
}

function run_neee(n) {
	D("RUN!");
	if (n==1) {
		// enable full screen
		D("ENABLE");
		enable_neee_fullscreen();
		window.onresize = function()  {  setTimeout(enable_neee_fullscreen, 1000);  };
	} else {
		D("DISABLE");
		disable_neee_fullscreen();
	}
}
