# Input-Framer

Framer module to easily turn your designs inputs into real inputs.

![Input Demo](img/input.gif)

## Add it in your Framer Studio project

### Install it with Framer Modules

<a href='https://open.framermodules.com/input-framer'>
  <img alt='Install with Framer Modules' src='https://www.framermodules.com/assets/badge@2x.png' width='160' height='40' />
</a>

### Or install it manually

- Download the project from github.
- Copy `input.coffee` and `keyboard.png` into `modules/` folder.
- Import it in Framer Studio by writing: `InputModule = require "input"`.

**Note:** `keyboard.png` is prepared for iPhone 7. If you want to use a different size, replace with your own image.

## How to use it

Export your assets as you would do normally, then create an input object and place it over your designed input. Done!
Remember that all parameters are optional.


```coffeescript
# Basic usage
InputModule = require "input"

input = new InputModule.Input
  setup: true # Change to true when positioning the input so you can see it
  y: 240 # y position
  x: 90  # x position
  width: 500
  height: 60
```

```coffeescript
# All options
InputModule = require "input"

input = new InputModule.Input
  setup: false # Change to true when positioning the input so you can see it
  virtualKeyboard: true # Enable or disable virtual keyboard for when viewing on computer
  placeholder: "Username" # Text visible before the user type
  placeholderColor: "#fff" # Color of the placeholder text
  text: "Some text" # Initial text in the input
  textColor: "#000" # Color of the input text
  type: "text" # Use any of the available HTML input types. Take into account that on the computer the same keyboard image will appear regarding the type used.
  backgroundColor: "transparent" # e.g. "#ffffff" or "blue"
  fontSize: 30 # Size in px
  fontFamily: "-apple-system" # Font family for placeholder and input text
  fontWeight: "500" # Font weight for placeholder and input text
  lineHeight: 1 # Line height in em
  tabIndex: 5 # Tab index for the input (default is 0)
  padding: 10 # Padding in px, multiple values are also supported via string, e.g. "10 5 16 2"
  autofocus: false # Change to true to enable autofocus
  goButton: false # Set true here in order to use "Go" instead of "Return" as button (only works on real devices)
  submit: false # Change to true if you want to enable form submission
  textarea: true # Use textarea instead of input
  letterSpacing: 0 # Letter spacing
  disabled: true # disable input (inactive)
  
  y: 240 # y position
  x: 90  # x position
  width: 500
  height: 60
```


#### Styling your input
You can style many properties directly on creation or from here

```coffeescript
input.style =
  fontSize: "30px"
  lineHeight: "30px"
  padding: "10px"
  color: "white"
  ...
```

#### Retrieving value of your input

You can access directly to `.value` property to get the value. For example to get the value on each key up you could do something like this...

```coffeescript
input.on "keyup", ->
  print @value
```

#### Focusing and Unfocusing the input via code

Imagine that you want to `focus` the input once you click "myButton", here is an example:

```coffeescript
myButton.on Events.Click, ->
  input.focus()
```  

Imagine that you want to `unfocus` the input once you press enter, here is an example:

```coffeescript
input.on 'keyup', (e) ->
  if e.keyCode == 13
    input.unfocus()
```

#### Focus and Blur(Unfocus) events

You can add your own custom actions using the `onFocus` and `onBlur` helpers.

```coffeescript
input.onFocus ->
  print "Input is focused and has the value: #{@value}"

input.onBlur ->
  print "Input lost focus"
```

#### Disable and Enable Input

```coffeescript
input.disable() // disable input (inactive)
input.enable() // enable input (active)
```


### [Advanced] Accessing original elements

The input layer is constructed of a form and an input field. You can always access those elements by accessing directly to the properties `input` and `form`.

Example:

```coffeescript
Events.wrap(someNiceInput.form).addEventListener "submit", ->
	print "The form was submitted"
someNiceInput.input.something...
```

## Usage Examples

Here you can find a nice project which combines this module with other modules to create a realtime chat app prototype using Firebase: [FramerJS-Firebase-Demo](https://github.com/charleswong28/FramerJS-Firebase-Demo/)

If you have done something cool and want to show it, just make a pull request to the project :)
