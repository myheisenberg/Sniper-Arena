-- ============================================================
--  Sniper Arena Hub v3 | Official Hub
--  Developer: zynexdev
--  Protected by Platoboost & Fluent UI Renewed
-- ============================================================

local ok, err = pcall(function()
    loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/myheisenberg/Sniper-Arena/main/main.luau"))()
end)

if not ok then
    warn("[Sniper-Arena Hub Loader Error]:", err)
end
