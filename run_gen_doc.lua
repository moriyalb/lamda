--[[
	Generate Lamda Documents.
	```lua
		lua run_gen_doc.lua
	```
]]

local R = require("./dist/lamda")

local symbol_check = R.startsWith

local SECTION_START = symbol_check("--[[")
local SECTION_END = symbol_check("]]")
local TAG_PRIVATE = symbol_check("@private")
local TAG_FUNC = symbol_check("@func")
local TAG_CATEGORY = symbol_check("@category")
local TAG_SINCE = symbol_check("@since")
local TAG_PARAM = symbol_check("@param")
local TAG_RETURN = symbol_check("@return")
local TAG_SIGNATURE = symbol_check("@sig")
local TAG_EXAMPLE = symbol_check("@example")
local TAG_SEE = symbol_check("@see")
local TAG_SYMBOL = symbol_check("@symb")
local TAG_ALIAS = symbol_check("@alias")
local TAG_NOT_CURRY = symbol_check("@not curried")
local TAG_R = symbol_check("R.")
local VERSION = symbol_check("--  Lamda v")

local SECTION_INVALID = 0
local SECTION_DESC = 1
local SECTION_EXAMPLE = 2
local SECTION_SYMBOL = 3

local section
local version = ""

local count = 0
local cur_line = 0

local functions = {}

function _resetSection()
	section = {
		now = SECTION_INVALID, 
		value = "",
		params = {},
		alias = {},
		see = {}
	}
	functionBegin = false
end

local sortedFunctions = {}

function _changeSection(s)
	--print("ChangeSection ", section.now, s, section.value)
	if section.now == SECTION_DESC then
		section.desc = section.value
		section.desc = R.replace("\n\n", "<br/>", 0, section.desc)
		section.desc = R.replace("\n", "", 0, section.desc)
	elseif section.now == SECTION_EXAMPLE then
		if section.value ~= "" then
			section.example = string.format('<pre><code class="lua">%s</code></pre>', section.value)
			--section.example = R.replace("\n", "<br/>\n", 0, section.example)
		else
			section.example = ""
		end
	elseif section.now == SECTION_SYMBOL then
		--pass
	end
	section.now = s
	section.value = ""
end

function _sortFunction()
	--local fvalids = R.reject(function(v) return v.isAlias end, functions)

	local fs = R.values(functions)
	sortedFunctions = R.sortWith({
		R.ascend(R.prop("category")),
		R.ascend(R.prop("fname")),
	}, fs)
	--R.show(functions)
	--R.show(sortedFunctions)
end

function load()
	_resetSection()

	for _line in io.lines("./dist/lamda.lua") do
		cur_line = cur_line + 1
		--if count > 3 then break end
		local line = R.strip(_line)
				
		if VERSION(line) then
			version = R.split("v", line)[2]		
		elseif SECTION_START(line) then
			--print("SECTION_START ------> ", line, cur_line)
			_resetSection()
			_changeSection(SECTION_DESC)
		elseif SECTION_END(line) then			
			functionBegin = true
			_changeSection(SECTION_INVALID)
		elseif TAG_PRIVATE(line) then
			section.isPrivate = true				
			functionBegin = false
			_changeSection(SECTION_INVALID)
		elseif functionBegin then
			if TAG_R(line) then
				--print("TAG_R ------> ", line, cur_line)
				local fn = R.split("=", line)
				section.fname = R.strip(fn[1])	
				
				if section.fname ~= nil then
					functions[section.fname] = section
				end

				--handle default
				if R.isNull(section.since) then
					section.since = "0.1.0"
				end
				if R.isNull(section.category) then
					section.category = ""
				end
				
				functionBegin = false
				count = count + 1
			end			
		elseif TAG_CATEGORY(line) then
			section.category = R.split(" ", line)[2]
			_changeSection(SECTION_INVALID)
		elseif TAG_SINCE(line) then
			section.since = R.split(" ", line)[2]
			_changeSection(SECTION_INVALID)
		elseif TAG_FUNC(line) then
			_changeSection(SECTION_INVALID)
		elseif TAG_EXAMPLE(line) then		
			_changeSection(SECTION_EXAMPLE)
		elseif TAG_NOT_CURRY(line) then
			section.notCurry = true
			_changeSection(SECTION_INVALID)
		elseif TAG_SYMBOL(line) then
			section.symbol = true --nothing output now
			_changeSection(SECTION_SYMBOL)
		elseif TAG_SIGNATURE(line) then
			local sig = R.strip(R.split("@sig", line)[2])
			section.sig = string.format("<div><code>%s</code></div>", sig)
		elseif TAG_PARAM(line) then
			local _p = R.split(" ", line)
			table.insert(section.params, {
				name = _p[3],
				type = _p[2],
				desc = R.join(" ", R.drop(3, _p))
			})
		elseif TAG_RETURN(line) then

		elseif TAG_ALIAS(line) then
			local src = R.strip(R.split(" ", line)[2])
			local s = functions[src]
			section.isAlias = true
			section.aliasTo = src
			section.category = s.category
			-- if R.isNull(s) then
			-- 	R.show("Invalid Alias Config ---", src)
			-- else
			-- 	table.insert(s.alias, section)
			-- end
		elseif TAG_SEE(line) then
			local all = R.strip(R.split("@see", line)[2])
			section.see = R.split(",", all)
		elseif section.now ~= SECTION_INVALID then			
			section.value = R.append(_line, section.value)
			section.value = section.value .. "\n"
		else
			
		end
	end

	_sortFunction()
end

function generate()
	local f = io.open("./docs/index.html", "w")
	f:write(string.format([==[
<!DOCTYPE html>
<html class="docs-page">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Lamda Documentation</title>
	<link rel="stylesheet" type="text/css" href="./style.css">
	<link rel="stylesheet" type="text/css" href="./dracula.css">
	<script src="./highlight.pack.js"></script>
	<script>hljs.initHighlightingOnLoad();</script>
</head>
<body>
	<input type="checkbox" id="open-nav">
	<header class="navbar navbar-fixed-top navbar-inverse container-fluid">
		<div class="container-fluid">
			<div class="navbar-header">
				<label class="open-nav" for="open-nav"></label>
				<a class="navbar-brand" href="#">
					<strong>Lamda</strong>
					<span class="version">v%s</span>
				</a>
			</div>
			<ul class="nav navbar-nav navbar-right">
				<li><a href="https://github.com/moriyalb/lamda">GitHub</a></li>
			</ul>
		</div>
	</header>
	<aside class="sidebar container-fluid">	
		<ul class="nav nav-pills nav-stacked toc">
	]==], version))

	for k, v in ipairs(sortedFunctions) do
		if not R.isNull(v.fname) then
			f:write(string.format([==[
			<li class="func" data-name="%s" data-category="%s">
				<a href="#%s">
					%s
					<span data-category="%s" class="label label-category pull-right"
					>%s</span>
				</a>
			</li>
		]==], v.fname, v.category, v.fname, v.fname, v.category, v.category))
		end
	end

	f:write([==[
		</ul>
    </aside>
	<main class="container-fluid">
	]==])

	local _notCurry = function(notCurry)
		if notCurry then
			return "<p><small>Not Curried</small></p>"
		else
			return ""
		end
	end

	local _isAlias = function(v)
		if v.isAlias then
			return string.format('<p>Alias To <a href="#%s">%s</a>', v.aliasTo, v.aliasTo)
		else
			return ""
		end
	end

	local _see = function(v)
		if R.size(v.see) == 0 then return "" end
		local r = "<p><small>see "
		local refs = {}
		for i, see in ipairs(v.see) do
			local sv = R.trim(see)
			if sv ~= "" then				
				table.insert(refs, string.format('<a href="#%s">%s</a>', sv, sv))
			end
		end
		return r .. R.join(",", refs) .. "</small>"
	end

	local _alias = function(alias)
		if R.size(alias) == 0 then return "" end
		local r = "<p>Alias: "
		for i, v in ipairs(alias) do
			r = r .. string.format('%s', v.fname)
		end
		r = r.."</p>"
		return r
	end

	local _ds = function(v) 
		return R.defaultTo("", v)
	end

	for k, v in ipairs(sortedFunctions) do
		if not R.isNull(v.fname) then
			f:write(string.format([==[
		<div id="%s" class="section-id"></div>
		<section class="card">		
			<h2>
				<a tabindex="2" class="name" href="#%s">%s</a>
				<span class="pull-right">
					<span class="label label-category">%s</span>					
				</span>
			</h2>
			<p><small>Added in v%s</small> %s</p>
			%s
			%s
			%s			
			<div class="description">%s
</div>
		%s
		%s
		</section>
			]==], v.fname, v.fname, v.fname, v.category, v.since, _notCurry(v.notCurry), _ds(v.sig), 
			_isAlias(v), _alias(v.alias), _ds(v.desc), _see(v), _ds(v.example)))
		end
	end
end

load()
generate()