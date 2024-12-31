function toggleApp(appName, key)
  hs.hotkey.bind({"option"}, key, function()
    local app = hs.application.get(appName)
    local appPaths = {
      "/Applications/" .. appName .. ".app",
      "/System/Applications/" .. appName .. ".app",
      "/System/Library/CoreServices/" .. appName .. ".app"
    }
    local appPath = nil
    for _, path in ipairs(appPaths) do
      if hs.fs.attributes(path) then
        appPath = path
        break
      end
    end
    if app == nil then
      hs.application.launchOrFocus(appPath)
    elseif app:isFrontmost() then
      app:hide()
    else
      hs.application.launchOrFocus(appPath)
    end
  end)
end

toggleApp("Arc", "j")
toggleApp("Ghostty", "k")
toggleApp("Slack", "l")
toggleApp("Visual Studio Code", "h")
toggleApp("Finder", "f")
toggleApp("Notion", "n")
toggleApp("Music", "m")
toggleApp("Postman", "p")
toggleApp("TextEdit", "t")
toggleApp("Obsidian", "o")
