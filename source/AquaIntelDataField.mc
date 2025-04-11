using Toybox.FitContributor as Fit;
using Toybox.ActivityRecording;
using Toybox.WatchUi;
using Toybox.Position;

import Toybox.Graphics;

class AquaIntelDataField extends WatchUi.DataField {

    private var _dataModel as DeviceDataModel;
    private var _session;

    const WATER_FIELD_ID = 1; 
    hidden var mWaterField; 

    var hr = 0;
    var time = 0;
    var loc = null;
    var water = 0;
    var distance = 0;
    var ascent = 0;

    function onPosition(info as Position.Info) as Void{
        var myLocation = info.position.toDegrees();
        System.println("Latitude: " + myLocation[0]); // e.g. 38.856147
        System.println("Longitude: " + myLocation[1]); // e.g -94.800953
    }

    // Initializes the new field in the activity file
    function initialize(dataModel as DeviceDataModel, session) {
        _session = session;
        _dataModel = dataModel;

        DataField.initialize();

        setupField(_session);
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
    }

    function setupField(session) {

        if( null == mWaterField ) {
            //Create the custom FIT data field we want to record.
            mWaterField = session.createField(
            "Water Consumed", 
            WATER_FIELD_ID,
            FitContributor.DATA_TYPE_UINT16, 
            { :mesgType=>Fit.MESG_TYPE_RECORD, :units=>"ml" }  
            );

            mWaterField.setData(0);
        }
    }

    function refreshActivityStats() {
        var activityInfo = Activity.getActivityInfo();
        if (activityInfo == null) {
            return;
        }

        if (activityInfo.currentHeartRate != null ) {
            hr = activityInfo.currentHeartRate;
        }

        if(activityInfo.currentLocation != null){
            loc = activityInfo.currentLocation.toDegrees();
        }

        if(activityInfo.elapsedTime != null){
            time = activityInfo.elapsedTime;
        }

        if(activityInfo.elapsedDistance != null){
            distance = activityInfo.elapsedDistance;
        }

        if(activityInfo.totalAscent != null){
            ascent = activityInfo.totalAscent;
        }

    }


    function compute(info) {
        var profile = _dataModel.getActiveProfile();

        if (_dataModel.isConnected() && (profile != null) ) {
            water = profile.getValue();
           
            if (water  != null)
            {
                //System.println("Temp is: " + temp);
                mWaterField.setData(water);
            }

        }

        refreshActivityStats();
    }
}
