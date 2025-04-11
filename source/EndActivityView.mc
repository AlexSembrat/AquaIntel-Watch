using Toybox.ActivityRecording;
using Toybox.WatchUi;
using Toybox.System;

class EndActivityView extends WatchUi.View {
    var time;
    var _averageHR;
    var _loc = null;
    var _water = 0;
    var _distance = 0;
    var _ascent = 0;

    // Initializes the new field in the activity file
    public function initialize(duration, water, distance, elevation, averageHR) {
        View.initialize();
        time = duration;
        _water = water;
        _distance = distance;
        _ascent = elevation;
        _averageHR = averageHR;
    }

    public function onLayout(dc) as Void {
        setLayout( Rez.Layouts.Score( dc ) );
    }

    // Update the field layout and display the field data
    public function onUpdate(dc) {  
        var view = (View.findDrawableById("water") as Toybox.WatchUi.Text);
        view.setText( Lang.format("$1$ ", [_water]) );
        view = (View.findDrawableById("time") as Toybox.WatchUi.Text);
        var total_seconds = time / 1000;
        var minutes = total_seconds / 60;
        var seconds = total_seconds % 60;
        var timeString = Lang.format("$1$:$2$",[minutes, seconds.format("%02d")]);
        view.setText(timeString);
        view = (View.findDrawableById("distance") as Toybox.WatchUi.Text);
        view.setText( Lang.format("$1$ ", [_distance.format("%d") ]));
        view = (View.findDrawableById("elevation") as Toybox.WatchUi.Text);
        view.setText( Lang.format("$1$ ", [_ascent.format("%d") ]));
        view = (View.findDrawableById("hr") as Toybox.WatchUi.Text);
        view.setText( Lang.format("$1$ ", [_averageHR.format("%d") ]));

        // var water = 859;
        // var min = 52;
        // var sec = 30;
        // var distance = 976;
        // var ascent = 130;
        // var averageHR = 129;


        // var view = (View.findDrawableById("water") as Toybox.WatchUi.Text);
        // view.setText( Lang.format("$1$ ", [water]) );
        // view = (View.findDrawableById("time") as Toybox.WatchUi.Text);
        // var total_seconds = time / 1000;
        // var minutes = total_seconds / 60;
        // var seconds = total_seconds % 60;
        // var timeString = Lang.format("$1$:$2$",[min, sec]);
        // view.setText(timeString);
        // view = (View.findDrawableById("distance") as Toybox.WatchUi.Text);
        // view.setText( Lang.format("$1$ ", [distance ]));
        // view = (View.findDrawableById("elevation") as Toybox.WatchUi.Text);
        // view.setText( Lang.format("$1$ ", [ascent]));
        // view = (View.findDrawableById("hr") as Toybox.WatchUi.Text);
        // view.setText( Lang.format("$1$ ", [averageHR ]));

        View.onUpdate(dc);
    } 
}
