# MIDI Liveliness
This is a Reascript that will take active MIDI notes in Reaper and attempt
to make them feel less programmed and more real by randomly adjusting
velocity and slightly tweaking note 
position.

## Usage
### Dependencies
To use this script, first install the following dependencies:
* ReaPack - downloaded from the [ReaPack website](https://reapack.com/)
* [Lokasenna’s GUI library v2 for Lua](https://github.com/jalovatt/Lokasenna_GUI) - install via ReaPack

### Usage
Follow these steps to run the script in Reaper:
* Have MIDI editor opened and notes highlighted
* Click on the main Reaper window and enter the keyboard shortcut ? to bring up the action menu
* Choose "ReaScript: Run ReaScript (EEL2 or lua)..."
* Navigate to the directory you cloned the repo to and choose the `midi_liveliness.lua` file
* Enter your settings as shown below


Midi notes before using this script:

![alt text](https://github.com/dschuler36/midi-liveliness/blob/main/images/before.PNG)

Using the script:

![alt text](https://github.com/dschuler36/midi-liveliness/blob/main/images/settings.PNG)

Results:

![alt text](https://github.com/dschuler36/midi-liveliness/blob/main/images/after.PNG)