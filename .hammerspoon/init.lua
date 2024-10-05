function toggleApp(appName, key)
  hs.hotkey.bind({"option"}, key, function()
    local app = hs.application.get(appName)
    if app == nil then
      hs.application.launchOrFocus("/Applications/" .. appName .. ".app")
    elseif app:isFrontmost() then
      app:hide()
    else
      hs.application.launchOrFocus("/Applications/" .. appName .. ".app")
    end
  end)
end

toggleApp("Google Chrome", "j")
toggleApp("WezTerm", "k")
-- toggleApp("Slack", "l")
toggleApp("Visual Studio Code", "v")
