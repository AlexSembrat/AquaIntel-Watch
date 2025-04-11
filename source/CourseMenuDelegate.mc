import Toybox.PersistedContent;
import Toybox.Lang;
import Toybox.WatchUi;

class CourseMenuDelegate extends WatchUi.MenuInputDelegate {

    var _courses;

    //! Constructor
    public function initialize() {
        MenuInputDelegate.initialize();
        // Retrieve the list of courses stored on the watch.
        _courses = PersistedContent.getCourses();
    }

    //! Return the number of menu items.
    //! If no courses are stored, we return 1 to display the "No Courses" item.
    public function getItemCount() as Number {
        if (_courses == null || _courses.length == 0) {
            return 1;
        }
        return _courses.length;
    }

    //! Return the text for a given menu item.
    //! When no courses exist, return "No Courses"; otherwise, return the course name.
    public function getItemText(index as Number) as String {
        if (_courses == null || _courses.length == 0) {
            return "No Courses";
        }
        // Assuming each course object has a 'name' property.
        return _courses[index].name;
    }

    //! Handle a menu item being chosen.
    //! For the "No Courses" case, there is nothing to do.
    public function onMenuItem(index as Number) as Void {
        if (_courses == null || _courses.length == 0) {
            // Nothing to select if there are no courses.
            return;
        }
        // var selectedCourse = _courses[index];
        // Add your handling logic here (e.g. display course details or start navigation)
    }
}