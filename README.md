# Pre-work - *Tipper*

**Tipper** is a tip calculator application for iOS.

Submitted by: **Santiago Gomez**

Time spent: **15** hours spent in total

## User Stories

The following **required** functionality is complete:

* [x] User can enter a bill amount, choose a tip percentage, and see the tip and total values.
* [x] Settings page to change the default tip percentage.

The following **optional** features are implemented:
* [x] UI animations
* [x] Remembering the bill amount across app restarts (if <10mins)
* [x] Using currency thousands separators.
* [x] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.

The following **additional** features are implemented:
- [x] Select specific currency symbol (I decided to implement this option instead of the locale-specific currency because I like the idea of being able to change the currency symbol without having to change your formatting settings)
- [x] Using a slider instead of a segmented control to give the user more freedom when choosing the tipping percentage
- [x] Using a slider to split the bill and tip equally, handy when going out with friends
- [x] Select color theme: Dark, light, blue and red
- [x] Adjust the status bar theme based on the app color theme
- [x] Input validation: users can't enter random keys when using the computer keyboard, can't enter more than one period, are restricted to a fixed number of digits on the bill and total fields, can't enter more than one zero and can't have preceding zeros to other digits
- [x] Bill field format: bill text field is also formatted with thousands separators
- [x] Created an app icon


## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/ZQ7l0js.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Building the app was really fun! Being used to Node and Javascript from my day to day work, it was really great to work with swift because it is really similar in terms of syntax.  I think that my main struggle was finding the correct attributes for each of the UI elements in the app.  Getting values from them or finding the right attribute to change a color was complicated since I didn't know what properties existed or not.  Since I added the feature to change the color theme, I had to go through many UI properties to get it working correctly.

It's good to come back to a compiling language, although at times I wish those let vs var warnings would leave me alone.  The one thing I didn't like about Swift was the way it handles colors.  I am very used to RGB or hex from web development, and having to convert all the colors to Swift's UI Color system was a pain.

Finally, another one of my main struggles was casting variables.  I am used to javascript's flexibility, and casting in Swift was sometimes not as intuitive as I thought it would be, sometimes requiring additional steps to get the desired value. E.g. reversing an Array gives you a ReverseCollection, which is no longer an array, so you have to cast it again if you want to re-assign it to an array.

## License

    Copyright [2016] [Santiago Gomez]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
