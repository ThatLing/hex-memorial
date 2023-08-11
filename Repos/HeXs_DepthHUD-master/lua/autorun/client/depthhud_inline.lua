////////////////////////////////////////////////
// -- Depth HUD : Inline                      //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Main autorun file, with drawing functions  //
////////////////////////////////////////////////
//  About making elements, read _empty._lua   //
////////////////////////////////////////////////


if not iface3 then
	HeXInclude = include
end



surface.CreateFont("dhinline_hl2num", {
	font		= "halflife2",
	size 		= 36,
	weight		= 0,
	antialias	= true,
	additive	= false,
	}
)

surface.CreateFont("dhinline_hl2nummedium", {
	font		= "halflife2",
	size 		= 26,
	weight		= 2,
	antialias	= true,
	additive	= false,
	}
)

surface.CreateFont("dhinline_hl2numsmall", {
	font		= "halflife2",
	size 		= 20,
	weight		= 0,
	antialias	= true,
	additive	= false,
	}
)

surface.CreateFont("dhinline_textlarge", {
	font		= "DIN Light",
	size 		= 36,
	weight		= 0,
	antialias	= true,
	additive	= false,
	}
)

surface.CreateFont("dhinline_textmedium", {
	font		= "DIN Light",
	size 		= 24,
	weight		= 2,
	antialias	= true,
	additive	= false,
	}
)
surface.CreateFont("dhinline_textsmall", {
	font		= "DIN Medium",
	size 		= 16,
	weight		= 400,
	antialias	= true,
	additive	= false,
	}
)


surface.CreateFont("dhinline_textmediumbold", {
	font		= "DIN Medium",
	size 		= 24,
	weight		= 2,
	antialias	= true,
	additive	= false,
	}
)




surface.CreateFont("dhinline_hl2num_noblend", {
	font		= "halflife2",
	size 		= 36,
	weight		= 0,
	antialias	= false,
	additive	= false,
	}
)

surface.CreateFont("dhinline_hl2nummedium_noblend", {
	font		= "halflife2",
	size 		= 26,
	weight		= 2,
	antialias	= false,
	additive	= false,
	}
)

surface.CreateFont("dhinline_hl2numsmall_noblend", {
	font		= "halflife2",
	size 		= 20,
	weight		= 0,
	antialias	= false,
	additive	= false,
	}
)

surface.CreateFont("dhinline_textlarge_noblend", {
	font		= "halflife2",
	size 		= 36,
	weight		= 0,
	antialias	= false,
	additive	= false,
	}
)

surface.CreateFont("dhinline_textmedium_noblend", {
	font		= "halflife2",
	size 		= 24,
	weight		= 2,
	antialias	= false,
	additive	= false,
	}
)

surface.CreateFont("dhinline_textsmall_noblend", {
	font		= "halflife2",
	size 		= 16,
	weight		= 400,
	antialias	= false,
	additive	= false,
	}
)

surface.CreateFont("dhinline_textmediumbold_noblend", {
	font		= "halflife2",
	size 		= 24,
	weight		= 2,
	antialias	= false,
	additive	= false,
	}
)



CreateClientConVar("dhinline_enable", "1", true, false)
CreateClientConVar("dhinline_disabledefault", "1", true, false)
CreateClientConVar("dhinline_ui_blendfonts", "1", true, false)
CreateClientConVar("dhinline_ui_spacing", "1", true, false)
CreateClientConVar("dhinline_ui_hudlag_mul", "2", true, false)
CreateClientConVar("dhinline_ui_hudlag_retab", "0.2", true, false)
CreateClientConVar("dhinline_ui_dynamicbackground", "0", true, false)
CreateClientConVar("dhinline_ui_drawglow", "0", true, false)

CreateClientConVar("dhinline_col_base_r", "255", true, false)
CreateClientConVar("dhinline_col_base_g", "220", true, false)
CreateClientConVar("dhinline_col_base_b", "0", true, false)
CreateClientConVar("dhinline_col_base_a", "192", true, false)

CreateClientConVar("dhinline_col_back_r", "0", true, false)
CreateClientConVar("dhinline_col_back_g", "0", true, false)
CreateClientConVar("dhinline_col_back_b", "0", true, false)
CreateClientConVar("dhinline_col_back_a", "92", true, false)

HeXInclude("cl_dhinline_element.lua")
HeXInclude("cl_dhinline_elementpanel.lua")

dhinline_dat = {}

dhinline_dat.DEBUG = false

dhinline_dat.ui_backcolor = Color(0, 0, 0, 92)
dhinline_dat.ui_basecolor = Color(255, 220, 0, 192)
dhinline_dat.ui_basecolor_lesser = Color(255, 220, 0, 92)
dhinline_dat.ui_drawglow = 0
dhinline_dat.ui_glowrelsize = 5.0
dhinline_dat.ui_glowalpharel = 1.0
dhinline_dat.ui_blendfonts = 1
dhinline_dat.ui_hudlag = {}
dhinline_dat.ui_hudlag.x = 0
dhinline_dat.ui_hudlag.y = 0
dhinline_dat.ui_hudlag.mul = 2
dhinline_dat.ui_hudlag.retab = 0.2
dhinline_dat.ui_edgeSpacingRel = 0.015
dhinline_dat.ui_rectHeight = 44
dhinline_dat.ui_rectLen     = math.floor(dhinline_dat.ui_rectHeight * 2.2)
dhinline_dat.ui_innerSquareProportions = 0.7

dhinline_dat.STOR_Smoothers = {}
dhinline_dat.STOR_TempVars  = {}
dhinline_dat.STOR_HUDPATCH_Volatile  = {}

dhinline_dat.STOR_DynamicBackCalc = Color(0, 255, 255, 255)
dhinline_dat.STOR_BackCalc    = Color(0,255,255,255)
dhinline_dat.STOR_BlendCalc    = Color(0,255,255,255)
dhinline_dat.STOR_TextColorCalc  = Color(0,255,255,255)
dhinline_dat.STOR_TextSmallColCalc   = Color(0,255,255,255)

dhinline_dat.STOR_ElementNamesTable = {}

dhinline_dat.tex_glow       = surface.GetTextureID("sprites/light_glow02_add")

local PARAM_GRID_DIVIDE  = 16
local PARAM_HUDLAG_LastAng = EyeAngles()
local PARAM_HUDLAG_BOX    = 1
local PARAM_HUDLAG_INBOX  = 1.5
local PARAM_HUDLAG_TEXT   = 1.25
local PARAM_BLINK_PERIOD  = 0.5


/*function dhradar_DrawDebug(x, y , color)
	if not dhinline_dat.DEBUG then return false end
	local spriteid = surface.GetTextureID("depthhud/X_Square")
	
	surface.SetTexture(spriteid)
	surface.SetDrawColor(color.r, color.g, color.b, 255)
	surface.DrawTexturedRectRotated(x, y, 10, 10, 45)
end*/


///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
//// INITIALIZATION FUNCTIONS .

local function dhinline_InitializeElements()
	for k,name in pairs( dhinline_dat.STOR_ElementNamesTable ) do
		local ELEMENT = dhinline.Get(name)
		if (ELEMENT and ELEMENT.Initialize) then
			ELEMENT:Initialize( )
		end
	end
end
	
local function dhinline_LoadAllElements()
	dhinline.RemoveAll()

	local path = "depthhud_inline_element/"
	for _,script in pairs(file.Find("lua/"..path.."*.lua", "GAME")) do
		ELEMENT = {}
		
		HeXInclude(path..script)
		
		local keyword = string.Replace(script, ".lua", "")
		dhinline.Register(keyword, ELEMENT)
	end
	
	dhinline_dat.STOR_ElementNamesTable = dhinline.GetNamesTable()
	
	print("Inline registered : ")
	for k,name in pairs( dhinline_dat.STOR_ElementNamesTable ) do
		Msg("["..name.."] ")
	end
	Msg("\n")
	
	dhinline_InitializeElements()
	dhinline_InitializeMisc()
	
	hook.Remove("HUDPaint","dhinlineHUDPaint")
	hook.Add("HUDPaint","dhinlineHUDPaint",dhinlineHUDPaint)
end
concommand.Add("dhinline_reloadelements",dhinline_LoadAllElements)
	
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
//// INTERNAL CALC .

local function dhinline_CalcCenter( xRel , yRel , width, height )
	local xCalc,yCalc = 0,0
	
	xDist = dhinline_dat.ui_edgeSpacingRel*ScrW() + width*0.5
	xCalc = xRel*ScrW() + (xRel*(-2) + 1)*xDist
	
	yDist = dhinline_dat.ui_edgeSpacingRel*ScrW() + height*0.5 //ScrW here is not a mistake
	yCalc = yRel*ScrH() + (yRel*(-2) + 1)*yDist
	
	return xCalc, yCalc
end

local function dhinline_CalcHudLag( )
	dhinline_dat.ui_hudlag.la = PARAM_HUDLAG_LastAng
	dhinline_dat.ui_hudlag.ca = EyeAngles()
	
	/*
	if dhinline_dat.ui_hudlag.la.y < -90 and dhinline_dat.ui_hudlag.ca.y > 90 then
		dhinline_dat.ui_hudlag.la.y = dhinline_dat.ui_hudlag.la.y + 360
	elseif dhinline_dat.ui_hudlag.la.y > 90 and dhinline_dat.ui_hudlag.ca.y < -90 then
		dhinline_dat.ui_hudlag.la.y = dhinline_dat.ui_hudlag.la.y - 360
	end
	*/
	
	local targetX = math.AngleDifference(dhinline_dat.ui_hudlag.ca.y , dhinline_dat.ui_hudlag.la.y)*dhinline_dat.ui_hudlag.mul
	local targetY = -math.AngleDifference(dhinline_dat.ui_hudlag.ca.p , dhinline_dat.ui_hudlag.la.p)*dhinline_dat.ui_hudlag.mul
	
	//print(x,y)
	
	dhinline_dat.ui_hudlag.x = dhinline_dat.ui_hudlag.x + (targetX - dhinline_dat.ui_hudlag.x) * math.Clamp(dhinline_dat.ui_hudlag.retab * 0.5 * FrameTime() * 50 , 0 , 1 )
	dhinline_dat.ui_hudlag.y = dhinline_dat.ui_hudlag.y + (targetY - dhinline_dat.ui_hudlag.y) * math.Clamp(dhinline_dat.ui_hudlag.retab * 0.5 * FrameTime() * 50 , 0 , 1 )
	
	/*
	dhinline_dat.ui_hudlag.x = (dhinline_dat.ui_hudlag.ca.y - dhinline_dat.ui_hudlag.la.y)*3*dhinline_dat.ui_hudlag_rate
	dhinline_dat.ui_hudlag.y = (dhinline_dat.ui_hudlag.la.p - dhinline_dat.ui_hudlag.ca.p)*3*dhinline_dat.ui_hudlag_rate
	dhinline_dat.ui_hudlag.nm = .1
	dhinline_dat.ui_hudlag.na = Angle((dhinline_dat.ui_hudlag.ca.p*dhinline_dat.ui_hudlag.nm+dhinline_dat.ui_hudlag.la.p)/(dhinline_dat.ui_hudlag.nm+1),(dhinline_dat.ui_hudlag.ca.y*dhinline_dat.ui_hudlag.nm+dhinline_dat.ui_hudlag.la.y)/(dhinline_dat.ui_hudlag.nm+1))
	*/
	
	PARAM_HUDLAG_LastAng = EyeAngles()
end


/*
local function dhinline_CalcHudLag( )
	//Code taken from the old DepthHUD,
	//which is itself taken from NightEagle's code,
	//the Compass is also his code.

	dhinline_dat.ui_hudlag.la = PARAM_HUDLAG_LastAng
	dhinline_dat.ui_hudlag.ca = EyeAngles()
	
	if dhinline_dat.ui_hudlag.la.y < -90 and dhinline_dat.ui_hudlag.ca.y > 90 then
		dhinline_dat.ui_hudlag.la.y = dhinline_dat.ui_hudlag.la.y + 360
	elseif dhinline_dat.ui_hudlag.la.y > 90 and dhinline_dat.ui_hudlag.ca.y < -90 then
		dhinline_dat.ui_hudlag.la.y = dhinline_dat.ui_hudlag.la.y - 360
	end
	
	dhinline_dat.ui_hudlag.x = (dhinline_dat.ui_hudlag.ca.y - dhinline_dat.ui_hudlag.la.y)*3*dhinline_dat.ui_hudlag_rate
	dhinline_dat.ui_hudlag.y = (dhinline_dat.ui_hudlag.la.p - dhinline_dat.ui_hudlag.ca.p)*3*dhinline_dat.ui_hudlag_rate
	dhinline_dat.ui_hudlag.nm = .1
	dhinline_dat.ui_hudlag.na = Angle((dhinline_dat.ui_hudlag.ca.p*dhinline_dat.ui_hudlag.nm+dhinline_dat.ui_hudlag.la.p)/(dhinline_dat.ui_hudlag.nm+1),(dhinline_dat.ui_hudlag.ca.y*dhinline_dat.ui_hudlag.nm+dhinline_dat.ui_hudlag.la.y)/(dhinline_dat.ui_hudlag.nm+1))
	
	PARAM_HUDLAG_LastAng = dhinline_dat.ui_hudlag.na
end
*/

function dhinline_GetGridDivideMax()
	return PARAM_GRID_DIVIDE
end

function dhinline_GetGenericBoxSizes()
	return dhinline_dat.ui_rectLen, dhinline_dat.ui_rectHeight
end

function dhinline_GetRelPosFromGrid( xGrid, yGrid )
	local max = dhinline_GetGridDivideMax()
	local xRel, yRel = (xGrid / max), (yGrid / max)
	
	return xRel, yRel
end

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
//// USEFUL FUNCTIONS FOR USER .

function dhinline_GetStyleData( stringPredefName )
	if     stringPredefName == "color_base"        then return dhinline_dat.ui_basecolor
	elseif stringPredefName == "color_base_lesser" then return dhinline_dat.ui_basecolor_lesser
	elseif stringPredefName == "color_back"        then return dhinline_dat.ui_backcolor
	else return nil end
end

function dhinline_StringNiceNameTransform( stringInput )
	local stringParts = string.Explode("_",stringInput)
	local stringOutput = ""
	for k,part in pairs(stringParts) do
		local len = string.len(part)
		if (len == 1) then
			stringOutput = stringOutput .. string.upper(part)
		elseif (len > 1) then
			stringOutput = stringOutput .. string.Left(string.upper(part),1) .. string.Right(part,len-1)
		end
		if (k != #stringParts) then stringOutput = stringOutput .. " " end
	end
	return stringOutput
end

function dhinline_GetAppropriateFont(text, desiredChoice)
	local font = ""
	desiredChoice = desiredChoice or 2
	if (desiredChoice == -1) then
		if type(text) == "number" then
			font = "dhinline_hl2nummedium"
		else
			font = "dhinline_textmediumbold"
		end
	elseif (desiredChoice >= 2) then
		if type(text) == "number" then
			font = "dhinline_hl2num"
		else
			font = "dhinline_textlarge"
		end

	elseif (desiredChoice == 1) then 
		if type(text) == "number" then
			font = "dhinline_hl2nummedium"
		else
			font = "dhinline_textmedium"
		end
	else
		if type(text) == "number" then
			font = "dhinline_hl2numsmall"
		else
			font = "dhinline_textsmall"
		end
	end
	if (dhinline_dat.ui_blendfonts <= 0) then
		font = font .. "_noblend"
	end
	return font
end

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
//// DRAWING FUNCTIONS. DO NOT USE IN YOUR ELEMENTS.
//// READ cl_dhinline_element.lua FOR DRAWING FUNCTIONS
//// AND _empty._lua .

function dhinline_DrawSprite(sprite, x, y, width, height, angle, r, g, b, a)
	local spriteid = 0
	if ( type(sprite) == "string" ) then
		spriteid = surface.GetTextureID(sprite)
	else
		spriteid = sprite
	end
	
	surface.SetTexture(spriteid)
	surface.SetDrawColor(r, g, b, a)
	surface.DrawTexturedRectRotated(x, y, width, height, angle)
end

//The font changes if the text is a number or not.
//If it is a number, it will take the best version of the font, that is the HL2 one.
//If not, it will take a similar, lesser quality version, that allows alphabetical characters.

function dhinline_DrawGenericInfobox(xRel, yRel, width, height, text, smallText, rate, boxIsAtRight, falseColor, trueColor, minSize, maxSize, blinkBelowRate, blinkSize, mainFontChoice, useStaticTextColor, opt_textColor, opt_smallTextColor)
	local dispell = nil
	
	//We have to calccenter using the real sizes despite dispell will be true or not
	local xCenter,yCenter = dhinline_CalcCenter( xRel , yRel , width , height )
	//Should Dispell?
	if (blinkSize > 1.0) then
		dispell = math.Clamp(blinkSize - 1.0, 0, 1)
		
		if dispell > 0.95 then return end
		
		width  = (1.0 + dispell*0.5) * width
		height = (1.0 + dispell*0.5) * height
		
		blinkSize = -1
	end
	local inEdgeSpacing = math.floor((height * (1 - dhinline_dat.ui_innerSquareProportions)) * 0.5)
	local innerSquare = height * dhinline_dat.ui_innerSquareProportions
	local xBox ,yBox  = 0,0
	local xText,yText = 0,0
	local yTextSmall = 0
	local font = ""
	local fontSmall = ""
	local boxSize = -1
	local boxRound = -1
	local boxRevert = -1
	local backColor = dhinline_dat.ui_backcolor
	local glowalpha = -1
	
	//dhradar_DrawDebug(xCenter, yCenter, Color(255,0,0))
	
	local boxBigSizeCalc = (height/44)
	if boxBigSizeCalc <= 0.75 && boxBigSizeCalc > 0.5 then
		boxRound = 6
	elseif boxBigSizeCalc <= 0.5 && boxBigSizeCalc > 0.25 then
		boxRound = 4
	elseif boxBigSizeCalc <= 0.25 then
		boxRound = 0
	else
		boxRound = 8
	end
	
	//Back color
	dhinline_dat.STOR_BackCalc.r = backColor.r
	dhinline_dat.STOR_BackCalc.g = backColor.g
	dhinline_dat.STOR_BackCalc.b = backColor.b
	dhinline_dat.STOR_BackCalc.a = backColor.a
	if dispell then
		dhinline_dat.STOR_BackCalc.a = dhinline_dat.STOR_BackCalc.a * (1 - dispell)
	end
	
	draw.RoundedBox(boxRound, dhinline_dat.ui_hudlag.x*PARAM_HUDLAG_BOX + xCenter - width*0.5, dhinline_dat.ui_hudlag.y*PARAM_HUDLAG_BOX + yCenter - height*0.5, width, height, dhinline_dat.STOR_BackCalc)
	
	rate = math.Clamp(rate,0,1)
	local anti = 1 - rate
	
	trueColor = trueColor or dhinline_dat.ui_basecolor_lesser
	falseColor = falseColor or dhinline_dat.ui_basecolor_lesser
	
	//BlendColor
	dhinline_dat.STOR_BlendCalc.r = trueColor.r*rate + falseColor.r*anti
	dhinline_dat.STOR_BlendCalc.g = trueColor.g*rate + falseColor.g*anti
	dhinline_dat.STOR_BlendCalc.b = trueColor.b*rate + falseColor.b*anti
	dhinline_dat.STOR_BlendCalc.a = trueColor.a*rate + falseColor.a*anti
	
	if dispell then
		dhinline_dat.STOR_BlendCalc.a = dhinline_dat.STOR_BlendCalc.a * (1 - dispell)
	end
	
	yBox  = dhinline_dat.ui_hudlag.y*PARAM_HUDLAG_INBOX + yCenter - height*0.5 + inEdgeSpacing
	yText = dhinline_dat.ui_hudlag.y*PARAM_HUDLAG_TEXT + yCenter - height*0.02
	yTextSmall = dhinline_dat.ui_hudlag.y*PARAM_HUDLAG_TEXT + yCenter/* + height*0.15*/ + height*0.40
	
	if not boxIsAtRight then
		xBox  = dhinline_dat.ui_hudlag.x*PARAM_HUDLAG_INBOX + xCenter - width*0.5 + inEdgeSpacing
		xText = dhinline_dat.ui_hudlag.x*PARAM_HUDLAG_TEXT + xCenter + height*0.5
	else
		xBox  = dhinline_dat.ui_hudlag.x*PARAM_HUDLAG_INBOX + xCenter + width*0.5 - inEdgeSpacing - innerSquare
		xText = dhinline_dat.ui_hudlag.x*PARAM_HUDLAG_TEXT + xCenter - height*0.5
	end
	
	if (rate <= blinkBelowRate) then
		dhinline_dat.STOR_BlendCalc.a = dhinline_dat.STOR_BlendCalc.a * (RealTime() % PARAM_BLINK_PERIOD) * (1/PARAM_BLINK_PERIOD)
		boxSize = blinkSize
	else
		boxSize = maxSize*rate + minSize*anti
	end
	local boxSizeCalc = boxSize*(innerSquare/32)
	if boxSizeCalc <= 0.75 && boxSizeCalc > 0.5 then
		boxRound = 6
	elseif boxSizeCalc <= 0.5 && boxSizeCalc > 0.25 then
		boxRound = 4
	elseif boxSizeCalc <= 0.25 then
		boxRound = 0
	else
		boxRound = 8
	end
	boxRevert = (innerSquare - boxSize*innerSquare)*0.5
	
	draw.RoundedBox(boxRound, xBox+boxRevert, yBox+boxRevert, boxSize*innerSquare, boxSize*innerSquare, dhinline_dat.STOR_BlendCalc)
	if (dhinline_dat.ui_drawglow > 0) then
		glowalpha = dhinline_dat.ui_glowalpharel*(dhinline_dat.STOR_BlendCalc.a/255)
		dhinline_DrawSprite(dhinline_dat.tex_glow, xBox+innerSquare*0.5, yBox+innerSquare*0.5, boxSize*innerSquare*dhinline_dat.ui_glowrelsize, boxSize*innerSquare*dhinline_dat.ui_glowrelsize, 0, dhinline_dat.STOR_BlendCalc.r*glowalpha, dhinline_dat.STOR_BlendCalc.g*glowalpha, dhinline_dat.STOR_BlendCalc.b*glowalpha, 255)
	end
	
	local textColor       = opt_textColor or dhinline_dat.ui_basecolor
	local textColorSmall  = opt_smallTextColor or textColor
	if useStaticTextColor or false then
		//textColor
		dhinline_dat.STOR_TextColorCalc.r = textColor.r
		dhinline_dat.STOR_TextColorCalc.g = textColor.g
		dhinline_dat.STOR_TextColorCalc.b = textColor.b
		dhinline_dat.STOR_TextColorCalc.a = textColor.a
		
		//textSmallColor
		dhinline_dat.STOR_TextSmallColCalc.r = textColorSmall.r
		dhinline_dat.STOR_TextSmallColCalc.g = textColorSmall.g
		dhinline_dat.STOR_TextSmallColCalc.b = textColorSmall.b
		dhinline_dat.STOR_TextSmallColCalc.a = textColorSmall.a
		
		textColor = dhinline_dat.STOR_TextColorCalc
		textColorSmall = dhinline_dat.STOR_TextSmallColCalc
	else
		//textColor
		dhinline_dat.STOR_TextColorCalc.r = dhinline_dat.STOR_BlendCalc.r
		dhinline_dat.STOR_TextColorCalc.g = dhinline_dat.STOR_BlendCalc.g
		dhinline_dat.STOR_TextColorCalc.b = dhinline_dat.STOR_BlendCalc.b
		dhinline_dat.STOR_TextColorCalc.a = 192
		
		//textSmallColor
		dhinline_dat.STOR_TextSmallColCalc.r = dhinline_dat.STOR_TextColorCalc.r
		dhinline_dat.STOR_TextSmallColCalc.g = dhinline_dat.STOR_TextColorCalc.g
		dhinline_dat.STOR_TextSmallColCalc.b = dhinline_dat.STOR_TextColorCalc.b
		dhinline_dat.STOR_TextSmallColCalc.a = dhinline_dat.STOR_TextColorCalc.a
		
		textColor = dhinline_dat.STOR_TextColorCalc
		textColorSmall = dhinline_dat.STOR_TextSmallColCalc
	end
	
	if dispell then
		textColor.a      = textColor.a      * (1 - dispell)
		textColorSmall.a = textColorSmall.a * (1 - dispell)
	end
	
	font = dhinline_GetAppropriateFont(text, mainFontChoice)
	draw.SimpleText(text, font, xText, yText, textColor, 1, 1 )
	
	if (smallText != "") then
		fontSmall = dhinline_GetAppropriateFont(smallText,0)
		draw.SimpleText(smallText, fontSmall, xText, yTextSmall, textColorSmall, 1, 1 )
	end
end

function dhinline_DrawVolatile( xRel, yRel, width, height, xRelOffset, yRelOffset, text, textColor, lagMultiplier, fontChoice)
	local xCalc, yCalc = dhinline_CalcCenter( xRel , yRel , width , height )
	local xCalcOffset, yCalcOffset = xRelOffset*0.5*width, yRelOffset*0.5*height
	
	xCalc, yCalc = xCalc + xCalcOffset + dhinline_dat.ui_hudlag.x*lagMultiplier , yCalc + yCalcOffset + dhinline_dat.ui_hudlag.y*lagMultiplier
	

	//dhradar_DrawDebug(xCalc, yCalc, Color(0,255,0))
	
	local font = dhinline_GetAppropriateFont(text, fontChoice)
	draw.SimpleText(text, font, xCalc, yCalc, textColor, 1, 1 )
end

function dhinline_DrawGenericContentbox(xRel, yRel, width, height, text, smallText, textColor, textColorSmall, fontChoice)
	local xCenter,yCenter = dhinline_CalcCenter( xRel , yRel , width , height , fontChoice)
	
	local xText,yText = 0,0
	local yTextSmall = 0
	local fontSmall = ""
	
	//dhradar_DrawDebug(xCenter, yCenter, Color(255,0,0))
	
	
	local boxSizeCalc = (height/44)
	local boxRound = 8
	if boxSizeCalc <= 0.75 && boxSizeCalc > 0.5 then
		boxRound = 6
	elseif boxSizeCalc <= 0.5 && boxSizeCalc > 0.25 then
		boxRound = 4
	elseif boxSizeCalc <= 0.25 then
		boxRound = 0
	else
		boxRound = 8
	end
	
	draw.RoundedBox(boxRound, dhinline_dat.ui_hudlag.x*PARAM_HUDLAG_BOX + xCenter - width*0.5, dhinline_dat.ui_hudlag.y*PARAM_HUDLAG_BOX + yCenter - height*0.5, width, height, dhinline_dat.ui_backcolor)
	
	textColor = textColor or dhinline_dat.ui_basecolor
	textColorSmall = textColorSmall or textColor
	
	yText = dhinline_dat.ui_hudlag.y*PARAM_HUDLAG_TEXT + yCenter - height*0.02
	yTextSmall = dhinline_dat.ui_hudlag.y*PARAM_HUDLAG_TEXT + yCenter + height*0.40
	
	xText = dhinline_dat.ui_hudlag.x*PARAM_HUDLAG_TEXT + xCenter
	
	local font = dhinline_GetAppropriateFont(text, fontChoice)
	draw.SimpleText(text, font, xText, yText, textColor, 1, 1 )
	
	if (smallText != "") then
		local fontSmall = dhinline_GetAppropriateFont(smallText, 0)
		draw.SimpleText(smallText, fontSmall, xText, yTextSmall, textColorSmall, 1, 1 )
	end
end

function dhinline_DrawGenericText(xRel, yRel, width, height, text, smallText, textColor, textColorSmall, fontChoice, lagMultiplier, insideBoxXEquirel, insideBoxYEquirel)
	local xCenter,yCenter = dhinline_CalcCenter( xRel , yRel , width , height , fontChoice)
	textColor = textColor or dhinline_dat.ui_basecolor
	textColorSmall = textColorSmall or textColor
	
	xText = dhinline_dat.ui_hudlag.x*PARAM_HUDLAG_TEXT + xCenter + insideBoxXEquirel*0.5*width
	
	yText = dhinline_dat.ui_hudlag.y*PARAM_HUDLAG_TEXT + yCenter - height*0.02 + insideBoxYEquirel*0.5*height
	yTextSmall = dhinline_dat.ui_hudlag.y*PARAM_HUDLAG_TEXT + yCenter + height*0.40 + insideBoxYEquirel*0.5*height
	
	local font = dhinline_GetAppropriateFont(text, fontChoice)
	draw.SimpleText(text, font, xText, yText, textColor, 1, 1 )
	
	if (smallText != "") then
		local fontSmall = dhinline_GetAppropriateFont(smallText, 0)
		draw.SimpleText(smallText, fontSmall, xText, yTextSmall, textColorSmall, 1, 1 )
	end
end

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
//// VOLATILE ACCUMULATION FUNCTIONS. DO NOT USE IN YOUR ELEMENTS.
//// READ cl_dhinline_element.lua FOR VOLATILE FUNCTIONS.

function dhinline_GetVolatileStorage(name)
	if (dhinline_dat.STOR_HUDPATCH_Volatile[name] == nil) then
		return nil
	end
	return dhinline_dat.STOR_HUDPATCH_Volatile[name][10] or nil
end

function dhinline_UpdateVolatile(name, xRel, yRel, width, height, xRelOffset, yRelOffset, text, textColor, lagMultiplier, fontChoice, duration, fadePower, storage)
	dhinline_dat.STOR_HUDPATCH_Volatile[name] = {}
	dhinline_dat.STOR_HUDPATCH_Volatile[name][1] = xRel
	dhinline_dat.STOR_HUDPATCH_Volatile[name][2] = yRel
	dhinline_dat.STOR_HUDPATCH_Volatile[name][3] = text
	dhinline_dat.STOR_HUDPATCH_Volatile[name][4] = textColor
	dhinline_dat.STOR_HUDPATCH_Volatile[name][5] = lagMultiplier
	dhinline_dat.STOR_HUDPATCH_Volatile[name][6] = duration
	dhinline_dat.STOR_HUDPATCH_Volatile[name][7] = fadePower
	dhinline_dat.STOR_HUDPATCH_Volatile[name][8] = fontChoice
	dhinline_dat.STOR_HUDPATCH_Volatile[name][9] = RealTime()
	dhinline_dat.STOR_HUDPATCH_Volatile[name][10] = storage
	dhinline_dat.STOR_HUDPATCH_Volatile[name][11] = width
	dhinline_dat.STOR_HUDPATCH_Volatile[name][12] = height
	dhinline_dat.STOR_HUDPATCH_Volatile[name][13] = xRelOffset
	dhinline_dat.STOR_HUDPATCH_Volatile[name][14] = yRelOffset
end

local function dhinline_DrawVolatiles()
	for name,subtable in pairs(dhinline_dat.STOR_HUDPATCH_Volatile) do	
		if (subtable[1] != nil) then
			local timeSpawned = dhinline_dat.STOR_HUDPATCH_Volatile[name][9]
			local duration    = dhinline_dat.STOR_HUDPATCH_Volatile[name][6]
			
			if ((RealTime() - timeSpawned) > duration) then
				dhinline_dat.STOR_HUDPATCH_Volatile[name] = {nil}
			else
				local stayedUpRel = (RealTime() - timeSpawned) / duration
				
				local xRel = dhinline_dat.STOR_HUDPATCH_Volatile[name][1]
				local yRel = dhinline_dat.STOR_HUDPATCH_Volatile[name][2]
				local text = dhinline_dat.STOR_HUDPATCH_Volatile[name][3]
				local lagMultiplier = dhinline_dat.STOR_HUDPATCH_Volatile[name][5]
				local fadePower = dhinline_dat.STOR_HUDPATCH_Volatile[name][7]
				local fontChoice = dhinline_dat.STOR_HUDPATCH_Volatile[name][8]
				local width = dhinline_dat.STOR_HUDPATCH_Volatile[name][11]
				local height = dhinline_dat.STOR_HUDPATCH_Volatile[name][12]
				local xRelOffset = dhinline_dat.STOR_HUDPATCH_Volatile[name][13]
				local yRelOffset = dhinline_dat.STOR_HUDPATCH_Volatile[name][14]
				
				local textColor = Color(dhinline_dat.STOR_HUDPATCH_Volatile[name][4].r, dhinline_dat.STOR_HUDPATCH_Volatile[name][4].g, dhinline_dat.STOR_HUDPATCH_Volatile[name][4].b, dhinline_dat.STOR_HUDPATCH_Volatile[name][4].a)
				textColor.a = textColor.a * (1 - (stayedUpRel^fadePower))
				
				dhinline_DrawVolatile(xRel, yRel, width, height, xRelOffset, yRelOffset, text, textColor, lagMultiplier, fontChoice)
			end
		end
		
	end
end

function dhinline_DeleteAllVolatiles()
	dhinline_dat.STOR_HUDPATCH_Volatile = {}
end

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
//// SMOOTHING FUNCTIONS. DO NOT USE IN YOUR ELEMENTS.
//// READ cl_dhinline_element.lua FOR SMOOTHING FUNCTIONS.

function dhinline_CreateSmoother(strName, numInit, numRate)
	--[[{Target, Current, Rate}
	if dhinline_dat.STOR_Smoothers[strName] then return end
	numRate = math.Clamp(numRate,0.001,1) ]]
	local numCurrent = nil
	if type(numInit) == "table" then
		numCurrent = table.Copy(numInit)
	else
		numCurrent = numInit
	end
	dhinline_dat.STOR_Smoothers[strName] = {numInit, numCurrent, numRate}
end

function dhinline_ChangeSmootherTarget(strName, numTarget)
	if not dhinline_dat.STOR_Smoothers[strName] then print("dhinline ERROR : ChangeSmootherTarget has requested field " .. strName .." which hasn't been created !") return end
	dhinline_dat.STOR_Smoothers[strName][1] = numTarget
end

function dhinline_ChangeSmootherRate(strName, numRate)
	if not dhinline_dat.STOR_Smoothers[strName] then print("dhinline ERROR : ChangeSmootherRate has requested field " .. strName .." which hasn't been created !") return end
	dhinline_dat.STOR_Smoothers[strName][3] = numRate
end

function dhinline_GetSmootherCurrent(strName)
	if not dhinline_dat.STOR_Smoothers[strName] then print("dhinline ERROR : GetSmootherCurrent has requested field " .. strName .." which hasn't been created !") return nil end
	return dhinline_dat.STOR_Smoothers[strName][2]
end



local function dhinline_RecalcAllSmoothers()
	local previousCurrent = 0
	for name,subtable in pairs(dhinline_dat.STOR_Smoothers) do
		if (type(dhinline_dat.STOR_Smoothers[name][2]) == "table") then
			for subkey,value in pairs(dhinline_dat.STOR_Smoothers[name][2]) do
				previousCurrent = dhinline_dat.STOR_Smoothers[name][2][subkey]
				dhinline_dat.STOR_Smoothers[name][2][subkey] = dhinline_dat.STOR_Smoothers[name][2][subkey] + (dhinline_dat.STOR_Smoothers[name][1][subkey] - dhinline_dat.STOR_Smoothers[name][2][subkey]) * dhinline_dat.STOR_Smoothers[name][3] * FrameTime() * 50
				if (previousCurrent < dhinline_dat.STOR_Smoothers[name][1][subkey]) and (dhinline_dat.STOR_Smoothers[name][2][subkey] > dhinline_dat.STOR_Smoothers[name][1][subkey]) then
					dhinline_dat.STOR_Smoothers[name][2][subkey] = dhinline_dat.STOR_Smoothers[name][1][subkey]
				elseif (previousCurrent > dhinline_dat.STOR_Smoothers[name][1][subkey]) and (dhinline_dat.STOR_Smoothers[name][2][subkey] < dhinline_dat.STOR_Smoothers[name][1][subkey]) then
					dhinline_dat.STOR_Smoothers[name][2][subkey] = dhinline_dat.STOR_Smoothers[name][1][subkey]
				end
			end
		else
			dhinline_dat.STOR_Smoothers[name][2] = dhinline_dat.STOR_Smoothers[name][2] + (dhinline_dat.STOR_Smoothers[name][1] - dhinline_dat.STOR_Smoothers[name][2]) * math.Clamp( dhinline_dat.STOR_Smoothers[name][3] * 0.5 * FrameTime() * 50 , 0 , 1 )
		end
	end
end

function dhinline_DeleteAllSmoothers()
	dhinline_dat.STOR_Smoothers = {}
end


local function dhinline_DrawElements()
	for k,name in pairs( dhinline_dat.STOR_ElementNamesTable ) do
		local ELEMENT = dhinline.Get(name)
		if (ELEMENT and ( GetConVarNumber( "dhinline_element_" .. name ) > 0 ) and ELEMENT.DrawFunction) then
			ELEMENT:DrawFunction( )
		end
	end
end


/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
//// THE MAIN HOOK - THINK .

function dhinline_InitializeMisc()
	dhinline_CreateSmoother("__dynamicbackground",color_white,0.05)
end

function dhinlineHUDPaint(name)
	if GetConVarNumber("dhinline_enable") <= 0 then return end
	
	dhinline_dat.ui_edgeSpacingRel = GetConVarNumber("dhinline_ui_spacing") * 0.015
	dhinline_dat.ui_hudlag.mul    = GetConVarNumber("dhinline_ui_hudlag_mul")
	dhinline_dat.ui_hudlag.retab  = GetConVarNumber("dhinline_ui_hudlag_retab")
	
	dhinline_dat.ui_drawglow    = GetConVarNumber("dhinline_ui_drawglow")
	dhinline_dat.ui_blendfonts    = GetConVarNumber("dhinline_ui_blendfonts")
	
	dhinline_dat.ui_basecolor.r = GetConVarNumber("dhinline_col_base_r")
	dhinline_dat.ui_basecolor.g = GetConVarNumber("dhinline_col_base_g")
	dhinline_dat.ui_basecolor.b = GetConVarNumber("dhinline_col_base_b")
	dhinline_dat.ui_basecolor.a = GetConVarNumber("dhinline_col_base_a")
	
	dhinline_dat.ui_basecolor_lesser.r = dhinline_dat.ui_basecolor.r
	dhinline_dat.ui_basecolor_lesser.g = dhinline_dat.ui_basecolor.g
	dhinline_dat.ui_basecolor_lesser.b = dhinline_dat.ui_basecolor.b
	dhinline_dat.ui_basecolor_lesser.a = dhinline_dat.ui_basecolor.a*0.5

	dhinline_dat.STOR_DynamicBackCalc.r = GetConVarNumber("dhinline_col_back_r")
	dhinline_dat.STOR_DynamicBackCalc.g = GetConVarNumber("dhinline_col_back_g")
	dhinline_dat.STOR_DynamicBackCalc.b = GetConVarNumber("dhinline_col_back_b")
	dhinline_dat.STOR_DynamicBackCalc.a = GetConVarNumber("dhinline_col_back_a")
	
	if (GetConVarNumber("dhinline_ui_dynamicbackground") > 0) then
		local lcolor = render.GetLightColor( EyePos() ) * 2
		lcolor.x = math.Clamp( lcolor.x, 0, 1 )
		lcolor.y = math.Clamp( lcolor.y, 0, 1 )
		lcolor.z = math.Clamp( lcolor.z, 0, 1 )
		
		local lightlevel_darkness = ( 1 - (lcolor.x + lcolor.y + lcolor.z) / 3 ) * 0.3
		
		local reflectcookie = math.cos(math.rad(2*EyeAngles().y+75)) * math.sin(math.rad(EyeAngles().p + 90)) * 0.2 + 0.8
		dhinline_dat.STOR_DynamicBackCalc.r = dhinline_dat.STOR_DynamicBackCalc.r + (255 - dhinline_dat.STOR_DynamicBackCalc.r) * lightlevel_darkness
		dhinline_dat.STOR_DynamicBackCalc.g = dhinline_dat.STOR_DynamicBackCalc.g + (255 - dhinline_dat.STOR_DynamicBackCalc.g) * lightlevel_darkness
		dhinline_dat.STOR_DynamicBackCalc.b = dhinline_dat.STOR_DynamicBackCalc.b + (255 - dhinline_dat.STOR_DynamicBackCalc.b) * lightlevel_darkness
		dhinline_dat.STOR_DynamicBackCalc.a = dhinline_dat.STOR_DynamicBackCalc.a * reflectcookie
		
		//We shouldn't need that due to the pointer
		dhinline_ChangeSmootherTarget("__dynamicbackground", dhinline_dat.STOR_DynamicBackCalc)
		
		dhinline_dat.ui_backcolor = dhinline_GetSmootherCurrent("__dynamicbackground")
	else
		dhinline_dat.ui_backcolor.r = dhinline_dat.STOR_DynamicBackCalc.r
		dhinline_dat.ui_backcolor.g = dhinline_dat.STOR_DynamicBackCalc.g
		dhinline_dat.ui_backcolor.b = dhinline_dat.STOR_DynamicBackCalc.b
		dhinline_dat.ui_backcolor.a = dhinline_dat.STOR_DynamicBackCalc.a
	end

	//Calc all required inline
	dhinline_CalcHudLag()
	dhinline_RecalcAllSmoothers()
	
	//Draw all the elements
	dhinline_DrawElements()
	dhinline_DrawVolatiles()
end
//hook.Add("HUDPaint","dhinlineHUDPaint",dhinlineHUDPaint)

local function dhinlineHideHUD(name)
	if GetConVarNumber("dhinline_disabledefault") <= 0 then return end
	
	if name == "CHudHealth"        then return false end
	if name == "CHudBattery"       then return false end
	if name == "CHudAmmo"          then return false end
	if name == "CHudSecondaryAmmo" then return false end
end
hook.Add("HUDShouldDraw","dhinlineHideHUD",dhinlineHideHUD)


/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
//// PANEL .


function dhinline_dat.Panel(Panel)	
	Panel:AddControl("Checkbox", {
			Label = "Enable", 
			Description = "Enable", 
			Command = "dhinline_enable" 
		}
	)
	Panel:AddControl("Checkbox", {
			Label = "Disable Base HUD",
			Description = "Disable Base HUD",
			Command = "dhinline_disabledefault" 
		}
	)
	Panel:AddControl("Slider", {
			Label = "HUD Lag",
			Type = "Float",
			Min = "0",
			Max = "0.4",
			Command = "dhinline_ui_hudlag"
		}
	)
	Panel:AddControl("Button", {
			Label = "Reload Element Files", 
			Description = "Reload Element Files", 
			Command = "dhinline_reloadelements" 
		}
	)
	Panel:AddControl("Button", {
			Label = "Open Menu (dhinline_menu)", 
			Description = "Open Menu (dhinline_menu)", 
			Command = "dhinline_menu"
		}
	)
	
	Panel:Help("To trigger the menu in any gamemode, type dhinline_menu in the console, or bind this command to any key.")
end

function dhinline_dat.AddPanel()
	spawnmenu.AddToolMenuOption("Options","Player","Depth HUD Inline","Depth HUD Inline","","",dhinline_dat.Panel,{SwitchConVar = 'dhinline_enable'})
end

hook.Add( "PopulateToolMenu", "AddDepthHUDInlinePanel", dhinline_dat.AddPanel )

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
//// STARTING UP .

dhinline_LoadAllElements()

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////