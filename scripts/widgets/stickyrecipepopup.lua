require "class"

local RecipePopup = require "widgets/recipepopup"
local ImageButton = require "widgets/imagebutton"

local RecipePopup_Refresh_base = RecipePopup.Refresh or function() return "" end

local StickyRecipePopup = Class(RecipePopup, function(self, horizontal)
    RecipePopup._ctor(self, horizontal)
end)

function StickyRecipePopup:MakeSticky(recipe, owner)
    self:SetRecipe(recipe, owner)
    self:Show()
end

function StickyRecipePopup:Refresh()
    RecipePopup_Refresh_base(self)

    self.bg:Hide()
    self.desc:Hide()

    self.button:SetPosition(520, 140)

    if self.unstickybutton == nil or self.unstickybutton.parent == nil then
        self.unstickybutton = self.contents:AddChild(ImageButton())
        self.unstickybutton:SetScale(1, 1, 1)
        self.unstickybutton.image:SetScale(.45, .7)
        self.unstickybutton:SetPosition(520, 70)
        self.unstickybutton:SetOnClick(function() self:Hide() end)
        self.unstickybutton:Show()
        self.unstickybutton:SetText("Unsticky")
        self.unstickybutton:Enable()
    end

    self.name:SetPosition(320, 142, 0)

    for k, v in pairs(self.ing) do
        local pos = v:GetPosition()
        pos.y = 80
        v:SetPosition(pos)
    end
end

return StickyRecipePopup
