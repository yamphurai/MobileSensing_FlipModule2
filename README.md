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
- In the AudioModel, you will now provide back to the user the array. When doing so, calculate the values of this new array by
  looping through the FFT magnitude array to take maxima of windows. Design the loop such that you can process 20 windows and these 20
  windows span all the data in the FFT magnitude array. (Also see diagram on next page)•
    - For example, if the magnitude buffer was 100 points long, each batch would be 100/20 = 5 points long. You would loop through the buffer
      in increments of 5 points, taking the max of each 5 point window.
    - Take the maximum in each window and save it to the array.
- Graph the 20 point array after you have filled it in by adding a graph using the MetalGraph class. This graph should be very similar to the FFT graph, but only 20 points
******************************************************************************************************************
Part 2: True Song Equalizer
- Stop sampling from the microphone. Instead, change the functionality of the program to show an equalizer of a song playing (like the RollingStones satisfaction song)
  instead of the microphone. Think about: what code do you truly need to change to make this happen? Be sure also that the song also plays on the speakers.
  Note:see page2 of PDF
******************************************************************************************************************
What to turn in:
• Team members name
• The Xcode project of the updated file (as a zipped/compressed file or GitHub link).
• Answer the questions posed above, upload as a text file in the Xcode project.
