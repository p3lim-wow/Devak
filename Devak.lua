--[[

	Copyright (c) 2010 Adrian L Lange <adrianlund@gmail.com>
	All rights reserved.

	You're allowed to use this addon, free of monetary charge,
	but you are not allowed to modify, alter, or redistribute
	this addon without express, written permission of the author.

--]]

if(select(2, UnitClass('player')) ~= 'SHAMAN') then return end

local buttons = {}
local coords = {
	{68/128, 96/128, 102/256, 128/256},
	{67/128, 95/128, 5/256, 31/256},
	{40/128, 68/128, 211/256, 237/256},
	{67/128, 95/128, 38/256, 64/256},
}

local function OnClick(self, button)
	if(button == 'RightButton') then
		DestroyTotem(self.id)
	end
end

local function OnUpdate(self, event, slot)
	local button = buttons[slot]
	local exists, _, start, duration = GetTotemInfo(slot)

	if(exists and duration > 0) then
		button.swirly:SetCooldown(start, duration)
		button:Show()
	else
		button:Hide()
	end
end

for index = 1, 4 do
	local button = CreateFrame('Button', nil, UIParent)
	button:SetHeight(23)
	button:SetWidth(23)
	button:SetNormalTexture([=[Interface\Buttons\UI-TotemBar]=])
	button:GetNormalTexture():SetTexCoord(unpack(coords[index]))
	button:SetBackdrop({bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=], insets = {left = -1, right = -1, top = -1, bottom = -1}})
	button:SetBackdropColor(0, 0, 0)
	button:RegisterForClicks('RightButtonUp')
	button:SetScript('OnClick', OnClick)
	button.id = index

	if(index == 1) then
		button:SetPoint('TOPLEFT', Minimap, 'BOTTOMLEFT', -1, -8)
	else
		button:SetPoint('TOPLEFT', buttons[index -1], 'TOPRIGHT', 11.5, 0)
	end

	button.swirly = CreateFrame('Cooldown', nil, button)
	button.swirly:SetAllPoints(button)
	button.swirly:SetReverse()

	buttons[index] = button
	OnUpdate(nil, nil, index)
end

local addon = CreateFrame('Frame')
addon:RegisterEvent('PLAYER_TOTEM_UPDATE')
addon:SetScript('OnEvent', OnUpdate)
