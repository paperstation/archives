//DEBUG STUFF
var escaper = encodeURIComponent || escape;
var decoder = decodeURIComponent || unescape;
window.onerror = function(msg, url, line, col, error) {
	var extra = !col ? '' : ' | column: ' + col;
	extra += !error ? '' : ' | error: ' + error;
	extra += !navigator.userAgent ? '' : ' | user agent: ' + navigator.userAgent;
	var debugLine = 'TOOLTIP Error: ' + msg + ' | url: ' + url + ' | line: ' + line + extra;
	window.location = '?action=ehjax&type=datum&datum=chatOutput&proc=debug&param[error]='+escaper(debugLine);
	return true;
};

var tooltip = {
	'mapControl': 'mapwindow.map',
	'tileSize': 32,
	'control': '',
	'params': {},
	'clientView': 0,
	'text': '',
	'theme': '',
	'padding': 2,
	'special': 'none',
	init: function(tileSize, control) {
		tooltip.tileSize = parseInt(tileSize);
		tooltip.control = control;
	},
	hide: function() {
		window.location = 'byond://winset?id='+tooltip.control+';is-visible=false';
	},
	updateCallback: function(map) {
		if (typeof map === 'undefined' || !map) {return false;}

		//alert(tooltip.params+' | '+tooltip.clientView+' | '+tooltip.text+' | '+tooltip.theme); //DEBUG

		//Some reset stuff to avoid fringe issues with sizing
		window.location = 'byond://winset?id='+tooltip.control+';anchor1=0,0;size=999x999';

		//Get the real icon size according to the client view
		var mapWidth 		= map['view-size'].x,
			mapHeight 		= map['view-size'].y,
			tilesShown 		= (tooltip.clientView * 2) + 1,
			realIconSize 	= mapWidth / tilesShown,
			resizeRatio		= realIconSize / tooltip.tileSize,
			//Calculate letterboxing offsets	
			leftOffset 		= (map.size.x - mapWidth) / 2,
			topOffset 		= (map.size.y - mapHeight) / 2;

		//alert(realIconSize + ' | ' +tooltip.tileSize + ' | ' + resizeRatio); //DEBUG

		//Parse out the tile and cursor locations from params (e.g. "icon-x=32;icon-y=29;screen-loc=3:10,15:29")
		var paramsA = tooltip.params.cursor.split(';');
		if (paramsA.length < 3) {return false;} //Sometimes screen-loc is never sent ahaha fuck you byond
		//icon-x
		var iconX = paramsA[0];
		iconX = iconX.split('=');
		iconX = parseInt(iconX[1]);
		//icon-y
		var iconY = paramsA[1];
		iconY = iconY.split('=');
		iconY = parseInt(iconY[1]);
		//screen-loc
		var screenLoc = paramsA[2];
		screenLoc = screenLoc.split('=');
		screenLoc = screenLoc[1].split(',');
		if (screenLoc.length < 2) {return false;}
		var left = screenLoc[0];
		var top = screenLoc[1];
		if (!left || !top) {return false;}
		screenLoc = left.split(':');
		left = parseInt(screenLoc[0]);
		var enteredX = parseInt(screenLoc[1]);
		screenLoc = top.split(':');
		top = parseInt(screenLoc[0]);
		var enteredY = parseInt(screenLoc[1]);

		//Screen loc offsets on objects (e.g. "WEST+0:6,NORTH-1:26") can royally mess with positioning depending on where the cursor enters
		//This is a giant bitch to parse. Note that it only expects screen_loc in the format <west>,<north>.
		var oScreenLoc = tooltip.params.screenLoc.split(','); //o for original ok

		var west = oScreenLoc[0].split(':');
		if (west.length > 1) { //Only if west has a pixel offset
			var westOffset = parseInt(west[1]);
			if (westOffset !== 0) {
				if ((iconX + westOffset) !== enteredX) { //Cursor entered on the offset tile
					left = left + (westOffset < 0 ? 1 : -1);
				}
				leftOffset = leftOffset + (westOffset * resizeRatio);
			}
		}

		if (oScreenLoc.length > 1) { //If north is given
			var north = oScreenLoc[1].split(':');
			if (north.length > 1) { //Only if north has a pixel offset
				var northOffset = parseInt(north[1]);
				if (northOffset !== 0) {
					if ((iconY + northOffset) === enteredY) { //Cursor entered on the original tile
						top--;
						topOffset = topOffset - ((tooltip.tileSize + northOffset) * resizeRatio);
					} else { //Cursor entered on the offset tile
						if (northOffset < 0) { //Offset southwards
							topOffset = topOffset - ((tooltip.tileSize + northOffset) * resizeRatio);
						} else { //Offset northwards
							top--;
							topOffset = topOffset - (northOffset * resizeRatio);
						}
					}
				}
			}
		}

		//Handle special cases (for fuck sake)
		if (tooltip.special !== 'none') {
			if (tooltip.special === 'pod') {
				top--; //Pods do some weird funky shit with view and well just trust me that this is needed
			} 
		}

		//Clamp values
		left = (left < 0 ? 0 : (left > tilesShown ? tilesShown : left));
		top = (top < 0 ? 0 : (top > tilesShown ? tilesShown : top));

		//Calculate where on the screen the popup should appear (below the hovered tile)
		var posX = Math.round(((left - 1) * realIconSize) + leftOffset + tooltip.padding); //-1 to position at the left of the target tile
		var posY = Math.round(((tilesShown - top + 1) * realIconSize) + topOffset + tooltip.padding); //+1 to position at the bottom of the target tile

		//alert(mapWidth+' | '+mapHeight+' | '+tilesShown+' | '+realIconSize+' | '+leftOffset+' | '+topOffset+' | '+left+' | '+top+' | '+posX+' | '+posY); //DEBUG

		$('body').attr('class', tooltip.theme);

		var $content = $('#content'),
			$wrap 	 = $('#wrap');
		$wrap.attr('style', '');
		$content.off('mouseover');
		$content.html(tooltip.text);

		$wrap.width($wrap.width() + 2); //Dumb hack to fix a bizarre sizing bug

		var docWidth	= $wrap.outerWidth(),
			docHeight	= $wrap.outerHeight();

		//Handle special flags
		if (tooltip.params.flags.length > 0) {
			var alignment = 'bottom';
			if ($.inArray('top', tooltip.params.flags) !== -1) { //TOOLTIP_TOP
				alignment = 'top';
				posY = (posY - docHeight) - realIconSize - (tooltip.padding * 2);
			}
			if ($.inArray('right', tooltip.params.flags) !== -1) { //TOOLTIP_RIGHT
				alignment = 'right';
				posX = posX + realIconSize;
				posY = posY - realIconSize;
			}
			if ($.inArray('left', tooltip.params.flags) !== -1) { //TOOLTIP_LEFT
				alignment = 'left';
				posX = posX - docWidth - (tooltip.padding * 2);
				posY = posY - realIconSize;
			}
			if ($.inArray('center', tooltip.params.flags) !== -1) { //TOOLTIP_CENTER
				if (alignment === 'bottom' || alignment === 'top') { //Horizontal centering
					posX = (posX + (realIconSize / 2)) - (docWidth / 2);
					if (posX < tooltip.padding) {
						posX = tooltip.padding;
					}
				} else { //Vertical centering
					var gap = realIconSize - docHeight;
					if (gap > 0) {
						posY = posY + (gap / 2);
					}
				}
			}
		}

		if (posY + docHeight > map.size.y) { //Is the bottom edge below the window? Snap it up if so
			posY = (posY - docHeight) - realIconSize - tooltip.padding;
		}
		if (posX + docWidth > map.size.x) { //Is the right edge outside the map area? Snap it back left if so
			posX = posX - ((posX + docWidth) - map.size.x) - (tooltip.padding * 2);
		}

		//Actually size, move and show the tooltip box
		window.location = 'byond://winset?id='+tooltip.control+';size='+docWidth+'x'+docHeight+';pos='+posX+','+posY+';is-visible=true';

		$content.on('mouseover', function() {
			tooltip.hide();
		});
	},
	update: function(params, clientView, text, theme, special) {
		//Assign our global object
		tooltip.params = $.parseJSON(params);
		tooltip.clientView = parseInt(clientView);
		tooltip.text = text;
		tooltip.theme = theme;
		tooltip.special = special;

		//Go get the map details
		window.location = 'byond://winget?callback=tooltip.updateCallback;id='+tooltip.mapControl+';property=size,view-size';
	},
};