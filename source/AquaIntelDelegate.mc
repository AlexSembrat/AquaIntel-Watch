using Toybox.FitContributor as Fit;

using Toybox.System;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
using Toybox.ActivityMonitor as ActivityMonitor;
using Toybox.Activity as Activity;
using Toybox.UserProfile;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Communications;

class AquaIntelDelegate extends WatchUi.BehaviorDelegate {
    private var _session;
    private var _dataModel;
    
    const WATER_FIELD_ID = 1; 
    hidden var mWaterField; 

    var hr = 0;
    var time = 0;
    var loc = null;
    var water = 0;
    var distance = 0;
    var ascent = 0;

    //! Constructor
    //! @param deviceDataModel The device data model
    public function initialize(dataModel as DeviceDataModel, session,  viewController as ViewController) 
    {       
        BehaviorDelegate.initialize();

        _dataModel = dataModel;
        _session = session;
       // _viewController = viewController;

    }

    // The average heart rate during the current activity in beats per minute (bpm).
    function getAverageActivityHr() {
        var hr = 0;
        var activityInfo = Activity.getActivityInfo();
        if (activityInfo != null) {
            if (activityInfo.averageHeartRate != null ) {
                hr = activityInfo.averageHeartRate;
            }
        }
        return hr;
    }

    // Elapsed time of the current activity in milliseconds (ms).
    function getDuration(){
        time = 0;
        var activityInfo = Activity.getActivityInfo();
        if (activityInfo != null) {
            if (activityInfo.elapsedTime != null ) {
                time = activityInfo.elapsedTime;
            }
        }
        return time;
    }

    function getDistance(){
        distance = 0;
        var activityInfo = Activity.getActivityInfo();
        if (activityInfo != null) {
            if (activityInfo.elapsedDistance != null ) {
                distance = activityInfo.elapsedDistance;
            }
        }
        return distance;
    }

    function getElevation(){
        ascent = 0;
        var activityInfo = Activity.getActivityInfo();
        if (activityInfo != null) {
            if (activityInfo.totalAscent != null ) {
                ascent = activityInfo.totalAscent;
            }
        }
        return ascent;
    }

    function getWater(){
        var profile = _dataModel.getActiveProfile();
        water = profile.getValue();
        return water;
    }

    // The starting time of the current activity. 
    function getStartTime(){
        var date = 0;
        var activityInfo = Activity.getActivityInfo();
        if (activityInfo != null) {
            if (activityInfo.startTime != null ) {
                var moment = activityInfo.startTime;
                date = moment.value(); //Get the UTC value of a Moment.
            }
        }
        return date;
    }

    // A unique alphanumeric device identifier
    function getId()
    {
        var mySettings = System.getDeviceSettings();
        var id = mySettings.uniqueIdentifier;
        if (id != null) {
            System.println("ID" + id); 
        } else{
            id = "--";
        }
        return id.toString();
    }

    // if the Start/Enter key is pressed
    function onKey(evt) as Boolean 
    {
        var key = evt.getKey();
        if (WatchUi.KEY_START == key || WatchUi.KEY_ENTER == key) { 
            System.println("Stop activity recording!!");
            
            var v = new $.EndActivityView(getDuration(),getWater(),getDistance(),getElevation(),getAverageActivityHr());
            _session.stop();                                      // stop the session
            _session.save();                                      // save the session
            _session = null;   // set session control variable to null
            WatchUi.pushView(v, new $.EndActivityDelegate(), WatchUi.SLIDE_UP);
            return true;    
        }
        return false;
    }
}