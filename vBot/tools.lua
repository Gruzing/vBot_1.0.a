-- tools tab
setDefaultTab("Tools")
UI.Separator()
if type(storage.moneyItems) ~= "table" then
  storage.moneyItems = { 3031, 3035 }
end
macro(1000, "Exchange money", function()
  if not storage.moneyItems[1] then return end
  local containers = g_game.getContainers()
  for index, container in pairs(containers) do
    if not container.lootContainer then -- ignore monster containers
      for i, item in ipairs(container:getItems()) do
        if item:getCount() >= 100 then
          for m, moneyId in ipairs(storage.moneyItems) do
            if item:getId() == moneyId.id then
              return g_game.use(item)
            end
          end
        end
      end
    end
  end
end)

local moneyContainer = UI.Container(function(widget, items)
  storage.moneyItems = items
end, true)
moneyContainer:setHeight(35)
moneyContainer:setItems(storage.moneyItems)

macro(1000, "Stack Items", function()
  local containers = g_game.getContainers()
  local toStack = {}

  for index, container in pairs(containers) do
    if not container.lootContainer then
      for i, item in ipairs(container:getItems()) do
        if item:isStackable() and item:getCount() < 1000 then
          local stackWith = toStack[item:getId()]
          if stackWith then
            local stackCount = math.min(1000 - stackWith[2], item:getCount())
            g_game.move(item, stackWith[1], stackCount)
            return
          end
          toStack[item:getId()] = { container:getSlotPosition(i - 1), item:getCount() }
        end
      end
    end
  end
end)

UI.Separator()

macro(60000, "Send message on trade", function()
  local trade = getChannelId("advertising")
  if not trade then
    trade = getChannelId("trade")
  end
  if trade and storage.autoTradeMessage:len() > 0 then
    sayChannel(trade, storage.autoTradeMessage)
  end
end)
UI.TextEdit(storage.autoTradeMessage or "", function(widget, text)
  storage.autoTradeMessage = text
end)

UI.Separator()
