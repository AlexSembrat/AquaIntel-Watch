//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.WatchUi;

class CourseView extends WatchUi.View {
    private var _courseDataModel as CourseDataModel;

    //! Constructor
    //! @param scanDataModel The model containing the scan results
    public function initialize(courseDataModel as CourseDataModel) {
        View.initialize();

        _courseDataModel = courseDataModel;
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
        var displayResult = _courseDataModel.getDisplayResult();

        // var str = "Course: " + _scanDataModel.getDisplayIndex() + "/" + _scanDataModel.getResultCount();

        var str = "Course ";

        if (null != displayResult) {
            str += "Name:\n" + displayResult.getName();
        }


        var strDimen = dc.getTextDimensions(str, Graphics.FONT_SMALL);
        var textOffset = dc.getHeight() / 2;
        textOffset -= strDimen[1] / 2;

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();
        dc.drawText(dc.getWidth() / 2, textOffset, Graphics.FONT_SMALL, str, Graphics.TEXT_JUSTIFY_CENTER);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    public function onHide() as Void {
    }

}
