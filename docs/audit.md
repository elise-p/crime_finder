audit link w/ screenshots: https://docs.google.com/document/d/1E0tidns7lzfW_Pf7RWPX-lJVE4WFJics-DHcssf8Bic/edit?usp=sharing

Crime Finder App: Accessibility Audit

Background Information
Developer: Group 2 (multiple developers)
Audit by: Rohan Simon Shanthanu 
Audit Conducted: 7:30 PM at the Microsoft Campus (May 29), Redmond WA
Device and Device Settings: Android Emulator 
Commit id: d32ea52b


What the App Does Well
Robustness Feature #1

The transition between the three windows of the application was very smooth. Despite attempts to overwhelm the application with back-to-back switches between windows, there was no slow down or lag. Zooming in and out of the map was also very robust. You can zoom all the way out and move through the map UI without any slow down. I also tried to pin a very large number of locations, trying to see if that would affect the performance of the application. I saw no visual difference in performance as the number of pins increased.


What the App Doesn’t Do Well
Accessibility Issue #1
Description:  Low Color Contrast for the Pinned Location Title
Testing Method: WebAim Contrast Checker and color picker
Evidence: Guideline violated: 1.4.3 Contrast (Minimum)

Alt Text: Pinned Locations window in app. There is a heading with a red background at the very top, with white text that says ‘Crime Finder.’ Under it there is a large light purple area with prompts for the user to enter a name for a location. The UI has a bar on the bottom that includes three icons and corresponding text saying Map, Crime List, and Pinned Locations

Explanation: The accessibility issue violates success criterion 1.4.3 Contrast(Minimum) as the color contrast between the white title text and the red header bar at the top of the application has a contrast ratio of 3.69:1, which is under the 4.5:1 minimum as proposed by the guideline. This can cause issues for those with visual impairments, like those with color blindness or low vision, as it’ll obstruct them from understanding what the current UI represents.

Severity Rating: 1

Justification:
The frequency is low as only a single text element has a contrast issue with the background. The impact is low as the ‘Crime Finder’ acts as a title for the entire app and therefore does not provide any extra information about the app functionality. The persistence is high as there is no way to work around the problem. The text will always be low contrast. However, because it is only a cosmetic with no functionality, the overall severity is very low. 
Possible Solution: You could darken the red background to create more contrast with the white text. Another possible solution would be to bold the text of increase the font size, which only needs to have a 3:1 contrast according to the WCAG guidelines.


Accessibility Issue #2
Description:  Low Color Contrast Between Crime Tiles and Bottom App Bar
Testing Method: WebAim Contrast Checker and color picker
Evidence: Guideline violated: 1.4.11 Non-text Contrast


Alt Text: Crime Finder window in app. There is a heading with a red background at the very top, with white text that says ‘Crime Finder.’ Under it there are multiple light red tiles, each with a red border. There is a bar at the bottom of the UI, which is pink. It includes three icons and corresponding text saying Map, Crime List, and Pinned Locations

Explanation: The accessibility issue violates success criterion 1.4.11 as the color contrast between the tile border (red) with the light red app bar is very low. The contrast color ratio is 2.61:1, which is under the 4.5:1 minimum as proposed by the guideline. This can cause issues for those with visual impairments, like those with color blindness or low vision, as i ll obstruct them from being able to identify the location of the bottom app bar within the entire UI. This may cause confusion for these demographics of users when using the app, barring them from easily accessing all of the app’s functionality.

Severity Rating: 3

Justification: The frequency is high as everytime the tiles fill the middle space in the Crime List window, there is a possibility that one of the tiles will overlap with the app bar, therefore causing the issue with the color contrast. The impact is moderately high, as when the tiles overlap with the bar, it is hard to change the positioning of the tiles. Thus, in this case, people with vision deficiencies won’t be able to identify the app bar and use it effectively. The persistence is medium. The only workaround is when there are enough crime tiles to scroll down. If you scroll down correctly the tile will no longer overlap with the app bar, and the contrast issue is avoided. 

Possible Solution: Change the color of the app bar to a different hue. Although the red is a thematic decision for the entire app, overuse of the color can lead to contrast issues as seen here. 

Accessibility Issue #3 and Onward

Description:  No Accurate Labels on Any of the Application
Testing Method: Android Screen Reader
Evidence: Guideline violated: all WCAG screen reader guidelines

All screen reader labels on the UI are at the default. For example, clicking any of the buttons at the bottom app bar simply reads out the label ‘button’ without any information on the function. Moreover, there are no labels for the text-entry box of the Pinned location window and on the map view. The tiles on the Crime list do read out the text but they don’t mention the organization of the information

Severity Rating: 4

Justification: Frequency is very high as explained above. Impact is very high as those who use screen readers have no way to understand what the UI elements fo. Persistence is also very high. There is no work around.

Possible Solution: Add semantic labels to everything. 





