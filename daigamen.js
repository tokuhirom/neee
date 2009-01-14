dbg = []
function D (msg) { dbg.push(msg); }
D("START");

var neee_elems = ['PAGEHEADER', 'PAGEFOOTER', 'WATCHHEADER', 'WATCHFOOTER']

function enable_neee_fullscreen() {
    D("DO ENABLE");
    if (!neee_maximized) {
        D("MAXIMIZED>>> SKIP");
        return;
    }

    var a = $('flvplayer'),
        w = window.innerWidth - 10,
        h = window.innerHeight,
        // w = document.documentElement.clientWidth,
        // h = document.documentElement.clientHeight,
        c = w / 544 < 1 ? 1 : w / 544,
        d = h / 384 < 1 ? 1 : h / 384,
        e = c <= d ? c : d;
    D("variable setup OK");
    D(a);
    a.SetVariable('videowindow.video_mc.video.smoothing' , 1);
    a.SetVariable('videowindow.video_mc.video.deblocking', 5);
    document.body.style.background = '#000 url()';

    {
        var flvstyle;
        if(c >= d)  {
            flvstyle = {
                "width"       : Math.floor(544 * d) + 'px',
                "height"      : h + 'px',
                'margin-left' : Math.floor((w-544*d)/2)+'px',
                'margin-top'  : '0px'
            };
        }  else  {
            flvstyle = {
                'width'       : w+'px',
                'height'      : Math.floor(384 * c) + 'px',
                'margin-left' : '0px',
                'margin-top'  : Math.floor(( h - 384 * c) / 2) + 'px'
            };
        }
        Element.setStyle(a, flvstyle);
    }

    Element.setStyle(
        $('flvplayer_container'), {
            "height": a.style.height,
            "padding": "0px",
            'margin': '0px',
            'position': 'absolute',
            'top':'0px',
            'left':'0px',
            "overflow": "visible"
        }
    );
    D(a)

    a.SetVariable('videowindow._xscale', 100*e);
    a.SetVariable('videowindow._yscale', 100*e);
    a.SetVariable('videowindow._x'     ,   0  );
    a.SetVariable('videowindow._y'     ,   0  );
    a.SetVariable('controller._x'      ,-550  );
    a.SetVariable('inputArea._x'       ,-550  );
    ['controller', 'inputArea', 'waku', 'header', 'tabmenu'].each(function (x) {
        a.SetVariable(x + '._visible', 0);
    });

    document.body.style.background = "white"

    D("HMM")
    neee_elems.each(function (x) {
        $(x).style.display = "none"
    });
    D("FIN")
}

function disable_neee_fullscreen () {
    document.body.style.background = '#FFFFFF url(/img/base/head/topline.gif) no-repeat scroll center top';

    var a = $('flvplayer');
    Element.setStyle(a, {
        "width":"952px",
        "height":"540px",
        'margin-left': '',
        'margin-top':  '',
    });

    a.SetVariable('videowindow._xscale', 100);
    a.SetVariable('videowindow._yscale', 100);
    a.SetVariable('videowindow._x'     ,   6);
    a.SetVariable('videowindow._y'     ,  65);
    a.SetVariable('controller._x'      ,   6);
    a.SetVariable('inputArea._x'       ,   4);

    ['controller', 'inputArea', 'waku', 'header', 'tabmenu'].each(function (x) {
        a.SetVariable(x + '._visible', 1);
    });

	Element.setStyle(
        $('flvplayer_container'), {
            "width":"952px",
            "height":"540px",
            "padding":"4px",
            'position': 'relative'
        }
    );

    neee_elems.each(function (x) {
        Element.setStyle($(x), {"display": "block"})
    });

    window.onresize = function()  {  };
}

D("RUN!");
var ret;
try {
    if (neee_maximized) {
        // enable full screen
        D("ENABLE");
        enable_neee_fullscreen();
        window.onresize = function()  {  setTimeout(enable_neee_fullscreen, 1000);  };
    } else {
        D("DISABLE");
        disable_neee_fullscreen();
    }
    ret = "OK";
} catch (e) {
    D(e.description);
    ret = e.description;
}
ret
