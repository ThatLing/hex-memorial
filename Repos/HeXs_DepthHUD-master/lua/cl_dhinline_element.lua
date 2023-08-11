////////////////////////////////////////////////
// -- Depth HUD : Inline                        //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// The Element Module, to register easily     //
////////////////////////////////////////////////

module( "dhinline", package.seeall )

local Elements = {}
local Elements_names = {}



local ELEMENT = {}

function ELEMENT:GetMyGridPos()
	return GetConVarNumber("dhinline_element_" .. self._rawname .. "_x"), GetConVarNumber("dhinline_element_" .. self._rawname .. "_y")
end

function ELEMENT:GetMySizes()
	local xGeneric, yGeneric = dhinline_GetGenericBoxSizes()
	local xSize, ySize = self.SizeX, self.SizeY
	if ySize then
		if (ySize < 0) then
			ySize = yGeneric * (-ySize)
		elseif (xSize == 0) then
			ySize = yGeneric
		end
	else
		ySize = yGeneric
	end
	if xSize then
		if (xSize < 0) then
			xSize = xGeneric * (-xSize)
		elseif (xSize == 0) then
			xSize = ySize or yGeneric
		end
	else
		xSize = xGeneric
	end
	if xSize < ySize then
		xSize = ySize
	end
	
	
	return xSize, ySize
end

function ELEMENT:GetMySmootherFullName( stringSuffix )
	return self._rawname .. "_" .. stringSuffix
end

function ELEMENT:CreateSmoother(stringSuffix, numInit, numRate)
	dhinline_CreateSmoother( self:GetMySmootherFullName( stringSuffix ), numInit, numRate)
end

function ELEMENT:ChangeSmootherTarget(stringSuffix, numTarget)
	dhinline_ChangeSmootherTarget( self:GetMySmootherFullName( stringSuffix ), numTarget )
end

function ELEMENT:ChangeSmootherRate(stringSuffix, numRate)
	dhinline_ChangeSmootherRate( self:GetMySmootherFullName( stringSuffix ), numRate )
end

function ELEMENT:GetSmootherCurrent(stringSuffix)
	return dhinline_GetSmootherCurrent( self:GetMySmootherFullName( stringSuffix ) )
end

/*
function ELEMENT:GetMyConVarFullName( stringSuffix )
	return "dhinline_" .. self._rawname .. "_" .. stringSuffix
end

function ELEMENT:MakeMyConVar( stringSuffix, valueDefault, bPersist, bSth)
	CreateClientConVar( self:GetMyConVarFullName( stringSuffix ), valueDefault, bPersist, bSth)
	if not self.__myConVarsDefaults then
		self.__myConVarsDefaults = {}
	end
	self.__myConVarsDefaults[stringSuffix] = valueDefault;
end

function ELEMENT:ForceChangeMyConVar( stringSuffix, value )
	RunConsoleCommand( self:GetMyConVarFullName( stringSuffix ) , value)
end

function ELEMENT:ResetMyConVars( )
	if not self.__myConVarsDefaults then return end
	
	for suffix,value in pairs(self.__myConVars) do
		self:ForceChangeMyConVar(suffix, self.__myConVarsDefaults[suffix])
	end
end

function ELEMENT:CreateMyPanel( myDPanelList )
end
*/
function ELEMENT:DrawGenericInfobox(text, smallText, rate, boxIsAtRight, falseColor, trueColor, minSize, maxSize, blinkBelowRate, blinkSize, mainFontChoice, useStaticTextColor, opt_textColor, opt_smallTextColor)

	local xGrid, yGrid = self:GetMyGridPos()
	local xRel , yRel  = dhinline_GetRelPosFromGrid( xGrid, yGrid )
	
	local width, height = self:GetMySizes()
	
	dhinline_DrawGenericInfobox(xRel, yRel, width, height, text, smallText, rate, boxIsAtRight, falseColor, trueColor, minSize, maxSize, blinkBelowRate, blinkSize, mainFontChoice, useStaticTextColor, opt_textColor, opt_smallTextColor)
end


function ELEMENT:DrawGenericContentbox(text, smallText, textColor, textColorSmall, fontChoice)

	local xGrid, yGrid = self:GetMyGridPos()
	local xRel, yRel  = dhinline_GetRelPosFromGrid( xGrid, yGrid )
	
	local width, height = self:GetMySizes()
	
	dhinline_DrawGenericContentbox(xRel, yRel, width, height, text, smallText, textColor, textColorSmall, fontChoice)
end

function ELEMENT:DrawGenericText(text, smallText, textColor, textColorSmall, fontChoice, lagMultiplier, insideBoxXEquirel, insideBoxYEquirel)
	local xGrid, yGrid = self:GetMyGridPos()
	local xRel, yRel  = dhinline_GetRelPosFromGrid( xGrid, yGrid )
	
	local width, height = self:GetMySizes()
	
	dhinline_DrawGenericText(xRel, yRel, width, height, text, smallText, textColor, textColorSmall, fontChoice, lagMultiplier, insideBoxXEquirel, insideBoxYEquirel)
end

function ELEMENT:UpdateVolatile(name, xRelOffset, yRelOffset, text, textColor, lagMultiplier, fontChoice, duration, fadePower, storage)
	local xGrid, yGrid = self:GetMyGridPos()
	local xRel , yRel  = dhinline_GetRelPosFromGrid( xGrid, yGrid )
	
	local width, height = self:GetMySizes()
	
	dhinline_UpdateVolatile(name, xRel, yRel, width, height, xRelOffset, yRelOffset, text, textColor, lagMultiplier, fontChoice, duration, fadePower, storage)
end



local element_meta = {__index=ELEMENT}

function Register(name, element)
	if string.find( name , " " ) then return end
	
	element._rawname = name
	element.Name = element.Name or name
	setmetatable(element, element_meta)
	
	Elements[name] = element
	table.insert(Elements_names, name)
	
	/*local cstr = ""
	if (element.DefaultOff or false) then
		cstr = "0"
	else
		cstr = "1"
	end*/
	CreateClientConVar("dhinline_element_" .. name, ( not (dhinline.Get(name).DefaultOff or false ) ) and "1" or "0", true, false)
	CreateClientConVar("dhinline_element_" .. name .. "_x", element.DefaultGridPosX or 0, true, false)
	CreateClientConVar("dhinline_element_" .. name .. "_y", element.DefaultGridPosY or 0, true, false)
end

function RemoveAll()
	Elements = {}
	Elements_names = {}
	
	dhinline_DeleteAllSmoothers()
	dhinline_DeleteAllVolatiles()
end

function Get(name)
	if Elements[name] == nil then return nil end
	return Elements[name] or nil
end

function GetNamesTable()
	return table.Copy(Elements_names)
end

function GetConVarTable()
	local ConVars = {}
	for k,name in pairs(Elements_names) do
		table.insert(ConVars, "dhinline_element_" .. name)
		table.insert(ConVars, "dhinline_element_" .. name .. "_x")
		table.insert(ConVars, "dhinline_element_" .. name .. "_y")
	end
	return ConVars
end

function GetAllDefaultsTable()
	local Defaults = {}
	for k,name in pairs(Elements_names) do
		Defaults["dhinline_element_" .. name]         = ( not (dhinline.Get(name).DefaultOff or false ) ) and "1" or "0"
		Defaults["dhinline_element_" .. name .. "_x"] = dhinline.Get(name).DefaultGridPosX
		Defaults["dhinline_element_" .. name .. "_y"] = dhinline.Get(name).DefaultGridPosY
	end
	return Defaults
end
