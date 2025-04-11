//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.WatchUi;
import Rez.Styles;

class DeviceDelegate extends WatchUi.BehaviorDelegate {
    private var _deviceDataModel as DeviceDataModel;
    private var _viewController as ViewController;
    private var _courseDataModel as CourseDataModel;

    //! Constructor
    //! @param deviceDataModel The device data model
    public function initialize(deviceDataModel as DeviceDataModel, viewController as ViewController, courseDataModel as CourseDataModel) {
        BehaviorDelegate.initialize();

        _deviceDataModel = deviceDataModel;
        _deviceDataModel.pair();
        _viewController = viewController;
        _courseDataModel = courseDataModel;
    }

    //! Handle the back behavior
    //! @return true if handled, false otherwise
    public function onBack() as Boolean {
        _deviceDataModel.unpair();
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }

    // use the select Start/Stop 
    public function onKey(evt) as Boolean 
    {
        var key = evt.getKey();
        System.println("Key: " + key.toString());
        if (WatchUi.KEY_START == key || WatchUi.KEY_ENTER == key) { 
            _viewController.pushActivityView(_deviceDataModel);
            return true;                                                 // return true for onSelect function
        }
        return false;
    } 

    public function onMenu() as Boolean {
        _viewController.pushKeyboardView();
        return true;
    }
}
