//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.UserProfile;

class DeviceView extends WatchUi.View {
    private var _dataModel as DeviceDataModel;
    var background;
    var logo;
    //! Constructor
    //! @param dataModel The data to show
    public function initialize(dataModel as DeviceDataModel) {
        View.initialize();

        var profile = UserProfile.getProfile();
        System.println("The user was born in " + profile.birthYear);

        _dataModel = dataModel;

        background = WatchUi.loadResource(Rez.Drawables.Mountains);
        logo = WatchUi.loadResource(Rez.Drawables.Logo);
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        var statusString;
        var profile = _dataModel.getActiveProfile();


        if (_dataModel.isConnected() && (profile.getValue() != null)) {
            statusString = "Connected";
        } else {
            statusString = "Connecting...";
        }

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.clear();

        dc.drawBitmap(dc.getWidth() / 2 - 300, dc.getHeight() / 2 - 300, background);
        dc.drawBitmap(dc.getWidth() / 2 - 75, dc.getHeight() / 2 - 210, logo);

        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 - 15, Graphics.FONT_SMALL, statusString, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 + 50, Graphics.FONT_XTINY, "AquaIntel", Graphics.TEXT_JUSTIFY_CENTER);

        if (_dataModel.isConnected() && (profile != null) && (profile.getValue() != null)) {
            dc.drawText(dc.getWidth() /2 - 100, dc.getHeight() / 2 + 114, Graphics.FONT_XTINY, "H20", Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth() / 2 + 100, dc.getHeight() / 2 + 114, Graphics.FONT_XTINY, "Prediction", Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth() /2 - 100, dc.getHeight() / 2 + 80, Graphics.FONT_XTINY, getString(profile.getValue(),"%d"), Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth() / 2 + 100, dc.getHeight() / 2 + 80, Graphics.FONT_XTINY, getString(profile.getPrediction(),"%d"), Graphics.TEXT_JUSTIFY_CENTER);
        }
    }


    private function getGenderString(gender) {
        if (gender == UserProfile.GENDER_FEMALE) {
            return "Female";
        } else if (gender == UserProfile.GENDER_MALE) {
            return "Male";
        }
        return "Other";
    }

    private function getString(value as Numeric?, format as String){
        var label = "";
        if (value != null) {
            label += value.format(format);
            label += " ml";
        }
        return label;
    }

    //! Draw the indicator with the given bitmap and text
    //! @param dc Device context
    //! @param bitmap Identifier for a bitmap
    //! @param value The value
    //! @param format Formatting string for the value
    //! @param units The units for the value
    //! @param cell Which cell to place the indicator in
    private function drawIndicator(dc as Dc, bitmap as ResourceId, value as Numeric?, format as String, units as String, cell as Number) as Void {
        var gridOffset = dc.getFontHeight(Graphics.FONT_SMALL) + 15;
        var cellHeight = (dc.getHeight() - (2 * gridOffset)) / 2;

        var cellWidth;
        var cellY;
        var cellXOffset;

        if (cell < 3) {
            cellWidth = dc.getWidth() / 3;
            cellY = gridOffset;
            cellXOffset = 0;
        } else {
            cell = 1;
            cellXOffset = 0;
            cellWidth = dc.getWidth() / 3;
            cellY = gridOffset + cellHeight;
        }

        var cellX = cellXOffset + (cellWidth * cell);

        var image = WatchUi.loadResource(bitmap) as BitmapType;
        var label = "";
        if (value != null) {
            label += value.format(format);
        }

        var centerCellX = cellX + (cellWidth / 2);
        var imageOffset = centerCellX - (image.getWidth() / 2);

        dc.drawBitmap(imageOffset, cellY, image);
        dc.drawText(centerCellX, cellY + image.getHeight() - 5, Graphics.FONT_SYSTEM_XTINY, label, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerCellX, cellY + image.getHeight() + dc.getFontHeight(Graphics.FONT_SYSTEM_XTINY) - 8,
            Graphics.FONT_SYSTEM_XTINY, units, Graphics.TEXT_JUSTIFY_CENTER);

        // System.println()
    }
}
