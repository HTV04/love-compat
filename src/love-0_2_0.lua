--[[
LOVE 0.2.0 Compatibility Module v1.0.0
Developed by HTV04

TODO:
* Examine functions in more situations
  * For example, look for unintentional or undocumented behavior
* Functions need better errors

* graphics:drawLine has a minimum width of 1, how is that enforced (error or set to minimum)?
* Check if graphics:setColorMode errors out with an invalid color mode

* Fix mouse wheel input
--]]

-- Cached objects
local math = math
local table = table
local unpack = unpack or table.unpack

local love = love

local anim8
local ripple

-- Local variables
local filters = {
	align = {"left", "right", "center"},
	blend = {[0] = "alpha", "add"},

	key = {
		["unknown"] = 0, -- key_unknown
		["backspace"] = 8, -- key_backspace
		["tab"] = 9, -- key_tab
		["clear"] = 12, -- key_clear
		["return"] = 13, -- key_return
		["pause"] = 19, -- key_pause
		["escape"] = 27, -- key_escape
		["space"] = 32, -- key_space
		["!"] = 33, -- key_exclaim
		["\""] = 34, -- key_quotedbl
		["#"] = 35, -- key_hash
		["$"] = 36, -- key_dollar
		["&"] = 38, -- key_ampersand
		["'"] = 39, -- key_quote
		["("] = 40, -- key_leftparen
		[")"] = 41, -- key_rightparen
		["*"] = 42, -- key_asterisk
		["+"] = 43, -- key_plus
		[","] = 44, -- key_comma
		["-"] = 45, -- key_minus
		["."] = 46, -- key_period
		["/"] = 47, -- key_slash
		["0"] = 48, -- key_0
		["1"] = 49, -- key_1
		["2"] = 50, -- key_2
		["3"] = 51, -- key_3
		["4"] = 52, -- key_4
		["5"] = 53, -- key_5
		["6"] = 54, -- key_6
		["7"] = 55, -- key_7
		["8"] = 56, -- key_8
		["9"] = 57, -- key_9
		[":"] = 58, -- key_colon
		[";"] = 59, -- key_semicolon
		["<"] = 60, -- key_less
		["="] = 61, -- key_equals
		[">"] = 62, -- key_greater
		["?"] = 63, -- key_question
		["@"] = 64, -- key_at

		["["] = 91, -- key_leftbracket
		["\\"] = 92, -- key_backslash
		["]"] = 93, -- key_rightbracket
		["^"] = 94, -- key_caret
		["_"] = 95, -- key_underscore
		["`"] = 96, -- key_backquote
		["a"] = 97, -- key_a
		["b"] = 98, -- key_b
		["c"] = 99, -- key_c
		["d"] = 100, -- key_d
		["e"] = 101, -- key_e
		["f"] = 102, -- key_f
		["g"] = 103, -- key_g
		["h"] = 104, -- key_h
		["i"] = 105, -- key_i
		["j"] = 106, -- key_j
		["k"] = 107, -- key_k
		["l"] = 108, -- key_l
		["m"] = 109, -- key_m
		["n"] = 110, -- key_n
		["o"] = 111, -- key_o
		["p"] = 112, -- key_p
		["q"] = 113, -- key_q
		["r"] = 114, -- key_r
		["s"] = 115, -- key_s
		["t"] = 116, -- key_t
		["u"] = 117, -- key_u
		["v"] = 118, -- key_v
		["w"] = 119, -- key_w
		["x"] = 120, -- key_x
		["y"] = 121, -- key_y
		["z"] = 122, -- key_z
		["delete"] = 127, -- key_delete

		["kp0"] = 256, -- key_kp0
		["kp1"] = 257, -- key_kp1
		["kp2"] = 258, -- key_kp2
		["kp3"] = 259, -- key_kp3
		["kp4"] = 260, -- key_kp4
		["kp5"] = 261, -- key_kp5
		["kp6"] = 262, -- key_kp6
		["kp7"] = 263, -- key_kp7
		["kp8"] = 264, -- key_kp8
		["kp9"] = 265, -- key_kp9
		["kp."] = 266, -- key_kp_period
		["kp/"] = 267, -- key_kp_divide
		["kp*"] = 268, -- key_kp_multiply
		["kp-"] = 269, -- key_kp_minus
		["kp+"] = 270, -- key_kp_plus
		["kpenter"] = 271, -- key_kp_enter
		["kp="] = 272, -- key_kp_equals

		["up"] = 273, -- key_up
		["down"] = 274, -- key_down
		["right"] = 275, -- key_right
		["left"] = 276, -- key_left
		["insert"] = 277, -- key_insert
		["home"] = 278, -- key_home
		["end"] = 279, -- key_end
		["pageup"] = 280, -- key_pageup
		["pagedown"] = 281, -- key_pagedown

		["f1"] = 282, -- key_f1
		["f2"] = 283, -- key_f2
		["f3"] = 284, -- key_f3
		["f4"] = 285, -- key_f4
		["f5"] = 286, -- key_f5
		["f6"] = 287, -- key_f6
		["f7"] = 288, -- key_f7
		["f8"] = 289, -- key_f8
		["f9"] = 290, -- key_f9
		["f10"] = 291, -- key_f10
		["f11"] = 292, -- key_f11
		["f12"] = 293, -- key_f12
		["f13"] = 294, -- key_f13
		["f14"] = 295, -- key_f14
		["f15"] = 296, -- key_f15

		["numlock"] = 300, -- key_numlock
		["capslock"] = 301, -- key_capslock
		["scrolllock"] = 302, -- key_scrollock
		["rshift"] = 303, -- key_rshift
		["lshift"] = 304, -- key_lshift
		["rctrl"] = 305, -- key_rctrl
		["lctrl"] = 306, -- key_lctrl
		["ralt"] = 307, -- key_ralt
		["lalt"] = 308, -- key_lalt
		["rgui"] = 312, -- key_rsuper
		["lgui"] = 311, -- key_lsuper
		["mode"] = 313, -- key_mode

		["help"] = 315, -- key_help
		["printscreen"] = 316, -- key_print
		["sysreq"] = 317, -- key_sysreq
		["menu"] = 319, -- key_menu
		["power"] = 320, -- key_power
		["currencyunit"] = 321, -- key_euro
		["undo"] = 322 -- key_undo
	},

	mouse = {1, 3, 2}
}
local sources = {} -- Object sources

-- Objects module local variables
local centers = {}
local sheets = {}
local frames = {}
local durations = {}

-- Graphics module local variables
local colorMode = 0 -- color_normal
local curColor = {1, 1, 1}

-- Audio module local variables
local audioIsPlaying
local audioIsPaused

-- Filesystem module local variables
local includes = {}

love.load = function() if load then load() end end
love.update = function(dt) if update then update(dt) end end
love.draw = function() if draw then draw() end end
love.mousepressed = function(x, y, button) if mousepressed then mousepressed(x, y, filters.mouse[button]) end end
love.mousereleased = function(x, y, button) if mousereleased then mousereleased(x, y, filters.mouse[button]) end end
love.keypressed = function(key) if keypressed then keypressed(filters.key[key]) end end
love.keyreleased = function(key) if keyreleased then keyreleased(filters.key[key]) end end

-- Ripple library for sound handling
do
	ripple = {
		_VERSION = 'Ripple',
		_DESCRIPTION = 'Audio helpers for LÖVE.',
		_URL = 'https://github.com/tesselode/ripple',
		_LICENSE = [[
			MIT License

			Copyright (c) 2019 Andrew Minnich

			Permission is hereby granted, free of charge, to any person obtaining a copy
			of this software and associated documentation files (the "Software"), to deal
			in the Software without restriction, including without limitation the rights
			to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
			copies of the Software, and to permit persons to whom the Software is
			furnished to do so, subject to the following conditions:

			The above copyright notice and this permission notice shall be included in all
			copies or substantial portions of the Software.

			THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
			IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
			FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
			AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
			LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
			OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
			SOFTWARE.
		]]
	}

	local unpack = unpack or table.unpack -- luacheck: ignore

	--[[
		Represents an object that:
		- can have tags applied
		- has a volume
		- can have effects applied

		Tags, instances, and sounds are all taggable.

		Note that not all taggable objects have children - tags and sounds
		do, but instances do not.
	]]
	local Taggable = {}

	--[[
		Gets the total volume of this object given its own volume
		and the volume of each of its tags.
	]]
	function Taggable:_getTotalVolume()
		local volume = self.volume
		for tag, _ in pairs(self._tags) do
			volume = volume * tag:_getTotalVolume()
		end
		return volume
	end

	--[[
		Gets all the effects that should be applied to this object given
		its own effects and the effects of each of its tags. The object's
		own effects will override tag effects.

		Note: currently, if multiple tags define settings for the same effect,
		the final result is undefined, as taggable objects use pairs to iterate
		through the tags, which iterates in an undefined order.
	]]
	function Taggable:_getAllEffects()
		local effects = {}
		for tag, _ in pairs(self._tags) do
			for name, filterSettings in pairs(tag:_getAllEffects()) do
				effects[name] = filterSettings
			end
		end
		for name, filterSettings in pairs(self._effects) do
			effects[name] = filterSettings
		end
		return effects
	end

	--[[
		A callback that is called when anything happens that could
		lead to a change in the object's total volume.
	]]
	function Taggable:_onChangeVolume() end

	--[[
		A callback that is called when anything happens that could
		change which effects are applied to the object.
	]]
	function Taggable:_onChangeEffects() end

	function Taggable:_setVolume(volume)
		self._volume = volume
		self:_onChangeVolume()
	end

	--[[
		_tag, _untag, and _setEffect are analogous to the
		similarly named public API functions (see below), but
		they don't call the _onChangeVolume and _onChangeEffects
		callbacks. This allows me to have finer control over when
		to call those callbacks, so I can set multiple tags and
		effects without needlessly calling the callbacks for each
		one.
	]]

	function Taggable:_tag(tag)
		self._tags[tag] = true
		tag._children[self] = true
	end

	function Taggable:_untag(tag)
		self._tags[tag] = nil
		tag._children[self] = nil
	end

	function Taggable:_setEffect(name, filterSettings)
		if filterSettings == nil then filterSettings = true end
		self._effects[name] = filterSettings
	end

	--[[
		Given an options table, initializes the object's volume,
		tags, and effects.
	]]
	function Taggable:_setOptions(options)
		self.volume = options and options.volume or 1
		-- reset tags
		for tag in pairs(self._tags) do
			self:_untag(tag)
		end
		-- apply new tags
		if options and options.tags then
			for _, tag in ipairs(options.tags) do
				self:_tag(tag)
			end
		end
		-- reset effects
		for name in pairs(self._effects) do
			self._effects[name] = nil
		end
		-- apply new effects
		if options and options.effects then
			for name, filterSettings in pairs(options.effects) do
				self:_setEffect(name, filterSettings)
			end
		end
		-- update final volume and effects
		self:_onChangeVolume()
		self:_onChangeEffects()
	end

	function Taggable:tag(...)
		for i = 1, select('#', ...) do
			local tag = select(i, ...)
			self:_tag(tag)
		end
		self:_onChangeVolume()
		self:_onChangeEffects()
	end

	function Taggable:untag(...)
		for i = 1, select('#', ...) do
			local tag = select(i, ...)
			self:_untag(tag)
		end
		self:_onChangeVolume()
		self:_onChangeEffects()
	end

	--[[
		Sets an effect for this object. filterSettings can be the following types:
		- table - the effect will be enabled with the filter settings given in the table
		- true/nil - the effect will be enabled with no filter
		- false - the effect will be explicitly disabled, overriding effect settings
		from a parent sound or tag
	]]
	function Taggable:setEffect(name, filterSettings)
		self:_setEffect(name, filterSettings)
		self:_onChangeEffects()
	end

	function Taggable:removeEffect(name)
		self._effects[name] = nil
		self:_onChangeEffects()
	end

	function Taggable:getEffect(name)
		return self._effects[name]
	end

	function Taggable:__index(key)
		if key == 'volume' then
			return self._volume
		end
		return Taggable[key]
	end

	function Taggable:__newindex(key, value)
		if key == 'volume' then
			self:_setVolume(value)
		else
			rawset(self, key, value)
		end
	end

	--[[
		Represents a tag that can be applied to sounds,
		instances of sounds, or other tags.
	]]
	local Tag = {__newindex = Taggable.__newindex}

	function Tag:__index(key)
		if Tag[key] then return Tag[key] end
		return Taggable.__index(self, key)
	end

	function Tag:_onChangeVolume()
		-- tell objects using this tag about a potential
		-- volume change
		for child, _ in pairs(self._children) do
			child:_onChangeVolume()
		end
	end

	function Tag:_onChangeEffect()
		-- tell objects using this tag about a potential
		-- effect change
		for child, _ in pairs(self._children) do
			child:_onChangeEffect()
		end
	end

	-- Pauses all the sounds and instances tagged with this tag.
	function Tag:pause(fadeDuration)
		for child, _ in pairs(self._children) do
			child:pause(fadeDuration)
		end
	end

	-- Resumes all the sounds and instances tagged with this tag.
	function Tag:resume(fadeDuration)
		for child, _ in pairs(self._children) do
			child:resume(fadeDuration)
		end
	end

	-- Stops all the sounds and instances tagged with this tag.
	function Tag:stop(fadeDuration)
		for child, _ in pairs(self._children) do
			child:stop(fadeDuration)
		end
	end

	function ripple.newTag(options)
		local tag = setmetatable({
			_effects = {},
			_tags = {},
			_children = {},
		}, Tag)
		tag:_setOptions(options)
		return tag
	end

	-- Represents a specific occurrence of a sound.
	local Instance = {}

	function Instance:__index(key)
		if key == 'pitch' then
			return self._source:getPitch()
		elseif key == 'loop' then
			return self._source:isLooping()
		elseif Instance[key] then
			return Instance[key]
		end
		return Taggable.__index(self, key)
	end

	function Instance:__newindex(key, value)
		if key == 'pitch' then
			self._source:setPitch(value)
		elseif key == 'loop' then
			self._source:setLooping(value)
		else
			Taggable.__newindex(self, key, value)
		end
	end

	function Instance:_getTotalVolume()
		local volume = Taggable._getTotalVolume(self)
		-- apply sound volume as well as tag/self volumes
		volume = volume * self._sound:_getTotalVolume()
		-- apply fade volume
		volume = volume * self._fadeVolume
		return volume
	end

	function Instance:_getAllEffects()
		local effects = {}
		for tag, _ in pairs(self._tags) do
			for name, filterSettings in pairs(tag:_getAllEffects()) do
				effects[name] = filterSettings
			end
		end
		-- apply sound effects as well as tag/self effects
		for name, filterSettings in pairs(self._sound:_getAllEffects()) do
			effects[name] = filterSettings
		end
		for name, filterSettings in pairs(self._effects) do
			effects[name] = filterSettings
		end
		return effects
	end

	function Instance:_onChangeVolume()
		-- update the source's volume
		self._source:setVolume(self:_getTotalVolume())
	end

	function Instance:_onChangeEffects()
		-- get the list of effects that should be applied
		local effects = self:_getAllEffects()
		for name, filterSettings in pairs(effects) do
			-- remember which effects are currently applied to the source
			if filterSettings == false then
				self._appliedEffects[name] = nil
			else
				self._appliedEffects[name] = true
			end
			if filterSettings == true then
				self._source:setEffect(name)
			else
				self._source:setEffect(name, filterSettings)
			end
		end
		-- remove effects that are currently applied but shouldn't be anymore
		for name in pairs(self._appliedEffects) do
			if not effects[name] then
				self._source:setEffect(name, false)
				self._appliedEffects[name] = nil
			end
		end
	end

	function Instance:_play(options)
		if options and options.fadeDuration then
			self._fadeVolume = 0
			self._fadeSpeed = 1 / options.fadeDuration
		else
			self._fadeVolume = 1
		end
		self._fadeDirection = 1
		self._afterFadingOut = false
		self._paused = false
		self:_setOptions(options)
		self.pitch = options and options.pitch or 1
		if options and options.loop ~= nil then
			self.loop = options.loop
		end
		self._source:seek(options and options.seek or 0)
		self._source:play()
	end

	function Instance:_update(dt)
		-- fade in
		if self._fadeDirection == 1 and self._fadeVolume < 1 then
			self._fadeVolume = self._fadeVolume + self._fadeSpeed * dt
			if self._fadeVolume > 1 then self._fadeVolume = 1 end
			self:_onChangeVolume()
		-- fade out
		elseif self._fadeDirection == -1 and self._fadeVolume > 0 then
			self._fadeVolume = self._fadeVolume - self._fadeSpeed * dt
			if self._fadeVolume < 0 then
				self._fadeVolume = 0
				-- pause or stop after fading out
				if self._afterFadingOut == 'pause' then
					self:pause()
				elseif self._afterFadingOut == 'stop' then
					self:stop()
				end
			end
			self:_onChangeVolume()
		end
	end

	function Instance:isStopped()
		return (not self._source:audioIsPlaying()) and (not self._paused)
	end

	function Instance:pause(fadeDuration)
		if fadeDuration and not self._paused then
			self._fadeDirection = -1
			self._fadeSpeed = 1 / fadeDuration
			self._afterFadingOut = 'pause'
		else
			self._source:pause()
			self._paused = true
		end
	end

	function Instance:resume(fadeDuration)
		if fadeDuration then
			if self._paused then
				self._fadeVolume = 0
				self:_onChangeVolume()
			end
			self._fadeDirection = 1
			self._fadeSpeed = 1 / fadeDuration
		end
		self._source:play()
		self._paused = false
	end

	function Instance:stop(fadeDuration)
		if fadeDuration and not self._paused then
			self._fadeDirection = -1
			self._fadeSpeed = 1 / fadeDuration
			self._afterFadingOut = 'stop'
		else
			self._source:stop()
			self._paused = false
		end
	end

	-- Represents a sound that can be played.
	local Sound = {}

	function Sound:__index(key)
		if key == 'loop' then
			return self._source:isLooping()
		elseif Sound[key] then
			return Sound[key]
		end
		return Taggable.__index(self, key)
	end

	function Sound:__newindex(key, value)
		if key == 'loop' then
			self._source:setLooping(value)
			for _, instance in ipairs(self._instances) do
				instance.loop = value
			end
		else
			Taggable.__newindex(self, key, value)
		end
	end

	function Sound:_onChangeVolume()
		-- tell instances about potential volume changes
		for _, instance in ipairs(self._instances) do
			instance:_onChangeVolume()
		end
	end

	function Sound:_onChangeEffects()
		-- tell instances about potential effect changes
		for _, instance in ipairs(self._instances) do
			instance:_onChangeEffects()
		end
	end

	function Sound:play(options)
		-- reuse a stopped instance if one is available
		for _, instance in ipairs(self._instances) do
			if instance:isStopped() then
				instance:_play(options)
				return instance
			end
		end
		-- otherwise, create a brand new one
		local instance = setmetatable({
			_sound = self,
			_source = self._source:clone(),
			_effects = {},
			_tags = {},
			_appliedEffects = {},
		}, Instance)
		table.insert(self._instances, instance)
		instance:_play(options)
		return instance
	end

	function Sound:pause(fadeDuration)
		for _, instance in ipairs(self._instances) do
			instance:pause(fadeDuration)
		end
	end

	function Sound:resume(fadeDuration)
		for _, instance in ipairs(self._instances) do
			instance:resume(fadeDuration)
		end
	end

	function Sound:stop(fadeDuration)
		for _, instance in ipairs(self._instances) do
			instance:stop(fadeDuration)
		end
	end

	function Sound:update(dt)
		for _, instance in ipairs(self._instances) do
			instance:_update(dt)
		end
	end

	function ripple.newSound(source, options)
		local sound = setmetatable({
			_source = source,
			_effects = {},
			_tags = {},
			_instances = {},
		}, Sound)
		sound:_setOptions(options)
		if options and options.loop then sound.loop = true end
		return sound
	end
end

-- anim8 code because I don't feel like writing my own animation library lol
do
	anim8 = {
		_VERSION     = 'anim8 v2.3.1',
		_DESCRIPTION = 'An animation library for LÖVE',
		_URL         = 'https://github.com/kikito/anim8',
		_LICENSE     = [[
		  MIT LICENSE
		  Copyright (c) 2011 Enrique García Cota
		  Permission is hereby granted, free of charge, to any person obtaining a
		  copy of this software and associated documentation files (the
		  "Software"), to deal in the Software without restriction, including
		  without limitation the rights to use, copy, modify, merge, publish,
		  distribute, sublicense, and/or sell copies of the Software, and to
		  permit persons to whom the Software is furnished to do so, subject to
		  the following conditions:
		  The above copyright notice and this permission notice shall be included
		  in all copies or substantial portions of the Software.
		  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
		  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
		  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
		  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
		  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
		  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
		  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
		]]
	}

	local Grid = {}

	local _frames = {}

	local function assertPositiveInteger(value, name)
		if type(value) ~= 'number' then error(("%s should be a number, was %q"):format(name, tostring(value))) end
		if value < 1 then error(("%s should be a positive number, was %d"):format(name, value)) end
		if value ~= math.floor(value) then error(("%s should be an integer, was %d"):format(name, value)) end
	end

	local function createFrame(self, x, y)
		local fw, fh = self.frameWidth, self.frameHeight
		return love.graphics.newQuad(
		  self.left + (x-1) * fw + x * self.border,
		  self.top  + (y-1) * fh + y * self.border,
		  fw,
		  fh,
		  self.imageWidth,
		  self.imageHeight
		)
	end

	local function getGridKey(...)
		return table.concat( {...} ,'-' )
	end

	local function getOrCreateFrame(self, x, y)
		if x < 1 or x > self.width or y < 1 or y > self.height then
		  error(("There is no frame for x=%d, y=%d"):format(x, y))
		end
		local key = self._key
		_frames[key]       = _frames[key]       or {}
		_frames[key][x]    = _frames[key][x]    or {}
		_frames[key][x][y] = _frames[key][x][y] or createFrame(self, x, y)
		return _frames[key][x][y]
	end

	local function parseInterval(str)
		if type(str) == "number" then return str,str,1 end
		str = str:gsub('%s', '') -- remove spaces
		local min, max = str:match("^(%d+)-(%d+)$")
		assert(min and max, ("Could not parse interval from %q"):format(str))
		min, max = tonumber(min), tonumber(max)
		local step = min <= max and 1 or -1
		return min, max, step
	end

	function Grid:getFrames(...)
		local result, args = {}, {...}
		local minx, maxx, stepx, miny, maxy, stepy

		for i=1, #args, 2 do
		  minx, maxx, stepx = parseInterval(args[i])
		  miny, maxy, stepy = parseInterval(args[i+1])
		  for y = miny, maxy, stepy do
			for x = minx, maxx, stepx do
			  result[#result+1] = getOrCreateFrame(self,x,y)
			end
		  end
		end

		return result
	end

	local Gridmt = {
		__index = Grid,
		__call  = Grid.getFrames
	}

	local function newGrid(frameWidth, frameHeight, imageWidth, imageHeight, left, top, border)
		assertPositiveInteger(frameWidth,  "frameWidth")
		assertPositiveInteger(frameHeight, "frameHeight")
		assertPositiveInteger(imageWidth,  "imageWidth")
		assertPositiveInteger(imageHeight, "imageHeight")

		left   = left   or 0
		top    = top    or 0
		border = border or 0

		local key  = getGridKey(frameWidth, frameHeight, imageWidth, imageHeight, left, top, border)

		local grid = setmetatable(
		  { frameWidth  = frameWidth,
			frameHeight = frameHeight,
			imageWidth  = imageWidth,
			imageHeight = imageHeight,
			left        = left,
			top         = top,
			border      = border,
			width       = math.floor(imageWidth/frameWidth),
			height      = math.floor(imageHeight/frameHeight),
			_key        = key
		  },
		  Gridmt
		)
		return grid
	end

	-----------------------------------------------------------

	local Animation = {}

	local function cloneArray(arr)
		local result = {}
		for i=1,#arr do result[i] = arr[i] end
		return result
	end

	local function parseDurations(durations, frameCount)
		local result = {}
		if type(durations) == 'number' then
		  for i=1,frameCount do result[i] = durations end
		else
		  local min, max, step
		  for key,duration in pairs(durations) do
			assert(type(duration) == 'number', "The value [" .. tostring(duration) .. "] should be a number")
			min, max, step = parseInterval(key)
			for i = min,max,step do result[i] = duration end
		  end
		end

		if #result < frameCount then
		  error("The durations table has length of " .. tostring(#result) .. ", but it should be >= " .. tostring(frameCount))
		end

		return result
	end

	local function parseIntervals(durations)
		local result, time = {0},0
		for i=1,#durations do
		  time = time + durations[i]
		  result[i+1] = time
		end
		return result, time
	end

	local Animationmt = { __index = Animation }
	local nop = function() end

	local function newAnimation(frames, durations, onLoop)
		local td = type(durations);
		if (td ~= 'number' or durations <= 0) and td ~= 'table' then
		  error("durations must be a positive number. Was " .. tostring(durations) )
		end
		onLoop = onLoop or nop
		durations = parseDurations(durations, #frames)
		local intervals, totalDuration = parseIntervals(durations)
		return setmetatable({
			frames         = cloneArray(frames),
			durations      = durations,
			intervals      = intervals,
			totalDuration  = totalDuration,
			onLoop         = onLoop,
			timer          = 0,
			position       = 1,
			status         = "playing",
			flippedH       = false,
			flippedV       = false
		  },
		  Animationmt
		)
	end

	function Animation:clone()
		local newAnim = newAnimation(self.frames, self.durations, self.onLoop)
		newAnim.flippedH, newAnim.flippedV = self.flippedH, self.flippedV
		return newAnim
	end

	function Animation:flipH()
		self.flippedH = not self.flippedH
		return self
	end

	function Animation:flipV()
		self.flippedV = not self.flippedV
		return self
	end

	local function seekFrameIndex(intervals, timer)
		local high, low, i = #intervals-1, 1, 1

		while(low <= high) do
		  i = math.floor((low + high) / 2)
		  if     timer >= intervals[i+1] then low  = i + 1
		  elseif timer <  intervals[i]   then high = i - 1
		  else
			return i
		  end
		end

		return i
	end

	function Animation:update(dt)
		if self.status ~= "playing" then return end

		self.timer = self.timer + dt
		local loops = math.floor(self.timer / self.totalDuration)
		if loops ~= 0 then
		  self.timer = self.timer - self.totalDuration * loops
		  local f = type(self.onLoop) == 'function' and self.onLoop or self[self.onLoop]
		  f(self, loops)
		end

		self.position = seekFrameIndex(self.intervals, self.timer)
	end

	function Animation:pause()
		self.status = "paused"
	end

	function Animation:gotoFrame(position)
		self.position = position
		self.timer = self.intervals[self.position]
	end

	function Animation:pauseAtEnd()
		self.position = #self.frames
		self.timer = self.totalDuration
		self:pause()
	end

	function Animation:pauseAtStart()
		self.position = 1
		self.timer = 0
		self:pause()
	end

	function Animation:resume()
		self.status = "playing"
	end

	function Animation:draw(image, x, y, r, sx, sy, ox, oy, kx, ky)
		love.graphics.draw(image, self:getFrameInfo(x, y, r, sx, sy, ox, oy, kx, ky))
	end

	function Animation:getFrameInfo(x, y, r, sx, sy, ox, oy, kx, ky)
		local frame = self.frames[self.position]
		if self.flippedH or self.flippedV then
		  r,sx,sy,ox,oy,kx,ky = r or 0, sx or 1, sy or 1, ox or 0, oy or 0, kx or 0, ky or 0
		  local _,_,w,h = frame:getViewport()

		  if self.flippedH then
			sx = sx * -1
			ox = w - ox
			kx = kx * -1
			ky = ky * -1
		  end

		  if self.flippedV then
			sy = sy * -1
			oy = h - oy
			kx = kx * -1
			ky = ky * -1
		  end
		end
		return frame, x, y, r, sx, sy, ox, oy, kx, ky
	end

	function Animation:getDimensions()
		local _,_,w,h = self.frames[self.position]:getViewport()
		return w,h
	end

	-----------------------------------------------------------

	anim8.newGrid       = newGrid
	anim8.newAnimation  = newAnimation
end

return {
	-- Constants
	key_unknown = 0,
	key_first = 0,
	key_backspace = 8,
	key_tab = 9,
	key_clear = 12,
	key_return = 13,
	key_pause = 19,
	key_escape = 27,
	key_space = 32,
	key_exclaim = 33,
	key_quotedbl = 34,
	key_hash = 35,
	key_dollar = 36,
	key_ampersand = 38,
	key_quote = 39,
	key_leftparen = 40,
	key_rightparen = 41,
	key_asterisk = 42,
	key_plus = 43,
	key_comma = 44,
	key_minus = 45,
	key_period = 46,
	key_slash = 47,
	key_0 = 48,
	key_1 = 49,
	key_2 = 50,
	key_3 = 51,
	key_4 = 52,
	key_5 = 53,
	key_6 = 54,
	key_7 = 55,
	key_8 = 56,
	key_9 = 57,
	key_colon = 58,
	key_semicolon = 59,
	key_less = 60,
	key_equals = 61,
	key_greater = 62,
	key_question = 63,
	key_at = 64,

	key_leftbracket = 91,
	key_backslash = 92,
	key_rightbracket = 93,
	key_caret = 94,
	key_underscore = 95,
	key_backquote = 96,
	key_a = 97,
	key_b = 98,
	key_c = 99,
	key_d = 100,
	key_e = 101,
	key_f = 102,
	key_g = 103,
	key_h = 104,
	key_i = 105,
	key_j = 106,
	key_k = 107,
	key_l = 108,
	key_m = 109,
	key_n = 110,
	key_o = 111,
	key_p = 112,
	key_q = 113,
	key_r = 114,
	key_s = 115,
	key_t = 116,
	key_u = 117,
	key_v = 118,
	key_w = 119,
	key_x = 120,
	key_y = 121,
	key_z = 122,
	key_delete = 127,

	key_kp0 = 256,
	key_kp1 = 257,
	key_kp2 = 258,
	key_kp3 = 259,
	key_kp4 = 260,
	key_kp5 = 261,
	key_kp6 = 262,
	key_kp7 = 263,
	key_kp8 = 264,
	key_kp9 = 265,
	key_kp_period = 266,
	key_kp_divide = 267,
	key_kp_multiply = 268,
	key_kp_minus = 269,
	key_kp_plus = 270,
	key_kp_enter = 271,
	key_kp_equals = 272,

	key_up = 273,
	key_down = 274,
	key_right = 275,
	key_left = 276,
	key_insert = 277,
	key_home = 278,
	key_end = 279,
	key_pageup = 280,
	key_pagedown = 281,

	key_f1 = 282,
	key_f2 = 283,
	key_f3 = 284,
	key_f4 = 285,
	key_f5 = 286,
	key_f6 = 287,
	key_f7 = 288,
	key_f8 = 289,
	key_f9 = 290,
	key_f10 = 291,
	key_f11 = 292,
	key_f12 = 293,
	key_f13 = 294,
	key_f14 = 295,
	key_f15 = 296,

	key_numlock = 300,
	key_capslock = 301,
	key_scrollock = 302,
	key_rshift = 303,
	key_lshift = 304,
	key_rctrl = 305,
	key_lctrl = 306,
	key_ralt = 307,
	key_lalt = 308,
	key_rmeta = 309,
	key_lmeta = 310,
	key_rsuper = 312,
	key_lsuper = 311,
	key_mode = 313,
	key_compose = 314,

	key_help = 315,
	key_print = 316,
	key_sysreq = 317,
	key_break = 318,
	key_menu = 319,
	key_power = 320,
	key_euro = 321,
	key_undo = 322,

	mouse_left = 1,
	mouse_middle = 2,
	mouse_right = 3,
	mouse_wheeldown = 5,
	mouse_wheelup = 4,

	align_left = 1,
	align_center = 3,
	align_right = 2,
	align_top = 4,
	align_bottom = 5,

	mode_loop = 1,
	mode_once = 2,
	mode_bounce = 3,

	blend_normal = 0,
	blend_additive = 1,
	color_normal = 0,
	color_modulate = 1,

	default_font = 0,

	-- Objects module
	objects = {
		newImage = function(self, filename)
			local object = {
				getWidth = function(self)
					return sources[self]:getWidth()
				end,
				getHeight = function(self)
					return sources[self]:getHeight()
				end,
				setCenter = function(self, x, y)
					local center = centers[self]

					center.x, center.y = x, y
				end
			}

			local source = love.graphics.newImage(filename)

			sources[object] = source

			centers[object] = {x = source:getWidth() / 2, y = source:getHeight() / 2}

			return object
		end,

		newAnimation = function(self, image, frameWidth, frameHeight, delay, numFrames)
			local image = sources[image]
			local imageWidth = image:getWidth()
			local imageHeight = image:getHeight()

			local speed = 1

			local object = {
				addFrame = function(self, x, y, width, height, delay)
					local oldAnim = sources[self]
					local sheet = sheets[self]
					local anim

					table.insert(frames[self], love.graphics.newQuad(x, y, width, height, sheet:getWidth(), sheet:getHeight()))
					table.insert(durations, delay)

					sources[self] = anim8.newAnimation(frames[self], durations[self])
					anim = sources[self]
					if oldAnim then anim.timer, anim.position, anim.status = oldAnim.timer, oldAnim.position, oldAnim.status end
				end,
				setMode = function(self) end, -- Unknown?

				play = function(self)
					sources[self]:resume()
				end,
				stop = function(self)
					sources[self]:pause()
				end,
				reset = function(self)
					sources[self]:gotoFrame(1)
				end,

				seek = function(self, frame)
					sources[self]:gotoFrame(frame)
				end,
				getCurrentFrame = function(self)
					return sources[self].position
				end,

				setDelay = function(self, frame, delay)
					local oldAnim = sources[self]
					local anim

					durations[frame] = delay

					sources[self] = anim8.newAnimation(frames[self], durations[self])
					anim = sources[self]
					if oldAnim then anim.timer, anim.position, anim.status = oldAnim.timer, oldAnim.position, oldAnim.status end
				end,

				setSpeed = function(self, factor)
					speed = factor
				end,
				getSpeed = function(self)
					return speed
				end,

				getWidth = function(self)
					return sheets[self]:getWidth()
				end,
				getHeight = function(self)
					return sheets[self]:getHeight()
				end,

				setCenter = function(self, x, y)
					local center = centers[self]

					center.x, center.y = x, y
				end,

				update = function(self, dt)
					sources[self]:update(dt * speed)
				end
			}

			sheets[object] = image
			durations[object] = {}

			if frameWidth then
				local grid = anim8.newGrid(frameWidth, frameHeight, imageWidth, imageHeight)

				local gridWidth = imageWidth / frameWidth
				local gridHeight = imageHeight/ frameHeight

				local numFrames = (numFrames and numFrames > 0) or gridWidth * gridHeight

				local gridData = {}
				if numFrames > 0 then
					for i = 0, numFrames - 1 do
						table.insert(gridData, (i % gridWidth) + 1)
						table.insert(gridData, math.floor(i / gridWidth) + 1)

						table.insert(durations[object], delay)
					end
				end

				frames[object] = grid(unpack(gridData))
				centers[object] = {x = frameWidth / 2, y = frameHeight / 2}

				sources[object] = anim8.newAnimation(frames[object], durations[object])
			else
				frames[object] = {}
				centers[object] = {x = 0, y = 0}
			end

			return object
		end,

		newSound = function(self, filename)
			local object = {
				setVolume = function(self)
					sources[self]:setVolume()
				end
			}

			sources[object] = ripple.newSound(love.audio.newSource(filename, "static"))

			return object
		end,

		newMusic = function(self, filename)
			local object = {}

			sources[object] = love.audio.newSource(filename, "stream")

			return object
		end,

		newColor = function(self, red, green, blue, alpha)
			if not alpha then alpha = 255 end

			local object = {
				getRed = function(self)
					return red
				end,
				getGreen = function(self)
					return green
				end,
				getBlue = function(self)
					return blue
				end,
				getAlpha = function(self)
					return alpha
				end
			}

			sources[object] = {red, green, blue, alpha}

			return object
		end,

		newFont = function(self, filename, size)
			local object = {
				getHeight = function(self)
					return math.floor(sources[self]:getHeight() / 1.25 - 1) -- getHeight is weird
				end,
				getWidth = function(self, text)
					return sources[self]:getWidth(text)
				end
			}

			if filename == 0 then -- defaultfont
				sources[object] = love.graphics.newFont(math.floor(size * 1.25)) -- 1.25 is the "magic line height" for TrueType fonts
			else
				sources[object] = love.graphics.newFont(filename, math.floor(size * 1.25)) -- Ditto
			end

			return object
		end,

		newImageFont = function(self, filename, glyphs)
			local object = {
				getHeight = function(self)
					return sources[self]:getHeight()
				end,
				getWidth = function(self, text)
					return sources[self]:getWidth(text)
				end
			}

			sources[object] = love.graphics.newImageFont(filename, glyphs)

			return object
		end
	},

	-- Graphics module
	graphics = {
		setColor = function(self, red, green, blue, alpha)
			local red, green, blue, alpha = red, green, blue, alpha or 255

			if sources[red] then -- Color object
				red, green, blue, alpha = unpack(sources[red])
			end

			curColor[1], curColor[2], curColor[3], curColor[4] = red / 255, green / 255, blue / 255, alpha / 255

			love.graphics.setColor(curColor)
		end,
		setBackgroundColor = function(self, red, green, blue)
			local red, green, blue = red, green, blue

			if sources[red] then -- Color object
				red, green, blue = unpack(sources[red])
			end

			love.graphics.setBackgroundColor(red / 255, green / 255, blue / 255)
		end,
		setFont = function(self, font)
			love.graphics.setFont(sources[font])
		end,

		draw = function(self, drawable, x, y, angle, sx, sy)
			local sheet = sheets[drawable]

			local source = sources[drawable]

			local center = centers[drawable]

			if sheet then -- Animation
				if colorMode == 0 then love.graphics.setColor(1, 1, 1) end

				source:draw(sheet, x, y, angle and angle * (math.pi / 180), sx, sy or sx, center.x, center.y)

				if colorMode == 0 then love.graphics.setColor(curColor) end
			elseif source then -- Image
				if colorMode == 0 then love.graphics.setColor(1, 1, 1) end

				love.graphics.draw(source, x, y, angle and angle * (math.pi / 180), sx, sy or sx, center.x, center.y)

				if colorMode == 0 then love.graphics.setColor(curColor) end
			elseif angle then -- Text (formatted)
				love.graphics.printf(drawable, x, y, angle, filters.align[sx]) -- love.graphics.printf(string, x, y, limit, filters.align[align])
			else -- Text
				love.graphics.print(drawable, x, y) -- love.graphics.print(string, x, y)
			end
		end,

		drawLine = function(self, xpos, ypos, x1, y1, x2, y2, width)
			love.graphics.setLineWidth(width or 1)
			love.graphics.line(xpos + x1, ypos + y1, xpos + x2, ypos + y2)
			love.graphics.setLineWidth(1)
		end,

		drawTriangle = function(self, xpos, ypos, x1, y1, x2, y2, x3, y3, width)
			love.graphics.setLineWidth(width or 1)
			love.graphics.polygon("line", xpos + x1, ypos + y1, xpos + x2, ypos + y2, xpos + x3, ypos + y3)
			love.graphics.setLineWidth(1)
		end,
		fillTriangle = function(self, xpos, ypos, x1, y1, x2, y2, x3, y3)
			love.graphics.polygon("fill", xpos + x1, ypos + y1, xpos + x2, ypos + y2, xpos + x3, ypos + y3)
		end,

		drawQuad = function(self, xpos, ypos, x1, y1, x2, y2, x3, y3, x4, y4, width)
			love.graphics.setLineWidth(width or 1)
			love.graphics.polygon("line", xpos + x1, ypos + y1, xpos + x2, ypos + y2, xpos + x3, ypos + y3, xpos + x4, ypos + y4)
			love.graphics.setLineWidth(1)
		end,
		fillQuad = function(self, xpos, ypos, x1, y1, x2, y2, x3, y3, x4, y4)
			love.graphics.polygon("fill", xpos + x1, ypos + y1, xpos + x2, ypos + y2, xpos + x3, ypos + y3, xpos + x4, ypos + y4)
		end,

		drawCircle = function(self, x, y, radius, segments, width)
			love.graphics.setLineWidth(width or 1)
			love.graphics.circle("line", x, y, radius, segments)
			love.graphics.setLineWidth(1)
		end,
		fillCircle = function(self, x, y, radius, segments)
			love.graphics.circle("fill", x, y, radius, segments)
		end,

		setBlendMode = function(self, mode)
			love.graphics.setBlendMode(filters.blend[mode])
		end,
		setColorMode = function(self, mode)
			colorMode = mode -- TODO: Need to check if invalid color mode errors out
		end
	},

	-- Audio module
	audio = {
		play = function(self, sound, loop)
			local sound = sources[sound]

			if sound.loop then -- Sound
				sound.loop = loop == 0
			else -- Music
				sound:setLooping(loop == 0)

				sound:stop()
			end

			sound:play()

			audioIsPlaying = true
			audioIsPaused = false
		end,

		pause = function(self)
			love.audio.pause()

			audioIsPaused = false
			audioIsPaused = true
		end,
		resume = function(self)
			love.audio.play()

			audioIsPlaying = true
			audioIsPaused = false
		end,
		stop = function(self)
			love.audio.stop()

			audioIsPlaying = false
			audioIsPaused = false
		end,

		isPlaying = function(self) return audioIsPlaying end,
		isPaused = function(self) return audioIsPaused end,

		setVolume = function(self, volume) love.audio.setVolume(volume / 100) end
	},

	-- Keyboard module
	keyboard = {
		isDown = function(self, key) return love.keyboard.isDown(filters.key[key]) end
	},

	-- Mouse module
	mouse = {
		getX = function(self) return love.mouse.getX() end,
		getY = function(self) return love.mouse.getY() end,

		isDown = function(self, button) return love.mouse.isDown(filters.mouse[button]) end,

		setVisible = function(self, visible) love.mouse.setVisible(visible) end,
		isVisible = function(self) return love.mouse.isVisible() end
	},

	-- Filesystem module
	filesystem = {
		include = function(filename) -- NOTE: Does not support return values
			if not includes[filename] then
				love.filesystem.load(filename)()

				includes[filename] = true
			end
		end
	},

	-- Timer module
	timer = {
		getFps = function(self) return love.timer.getFPS() end
	}
}
