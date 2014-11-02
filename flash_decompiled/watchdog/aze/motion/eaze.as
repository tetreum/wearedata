package aze.motion {

    public function eaze(target:Object):EazeTween{
        return (new EazeTween(target));
    }
    PropertyTint.register();
    PropertyFrame.register();
    PropertyFilter.register();
    PropertyVolume.register();
    PropertyColorMatrix.register();
    PropertyBezier.register();
    PropertyShortRotation.register();
    var _local1:* = PropertyRect.register();
    return (_local1);
}//package aze.motion 
