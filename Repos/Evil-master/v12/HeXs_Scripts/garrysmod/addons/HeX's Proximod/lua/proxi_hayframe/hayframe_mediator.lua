////////////////////////////////////////////////
// -- HayFrame                                //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Parameter Mediator                         //
////////////////////////////////////////////////


local HAY_MAIN, HAY_INTERNAL, HAY_CLOUD, HAY_UTIL = HAYFRAME_SetupReferences( )
local HAY_NAME, HAY_SHORT, HAY_DEBUG = HAYFRAME_SetupConstants( )

local HAY_MEDIATOR_REQUIRED = false
local HAY_PARAM_Types = nil
local HAY_PARAM_Constructors = nil
local HAY_PARAM_ConvarSuffixes = nil
local HAY_PARAM_ExtraData = nil

function HAY_MAIN:RequireParameterMediator( )
	if HAY_MEDIATOR_REQUIRED then return end
	HAY_MEDIATOR_REQUIRED = true
	
	HAY_PARAM_Types = {}
	HAY_PARAM_Constructors = {}
	HAY_PARAM_ConvarSuffixes = {}
	HAY_PARAM_ExtraData = {}
	
	self:InitializeGenericConstructors()
	
	if self.InitializeCustomConstructors then
		self:InitializeCustomConstructors()
		
	end
	
end

function HAY_MAIN:ParamTypeExists( sType )
	return table.HasValue( HAY_PARAM_Types, string.lower(tostring(sType)) )
	
end

---- When registering a new parameter type...
-- Extra data are :
--   Callback shall evaluate a boolean or not.

---- When creating the constructor, the argument proposes a stock...
-- Stock IN THE CONSTRUCTOR could be :
--   Panel-associated callbacks.

function HAY_MAIN:RegisterParamType( sType, fConstructor, stConvarSuffixes, stExtraData )
	sType = string.lower(sType)
	if self:ParamTypeExists( sType ) then return end
	
	HAY_PARAM_Constructors[sType]   = fConstructor
	HAY_PARAM_ConvarSuffixes[sType] = stConvarSuffixes or nil
	HAY_PARAM_ExtraData[sType] = stExtraData or nil
	table.insert( HAY_PARAM_Types, sType)
	
	HAY_UTIL.OutputDebug( "Registered Panel Constructor : ".. sType )
	
end

function HAY_MAIN:BuildParamPanel( sFullConvarName, stData, pParent )
	if not self:ParamTypeExists( stData.Type ) then
		HAY_UTIL.OutputError( "Tried to create panel with a non-existant type : " .. tostring( sType ) )
		return
	end
	
	local myPanel = HAY_PARAM_Constructors[stData.Type](sFullConvarName , stData)
	if ValidPanel( pParent ) then
		myPanel:SetParent( pParent )
		
	end
	
	return myPanel
	
end

---- When creating new variables...
-- Extra data are :
--   Callback function
function HAY_MAIN:CreateVarParam( sType, sConvarName, sDefault, stExtraData )
	sType = string.lower(sType)
	if not self:ParamTypeExists( sType ) then
		HAY_UTIL.OutputError( "Tried to create paramater with a non-existant type : " .. tostring( sType ) )
		return false
		
	end
	
	local fCallback = (type(stExtraData) == "table") and stExtraData["callback"] or nil
	local fCallbackBool = fCallback and HAY_PARAM_ExtraData[sType] and HAY_PARAM_ExtraData[sType]["callback_isbool"] or false
	
	//local buildTable = {}
	
	if HAY_PARAM_ConvarSuffixes[sType] == nil then
		self:CreateVar( sConvarName, tostring(sDefault), true, false, fCallback, fCallbackBool )
		//table.insert( buildTable, { sConvarName, tostring(sDefault) } )
		
		HAY_UTIL.OutputDebug( "Added Var : ".. sConvarName .." = ".. tostring(sDefault))
		
	elseif type(HAY_PARAM_ConvarSuffixes[sType]) == "table" then
		for k,suffix in pairs( HAY_PARAM_ConvarSuffixes[sType] ) do
			local curDefault = tostring(sDefault[k] or sDefault[1] or sDefault)
			self:CreateVar( sConvarName .. "_" .. suffix, curDefault, true, false, fCallback, fCallbackBool )
			//table.insert( buildTable, { sConvarName  .. "_" .. suffix, curDefault } )
			
			HAY_UTIL.OutputDebug( "Added Var : ".. sConvarName .. "_" .. suffix.." = ".. tostring(sDefault[k] or sDefault[1] or sDefault) )
			
		end
		
	else -- Could be a "noconvars" that is a string, and so exit code
		return false
		
	end
	
	//return buildTable
	return true
	
end

function HAY_MAIN:GetParamSuffixes( sType )
	sType = string.lower(sType)
	if not self:ParamTypeExists( sType ) then return end
	
	return HAY_PARAM_ConvarSuffixes[sType]
	
end

function HAY_MAIN:ParamBridgeCall( stData )
	return not self.EvaluateBridgeCall or self:EvaluateBridgeCall()
	
end

//////////
//////////

function HAY_MAIN:InitializeGenericConstructors()	
	self:RegisterParamType( "panel_label" , function( sConvarName, stData )	
		local myPanel = vgui.Create("DLabel")
		myPanel:SetText( stData.Text or "<Error : no text !>" )
		myPanel:SetContentAlignment( stData.ContentAlignment or 4 )
		if stData.Font then myPanel:SetFont( stData.Font ) end
		if stData.Wrap then
			myPanel:SetWrap( true )
			myPanel:SetAutoStretchVertical( true )
			
		end
		
		return myPanel
		
	end, "noconvars" )
	
	self:RegisterParamType( "bool" , function( sConvarName, stData )
		local myPanel = vgui.Create( "DCheckBoxLabel" )
		myPanel:SetText( stData.Text or "<Error : no text !>" )
		myPanel:SetConVar( self:GetVarName( sConvarName ) )
		
		return myPanel
		
	end, nil, { ["callback_isbool"] = true } )
	
	self:RegisterParamType( "range" , function( sConvarName, stData )	
		local myPanel = vgui.Create( "DNumSlider" )
		myPanel:SetText( stData.Text or "<Error : no text !>" )
		myPanel:SetMin( tonumber(stData.Min or 0) )
		myPanel:SetMax( tonumber(stData.Max or ((stData.Min or 0) + 1)) )
		myPanel:SetDecimals( tonumber(stData.Decimals or 0) )
		myPanel:SetConVar( self:GetVarName( sConvarName ) )
		
		return myPanel
		
	end )
	
	self:RegisterParamType( "color" , function( sConvarName, stData )	
		local myPanel = vgui.Create(HAY_SHORT .. "_CtrlColor")
		myPanel:SetConVarR( self:GetVarName( sConvarName ) .."_r")
		myPanel:SetConVarG( self:GetVarName( sConvarName ) .."_g")
		myPanel:SetConVarB( self:GetVarName( sConvarName ) .."_b")
		myPanel:SetConVarA( self:GetVarName( sConvarName ) .."_a")
		
		return myPanel
		
	end , {"r","g","b","a"})
	
	self:RegisterParamType( "string" , function( sConvarName, stData )	
		local myPanel = vgui.Create("DTextEntry")
		myPanel:SetConVar( self:GetVarName( sConvarName ) )
		myPanel:SetUpdateOnType( stData.UpdateOnType and true or false )
		if stData.OnEnter then
			myPanel.OnEnter = function( ... )
				if self:ParamBridgeCall( stData ) then
					stData.OnEnter( ... )
				end
			end
		end
		
		return myPanel
	end )
	
	self:RegisterParamType( "panel_readonly" , function( sConvarName, stData )	
		local myPanel = vgui.Create("DTextEntry")
		myPanel:SetText( stData.Text or "<Error : no text !>" )
		myPanel:SetEditable( false )
		
		return myPanel
	end, "noconvars" )
	
	self:RegisterParamType( "panel_button" , function( sFullConvarName, stData )	
		local myPanel = vgui.Create("DButton")
		myPanel:SetText( stData.Text or "<Error : no text !>" )
		if stData.DoClick then
			myPanel.DoClick = function( ... )
				if self:ParamBridgeCall( stData ) then
					stData.DoClick( ... )
				end
			end
		end
		if stData.DoRightClick then
			myPanel.DoRightClick = function( ... )
				if self:ParamBridgeCall( stData ) then
					stData.DoRightClick( ... )
				end
			end
		end
		
		return myPanel
	end , "noconvars" )
	
	self:RegisterParamType( "panel_sysbutton" , function( sFullConvarName, stData )	
		local myPanel = vgui.Create("DSysButton")
		myPanel:SetType( stData.Style or "grip" )
		if stData.DoClick then
			myPanel.DoClick = function( ... )
				if self:ParamBridgeCall( stData ) then
					stData.DoClick( ... )
				end
			end
		end
		if stData.DoRightClick then
			myPanel.DoRightClick = function( ... )
				if self:ParamBridgeCall( stData ) then
					stData.DoRightClick( ... )
				end
			end
		end
		
		return myPanel
	end , "noconvars" )
	

	self:RegisterParamType( "panel_imagebutton" , function( sFullConvarName, stData )	
		local myPanel = vgui.Create("DImageButton")
		myPanel:SetMaterial( stData.Material or "gui/silkicons/wrench" )
		if stData.DoClick then
			myPanel.DoClick = function( ... )
				if self:ParamBridgeCall( stData ) then
					stData.DoClick( ... )
				end
			end
		end
		if stData.DoRightClick then
			myPanel.DoRightClick = function( ... )
				if self:ParamBridgeCall( stData ) then
					stData.DoRightClick( ... )
				end
			end
		end
		
		return myPanel
	end , "noconvars" )
	
	self:RegisterParamType( "bool_nolabel" , function( sConvarName, stData )
		local myPanel = vgui.Create( "DCheckBox" )
		myPanel:SetType( stData.Style or "tick" )
		myPanel:SetConVar( self:GetVarName( sConvarName ) )
		
		return myPanel
		
	end, nil, { ["callback_isbool"] = true } )
	
end

