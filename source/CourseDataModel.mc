//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.BluetoothLowEnergy;
import Toybox.Lang;
import Toybox.WatchUi;

class CourseDataModel {
    private var _displayResult;
    private var _courseResults;

    //! Constructor
    //! @param bleDelegate The BLE delegate for this model
    public function initialize() {
        _courseResults = PersistedContent.getCourses();
    }

    //! Update display to next result
    public function nextResult() as Void {
        if (_courseResults != null) {
            _displayResult = _courseResults.next();
            WatchUi.requestUpdate();
        }
    }

    //! Update display to previous result
    public function previousResult() as Void {
        if (_courseResults != null) {
            _displayResult = _courseResults.next();
            WatchUi.requestUpdate();
        }
    }

    //! Get the current scan result
    //! @return The current scan result
    public function getDisplayResult() {
        if (_courseResults == null) {
            return null;
        }

        return _displayResult;
    }

    //! Get the current display index
    //! @return The display index
    public function getDisplayIndex() as Number {
        if (_courseResults.size() == 0) {
            return 0;
        }

        return _displayResult + 1;
    }

    //! Get the number of scan results
    //! @return The number of scan results
    public function getResultCount() as Number {
        return _courseResults.size();
    }
}
