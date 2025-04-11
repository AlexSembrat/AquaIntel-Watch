//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.BluetoothLowEnergy;
import Toybox.Lang;
import Toybox.WatchUi;

class ViewController {
    private var _modelFactory as DataModelFactory;
    private var _scanResult as ScanResult;
    var session;


    //! Constructor
    //! @param modelFactory Factory to create models
    public function initialize(modelFactory as DataModelFactory) {
        _modelFactory = modelFactory;
    }

    //! Return the initial views for the app
    //! @return Array Pair [View, InputDelegate]
    public function getInitialView() as [Views] or [Views, InputDelegates] {
        var scanDataModel = _modelFactory.getScanDataModel();
        BluetoothLowEnergy.setScanState(BluetoothLowEnergy.SCAN_STATE_SCANNING);
        return [new $.ScanView(scanDataModel), new $.ScanDelegate(scanDataModel, self)] as Array<ScanView or ScanDelegate>;
    }

    //! Push the scan menu view
    public function pushScanMenu() as Void {
        WatchUi.pushView(new $.Rez.Menus.MainMenu(), new $.ScanMenuDelegate(), WatchUi.SLIDE_UP);
    }

    //! Push the course menu view
    public function pushCourseMenu() as Void {
        WatchUi.pushView(new $.Rez.Menus.MainMenu(), new $.CourseMenuDelegate(), WatchUi.SLIDE_UP);
    }

    //! Push the device view
    //! @param scanResult The scan result for the device view to push
    public function pushDeviceView(scanResult as ScanResult) as Void {
        var deviceDataModel = _modelFactory.getDeviceDataModel(scanResult);
        var courseDataModel = _modelFactory.getCourseDataModel();

        WatchUi.pushView(new $.DeviceView(deviceDataModel), new $.DeviceDelegate(deviceDataModel, self, courseDataModel), WatchUi.SLIDE_UP);
    }

    //! Push the device view
    //! @param scanResult The scan result for the device view to push
    public function pushCourseView(scanResult as ScanResult) as Void {
        var courseDataModel = _modelFactory.getCourseDataModel();

        WatchUi.pushView(new $.CourseView(courseDataModel), new $.CourseDelegate(courseDataModel, self), WatchUi.SLIDE_UP);
    }

     //! Push the device view
    //! @param scanResult The scan result for the device view to push
    public function pushKeyboardView() as Void {
        var deviceDataModel = _modelFactory.getDeviceDataModel(_scanResult);
        var view = new $.KeyboardView(deviceDataModel);
        var delegate = new $.KeyboardDelegate(view,self);

        WatchUi.pushView(view, delegate, WatchUi.SLIDE_UP);
    }

    public function pushActivityView(deviceDataModel) as Void
    {
        if (Toybox has :ActivityRecording) {                         // check device for activity recording
            if ((session == null) || (session.isRecording() == false)) { 
                System.println("Start activity recording!!");
                session = ActivityRecording.createSession({          // set up recording session
                        :name=>"AquaIntel Hike",                              // set session name
                        :sport=>Activity.SPORT_HIKING,                // set sport type
                        :subSport=>Activity.SUB_SPORT_GENERIC         
                });
                session.start();                                             // call start session
            }
        }

        var v = new $.AquaIntelView(deviceDataModel, session);
        WatchUi.pushView(v, new $.AquaIntelDelegate(deviceDataModel, session, self), WatchUi.SLIDE_UP);
    }
}
