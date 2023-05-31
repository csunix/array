--// @youghage
--// May 29th, 2023

--[[
* Extensive table package for developers who like the taste of JavaScript arrays and more!
]]--

local Array = {}
Array.__index = Array

function Array.new(table: {})
	local self = setmetatable({}, Array)
	self.array = Array.isArray(table) and table or error("Cannot make a super-array with a non-table object.")

	return self
end

function Array.from(value: string, separator: string? | ""?)
	return value:split(separator or "")
end

function Array.isArray(a: {a}?)
	return typeof(a) == "table" or false
end

function Array.copy(a: {a})
	local newArray = {}
	
	for index, element in pairs(a) do
		newArray[index] = element
	end
	
	return newArray
end

function Array:at(index: number | "1")
	index = index or 1
	if index < 0 then
		index = (#self.array+index)+1
	end
	
	if self.array[index] then
		return self.array[index]
	end
end

function Array:concat(array: { any })
	if not Array.isArray(array) then return self.array end
	for _, element in pairs(array) do
		table.insert(self.array, element)
	end
	
	return self.array
end

function Array:swapWithin(targetIndex: number, startIndex: number, lastIndex: number | "max"?)
	if not targetIndex then
		warn("No targetIndex provided for swapWithin - are you missing the first parametre?")
		return
	elseif not startIndex then
		warn("No startIndex provided for swapWithin - are you missing the second parametre?")
		return
	end
	local arrayIndexes = {}
	local externalIndexes = {}
	
	lastIndex = lastIndex or #self.array
	for index, element in pairs(self.array) do
		if index >= startIndex and index <= lastIndex then
			table.insert(arrayIndexes, element)
		end
	end
	
	for index, element in pairs(self.array) do
		if index < startIndex or index > lastIndex then
			table.insert(externalIndexes, element)
		end
	end
	
	if #arrayIndexes > #self.array - targetIndex then
		return self.array
	end
	
	local i = 0
	for index, _ in pairs(self.array) do
		if index >= targetIndex then
			i+=1
			self.array[index] = arrayIndexes[i]
		end 
	end
	
	self:concat(externalIndexes)
	
	return self.array
end

function Array:copyWithin(targetIndex: number, startIndex: number, lastIndex: number | "max"?)
	if not targetIndex then
		warn("No targetIndex provided for copyWithin - are you missing the first parametre?")
		return
	elseif not startIndex then
		warn("No startIndex provided for copyWithin - are you missing the second parametre?")
		return
	end
	local arrayIndexes = {}
	local externalIndexes = {}

	lastIndex = lastIndex or #self.array
	for index, element in pairs(self.array) do
		if index >= startIndex and index <= lastIndex then
			table.insert(arrayIndexes, element)
		end
	end

	for index, element in pairs(self.array) do
		if index > (targetIndex + (lastIndex-startIndex)) then
			table.insert(externalIndexes, element)
		end
	end

	if #arrayIndexes > #self.array - targetIndex then
		return self.array
	end

	local i = 0
	for index, _ in pairs(self.array) do
		if index >= targetIndex then
			i+=1
			self.array[index] = arrayIndexes[i]
		end 
	end

	self:concat(externalIndexes)

	return self.array
end

function Array:entries()
	local entires = {}
	for index, element in pairs(self.array) do
		table.insert(entires, {index, element})
	end
	
	return entires
end

function Array:every(callback: (element: any | nil) -> boolean)
	if not callback then
		warn("No callback function provided for every, making each entry unreadable - are you missing the first parametre?")
		return
	end
	local failedCondition = false
	for _, element in pairs(self.array) do
		if not callback(element) then
			failedCondition = true
		end
	end
	
	return not failedCondition
end

function Array:fill(value: any, startIndex: number? | "one", lastIndex: number? | "max")
	if not value then
		warn("No value provided for fill - are you missing the first parametre?")
		return
	end
	startIndex = startIndex or 1
	lastIndex = lastIndex or #self.array
	
	if startIndex < 0 then
		startIndex = (#self.array+startIndex)+1
	end
	if lastIndex < 0 then
		lastIndex = (#self.array+lastIndex)+1
	end
	
	for index, element in pairs(self.array) do
		if index >= startIndex and index <= lastIndex then
			self.array[index] = value
		end
	end
	
	return self.array
end

function Array:filter(condition: (element) -> boolean)
	if not condition then
		warn("No filter condition function provided for filter, making filtering invalid - are you missing the first parametre?")
		return
	end
	local filterArray = {}
	for _, element in pairs(self.array) do
		if condition(element) then
			table.insert(filterArray, element)
		end
	end
	
	self.array = filterArray
	return self.array
end

function Array:findFirst(condition: (element) -> boolean, isIndex: boolean)
	if not condition then
		warn("No condition procedure provided for findFirst, making entries invalid - are you missing the first parametre?")
		return
	end
	for index, element in pairs(self.array) do
		if condition(element) then
			return isIndex and index or element
		end
	end
end

function Array:findAny(condition: (element) -> boolean, isIndex: boolean)
	local foundArray = {}
	for index, element in pairs(self.array) do
		if condition(element) then
			table.insert(foundArray, isIndex and index or element)
		end
	end
	
	return foundArray
end

function Array:flat()
	local flatArray = {}
	local function newFlatArray(a: {any})
		for _, element in pairs(a) do
			if Array.isArray(element) then
				newFlatArray(element)
			else
				table.insert(flatArray, element)
			end
		end
	end
	
	newFlatArray(self.array)
	
	return flatArray
end

function Array:flatMap(entryMap: (entry) -> (mappedEntry))
	if not entryMap then
		warn("No entry map function provided for flatMap, making the array map invalid - are you missing the first parametre?")
		return
	end
	local flatArray = {}
	local function newFlatMapArray(a: {any})
		for _, element in pairs(a) do
			if Array.isArray(element) then
				newFlatMapArray(element)
			else
				table.insert(flatArray, entryMap(element))
			end
		end
	end
	
	newFlatMapArray(self.array)
	
	return flatArray
end

function Array:forEach(entryFunction: (index: number, element: any) -> any | nil)
	if not entryFunction then
		warn("No entry function provided for forEach, making entries invalid - are you missing the first parametre?")
		return
	end
	for index, element in pairs(self.array) do
		entryFunction(index, element)
	end
end

function Array:includes(value: any, startIndex: number? | "one", lastIndex: number? | "max")
	if not value then
		warn("No value provided for method includes, are you missing the first parametre?")
		return
	end
	startIndex = startIndex or 1
	lastIndex = lastIndex or #self.array
	
	if startIndex < 0 then
		startIndex = (#self.array+startIndex)+1
	end
	if lastIndex < 0 then
		lastIndex = (#self.array+lastIndex)+1
	end
	
	for index, element in pairs(self.array) do
		if index >= startIndex and index <= lastIndex then
			if element == value then
				return true
			end
		end
	end
end

function Array:indexOf(value: any, startIndex: number? | "one", lastIndex: number? | "max")
	if not value then
		warn("No value provided for method indexOf, are you missing the first parametre?")
		return
	end
	startIndex = startIndex or 1
	lastIndex = lastIndex or #self.array

	if startIndex < 0 then
		startIndex = (#self.array+startIndex)+1
	end
	if lastIndex < 0 then
		lastIndex = (#self.array+lastIndex)+1
	end
	
	for index, element in pairs(self.array) do
		if index >= startIndex and index <= lastIndex then
			if element == value then
				return index
			end
		end
	end
end

function Array:join(separator: string?)
	separator = separator or ","
	local stringJoin = ""
	
	for i, element in pairs(self.array) do
		if i == 1 then
			stringJoin = stringJoin..(tostring(element) and tostring(element) or "NaS")
		else
			stringJoin = stringJoin..(separator..(tostring(element) and tostring(element) or "NaS"))
		end
	end
	
	return stringJoin
end

function Array:keys()
	local keys = {}
	for key, _ in pairs(self.array) do
		table.insert(keys, key)
	end
	
	return keys
end

function Array:lastIndexOf(value: any, startIndex: number? | "one", lastIndex: number? | "max")
	if not value then
		warn("No value provided for lastIndexOf, are you missing the first parametre?")
		return
	end
	startIndex = startIndex or 1
	lastIndex = lastIndex or #self.array

	if startIndex < 0 then
		startIndex = (#self.array+startIndex)+1
	end
	if lastIndex < 0 then
		lastIndex = (#self.array+lastIndex)+1
	end
	
	local isLast = nil
	for index, element in pairs(self.array) do
		if index >= startIndex and index <= lastIndex then
			if element == value then
				isLast = index
			end
		end
	end
	
	return isLast
end

function Array:map(entryMap: (entry) -> (mappedEntry))
	if not entryMap then
		warn("No callback provided for map method, are you missing the first parametre?")
		return
	end
	local mapArray = Array.copy(self.array)
	local function mapDeepArray(a: {a})
		for i, element in pairs(a) do
			if Array.isArray(element) then
				mapDeepArray(element)
			else
				a[i] = entryMap(element)
			end
		end
	end
	
	mapDeepArray(mapArray)
	
	return mapArray
end

function Array:pop()
	local elementRemove
	xpcall(function()
		elementRemove = self.array[#self.array]
		self.array[#self.array] = nil
	end, function()
		warn("Missing table index for pop method, is the last index non-numerical?")
	end)
	
	return elementRemove
end

function Array:push(dset: {a})
	dset = dset or {}
	for _, element in dset do
		table.insert(self.array, element)
	end
end

function Array:reduce(callback: (now: a, next: a, index: a?) -> a?, init: any)
	if not callback then
		warn("No callback provided for reducer method, are you missing the first parametre?")
		return
	end
	local next = init
	for i, element in self.array do
		next = callback(next, element, i)
	end
	
	return next
end

function Array:reverse(startIndex: number? | "one", lastIndex: number? | "max")
	startIndex = startIndex or 1
	lastIndex = lastIndex or #self.array

	if startIndex < 0 then
		startIndex = (#self.array+startIndex)+1
	end
	if lastIndex < 0 then
		lastIndex = (#self.array+lastIndex)+1
	end

	local reverseArray = Array.copy(self.array)
	for index, element in pairs(self.array) do
		if index >= startIndex and index <= lastIndex then
			local n = (#self.array - index) + 1
			reverseArray[n] = element
		end
	end

	return reverseArray
end

function Array:shift()
	if typeof(self:keys()[1]) ~= "number" then
		warn("Non-numerical index, invalid shift param for array. See Array:indexOf() or Array:pattern()")
		return
	end
	
	local elementRemove = self.array[1]
	self.array[1] = nil
	
	return elementRemove
end

function Array:pattern()
	local newArray = {}
	self:reduce(function(currentValue, patternElemenet, index)
		currentValue+=1
		newArray[currentValue] = patternElemenet
		return currentValue
	end, 0)
	
	self.array = newArray
	return self.array
end

function Array:slice(startIndex: number, lastIndex: number?)
	if typeof(self:keys()[1]) ~= "number" then
		warn("Non-numerical index, invalid slice param for array. See Array:indexOf() or Array:pattern()")
		return
	elseif not startIndex then
		warn("No 'startIndex' for Array:slice().")
		return
	end
	
	lastIndex = lastIndex or #self.array

	if startIndex < 0 then
		startIndex = (#self.array+startIndex)+1
	end
	if lastIndex < 0 then
		lastIndex = (#self.array+lastIndex)+1
	end
	
	local sliceArray = {}
	for index, sliceElement in pairs(self.array) do
		if index >= startIndex and index <= lastIndex then
			table.insert(sliceArray, sliceElement)
		end
	end
	
	return sliceArray
end

function Array:findFirstElement(root: Instance, untilObject: string)
	if not root then
		warn("Missing root parametre of Array:findFirstElement, are you missing the first parametre?")
		return
	elseif not untilObject then
		warn("Missing untilObject parametre of Array:findFirstElement, are you missing the second parametre?")
		return
	end
	
	for index, pathElement in pairs(self.array) do
		if (root:FindFirstChild(pathElement)) then
			root = root:FindFirstChild(pathElement)
			if root:IsA(untilObject) then
				return root
			end
		end
	end
end

return Array.new
