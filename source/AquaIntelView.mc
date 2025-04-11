using Toybox.FitContributor as Fit;
using Toybox.ActivityRecording;
using Toybox.WatchUi;
import Toybox.Lang;

class AquaIntelView extends WatchUi.View {

    var activityRunning = false;
    var flowSensor = null;
    var activity_array = [];

    // Initializes the new field in the activity file
    public function initialize(dataModel as DeviceDataModel, session) {
        View.initialize();

        flowSensor = new AquaIntelDataField(dataModel, session); // set up new air exposure factor data field
    }

    public function onLayout(dc) as Void {
        setLayout( Rez.Layouts.Summary( dc ) );
    }

    // Update the field layout and display the field data
    public function onUpdate(dc) {
        //dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
        //dc.clear(); 
        // var activity = flowSensor.compute(Activity.getActivityInfo());
        flowSensor.compute(Activity.getActivityInfo());
        // activity_array.add(activity);

        var timeInSec = flowSensor.time/1000;
        

        var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$",[clockTime.hour, clockTime.min.format("%02d")]);

        var view = (View.findDrawableById("hr") as Toybox.WatchUi.Text);
        view.setText( Lang.format("$1$", [flowSensor.hr]) );
        view = (View.findDrawableById("water") as Toybox.WatchUi.Text);
        view.setText( Lang.format("$1$ ", [flowSensor.water]));
        view = (View.findDrawableById("distance") as Toybox.WatchUi.Text);
        view.setText( Lang.format("$1$ ", [flowSensor.distance.format("%d")]));
        view = (View.findDrawableById("timer") as Toybox.WatchUi.Text);
        view.setText( timeString);
        view = (View.findDrawableById("elevation") as Toybox.WatchUi.Text);
        view.setText( Lang.format("$1$ ", [flowSensor.ascent.format("%d")]));

        // var min = 12;
        // var sec = 15;
        // var timeString = Lang.format("$1$:$2$",[min, sec]);

        // var hr = 131;
        // var water = 473;
        // var distance = 759;
        // var elevation = 125;

        // var view = (View.findDrawableById("hr") as Toybox.WatchUi.Text);
        // view.setText( Lang.format("$1$", [hr]) );
        // view = (View.findDrawableById("water") as Toybox.WatchUi.Text);
        // view.setText( Lang.format("$1$ ", [water]));
        // view = (View.findDrawableById("distance") as Toybox.WatchUi.Text);
        // view.setText( Lang.format("$1$ ", [distance]));
        // view = (View.findDrawableById("timer") as Toybox.WatchUi.Text);
        // view.setText( timeString);
        // view = (View.findDrawableById("elevation") as Toybox.WatchUi.Text);
        // view.setText( Lang.format("$1$ ", [elevation]));

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    } 

    // called when this View is removed from the screen
    function onHide() {
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
            System.println("ID:" + id); 
        } else{
            id = "--";
        }
        return id.toString();
    }
}
