import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

import Rez.Styles;

class EndActivityDelegate extends  WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    public function onBack() as Boolean
    {
        System.println("Exit app");
        System.exit();
        return true;
    }

}