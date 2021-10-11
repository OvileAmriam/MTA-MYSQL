# ━ S Y N O P S I S

![](https://raw.githubusercontent.com/ov-sa/DBify-Library/Documentation/assets/dbify_banner.png)

##### ━ Maintainer(s): [Aviril](https://github.com/Aviril)

**DBify Library** is a open-source MySQL based Async database management library made by **Aviril** for [Multi Theft Auto \(MTA\)](https://multitheftauto.com/).

**DBify** integrates & synchronizes default MTA Accounts & Serials w/ MySQL aiming towards gamemode perspective for efficient & reliable database management, thus giving you more time to focus on your gamemode rather than managing redundant database queries or reinventing the wheel. Moreover, DBify helps you to process your queries efficiently without freezing the server due to its Async nature. This library is a complete overhaul of **mysql_library**, **accounts_library** & **serials_library** developed by **[Tron](https://github.com/OvileAmriam)** with efficient & reliable methodology.

## ━ Features

💎**CONSIDER** [**SPONSORING**](https://ko-fi.com/ovileamriam) **US TO SUPPORT THE DEVELOPMENT.**

* Completely Open-Source
* Procedure Oriented Programming
* Completely Performance-Friendly
* MySQL Based
* Gamemode Perspective
* Async Data-Handling
* Supports Multiple Queries
* Synchronizes default MTA Accounts
* Synchronizes default MTA Serials
* Supports Direct-Embedding (No exports required)
* Necessary Integration APIs

## ━ Contents

* [**Official Releases**](https://github.com/OvileAmriam/MTA-DBify-Library/releases)
* [**Installation Guide**](https://github.com/ov-sa/DBify-Library/wiki)
* [**Discord Community**](http://discord.gg/sVCnxPW)

```

## ━ Module APIs

### 📚 Serial Module
---
```lua
--Objective: Fetches all existing serials
dbify.serial.fetchAll(callback(result, arguments)
    print(toJSON(result))
    print(toJSON(arguments))
end, ...)


--Objective: Adds a new serial
dbify.serial.add(serial, callback(result, arguments)
    print(tostring(result))
    print(toJSON(arguments))
end, ...)


--Objective: Deletes an existing serial
dbify.serial.delete(serial, callback(result, arguments)
    print(tostring(result))
    print(toJSON(arguments))
end, ...)


--Objective: Sets serial datas of a valid serial
dbify.serial.setData(serial, {
    --These are serial datas to be updated
    {dataName1, dataValue1},
    {dataName2, dataValue2},
    ...
}, callback(result, arguments)
    print(tostring(result))
    print(toJSON(arguments))
end, ...)


--Objective: Retrieves serial datas of a valid serial
dbify.serial.getData(serial, {
    --These are serial datas to be retrieved
    dataName1,
    dataName2,
    ...
}, callback(result, arguments)
    print(toJSON(result))
    print(toJSON(arguments))
end, ...)
```
