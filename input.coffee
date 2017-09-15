exports.keyboardLayer = new Layer
	x:0, y:Screen.height, width:Screen.width, height:432
	html:"<img style='width: 100%;' src='modules/keyboard.png'/>"

#screen width vs. size of image width
growthRatio = Screen.width / 732
imageHeight = growthRatio * 432

# Extends the LayerStyle class which does the pixel ratio calculations in framer
_inputStyle =
	Object.assign({}, Framer.LayerStyle,
		calculatePixelRatio = (layer, value) ->
			(value * layer.context.pixelMultiplier) + "px"

		fontSize: (layer) ->
			calculatePixelRatio(layer, layer._properties.fontSize)

		lineHeight: (layer) ->
			(layer._properties.lineHeight) + "em"

		padding: (layer) ->
			{ pixelMultiplier } = layer.context
			padding = []
			paddingValue = layer._properties.padding

			# Check if we have a single number as integer
			if Number.isInteger(paddingValue)
				return calculatePixelRatio(layer, paddingValue)

			# If we have multiple values they come as string (e.g. "1 2 3 4")
			paddingValues = layer._properties.padding.split(" ")

			switch paddingValues.length
				when 4
					padding.top = parseFloat(paddingValues[0])
					padding.right = parseFloat(paddingValues[1])
					padding.bottom = parseFloat(paddingValues[2])
					padding.left = parseFloat(paddingValues[3])

				when 3
					padding.top = parseFloat(paddingValues[0])
					padding.right = parseFloat(paddingValues[1])
					padding.bottom = parseFloat(paddingValues[2])
					padding.left = parseFloat(paddingValues[1])

				when 2
					padding.top = parseFloat(paddingValues[0])
					padding.right = parseFloat(paddingValues[1])
					padding.bottom = parseFloat(paddingValues[0])
					padding.left = parseFloat(paddingValues[1])

				else
					padding.top = parseFloat(paddingValues[0])
					padding.right = parseFloat(paddingValues[0])
					padding.bottom = parseFloat(paddingValues[0])
					padding.left = parseFloat(paddingValues[0])

			# Return as 4-value string (e.g "1px 2px 3px 4px")
			"#{padding.top * pixelMultiplier}px #{padding.right * pixelMultiplier}px #{padding.bottom * pixelMultiplier}px #{padding.left * pixelMultiplier}px"
	)

exports.keyboardLayer.states =
	shown:
		y: Screen.height - imageHeight

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
		options.lineHeight ?= 1
		options.padding ?= 10
		options.text ?= ""
		options.placeholder ?= ""
		options.virtualKeyboard ?= if Utils.isMobile() then false else true
		options.type ?= "text"
		options.goButton ?= false
		options.autoCorrect ?= "on"
		options.autoComplete ?= "on"
		options.autoCapitalize ?= "on"
		options.spellCheck ?= "on"
		options.autofocus ?= false
		options.textColor ?= "#000"
		options.fontFamily ?= "-apple-system"
		options.fontWeight ?= "500"
		options.submit ?= false
		options.tabIndex ?= 0

		super options

		# Add additional properties
		@_properties.fontSize = options.fontSize
		@_properties.lineHeight = options.lineHeight
		@_properties.padding = options.padding

		@placeholderColor = options.placeholderColor if options.placeholderColor?
		@input = document.createElement "input"
		@input.id = "input-#{_.now()}"

		# Add styling to the input element
		@input.style.width = _inputStyle["width"](@)
		@input.style.height = _inputStyle["height"](@)
		@input.style.fontSize = _inputStyle["fontSize"](@)
		@input.style.lineHeight = _inputStyle["lineHeight"](@)
		@input.style.outline = "none"
		@input.style.border = "none"
		@input.style.backgroundColor = options.backgroundColor
		@input.style.padding = _inputStyle["padding"](@)
		@input.style.fontFamily = options.fontFamily
		@input.style.color = options.textColor
		@input.style.fontWeight = options.fontWeight

		@input.value = options.text
		@input.type = options.type
		@input.placeholder = options.placeholder
		@input.setAttribute "tabindex", options.tabindex
		@input.setAttribute "autocorrect", options.autoCorrect
		@input.setAttribute "autocomplete", options.autoComplete
		@input.setAttribute "autocapitalize", options.autoCapitalize
		if options.autofocus == true
			@input.setAttribute "autofocus", true
		@input.setAttribute "spellcheck", options.spellCheck
		@form = document.createElement "form"

		if (options.goButton && !options.submit) || !options.submit
			@form.action = "#"
			@form.addEventListener "submit", (event) ->
				event.preventDefault()

		@form.appendChild @input
		@_element.appendChild @form

		@backgroundColor = "transparent"
		@updatePlaceholderColor options.placeholderColor if @placeholderColor

		#only show honor virtual keyboard option when not on mobile,
		#otherwise ignore
		if !Utils.isMobile() && options.virtualKeyboard is true
			@input.addEventListener "focus", ->
				exports.keyboardLayer.bringToFront()
				exports.keyboardLayer.stateCycle()
			@input.addEventListener "blur", ->
				exports.keyboardLayer.animate("default")

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

	onFocus: (cb) ->
		@input.addEventListener "focus", ->
			cb.apply(@)

	onBlur: (cb) ->
		@input.addEventListener "blur", ->
			cb.apply(@)
