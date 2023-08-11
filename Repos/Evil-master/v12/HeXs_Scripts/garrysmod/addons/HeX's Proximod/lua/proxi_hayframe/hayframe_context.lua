////////////////////////////////////////////////
// -- HayFrame                                //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Menu UI Base                               //
////////////////////////////////////////////////


local HAY_MAIN, HAY_INTERNAL, HAY_CLOUD, HAY_UTIL = HAYFRAME_SetupReferences( )
local HAY_NAME, HAY_SHORT, HAY_DEBUG = HAYFRAME_SetupConstants( )

local HAY_ContextContainerList = {}
local function HAY_ContextContainer__Declare( objPanel )
	if ValidPanel( objPanel ) then
		table.insert( HAY_ContextContainerList, objPanel )
		
	end
	
end

local function HAY_ContextContainer__GetFocus( objPanel )
	local match = false
	local i = 1
	while (i <= #HAY_ContextContainerList) and not match do
		if not ValidPanel( HAY_ContextContainerList[ i ] ) then
			table.remove( HAY_ContextContainerList, i )
			
		elseif objPanel:HasParent( HAY_ContextContainerList[ i ] ) then
			match = true
			HAY_ContextContainerList[ i ]:StartKeyFocus()
			
		else
			i = i + 1
			
		end
		
	end
	
	return
	
end


local function HAY_ContextContainer__EndFocus( objPanel )
	
	local match = false
	local i = 1
	while (i <= #HAY_ContextContainerList) and not match do
		if not ValidPanel( HAY_ContextContainerList[ i ] ) then
			table.remove( HAY_ContextContainerList, i )
			
		elseif objPanel:HasParent( HAY_ContextContainerList[ i ] ) then
			match = true
			HAY_ContextContainerList[ i ]:EndKeyFocus()
			
		else
			i = i + 1
			
		end
		
	end
	
	return
	
end


local PANEL = {}

AccessorFunc( PANEL, "m_bHangOpen",     "HangOpen" )

// Code partially borrowed from contextmenu.lua from sandbox.

function PANEL:Init()
	self._Contents = nil
	
	self.Canvas = vgui.Create( "DPanelList", self )
   
	self.m_bHangOpen = false
   
	self.Canvas:EnableVerticalScrollbar( true )
	self.Canvas:SetSpacing( 0 )
	self.Canvas:SetPadding( 5 )
	self.Canvas:SetDrawBackground( false )
	
	HAY_ContextContainer__Declare( self )
       
	
end

function PANEL:GetCanvas( )
	return self.Canvas
	
end

function PANEL:SetContents( objPanel, obtb_NoUpdate )
	if not ValidPanel( objPanel ) then return end
	
	local oldContents = self._Contents
	if ValidPanel( oldContents ) then
		oldContents:SetParent( mil )
		
	end
	
	objPanel:SetParent( self )
	self._Contents = objPanel
	
	if not obtb_NoUpdate then
		self:UpdateContents()
		
	end
	
	return oldContents
	
end

function PANEL:GetContents()
	return self._Contents
	
end

function PANEL:UpdateContents()
	if not ValidPanel( self._Contents ) then return end
	
	self.Canvas:Clear()
	self.Canvas:AddItem( self._Contents )
	self.Canvas:Rebuild()
	
	self.Canvas:InvalidateLayout( )
	
end

function PANEL:Open()
	RestoreCursorPosition()
	
	self:SetKeyboardInputEnabled( false )
	self:SetMouseInputEnabled( true )
	
	self:MakePopup()
	self:SetVisible( true )
	// TODO : ?
	self:InvalidateLayout( true )
	
end


function PANEL:Close( optbForce )
	// Weird code : Supposedly cancels the first closing attempt
	if self:GetHangOpen() then
		self:SetHangOpen( false )
		if not optbForce then
			return
		
		end
		
	end
	RememberCursorPosition()
	
	self:SetKeyboardInputEnabled( false )
	self:SetMouseInputEnabled( false )

	self:SetVisible( false )
	
end

function PANEL:StartKeyFocus( pPanel )
	self:SetKeyboardInputEnabled( true )
	self:SetHangOpen( true )
       
end
 
function PANEL:EndKeyFocus( pPanel )
    self:SetKeyboardInputEnabled( false )
 
end

function PANEL:PerformLayout()
	local objContents = self._Contents
	
	if ( objContents ) then
   
			objContents:InvalidateLayout( true )
		   
			/*local Tall = objContents:GetTall() + 10
			local MaxTall = ScrH()
			if ( Tall > MaxTall ) then Tall = MaxTall end
		   
			self:SetTall( Tall )
			self.y = ScrH() - 50 - self:GetTall()*/
   
	end
   
	self.Canvas:StretchToParent( 0, 0, 0, 0 )
	self.Canvas:InvalidateLayout( true )
   
 
end

vgui.Register( HAY_SHORT .. "_ContextContainer", PANEL, "EditablePanel" )



// Remove-Add Avoids mounting issues
hook.Remove( "OnTextEntryGetFocus", "HC_" .. HAY_SHORT .. "_ContextContainer__GetFocus" )
hook.Remove( "OnTextEntryLoseFocus", "HC_" .. HAY_SHORT .. "_ContextContainer__EndFocus" )

hook.Add( "OnTextEntryGetFocus", "HC_" .. HAY_SHORT .. "_ContextContainer__GetFocus", HAY_ContextContainer__GetFocus )
hook.Add( "OnTextEntryLoseFocus", "HC_" .. HAY_SHORT .. "_ContextContainer__EndFocus", HAY_ContextContainer__EndFocus )



