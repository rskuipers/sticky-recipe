local require = GLOBAL.require

require "simutil"
require "constants"

local ImageButton = require "widgets/imagebutton"
local RecipePopup = require "widgets/recipepopup"
local StickyRecipePopup = require "widgets/stickyrecipepopup"
local RecipePopup_Refresh_base = RecipePopup.Refresh or function() return "" end
local STICKYRECIPE_OptionPos = GetModConfigData("StickyRecipePopup_AltPos") or "original"
local inst = GLOBAL.GetPlayer() -- needed or not ?
inst:AddComponent("stickiedrecipe") -- add component

-- mockup of what needs doing that I don't know how to start
--on game load
--  if not inst.components.stickiedrecipe.value then display / make sticky end
--end 

function RecipePopup:Refresh()
	RecipePopup_Refresh_base(self)
	
		
	if self.stickybutton == nil then
		self.stickybutton = self.contents:AddChild(ImageButton(UI_ATLAS, "button.tex", "button_over.tex", "button_disabled.tex"))
		self.stickybutton:SetScale(1, 1, 1)
		self.stickybutton:SetPosition(320, -175, 0)
		--this should work right ?
		self.stickybutton:SetOnClick(function() GLOBAL.GetPlayer().HUD.controls.stickyrecipepopup:MakeSticky(self.recipe, self.owner);inst.components.stickiedrecipe.value = self.recipe end)
		self.stickybutton:Show()
		self.stickybutton:SetText("Sticky")
		self.stickybutton:Enable()
	else
		if (GLOBAL.GetPlayer().HUD.controls.stickyrecipepopup == nil) then
			AddStickyRecipePopup(GLOBAL.GetPlayer().HUD.controls)
		end
		GLOBAL.GetPlayer().HUD.controls.stickyrecipepopup:Refresh()
	end
	-- not actually sure I should put it here, or should I put it inside the "setonclick()" above
	-- inst.components.stickiedrecipe.value = self.recipe -- save value of stickied recipe
	-- disabled for now, pretty sure I should put it above.
end

local function PositionStickyRecipePopup(controls, screensize, hudscale)
	w = 130
	h = 380
	offset = {-80, -150}
	
	if (STICKYRECIPE_OptionPos == "original") then verticalpos = 0 else verticalpos = 20 end

	controls.stickyrecipepopup:SetVAnchor(GLOBAL.ANCHOR_BOTTOM)
	controls.stickyrecipepopup:SetHAnchor(GLOBAL.ANCHOR_LEFT)
 
	controls.stickyrecipepopup:SetPosition(
		offset[1],
		verticalpos
	)

	controls.stickyrecipepopup:SetScale(hudscale*.8, hudscale*.8, hudscale*.8)
end

function AddStickyRecipePopup(controls)
	controls.stickyrecipepopup = controls.bottom_root:AddChild(StickyRecipePopup())

	local stickyrecipepopup = controls.stickyrecipepopup

	local screensize = {GLOBAL.TheSim:GetScreenSize()}
	local hudscale = GLOBAL.TheFrontEnd:GetHUDScale()
	PositionStickyRecipePopup(controls, screensize, hudscale)

	local OnUpdate_base = controls.OnUpdate
	controls.OnUpdate = function(self, dt)
		OnUpdate_base(self, dt)
		local curscreensize = {GLOBAL.TheSim:GetScreenSize()}
		local curhudscale = GLOBAL.TheFrontEnd:GetHUDScale()
		if curscreensize[1] ~= screensize[1] or curscreensize[2] ~= screensize[2] or hudscale ~= curhudscale then
			screensize = curscreensize
			hudscale = curhudscale
			PositionStickyRecipePopup(controls, screensize, hudscale)
		end
	end

	stickyrecipepopup:Hide()

	GLOBAL.GetPlayer():ListenForEvent("itemget", function() stickyrecipepopup:Refresh() end)
	GLOBAL.GetPlayer():ListenForEvent("itemlose", function() stickyrecipepopup:Refresh() end)
	GLOBAL.GetPlayer():ListenForEvent("stacksizechange", function() stickyrecipepopup:Refresh() end)
end
