//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! Show the text the user picked
class KeyboardView extends WatchUi.View {
    private var _dataModel as DeviceDataModel;

    private var _text as String = "Enter\nEstimated\nDuration\n(mins)";
    // private var _distance as String;
    // private var _elevation as String;
    private var _duration as String;
    private var _predicting = false;
    private var _done = true;

    //! Constructor
    public function initialize(dataModel as DeviceDataModel) {
        WatchUi.View.initialize();
        _dataModel = dataModel;
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
    }

    //! Restore the state of the app and prepare the view to be shown
    public function onShow() as Void {
    }

    //! Update the view
    //! @param dc Device context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        if (WatchUi has :TextPicker) {
            dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_SMALL, _text, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        } else {
            dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_SMALL, "TextPicker not\nsupported", Graphics.TEXT_JUSTIFY_CENTER);
        }

        if(_predicting){
            //get prediction here
            var profile = _dataModel.getActiveProfile();
            // profile.nullPrediction();
            profile.sendDurationData(_duration);
            var prediction = profile.getPrediction();

            // if(profile.getPrediction() == null){
            //     var progressBar = new WatchUi.ProgressBar("Calculating\nWater Intake...", null); // null for busy indicator
            //     WatchUi.pushView(
            //         progressBar,
            //         self,
            //         WatchUi.SLIDE_DOWN
            //     );
            // }
            // else {
            //     WatchUi.popView(WatchUi.SLIDE_DOWN);
            // }

            if(profile.getPrediction() == null){
                _text = "Calculating Your\nPrediction...";
                dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
                dc.clear();
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_SMALL, _text, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            }
            else{
            _text = "Your Prediction is:\n" + prediction + " ml";
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
            dc.clear();
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_SMALL, _text, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            
            _done = true;
            }
        }
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    public function onHide() as Void {
    }

    //! Set text to show
    //! @param text The text to show
    public function setText(text as String) as Void {
        _text = text;
    }

    public function setPredicting(bool as Boolean) as Void{
        _predicting = bool;
    }

    public function getDone() as Boolean{
        return _done;
    }

    public function saveText(text as String) as Void {
        _duration = text.toNumber();
        System.println("Duration " + _duration);
    }

}