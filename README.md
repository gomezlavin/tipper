# Pre-work - *Tipper*

**Tipper** is a tip calculator application for iOS.

Submitted by: **Santiago Gomez**

Time spent: **24** hours spent in total

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

<img src='http://i.imgur.com/CtvByAl.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

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
