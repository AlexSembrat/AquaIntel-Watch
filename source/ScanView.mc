//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.WatchUi;

class ScanView extends WatchUi.View {
    private var _scanDataModel as ScanDataModel;
    var background;
    var logo;

    //! Constructor
    //! @param scanDataModel The model containing the scan results
    public function initialize(scanDataModel as ScanDataModel) {
        View.initialize();

        _scanDataModel = scanDataModel;
        background = WatchUi.loadResource(Rez.Drawables.Mountains);
        logo = WatchUi.loadResource(Rez.Drawables.Logo);
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
        //setLayout( Rez.Layouts.Start( dc ) );
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    public function onShow() as Void {
    }

    //! Update the view
    //! @param dc Device context
    public function onUpdate(dc as Dc) as Void {
        var displayResult = _scanDataModel.getDisplayResult();

        // var str = "Device: " + _scanDataModel.getDisplayIndex() + "/" + _scanDataModel.getResultCount();

        // if (null != displayResult) {
        //     str += "\nName:\n" + displayResult.getDeviceName() + "\nRSSI: " + displayResult.getRssi() + " dbm";
        // }

        var str = "Scanning for Device";

         if (null != displayResult) {
            str = "AquaIntel Found!";
        }

        var strDimen = dc.getTextDimensions(str, Graphics.FONT_SMALL);
        var textOffset = dc.getHeight() / 2;
        textOffset -= strDimen[1] / 2;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.clear();

        // dc.drawBitmap(dc.getWidth() / 2, dc.getHeight() / 2, background);
        dc.drawBitmap(dc.getWidth() / 2 - 300, dc.getHeight() / 2 - 300, background);
        dc.drawBitmap(dc.getWidth() / 2 - 75, dc.getHeight() / 2 - 210, logo);
        dc.drawText(dc.getWidth() / 2, textOffset - 15, Graphics.FONT_SMALL, str, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth() / 2, textOffset + 50, Graphics.FONT_XTINY, "AquaIntel", Graphics.TEXT_JUSTIFY_CENTER);
        
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    public function onHide() as Void {
    }

    public function getH20(){
        var number = 1399-100;
        return number;
    }

}
