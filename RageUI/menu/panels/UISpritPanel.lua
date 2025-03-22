---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by iTexZ.
--- DateTime: 05/11/2020 02:17
---
local TextPanels = {
    Background = { Dictionary = "commonmenu", Texture = "gradient_bgd", Y = 0.25, Width = 431, Height = 42 },
}

function CalculateNormalizedCoordinates(x, y, width, height)
    local referenceWidth = 1920
    local referenceHeight = 1080

    local screenWidth, screenHeight = GetActiveScreenResolution()

    local normalizedX = x / referenceWidth * screenWidth
    local normalizedY = y / referenceHeight * screenHeight

    local normalizedWidth = width / referenceWidth * screenWidth
    local normalizedHeight = height / referenceHeight * screenHeight

    return normalizedX, normalizedY, normalizedWidth, normalizedHeight
end

---@type Panel
function RageUI.RenderSprite(Dictionary, Texture)
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            RenderSprite(Dictionary, Texture, CurrentMenu.X, CurrentMenu.Y + TextPanels.Background.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + (RageUI.StatisticPanelCount * 42), TextPanels.Background.Width + CurrentMenu.WidthOffset, TextPanels.Background.Height + 200, 0, 255, 255, 255, 255);
            RageUI.StatisticPanelCount = RageUI.StatisticPanelCount + 1
        end
    end
end

function RageUI.RenderVIP(Dictionary, Texture)
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            RenderSprite(Dictionary, Texture, CurrentMenu.X, 220.25, TextPanels.Background.Width + CurrentMenu.WidthOffset, TextPanels.Background.Height + 200, 0, 255, 255, 255, 255);
            RageUI.StatisticPanelCount = RageUI.StatisticPanelCount + 1
        end
    end
end

---@type Panel
function RageUI.RenderWeapons(Dictionary, Texture)
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            RenderSprite(Dictionary, Texture, CurrentMenu.X, 410.25, TextPanels.Background.Width + CurrentMenu.WidthOffset, TextPanels.Background.Height + 200, 0, 255, 255, 255, 255);
            RageUI.StatisticPanelCount = RageUI.StatisticPanelCount + 1
        end
    end
end
---@type Panel
function RageUI.CaissePreviewOpen(url)
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            local normalizedX, normalizedY, normalizedWidth, normalizedHeight = CalculateNormalizedCoordinates(28, 160, 530, 275)

            TriggerEvent('SHOW_IMAGE', 
                true, 
                url, 
                normalizedX,
                normalizedY, 
                normalizedWidth, 
                normalizedHeight
            )
            RageUI.StatisticPanelCount = RageUI.StatisticPanelCount + 1
        end
    end
end

---@type Panel
function RageUI.CaissePreviewOpen2(url)
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            local normalizedX, normalizedY, normalizedWidth, normalizedHeight = CalculateNormalizedCoordinates(28, 200, 530, 275)

            TriggerEvent('SHOW_IMAGE', 
                true, 
                url, 
                normalizedX,
                normalizedY, 
                normalizedWidth, 
                normalizedHeight
            )
            RageUI.StatisticPanelCount = RageUI.StatisticPanelCount + 1
        end
    end
end

---@type Panel
function RageUI.RenderCaisse(Dictionary, Texture)
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            RenderSprite(Dictionary, Texture, CurrentMenu.X, 298.25, TextPanels.Background.Width + CurrentMenu.WidthOffset, TextPanels.Background.Height + 200, 0, 255, 255, 255, 255);
            RageUI.StatisticPanelCount = RageUI.StatisticPanelCount + 1
        end
    end
end

---@type Panel
function RageUI.RenderCaissePreview(url, active)
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            local normalizedX, normalizedY, normalizedWidth, normalizedHeight = CalculateNormalizedCoordinates(30, 643, 532, 275)
            if active == true then
                TriggerEvent('SHOW_IMAGE',
                        true,
                        url,
                        normalizedX,
                        normalizedY,
                        normalizedWidth,
                        normalizedHeight
                )
            else
                TriggerEvent('SHOW_IMAGE',
                        false,
                        url,
                        normalizedX,
                        normalizedY,
                        normalizedWidth,
                        normalizedHeight
                )
            end
            RageUI.StatisticPanelCount = RageUI.StatisticPanelCount + 1
        end
    end
end

---@type Panel
function RageUI.RenderJournalier(Dictionary, Texture)
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            RenderSprite(Dictionary, Texture, CurrentMenu.X, 400.25, TextPanels.Background.Width + CurrentMenu.WidthOffset, TextPanels.Background.Height + 200, 0, 255, 255, 255, 255);
            RageUI.StatisticPanelCount = RageUI.StatisticPanelCount + 1
        end
    end
end

function RageUI.RenderVehUnique(Dictionary, Texture)
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            RenderSprite(Dictionary, Texture, CurrentMenu.X, 525.25, TextPanels.Background.Width + CurrentMenu.WidthOffset, TextPanels.Background.Height + 200, 0, 255, 255, 255, 255);
            RageUI.StatisticPanelCount = RageUI.StatisticPanelCount + 1
        end
end
end