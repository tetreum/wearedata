/**
 * 
 */
FlashObject=function(){function e(e,t){return Array.prototype.slice.call(e,t||0)}function t(t){this.cfg=e(arguments)}var n=t.prototype;return n.init=function(){swfobject.embedSWF.apply(swfobject,this.cfg)},n.onReady=function(){this.isReady=!0},n.onProgress=function(e){},n.onLoaded=function(){this.isLoaded=!0},t}()