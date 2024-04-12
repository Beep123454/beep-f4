util.AddNetworkString("beep_f4_send_richest")

local function getMoney()
    local money = MySQLite.query("SELECT DISTINCT * FROM darkrp_player ORDER BY wallet DESC LIMIT 20")
    local leader = {}
    local currentIndex = 1 

    for _, v in ipairs(money) do
        local alreadyAdded = false
        for _, leaderData in ipairs(leader) do
            if leaderData.rpname == v.rpname then
                alreadyAdded = true
                break
            end
        end

        if not alreadyAdded then
            leader[currentIndex] = {
                rpname = v.rpname,
                wallet = v.wallet,
                uid = v.uid
            }
            currentIndex = currentIndex + 1
        end
    end

    return leader
end


local function sendinfo(ply, leader)
    net.Start("beep_f4_send_richest")
    net.WriteTable(leader)
    net.Send(ply)
end

timer.Create("F4.Timer", 120, 0, function()
    local total = getMoney()
    
    for _, v in ipairs(player.GetHumans()) do
        if not IsValid(v) then continue end
        sendinfo(v, total)
    end

end)

hook.Add("PlayerSpawn", "Eternal.F4.SendTotalMoney.Spawn", function(ply)
    if ply.totalmoneyspawn then return end
    ply.totalmoneyspawn = true
    local total = getMoney()
    sendinfo(ply, total)
    ply:SetNWInt("loginTime", os.time())
end)
