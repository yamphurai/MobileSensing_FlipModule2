# MobileSensing_FlipModule2

- use lazy instantiation whenever possible
- deallocate any memory properly
  
Part 1: Table It
- Update the code to use a UITableViewController as the main entry point of the app. It's fine to use static cells
  When you click on the top cell, it should open the original ViewController (the previous entry point).
- Pause the audioManager object when leaving the view controller. Then start playing again (if needed) once the view controller
  is navigated to again by the user. Think critically about where to call these functions in terms of the view controller life cycle.
  You may need to write additional code in the AudioModel class to achieve the desired result.
******************************************************************************************************************
Part 2: Equalize It
- Add another graph to the view that is 20 points long
- Add another property to the AudioModel class that is a length 20 array. This array can be a computed property if you want.
- Update the code to use a UITableViewController as the main entry point of the app. It's fine to use static cells
  When you click on the top cell, it should open the original ViewController (the previous entry point).
- Pause the audioManager object when leaving the view controller. Then start playing again (if needed) once the view controller
  is navigated to again by the user. Think critically about where to call these functions in terms of the view controller life cycle.
  You may need to write additional code in the AudioModel class to achieve the desired result.
