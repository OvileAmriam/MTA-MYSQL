-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    pairs = pairs,
    tonumber = tonumber,
    tostring = tostring,
    addEventHandler = addEventHandler,
    dbQuery = dbQuery,
    dbPoll = dbPoll,
    dbExec = dbExec,
    table = table,
    string = string,
    table = table,
    math = math,
    assetify = assetify
}


-----------------
--[[ Utility ]]--
-----------------

local cUtility = {
    requestPushPopItem = function(inventoryID, items, processType, callback, cloneTable, ...)
        if not inventoryID or (imports.type(inventoryID) ~= "number") or not items or (imports.type(items) ~= "table") or (#items <= 0) or not processType or (imports.type(processType) ~= "string") or ((processType ~= "push") and (processType ~= "pop")) then return false end
        if cloneTable then items = imports.table.clone(items, true) end
        return dbify.inventory.fetchAll({
            {dbify.inventory.connection.key, inventoryID},
        }, function(result, cArgs)
            if result then
                result = result[1]
                for i = 1, #cArgs[1].items do
                    local j = cArgs[1].items[i]
                    j[1] = "item_"..imports.tostring(j[1])
                    j[2] = imports.math.max(0, imports.tonumber(j[2]) or 0)
                    local prevItemData = result[(j[1])]
                    prevItemData = (prevItemData and imports.table.decode(prevItemData)) or false
                    prevItemData = (prevItemData and prevItemData.data and (imports.type(prevItemData.data) == "table") and prevItemData.item and (imports.type(prevItemData.item) == "table") and prevItemData) or false
                    if not prevItemData then
                        prevItemData = imports.table.clone(dbify.inventory.connection.item.content, true)
                    end
                    prevItemData.property[(dbify.inventory.connection.item.counter)] = j[2] + (imports.math.max(0, imports.tonumber(prevItemData.property[(dbify.inventory.connection.item.counter)]) or 0)*((cArgs[1].processType == "push" and 1) or -1))
                    cArgs[1].items[i][2] = imports.table.encode(prevItemData)
                end
                dbify.inventory.setData(cArgs[1].inventoryID, cArgs[1].items, function(result, cArgs)
                    execFunction(callback, result, cArgs)
                end, cArgs[2])
            else
                execFunction(callback, false, cArgs[2])
            end
        end, {
            inventoryID = inventoryID,
            items = items,
            processType = processType
        }, imports.table.pack(...))
    end,

    requestSetGetItemProperty = function(inventoryID, items, properties, processType, callback, cloneTable, ...)
        if not inventoryID or (imports.type(inventoryID) ~= "number") or not items or (imports.type(items) ~= "table") or (#items <= 0) or not properties or (imports.type(properties) ~= "table") or (#properties <= 0) or not processType or (imports.type(processType) ~= "string") or ((processType ~= "set") and (processType ~= "get")) then return false end
        if cloneTable then items = imports.table.clone(items, true) end
        for i = 1, #items, 1 do
            local j = items[i]
            items[i] = "item_"..imports.tostring(j)
        end
        return dbify.inventory.getData(inventoryID, items, function(result, cArgs)
            if result then
                local properties = {}
                for i, j in imports.pairs(result) do
                    j = (j and imports.table.decode(j)) or false
                    j = (j and j.data and (imports.type(j.data) == "table") and j.property and (imports.type(j.property) == "table") and j) or false
                    if cArgs[1].processType == "set" then
                        if not j then
                            j = imports.table.clone(dbify.inventory.connection.item.content, true)
                        end
                        for k = 1, #cArgs[1].properties, 1 do
                            local v = cArgs[1].properties[k]
                            v[1] = imports.tostring(v[1])
                            if v[1] == dbify.inventory.connection.item.counter then
                                v[2] = imports.math.max(0, imports.tonumber(v[2]) or j.property[(v[1])])
                            end
                            j.property[(v[1])] = v[2]
                        end
                        imports.table.insert(properties, {i, imports.table.encode(j)})
                    else
                        local itemIndex = imports.string.gsub(i, "item_", "", 1)
                        properties[itemIndex] = {}
                        if j then
                            for k = 1, #cArgs[1].properties, 1 do
                                local v = cArgs[1].properties[k]
                                v = imports.tostring(v)
                                properties[itemIndex][v] = j.property[v]
                            end
                        end
                    end
                end
                if cArgs[1].processType == "set" then
                    dbify.inventory.setData(cArgs[1].inventoryID, properties, function(result, cArgs)
                        execFunction(callback, result, cArgs)
                    end, cArgs[2])
                else
                    execFunction(callback, properties, cArgs[2])
                end
            else
                execFunction(callback, false, cArgs[2])
            end
        end, {
            inventoryID = inventoryID,
            properties = properties,
            processType = processType
        }, imports.table.pack(...))
    end,

    requestSetGetItemData = function(inventoryID, items, datas, processType, callback, cloneTable, ...)
        if not inventoryID or (imports.type(inventoryID) ~= "number") or not items or (imports.type(items) ~= "table") or (#items <= 0) or not datas or (imports.type(datas) ~= "table") or (#datas <= 0) or not processType or (imports.type(processType) ~= "string") or ((processType ~= "set") and (processType ~= "get")) then return false end
        if cloneTable then items = imports.table.clone(items, true) end
        for i = 1, #items, 1 do
            local j = items[i]
            items[i] = "item_"..imports.tostring(j)
        end
        return dbify.inventory.getData(inventoryID, items, function(result, cArgs)
            if result then
                local datas = {}
                for i, j in imports.pairs(result) do
                    j = (j and imports.table.decode(j)) or false
                    j = (j and j.data and (imports.type(j.data) == "table") and j.property and (imports.type(j.property) == "table") and j) or false
                    if cArgs[1].processType == "set" then
                        if not j then
                            j = imports.table.clone(dbify.inventory.connection.item.content, true)
                        end
                        for k = 1, #cArgs[1].datas, 1 do
                            local v = cArgs[1].datas[k]
                            j.data[imports.tostring(v[1])] = v[2]
                        end
                        imports.table.insert(datas, {i, imports.table.encode(j)})
                    else
                        local itemIndex = imports.string.gsub(i, "item_", "", 1)
                        datas[itemIndex] = {}
                        if j then
                            for k = 1, #cArgs[1].datas, 1 do
                                local v = cArgs[1].datas[k]
                                v = imports.tostring(v)
                                datas[itemIndex][v] = j.data[v]
                            end
                        end
                    end
                end
                if cArgs[1].processType == "set" then
                    dbify.inventory.setData(cArgs[1].inventoryID, datas, function(result, cArgs)
                        execFunction(callback, result, cArgs)
                    end, cArgs[2])
                else
                    execFunction(callback, datas, cArgs[2])
                end
            else
                execFunction(callback, false, cArgs[2])
            end
        end, {
            inventoryID = inventoryID,
            datas = datas,
            processType = processType
        }, imports.table.pack(...))
    end
}


---------------------------
--[[ Module: Inventory ]]--
---------------------------

local moduleInfo = dbify.createModule({
    moduleName = "inventory",
    tableName = "dbify_inventories",
    structure = {
        {"id", "BIGINT AUTO_INCREMENT PRIMARY KEY"}
    }
})

dbify.inventory = {
    connection = {
        table = "dbify_inventories",
        key = "id",
        item = {
            counter = "amount",
            content = {
                data = {},
                property = {
                    amount = 0
                }
            }
        }
    },

    ensureItems = function(...)
        local isAsync, cArgs = dbify.parseArgs(2, ...)
        local promise = function()
            if not dbify.mysql.instance then return false end
            local items, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
            if not items or (imports.type(items) ~= "table") then return false end
            imports.dbQuery(function(queryHandler, cArgs)
                local result = imports.dbPoll(queryHandler, 0)
                local itemsToBeAdded, itemsToBeDeleted = {}, {}
                if result and (#result > 0) then
                    for i = 1, #result, 1 do
                        local j = result[i]
                        local columnName = j["column_name"] or j[(string.upper("column_name"))]
                        local itemIndex = imports.string.gsub(columnName, "item_", "", 1)
                        if not cArgs[1].items[itemIndex] then
                            imports.table.insert(itemsToBeDeleted, columnName)
                        end
                    end
                end
                for i, j in imports.pairs(cArgs[1].items) do
                    imports.table.insert(itemsToBeAdded, "item_"..i)
                end
                cArgs[1].items = itemsToBeAdded
                if #itemsToBeDeleted > 0 then
                    dbify.mysql.column.delete(dbify.inventory.connection.table, itemsToBeDeleted, function(result, cArgs)
                        if result then
                            for i = 1, #cArgs[1].items, 1 do
                                local j = cArgs[1].items[i]
                                dbify.mysql.column.isValid(dbify.inventory.connection.table, j, function(isValid, cArgs)
                                    if not isValid then
                                        imports.dbExec(dbify.mysql.instance, "ALTER TABLE `??` ADD COLUMN `??` TEXT", dbify.inventory.connection.table, cArgs[1])
                                    end
                                    if cArgs[2] then
                                        execFunction(callback, true, cArgs[2])
                                    end
                                end, j, ((i >= #cArgs[1].items) and cArgs[2]) or false)
                            end
                        else
                            execFunction(callback, result, cArgs[2])
                        end
                    end, cArgs[1], cArgs[2])
                else
                    for i = 1, #cArgs[1].items, 1 do
                        local j = cArgs[1].items[i]
                        dbify.mysql.column.isValid(dbify.inventory.connection.table, j, function(isValid, cArgs)
                            if not isValid then
                                imports.dbExec(dbify.mysql.instance, "ALTER TABLE `??` ADD COLUMN `??` TEXT", dbify.inventory.connection.table, cArgs[1])
                            end
                            if cArgs[2] then
                                execFunction(callback, true, cArgs[2])
                            end
                        end, j, ((i >= #cArgs[1].items) and cArgs[2]) or false)
                    end
                end
            end, {{{
                items = items
            }, cArgs}}, dbify.mysql.instance, "SELECT `column_name` FROM information_schema.columns WHERE `table_schema`=? AND `table_name`=? AND `column_name` LIKE 'item_%'", dbify.settings.credentials.database, dbify.inventory.connection.table)
            return true
        end
        if isAsync then promise(); return isAsync
        else return promise() end
    end,

    item = {
        add = function(...)
            local isAsync, cArgs = dbify.parseArgs(3, ...)
            local promise = function()
                local inventoryID, items, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
                return cUtility.requestPushPopItem(inventoryID, items, "push", callback, imports.table.unpack(cArgs))
            end
            if isAsync then promise(); return isAsync
            else return promise() end
        end,

        remove = function(...)
            local isAsync, cArgs = dbify.parseArgs(3, ...)
            local promise = function()
                local inventoryID, items, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
                return cUtility.requestPushPopItem(inventoryID, items, "pop", callback, imports.table.unpack(cArgs))
            end
            if isAsync then promise(); return isAsync
            else return promise() end
        end,

        setProperty = function(...)
            local isAsync, cArgs = dbify.parseArgs(4, ...)
            local promise = function()
                local inventoryID, items, properties, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
                return cUtility.requestSetGetItemProperty(inventoryID, items, properties, "set", callback, imports.table.unpack(cArgs))
            end
            if isAsync then promise(); return isAsync
            else return promise() end
        end,

        getProperty = function(...)
            local isAsync, cArgs = dbify.parseArgs(4, ...)
            local promise = function()
                local inventoryID, items, properties, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
                return cUtility.requestSetGetItemProperty(inventoryID, items, properties, "get", callback, imports.table.unpack(cArgs))
            end
            if isAsync then promise(); return isAsync
            else return promise() end
        end,

        setData = function(...)
            local isAsync, cArgs = dbify.parseArgs(4, ...)
            local promise = function()
                local inventoryID, items, datas, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
                return cUtility.requestSetGetItemData(inventoryID, items, datas, "set", callback, imports.table.unpack(cArgs))
            end
            if isAsync then promise(); return isAsync
            else return promise() end
        end,

        getData = function(...)
            local isAsync, cArgs = dbify.parseArgs(4, ...)
            local promise = function()
                local inventoryID, items, datas, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
                return cUtility.requestSetGetItemData(inventoryID, items, datas, "get", callback, imports.table.unpack(cArgs))
            end
            if isAsync then promise(); return isAsync
            else return promise() end
        end
    }
}


-----------------------
--[[ Module Booter ]]--
-----------------------

imports.assetify.scheduler.execOnModuleLoad(function()
    if not dbify.mysql.instance then return false end
    imports.dbExec(dbify.mysql.instance, "CREATE TABLE IF NOT EXISTS `??` (`??` INT AUTO_INCREMENT PRIMARY KEY)", dbify.inventory.connection.table, dbify.inventory.connection.key)
end)