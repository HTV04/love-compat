--[[
LOVE 0.1.1a Compatibility Module v1.0.0
Developed by HTV04

TODO:
* Examine functions in more situations
  * For example, look for unintentional or undocumented behavior
* Functions need better errors

* Fix mouse wheel input
--]]

-- Cached objects
local unpack = unpack or table.unpack

local love = love

local ripple

-- Local variables
local filters = {
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

-- Audio module local variables
local audioIsPlaying
local audioIsPaused

-- Filesystem module local variables
local includes = {}

love.load = function() if load then load() end end
love.update = function(dt) if update then update(dt) end end
love.draw = function() if render then render() end end
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

	-- Objects module
	objects = {
		newImage = function(self, filename)
			local object = {
				getWidth = function(self)
					return sources[self]:getWidth()
				end,
				getHeight = function(self)
					return sources[self]:getHeight()
				end
			}

			sources[object] = love.graphics.newImage(filename)

			return object
		end,

		newSound = function(self, filename)
			local object = {
				setVolume = function(self, volume)
					sources[self].volume = volume / 100
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

			sources[object] = love.graphics.newFont(filename, math.floor(size * 1.25)) -- 1.25 is the "magic line height" for TrueType fonts

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

			love.graphics.setColor(red / 255, green / 255, blue / 255, alpha / 255)
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

		draw = function(self, drawable, x, y)
			local source = sources[drawable]

			if source then -- Image
				love.graphics.draw(source, x, y, nil, nil, nil, source:getWidth() / 2, source:getHeight() / 2)
			else -- Text
				love.graphics.print(drawable, x, y) -- love.graphics.print(string, x, y)
			end
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
