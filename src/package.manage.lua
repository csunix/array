-- @move => parent
-- package.manage.lua

--.ignore

local UtilModule = {}

function UtilModule.new(utilityPackage: string)
	if script:FindFirstChild(utilityPackage) then
		return require(script:FindFirstChild(utilityPackage))
	end
end

return UtilModule.new
