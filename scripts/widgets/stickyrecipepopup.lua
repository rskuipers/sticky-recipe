require "class"

local RecipePopup = require "widgets/recipepopup"
local ImageButton = require "widgets/imagebutton"

local RecipePopup_Refresh_base = RecipePopup.Refresh or function() return "" end
local STICKYRECIPE_OptionPos
local foldername = KnownModIndex:GetModActualName("Sticky Recipe")STICKYRECIPE_OptionPos = GetModConfigData("StickyRecipePopup_AltPos", foldername)
local wscale, unstickyhpos, unstickyvpos, buildhpos, buildvpos

local StickyRecipePopup = Class(RecipePopup, function(self, horizontal)
	RecipePopup._ctor(self, horizontal)

    self.bg:Hide()
    self.desc:Hide()

	self.unstickybutton = self.contents:AddChild(ImageButton(UI_ATLAS, "button.tex", "button_over.tex", "button_disabled.tex"))
	
	if (STICKYRECIPE_OptionPos == "original")
	then
		wscale, unstickyhpos, unstickyvpos, buildhpos, buildvpos = 1, 520, 70, 520, 140
	else
		wscale, unstickyhpos, unstickyvpos, buildhpos, buildvpos = 0.8, 400, 10, 260, 10
	end
	self.unstickybutton:SetScale(wscale, wscale, wscale)
	self.unstickybutton:SetPosition(unstickyhpos, unstickyvpos) --520 70
    self.unstickybutton:SetOnClick(function() self:Hide() end)
    self.unstickybutton:Show()
	self.unstickybutton:SetText("UNSTICKY")
	self.unstickybutton:Enable()
end)

function StickyRecipePopup:MakeSticky(recipe, owner)
	self:SetRecipe(recipe, owner)
	self:Show()
end

function StickyRecipePopup:Refresh()
	RecipePopup_Refresh_base(self)
	-- Build button ?
	self.button:SetScale(wscale, wscale, wscale)
	self.button:SetPosition(buildhpos, buildvpos) --520 140
end

return StickyRecipePopup
