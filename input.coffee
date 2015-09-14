exports.keyboardLayer = new Layer
	x:0, y:Screen.height, width:750, height:432, image:"modules/keyboard.png"

exports.keyboardLayer.states.add
	"shown": y: Screen.height - exports.keyboardLayer.height

exports.keyboardLayer.states.animationOptions =
	curve: "spring(500,50,15)"

class exports.Input extends Layer
	@define "style",
		get: -> @input.style
		set: (value) ->
			_.extend @input.style, value

	@define "value",
		get: -> @input.value
		set: (value) ->
			@input.value = value

	constructor: (options = {}) ->
		options.setup ?= false
		options.width ?= Screen.width
		options.clip ?= false
		options.height ?= 60
		options.backgroundColor ?= if options.setup then "rgba(255, 60, 47, .5)" else "transparent"
		options.fontSize ?= 30
		options.lineHeight ?= 30
		options.padding ?= 10
		options.text ?= ""
		options.placeholder ?= ""
		options.virtualKeyboard ?= if Utils.isMobile() then false else true
		options.type ?= "text"
		options.goButton ?= false

		super options

		@placeholderColor = options.placeholderColor if options.placeholderColor?
		@input = document.createElement "input"
		@input.id = "input-#{_.now()}"
		@input.style.cssText = "font-size: #{options.fontSize}px; line-height: #{options.lineHeight}px; padding: #{options.padding}px; width: #{options.width}px; height: #{options.height}px; border: none; outline-width: 0; background-image: url(about:blank); background-color: #{options.backgroundColor};"
		@input.value = options.text
		@input.type = options.type
		@input.placeholder = options.placeholder
		@form = document.createElement "form"

		if options.goButton
			@form.action = "#"
			@form.addEventListener "submit", (event) ->
				event.preventDefault()

		@form.appendChild @input
		@_element.appendChild @form

		@backgroundColor = "transparent"
		@updatePlaceholderColor options.placeholderColor if @placeholderColor

		if !Utils.isMobile() || options.virtualKeyboard
			@input.addEventListener "focus", ->
				exports.keyboardLayer.bringToFront()
				exports.keyboardLayer.states.next()
			@input.addEventListener "blur", ->
				exports.keyboardLayer.states.switch "default"

	updatePlaceholderColor: (color) ->
		@placeholderColor = color
		if @pageStyle?
			document.head.removeChild @pageStyle
		@pageStyle = document.createElement "style"
		@pageStyle.type = "text/css"
		css = "##{@input.id}::-webkit-input-placeholder { color: #{@placeholderColor}; }"
		@pageStyle.appendChild(document.createTextNode css)
		document.head.appendChild @pageStyle

	focus: () ->
		@input.focus()
