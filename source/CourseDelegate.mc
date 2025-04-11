//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.WatchUi;

class CourseDelegate extends WatchUi.BehaviorDelegate {
    private var _courseDataModel as CourseDataModel;
    private var _viewController as ViewController;

    //! Constructor
    //! @param courseDataModel The model containing the course results
    //! @param viewController Object that controls pushing new views
    public function initialize(courseDataModel as CourseDataModel, viewController as ViewController) {
        BehaviorDelegate.initialize();

        _courseDataModel = courseDataModel;
        _viewController = viewController;
    }

    //! Handle menu button press
    //! @return true if handled, false otherwise
    public function onMenu() as Boolean {
        _viewController.pushCourseMenu();
        return true;
    }

    //! Handle the select action
    //! @return true if handled, false otherwise
    public function onSelect() as Boolean {
        var displayResult = _courseDataModel.getDisplayResult();
        if (null != displayResult) {
            _viewController.pushDeviceView(displayResult);
        }
        return true;
    }

    //! Handle next page behavior
    //! @return true if handled, false otherwise
    public function onNextPage() as Boolean {
        _courseDataModel.nextResult();
        return true;
    }

    //! Handle previous page behavior
    //! @return true if handled, false otherwise
    public function onPreviousPage() as Boolean {
        _courseDataModel.previousResult();
        return true;
    }
}
