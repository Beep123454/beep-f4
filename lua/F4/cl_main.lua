for i = 1, 45 do
    BUi:CreateFont("F4." .. i, "Montserrat", i, 500)
    BUi:CreateFont("F4s." .. i, "Montserrat", i, 600)
    BUi:CreateFont("F4b." .. i, "Montserrat", i, 1024)
end

-- just for anyone looking at this
-- this isn't for you to look at this is for me
-- so me doing this in one file isn't bad 
-- kind of a you problem tbh :nerd:
local c = {
    bg = Color(28,28,28),
    accent = Color(40,39,44),
    light = Color(55,54,60),
    sec = Color(35,34,38),
    cwhite = Color(202,202,202),
    tert = Color(194,55,9),
    stert = Color(255,78,217),
    moneygreen = Color(255,206,31),
    online = Color(0,82,224),
    current = Color(254,89,12),
    playtime = Color(0,247,589),
}

local places = {
    Color(255,213,0),
    Color(185,185,185),
    Color(124,79,27),
}

local ranks = {
    ["superadmin"] = Color(255,0,0)
}

local playerMoney = {}

net.Receive("beep_F4_send_richest",function()
    playerMoney = net.ReadTable()
end)


function F4:CreateButton(text, img, idet, func)

    local option = BUi.Create("DButton", F4.sidebar)
    option:Stick(TOP,nil,10,10,10,0)
    option:SetText("")
    option:SetTall(F4.frame:GetTall() * .06)
    option:ClearPaint()
    option:SetupTransition("tabanim", 0.6, function(s)
        if BUi.Doclick(s) then
            return math.min(s.tabanim + 10, 255) 
        else
            return math.max(s.tabanim - 10, 0)  
        end
    end)  
    option:FadeHover(Color(c.light.r, c.light.g, c.light.b, 90),6,8)  
    option:On("Paint", function(s, w, h)
        if F4.CurrentTab == idet then
            draw.RoundedBox(8, 0, 0, w, h, c.accent)
            local col1 = ColorAlpha(c.tert, c.tert.a*s.tabanim)
            local col2 = ColorAlpha(c.stert, c.stert.a*s.tabanim)
            local col3 = ColorAlpha(Color(0,0,0), math.min(Color(0,0,0).a * s.tabanim, 230))
            BUi.masks.Start()
            surface.SetMaterial(BUi.Grad["Right"])
            surface.SetDrawColor(col1)
            surface.DrawTexturedRect(0, 0, w, h)
            surface.SetMaterial(BUi.Grad["Left"])
            surface.SetDrawColor(col2)
            surface.DrawTexturedRect(0, 0, w/2, h)
            BUi.masks.Source()
            draw.RoundedBox(8, 0, 0, w, h, c.tert)
            BUi.masks.End()
            draw.RoundedBox(8, 1, 1, w-2, h-2,col3)
            draw.SimpleText(text, "F4s.22",w/4.5,h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            BUi.DrawImgur(h * .5, h* .26,h * .45, h * .45, img, color_white)
         
        else
            draw.RoundedBox(8, 0, 0, w, h, c.light)
            draw.RoundedBox(8, 1, 1, w-2, h-2,c.sec)
            draw.SimpleText(text, "F4s.22",w/4.5,h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            BUi.DrawImgur(h * .5, h* .26,h * .45, h * .45, img, color_white)
        end

        option.tab = idet

        option.DoClick = func or function()
            F4:SelectPage(option.tab)
            option.tabanim = 0
        end        
       

        return option
    end)

end

function F4:SelectPage(tName)
    for k, v in pairs(F4.Tabs) do
        if not IsValid(v) and not IsValid(F4.frame) then continue end
        F4.CurrentTab = k == tName and k or F4.CurrentTab

        v:SetVisible(k == tName)
        if v:IsVisible() then
            v:FadeIn(.5)
        end

   

    end
end

function F4:CreatePage(tName, img)
    F4.Tabs = F4.Tabs or {}

    if F4.Tabs[tName] then
        F4.Tabs[tName]:Remove()
        F4.Tabs[tName] = nil
    end

    local page = BUi.Create("DPanel", F4.frame)
    F4.Tabs[tName] = page
    page:SetVisible(false)
    page:Stick(FILL)
    page:ClearPaint()
    
    local button = F4:CreateButton(tName, img, tName)

    return page, button
end

function F4:Open()
    
    F4.frame = BUi.Create("EditablePanel")
    F4.frame:FadeIn(.5)
    F4.frame:SetSize(BUi:Scale(1420),BUi:Scale(850))
    F4.frame:Center()
    F4.frame:MakePopup()
    F4.frame:ClearPaint():Shadow(255):Background(c.light, 16)
    F4.frame:On("Paint", function(s, w, h)
        draw.RoundedBox(16,1,1,w-2,h-2,c.bg)
    end)
    F4.frame:DockPadding(10,10,10,10)
    
    function F4.frame:OnKeyCodePressed( key ) 
        if F4.frame:IsVisible() and key == KEY_F4 then
            F4.frame:AlphaTo(0, 0.2)
            timer.Simple(0.2,function()
                F4.frame:SetVisible(false)
            end)
        end
	end

    F4.sidebar = BUi.Create("DPanel", F4.frame)
    F4.sidebar:Stick(LEFT,nil,nil,nil,10)
    F4.sidebar:SetWide(F4.frame:GetWide() * .18)
    F4.sidebar:ClearPaint():Background(c.light, 14):On("Paint", function(s, w, h)
        draw.RoundedBox(14,1,1,w-2,h-2,c.sec)
    end)

    F4.topbar = BUi.Create("DPanel", F4.frame)
    F4.topbar:Stick(TOP,nil,nil,nil,nil,10)
    F4.topbar:SetTall(F4.frame:GetTall() * .08)
    F4.topbar:ClearPaint():Background(c.light, 14):On("Paint", function(s, w, h)
        draw.RoundedBox(14,1,1,w-2,h-2,c.sec)
    end)


    F4.topbar.name = BUi.Create("DButton", F4.topbar)
    F4.topbar.name:Stick(RIGHT, nil,nil,15,10,15)
    F4.topbar.name:Text("")
    F4.topbar.name:ClearPaint():Background(c.light):On("Paint", function(s, w, h)
        draw.RoundedBox(0, 2, 0, w , h, c.sec)
        local name = LocalPlayer():Name():gsub("^%l", string.upper)
        local textWidth, _ = surface.GetTextSize(name)
        draw.SimpleText(BUi.Truncate(name,20), "F4s.25", h * 0.3, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        F4.topbar.name:SetWide(textWidth + 10)
    end)
    F4.topbar.name:SetOpenURL("https://steamcommunity.com/profiles/" .. LocalPlayer():SteamID64())
    

    F4.topbar.avatar = BUi.Create("DPanel",F4.topbar)
    F4.topbar.avatar:Stick(RIGHT,12)
    F4.topbar.avatar:SetWide(  F4.topbar:GetTall() - 24)
    F4.topbar.avatar:CircleAvatar()
    F4.topbar.avatar:SetPlayer(LocalPlayer(),184)


    F4.page = BUi.Create("DPanel",  F4.sidebar)
    F4.page:Stick(TOP)
    F4.page:SetTall(F4.sidebar:GetTall() * .08)
    F4.page:ClearPaint():Background(c.light, 8,true,true,false,false):On("Paint",function(s,w,h)
        draw.RoundedBoxEx(8,1,1,w-2,h-2,c.accent,true,true,false,false)
        draw.SimpleText( "Meta Roleplay", "F4b.25",h,h/3, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText( "The best server", "F4.22",h,h/1.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        BUi.DrawImgur(h * .1, h * .1,h * .8 ,h * .8,"69PK8mX",color_white)
    end)

    F4.searchhold = BUi.Create("DPanel",  F4.topbar)
    F4.searchhold:Stick(LEFT,14)
    F4.searchhold:SetWide(F4.topbar:GetWide() * .25)
    F4.searchhold:ClearPaint():Background(c.light, 8):On("Paint", function(s, w, h)
        draw.RoundedBox(8,1,1,w-2,h-2,c.accent)
        BUi.DrawImgur(h * .15, h * .15,h * .7,h * .7, "MKP8lUR",color_white)
    end)
    F4.searchhold:DockPadding(40,0,0,0)

    F4.search = BUi.Create("DTextEntry",  F4.searchhold)
    F4.search:Stick(FILL)
    F4.search:ReadyTextbox()
    F4.search:SetPlaceholderText( "Search for...")
    F4.search:SetFont("F4b.22")
    F4.search:SetTextColor(c.cwhite)
    F4.search:SetCursorColor( c.cwhite )


    F4:Dashboard()
    F4:JobsTab()
    F4:EntTab()
    F4:WepTab()

    F4.search.OnChange = function()
        F4.jobtab.Fill()
        F4.EntitiesTab.Fill()
        F4.WepaonsTab.Fill()
    end

end

function F4:Dashboard()
    F4.dash = F4:CreatePage("Dashboard", "9ruR4Ef")
    F4.dash:ClearPaint()
    F4:SelectPage("Dashboard")
    
    F4.dash.right = BUi.Create("DPanel",F4.dash)
    F4.dash.right:Stick(RIGHT,nil,10)
    F4.dash.right:SetWide(F4.frame:GetWide() * .3)
    F4.dash.right:ClearPaint()

    F4.dash.right.leader = BUi.Create("DPanel",  F4.dash.right)
    F4.dash.right.leader:Stick(TOP,nil,nil,nil,nil,10)
    F4.dash.right.leader:SetTall(F4.frame:GetTall() * .375)
    F4.dash.right.leader:ClearPaint():Background(c.light, 14):On("Paint", function(s, w, h)
        draw.RoundedBox(14,1,1,w-2,h-2,c.sec)
        draw.RoundedBox(0,0,h/9,w,1,c.light)
        draw.RoundedBoxEx(14,1,1,w-2,h/9.4,c.accent,true,true,false,false)
        draw.SimpleText( "LeaderBoard", "F4s.20",h * .03,20, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end)
    
    F4.dash.right.leader.scroll = BUi.Create("DScrollPanel", F4.dash.right.leader)
    F4.dash.right.leader.scroll:Stick(FILL,nil,nil,36)
    F4.dash.right.leader.scroll:HideVBar()

    for k,v in pairs(playerMoney) do 
        F4.dash.right.leader.player = BUi.Create("DPanel",F4.dash.right.leader.scroll)
        F4.dash.right.leader.player:Stick(TOP,nil,10,10,10,0)
        F4.dash.right.leader.player:SetTall(F4.dash.right.leader:GetTall() * .15)
        F4.dash.right.leader.player:ClearPaint():Background(c.light, 8):On("Paint", function(s, w, h)
            
            for key,value in ipairs(places) do
                if k == key then
                    BUi.masks.Start()
                    surface.SetMaterial(BUi.Grad["Right"])
                    surface.SetDrawColor(value)
                    surface.DrawTexturedRect(0, 0, w, h)
                    BUi.masks.Source()
                    draw.RoundedBox(8, 0, 0, w, h, c.tert)
                    BUi.masks.End()
                end
            end

            draw.RoundedBox(8,1,1,w-2,h-2,c.sec)
            draw.SimpleText(BUi.Truncate(v.rpname,20) .. " | " .. BUi:FormatMoney(tonumber(v.wallet)), "F4s.25",h * 1,h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end)

        F4.dash.right.leader.avatar = BUi.Create("DPanel",F4.dash.right.leader.player)
        F4.dash.right.leader.avatar:Stick(LEFT,8)
        F4.dash.right.leader.avatar:SetWide(  F4.dash.right.leader.player:GetTall() - 16)
        F4.dash.right.leader.avatar:CircleAvatar()
        F4.dash.right.leader.avatar:SetSteamID(v.uid,184)
    end

    F4.dash.right.staff = BUi.Create("DPanel",  F4.dash.right)
    F4.dash.right.staff:Stick(TOP,nil,nil,nil,nil,10)
    F4.dash.right.staff:SetTall(F4.frame:GetTall() * .499)
    F4.dash.right.staff:ClearPaint():Background(c.light, 14):On("Paint", function(s, w, h)
        draw.RoundedBox(14,1,1,w-2,h-2,c.sec)
        draw.RoundedBox(0,0,h/12,w,1,c.light)
        draw.RoundedBoxEx(14,1,1,w-2,h/12.4,c.accent,true,true,false,false)
        draw.SimpleText( "Active Staff", "F4s.20",h * .03,20, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end)

    F4.dash.right.staff.scroll = BUi.Create("DScrollPanel", F4.dash.right.staff)
    F4.dash.right.staff.scroll:Stick(FILL,nil,nil,36)
    F4.dash.right.staff.scroll:HideVBar()

    for k,ply in pairs(player.GetAll()) do 
        for k,v in pairs(ranks) do
            if ply:GetUserGroup() == "user" then continue end
            if k == ply:GetUserGroup() then
                F4.dash.right.staff.player = BUi.Create("DPanel",F4.dash.right.staff.scroll)
                F4.dash.right.staff.player:Stick(TOP,nil,10,10,10,0)
                F4.dash.right.staff.player:SetTall(F4.dash.right.staff:GetTall() * .12)
                F4.dash.right.staff.player:ClearPaint():Background(c.light, 8):On("Paint", function(s, w, h)
                    draw.RoundedBox(8,1,1,w-2,h-2,c.sec)
                    draw.SimpleText(ply:Name(), "F4s.25",h * 1,h/3.4, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    draw.SimpleText(ply:GetUserGroup(), "F4.25",h * 1,h/1.5, v, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end)
        
                F4.dash.right.staff.avatar = BUi.Create("DPanel",F4.dash.right.staff.player)
                F4.dash.right.staff.avatar:Stick(LEFT,8)
                F4.dash.right.staff.avatar:SetWide(  F4.dash.right.staff.player:GetTall() - 16)
                F4.dash.right.staff.avatar:CircleAvatar()
                F4.dash.right.staff.avatar:SetPlayer(ply,184)
            end
        end
    end
    

    F4.dash.laws = BUi.Create("DPanel",F4.dash)
    F4.dash.laws:Stick(BOTTOM)
    F4.dash.laws:SetTall(F4.frame:GetTall() * .5)
    F4.dash.laws:ClearPaint():Background(c.light, 14):On("Paint", function(s, w, h)
        draw.RoundedBox(14,1,1,w-2,h-2,c.sec)
        draw.RoundedBox(0,0,h/12,w,1,c.light)
        draw.RoundedBoxEx(14,1,1,w-2,h/12.4,c.accent,true,true,false,false)
        draw.SimpleText( "Laws of the land", "F4s.20",h * .03,20, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end)

    F4.dash.laws.scroll = BUi.Create("DScrollPanel",F4.dash.laws)
    F4.dash.laws.scroll:Stick(FILL,nil,nil,36)
    F4.dash.laws.scroll:HideVBar()

    for k,v in pairs(DarkRP.getLaws()) do
        item = BUi.Create("DPanel",F4.dash.laws.scroll)
        item:Stick(TOP,nil,10)
        item:SetTall(F4.dash.laws:GetTall() * .1)
        item:ClearPaint():On("Paint", function(s, w, h)
            draw.SimpleText( "⋗ " .. BUi.Truncate(v,60), "F4s.20",h * .03,20, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end)
       
    end

    F4.dash.active = BUi.Create("DPanel",F4.dash)
    F4.dash.active:Stick(TOP,nil,nil,nil,F4.frame:GetWide() * .242,10)
    F4.dash.active:SetTall(F4.frame:GetTall() * .18)
    F4.dash.active:ClearPaint():Background(c.light, 14):On("Paint", function(s, w, h)
        draw.RoundedBox(14,1,1,w-2,h-2,c.sec)
        draw.RoundedBox(12,h* .1, h* .1,h * .8,h* .8,c.online)
        draw.RoundedBox(12,h* .1 + 4, h* .1 + 4,h * .8 - 8,h* .8 - 8,c.sec)
        BUi.masks.Start()
        surface.SetMaterial(BUi.Grad["Down"])
        surface.SetDrawColor(c.online)
        surface.DrawTexturedRect(0,0,w,h)
        BUi.masks.Source()
        draw.RoundedBox(12, h* .1 + 4, h* .1 + 4,h * .8 - 8,h* .8 - 8, c.online)
        BUi.masks.End()
        BUi.DrawImgur( h* .15, h* .15,h * .7, h * .7, "7QmSuO2", color_white,8)

        draw.SimpleText( "Total Players", "F4.25",h * 1,30, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        
        draw.SimpleText( table.Count(player.GetAll()) .. "/" .. game.MaxPlayers(), "F4s.30",h * 1,60, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    end)

    local totalmoeny = 0

    for k,v in pairs(playerMoney) do
        totalmoeny =  totalmoeny + v.wallet
    end

    F4.dash.economy = BUi.Create("DPanel",F4.dash)
    F4.dash.economy:Stick(LEFT,nil,nil,nil,10,10)
    F4.dash.economy:SetWide(F4.frame:GetWide() * .25)
    F4.dash.economy:ClearPaint():Background(c.light, 14):On("Paint", function(s, w, h)
        draw.RoundedBox(14,1,1,w-2,h-2,c.sec)
        draw.RoundedBox(8,h* .1, h* .1,h * .8,h* .8,c.moneygreen)
        draw.RoundedBox(8,h* .1 + 4, h* .1 + 4,h * .8 - 8,h* .8 - 8,c.sec)
        BUi.masks.Start()
        surface.SetMaterial(BUi.Grad["Down"])
        surface.SetDrawColor(c.moneygreen)
        surface.DrawTexturedRect(0,0,w,h)
        BUi.masks.Source()
        draw.RoundedBox(8, h* .1 + 4, h* .1 + 4,h * .8 - 8,h* .8 - 8, c.moneygreen)
        BUi.masks.End()
        BUi.DrawImgur( h* .15, h* .15,h * .7, h * .7, "GqAG3jm", color_white,8)
        draw.SimpleText( "Total Economy", "F4.25",h * 1,30, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        
        draw.SimpleText( "$" .. string.Comma(totalmoeny), "F4s.30",h * 1,60, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end)

    F4.dash.playtime = BUi.Create("DPanel",F4.dash)
    F4.dash.playtime:Stick(BOTTOM,nil,nil,nil,nil,10)
    F4.dash.playtime:SetTall(F4.frame:GetTall() * .18)
    F4.dash.playtime:ClearPaint():Background(c.light, 14):On("Paint", function(s, w, h)
        draw.RoundedBox(14,1,1,w-2,h-2,c.sec)
        draw.RoundedBox(8,h* .1, h* .1,h * .8,h* .8,c.playtime)
        draw.RoundedBox(8,h* .1 + 4, h* .1 + 4,h * .8 - 8,h* .8 - 8,c.sec)
        BUi.masks.Start()
        surface.SetMaterial(BUi.Grad["Down"])
        surface.SetDrawColor(c.playtime)
        surface.DrawTexturedRect(0,0,w,h)
        BUi.masks.Source()
        draw.RoundedBox(8, h* .1 + 4, h* .1 + 4,h * .8 - 8,h* .8 - 8, c.playtime)
        BUi.masks.End()
        BUi.DrawImgur( h* .15, h* .15,h * .7, h * .7, "kROgZPN", color_white,8)
        draw.SimpleText( "Play time", "F4.25",h * 1,30, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText( sam.reverse_parse_length(LocalPlayer():sam_get_play_time() / 60), "F4s.30",h * 1,60, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end)

    F4.dash.current = BUi.Create("DPanel",F4.dash)
    F4.dash.current:Stick(BOTTOM,nil,nil,nil,nil,10)
    F4.dash.current:SetTall(F4.frame:GetTall() * .18)
    F4.dash.current:ClearPaint():Background(c.light, 14):On("Paint", function(s, w, h)
        local loginTime = LocalPlayer():GetNWInt("loginTime")
        local currentTime = os.time()
        local sessionDuration = currentTime - loginTime
        local hours = math.floor(sessionDuration / 3600)
        local minutes = math.floor((sessionDuration % 3600) / 60)
        local seconds = sessionDuration % 60

        draw.RoundedBox(14,1,1,w-2,h-2,c.sec)
        draw.RoundedBox(8,h* .1, h* .1,h * .8,h* .8,c.current)
        draw.RoundedBox(8,h* .1 + 4, h* .1 + 4,h * .8 - 8,h* .8 - 8,c.sec)
        BUi.masks.Start()
        surface.SetMaterial(BUi.Grad["Down"])
        surface.SetDrawColor(c.current)
        surface.DrawTexturedRect(0,0,w,h)
        BUi.masks.Source()
        draw.RoundedBox(8, h* .1 + 4, h* .1 + 4,h * .8 - 8,h* .8 - 8, c.current)
        BUi.masks.End()
        BUi.DrawImgur( h* .15, h* .15,h * .7, h * .7, "LgqlUXE", color_white,8)
        draw.SimpleText( "Current Session", "F4.25",h * 1,30, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        if hours == 0  then
            draw.SimpleText( minutes .. ":" .. seconds , "F4s.30",h * 1,60, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText( hours .. ":" .. minutes .. ":" .. seconds , "F4s.30",h * 1,60, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end)
    
end

function F4:JobsTab()
    F4.jobtab = F4:CreatePage("Jobs", "EcaCkha")

    F4.jobtab.scroll = BUi.Create("BUi.Scroll",F4.jobtab)
    F4.jobtab.scroll:Stick(FILL)
    F4.jobtab.scroll:VBarSetWide(0)

    function F4.jobtab.Fill()
        local sorted = {}
        local seen = {}
        
        for k, cat in pairs(DarkRP.getCategories().jobs) do
            for k, v in pairs(cat.members) do 
                if #cat.members < 1 then continue end
                if isfunction(cat.canSee) and not cat.canSee(LocalPlayer()) then continue end
                if F4.search:GetValue() ~= "" and not string.find(string.lower(v.name), string.lower(F4.search:GetValue())) then continue end
                if seen[cat] then continue end
                table.insert(sorted, cat)
                seen[cat] = true
            end
        end
        F4.jobtab.scroll:Clear()

        for k, cat in pairs(sorted) do
    
            local category = BUi.Create("DCollapsibleCategory", F4.jobtab.scroll)
            category:Stick(TOP, nil, 10, 10, 10, 0)
            category:SetHeaderHeight(50)
            category:ClearPaint()
            category:SetLabel("")
            category.Header:BUi():ClearPaint():Background(c.light, 8):On("Paint", function(s, w, h)
                BUi.masks.Start()
                surface.SetMaterial(BUi.Grad["Right"])
                surface.SetDrawColor(cat.color)
                surface.DrawTexturedRect(0, 0, w, h)
                
                surface.SetMaterial(BUi.Grad["Left"])
                surface.SetDrawColor(cat.color)
                surface.DrawTexturedRect(0, 0, w/2, h)   
                BUi.masks.Source()
                draw.RoundedBox(8, 0, 0, w, h, c.tert)
                BUi.masks.End()
                draw.RoundedBox(8,1,1,w-2,h-2,c.sec)
                draw.SimpleText(cat.name, "F4s.28",20,h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                BUi.DrawImgur(w - 50, h/2 - h * .4, h * .8, h * .8, category:GetExpanded() and "biMVada" or "gmYCoos", color_white)
            end)
            category.Header:DockMargin(0,0,0,10)

            local categorygrid = BUi.Create("DIconLayout",category)
            category:SetContents(categorygrid)
            categorygrid:Dock(FILL)
            local spacing = 10
            categorygrid:SetSpaceX(spacing)
            categorygrid:SetSpaceY(spacing)

            for k,v in pairs(cat.members) do
                if (F4.search:GetValue() ~= "" and not string.find(string.lower(v.name), string.lower(F4.search:GetValue()))) then continue end
                category.ListItem = BUi.Create("DButton",categorygrid)
                category.ListItem:DockMargin(0,10,0,0)
                category.ListItem:SetSize((F4.frame:GetWide() - 320) / 2, 80) 
                category.ListItem:Text("")
                local todraw = math.Min(team.NumPlayers(v.team) / v.max, 1)
                local lerpc =  0
                category.ListItem:ClearPaint():Background(c.light, 8):On("Paint", function(s, w, h)
                    BUi.masks.Start()
                    surface.SetMaterial(BUi.Grad["Right"])
                    surface.SetDrawColor(v.color)
                    surface.DrawTexturedRect(0, 0, w, h)
                    
                    surface.SetMaterial(BUi.Grad["Left"])
                    surface.SetDrawColor(v.color)
                    surface.DrawTexturedRect(0, 0, w/2, h)                    
                    BUi.masks.Source()
                    draw.RoundedBox(8, 0, 0, w, h, c.tert)
                    BUi.masks.End()
                    draw.RoundedBox(8,1,1,w-2,h-2,c.sec)

                    draw.RoundedBox(8,h*.1,h * .1,h*.8,h * .8,v.color)
                    draw.RoundedBox(8,h*.1 + 1,h * .1 + 1,h*.8 - 2,h * .8 - 2,c.sec)
                    BUi.masks.Start()
                    surface.SetMaterial(BUi.Grad["Down"])
                    surface.SetDrawColor(v.color)
                    surface.DrawTexturedRect(0,0,w,h)
                    BUi.masks.Source()
                    draw.RoundedBox(4,h*.1 + 1,h * .1 + 1,h*.8 - 2,h * .8 - 2,c.sec)
                    BUi.masks.End()

                    draw.RoundedBox(4,h*.9 + 10,h * .55 + 1,h * 5.7,h * .3,c.light)
                    draw.RoundedBox(4,h*.9 + 11,h * .55 + 2,h * 5.7 - 2,h * .3 -2,c.sec)
                    BUi.masks.Start()
                    surface.SetMaterial(BUi.Grad["Right"])
                    surface.SetDrawColor(v.color)
                    surface.DrawTexturedRect(0, 0, w, h)

                    BUi.masks.Source()
                    lerpc = Lerp(FrameTime() * 4, lerpc, team.NumPlayers(v.team))
                    local count = math.Clamp(lerpc / (v.max == 0 and 1 or v.max), 0, 1)
                    draw.RoundedBox(4,h*.9 + 11,h * .55 + 2,(h * 5.7 - 2) * count,h * .3 -2,c.sec)
                    BUi.masks.End()

                    draw.SimpleText(v.name, "F4s.25",h * 1,h/3, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    if v.max > 0 then
                        draw.SimpleText(team.NumPlayers(v.team) .. "/" .. v.max or 0, "F4.22",w/1.8,h * .7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    else
                        draw.SimpleText(team.NumPlayers(v.team) .. "/∞", "F4.22",w/1.8,h * .7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end
                end):CircleClick()

                category.ListItem:On("DoClick", function(s, w, h)
                    if IsValid(category.ListItem.popout) then
                        category.ListItem.popout:Remove()
                    end

                    category.holder = BUi.Create("DButton",F4.jobtab)
                    category.holder:FadeIn(.5)
                    category.holder:Dock(FILL,nil,nil,100)
                    category.holder:Text("")
                    category.holder:ClearPaint():On("Paint", function(s, w, h)
                        draw.RoundedBox(8,1,1,w-2,h-2,Color(0,0,0,130))
                        
                    end):On("DoClick", function(s)
                        category.ListItem.popout:Remove()
                        s:Remove()
                    end):Blur()
                    F4.search.OnChange = function()
                        F4.jobtab.Fill()
                        if IsValid(category.holder) then
                            category.holder:Remove()
                        end
                        F4.EntitiesTab.Fill()
                        F4.WepaonsTab.Fill()
                    end

                    category.ListItem.popout = BUi.Create("DPanel", category.holder)
                    category.ListItem.popout:SetSize(F4.jobtab:GetWide() * .35,F4.jobtab:GetTall() * .985)
                    category.ListItem.popout:SetPos(F4.jobtab:GetWide() * .8, 0)
                    category.ListItem.popout:MoveTo(F4.jobtab:GetWide() * .65, 10, 0.2)
                    category.ListItem.popout:DockPadding(15,15,15,15)
                    

                    category.ListItem.popout:ClearPaint():FadeIn(.5):Background(v.color, 8):On("Paint", function(s, w, h)
                        draw.RoundedBox(8,1,1,w-2,h-2,c.bg)


                        draw.SimpleText(v.name, "F4b.35",w / 2,h * .38, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                        draw.SimpleText("Salary: $" .. v.salary, "F4s.20",w / 2,h * .42, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        

                    end)

                    local description = BUi.Create("DPanel",category.ListItem.popout) 
                    description:Stick(BOTTOM,nil,nil,10)
                    description:ClearPaint():Background(c.light, 8):On("Paint", function(s, w, h)
                        draw.RoundedBox(8,1,1,w-2,h-2,c.bg)

                        draw.RoundedBox(0,0,h/12,w,1,c.light)
                        draw.RoundedBoxEx(8,1,1,w-2,h/12.4,c.accent,true,true,false,false)
                        draw.SimpleText("Description", "F4s.20",5,h/24, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    end)
                    description:DockPadding(0,0,0,0)

                    local scroll = BUi.Create("BUi.Scroll",description)
                    scroll:Stick(FILL,nil,5,36)
                    
            
                  
                    local item = BUi.Create("DLabel",scroll)
                    item:SetWrap(true)
                    item:SetAutoStretchVertical(true)
                    item:Stick(TOP,2)
                    item:SetTall(description:GetTall() * 1.5)
                    item:SetText(v.description:gsub("\n%s*", "\n"))
                    item:SetFont("F4b.20")
                    item:SetTextColor(color_white)

                    for k,v in pairs(v.weapons) do
                        local wep = BUi.Create("DPanel",scroll)
                        wep:Stick(TOP,5)
                        wep:SetTall(50)
                        wep:ClearPaint():Background(c.light, 8):On("Paint", function(s, w, h)
                            draw.RoundedBox(8,1,1,w-2,h-2,c.bg)
                            draw.SimpleText(weapons.Get(v) and weapons.Get(v).PrintName or "Unknown", "F4s.20",w * .2,h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        end)

                        local wepmodel = BUi.Create("ModelImage",wep)
                        wepmodel:Dock(LEFT,5)
                        wepmodel:SetWide(50)
                        
                        local model = weapons.Get(v) and weapons.Get(v).WorldModel or "error.model"
                        wepmodel:SetModel(model)
                        
                       
                    end


                    description:SetTall(category.ListItem.popout:GetWide() * 1)

                    local become = BUi.Create("DButton",description) 
                    become:SetTall(50)
                    become:Stick(BOTTOM,10):ClearPaint():Background(c.light, 8):On("Paint", function(s, w, h)
                        draw.RoundedBox(8,1,1,w-2,h-2,c.bg)
                        draw.SimpleText(v.vote and "Vote" or "Become", "F4s.25",w /2,h /2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end)
                    become:FadeHover(Color(v.color.r,v.color.g,v.color.b,30),6,8)
                    become:Text("")


                    local model = BUi.Create("DModelPanel",category.ListItem.popout)
                    model:Stick(BOTTOM,nil,nil,nil,nil,60)
                    model:ClearPaint()
                    model:SetTall(category.ListItem.popout:GetWide() * .5)
                    model:SetCamPos(Vector(25, 0, 67))
                    model:SetLookAt(Vector(0, 0, 65))
                    model:SetFOV(60)
                    model:SetMouseInputEnabled(true)
                    model.LayoutEntity = function() end
                    local basePaint = baseclass.Get("DModelPanel").Paint
                    model:SetWide(category.ListItem.popout:GetWide() * .5)
                    model:SetTall(category.ListItem.popout:GetWide() * .5)
                    model.Paint = function(s, w, h)

                        local pixel = 1
                        render.ClearStencil()
                        render.SetStencilEnable(true)
                    
                        render.SetStencilWriteMask(1)
                        render.SetStencilTestMask(1)
                    
                        render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
                        render.SetStencilPassOperation(STENCILOPERATION_KEEP)
                        render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
                        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
                        render.SetStencilReferenceValue(pixel)

                        BUi.DrawCircle(w/2, h/2, 90, c.bg)
                        
                    
                        render.SetStencilFailOperation(STENCILOPERATION_KEEP)
                        render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
                        render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
                        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
                        render.SetStencilReferenceValue(pixel)


                        surface.SetMaterial(BUi.Grad["Up"])
                        surface.SetDrawColor(v.color)
                        surface.DrawTexturedRect(0,0,w,h)
                        basePaint(s, w, h)
                    
                        render.SetStencilEnable(false)
                        render.ClearStencil()
                        
            
                    end

                    if istable(v.model) then
                        model:SetModel(v.model[1])
                    else
                        model:SetModel(v.model)
                    end
                    

                    local count = 1

                    local leftbutton = BUi.Create("DButton",model)
                    leftbutton:Stick(LEFT)
                    leftbutton:Text("")
                    leftbutton:SetWide(model:GetWide() * .5)
                    leftbutton:ClearPaint():On("Paint",function(s,w,h)
                        BUi.DrawImgurRotated(h * .15,h* .45,w, h * .4,180,"Dy4zhm7",s:IsHovered() and color_white or c.light)
                    end):On("DoClick",function(s)
                        if count == 1 then 
                            count = #v.model
                        else
                            count = count - 1
                        end

                        if istable(v.model) then
                            model:SetModel(v.model[count])
                        else
                            model:SetModel(v.model)
                        end    
                    end)

                    local rightbutton = BUi.Create("DButton",model)
                    rightbutton:Stick(RIGHT)
                    rightbutton:Text("")
                    rightbutton:SetWide(model:GetWide() * .5)
                    rightbutton:ClearPaint():On("Paint",function(s,w,h)
                        BUi.DrawImgur(h *.09,h* .3,w, h * .4,"Dy4zhm7",s:IsHovered() and color_white or c.light)
                    end):On("DoClick",function(s)
                        if count == #v.model then 
                            count = 1
                        else
                            count = count + 1
                        end
                        if istable(v.model) then
                            model:SetModel(v.model[count])
                        else
                            model:SetModel(v.model)
                        end
                        
                    end)

                    become:On("DoClick",function(s)
                        LocalPlayer():ConCommand(v.vote and "say /vote" .. v.command or "say /" .. v.command)
                        DarkRP.setPreferredJobModel(v.team, model:GetModel())
                    end)
                    become:CircleClick()

                end)   

                local model = BUi.Create("ModelImage",category.ListItem) 
                model:Stick(LEFT, 10)
                model:SetWide(category.ListItem:GetTall() * .8)

                if istable(v.model) then
                    model:SetModel(v.model[1])
                else
                    model:SetModel(v.model)
                end
            end
        end
    end
    F4.jobtab.Fill()
        
end

function F4:EntTab()
    F4.EntitiesTab = F4:CreatePage("Entities", "EcaCkha")
    F4.EntitiesTab.scroll = BUi.Create("BUi.Scroll", F4.EntitiesTab)
    F4.EntitiesTab.scroll:Stick(FILL)
    F4.EntitiesTab.scroll:VBarSetWide(0)

    function F4.EntitiesTab.Fill()
        local sorted = {}
        local seen = {}
        for k,cat in pairs(DarkRP.getCategories().entities) do
            for k,v in pairs(cat.members) do 
                if v.cmd and not F4:CheckEntity(v) then continue end
                if F4.search:GetValue() ~= "" and not string.find(string.lower(v.name), string.lower(F4.search:GetValue())) then continue end
                if seen[cat] then continue end
                table.insert(sorted, cat)
                seen[cat] = true
            end
        end

        F4.EntitiesTab.scroll:Clear()
        for k, cat in pairs(sorted) do
            if #cat.members <= 0 then continue end
            local category = BUi.Create("DCollapsibleCategory", F4.EntitiesTab.scroll)
            category:Stick(TOP, nil, 10, 10, 10, 0)
            category:SetHeaderHeight(50)
            category:ClearPaint()
            category:SetLabel("")
            category.Header:BUi():ClearPaint():Background(c.light, 8):On("Paint", function(s, w, h)
                BUi.masks.Start()
                surface.SetMaterial(BUi.Grad["Right"])
                surface.SetDrawColor(cat.color)
                surface.DrawTexturedRect(0, 0, w, h)
                surface.SetMaterial(BUi.Grad["Left"])
                surface.SetDrawColor(cat.color)
                surface.DrawTexturedRect(0, 0, w / 2, h)
                BUi.masks.Source()
                draw.RoundedBox(8, 0, 0, w, h, c.tert)
                BUi.masks.End()
                draw.RoundedBox(8, 1, 1, w - 2, h - 2, c.sec)
                draw.SimpleText(cat.name:gsub("^%l", string.upper), "F4s.28", 20, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                BUi.DrawImgur(w - 50, h/2 - h * .4, h * .8, h * .8, category:GetExpanded() and "biMVada" or "gmYCoos", color_white)
            end)

            category.Header:DockMargin(0, 0, 0, 10)
            local categorygrid = BUi.Create("DIconLayout", category)
            category:SetContents(categorygrid)
            categorygrid:Dock(FILL)
            local spacing = 10
            categorygrid:SetSpaceX(spacing)
            categorygrid:SetSpaceY(spacing)
            for k, v in pairs(cat.members) do
                if F4.search:GetValue() ~= "" and not string.find(string.lower(v.name), string.lower(F4.search:GetValue())) then continue end
                if v.customCheck and not v.customCheck( LocalPlayer() )  then continue end
                category.ListItem = BUi.Create("DButton", categorygrid)
                category.ListItem:DockMargin(0, 10, 0, 0)
                category.ListItem:SetSize((F4.frame:GetWide() - 320) / 2, 80)
                category.ListItem:Text("")
                category.ListItem:ClearPaint():Background(c.light, 8):On("Paint", function(s, w, h)
                    BUi.masks.Start()
                    surface.SetMaterial(BUi.Grad["Right"])
                    surface.SetDrawColor(cat.color)
                    surface.DrawTexturedRect(0, 0, w, h)
                    surface.SetMaterial(BUi.Grad["Left"])
                    surface.SetDrawColor(cat.color)
                    surface.DrawTexturedRect(0, 0, w / 2, h)
                    BUi.masks.Source()
                    draw.RoundedBox(8, 0, 0, w, h, c.tert)
                    BUi.masks.End()
                    draw.RoundedBox(8, 1, 1, w - 2, h - 2, c.sec)
                    draw.RoundedBox(8, h * .1, h * .1, h * .8, h * .8, cat.color)
                    draw.RoundedBox(8, h * .1 + 1, h * .1 + 1, h * .8 - 2, h * .8 - 2, c.sec)
                    BUi.masks.Start()
                    surface.SetMaterial(BUi.Grad["Down"])
                    surface.SetDrawColor(cat.color)
                    surface.DrawTexturedRect(0, 0, w, h)
                    BUi.masks.Source()
                    draw.RoundedBox(4, h * .1 + 1, h * .1 + 1, h * .8 - 2, h * .8 - 2, c.sec)
                    BUi.masks.End()
                    draw.SimpleText(v.name, "F4s.25", h * 1, h / 3, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    draw.SimpleText(DarkRP.formatMoney(v.price), "F4s.22", h * 1, h / 1.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end):CircleClick()
                category.ListItem:On("DoClick", function(s, w, h) 
                    if v.cmd then
                        LocalPlayer():ConCommand("say /" .. v.cmd)
                    else
                        LocalPlayer():ConCommand("say /buyammo " .. v.id)
                    end
                end)
                local model = BUi.Create("ModelImage", category.ListItem)
                model:Stick(LEFT, 10)
                model:SetWide(category.ListItem:GetTall() * .8)
                model:SetModel(v.model)
            end
        end
    end
    F4.EntitiesTab.Fill()
end

function F4:WepTab()
    F4.WepaonsTab = F4:CreatePage("Weapons", "EcaCkha")
    F4.WepaonsTab.scroll = BUi.Create("BUi.Scroll", F4.WepaonsTab)
    F4.WepaonsTab.scroll:Stick(FILL)
    F4.WepaonsTab.scroll:VBarSetWide(0)

    local categories = {}

    local function mergeCategories(target, source)
        local existingCategories = {}
        
        for _, category in ipairs(target) do
            existingCategories[category.name] = category
        end

        for _, category in ipairs(source) do
            if not existingCategories[category.name] then
                table.insert(target, category)
                existingCategories[category.name] = category
            end
        end
    end
    
    local shipments = DarkRP.getCategories().shipments
    mergeCategories(categories, shipments)
    
    local weps = DarkRP.getCategories().weapons
    mergeCategories(categories, weps)

    local ammo = DarkRP.getCategories().ammo
    mergeCategories(categories, ammo)


    function F4.WepaonsTab.Fill()
        local sorted = {}
        local seen = {}
        for k,cat in pairs(categories) do
            for k,v in pairs(cat.members) do 
                if v.noship and not F4:CheckWeapon(v) or not v.noship and not F4:CheckShipment(v) or not v.id and not F4:CheckAmmo(v) then continue end
                if F4.search:GetValue() ~= "" and not string.find(string.lower(v.name), string.lower(F4.search:GetValue())) then continue end
                if seen[cat] then continue end
                table.insert(sorted, cat)
                seen[cat] = true
            end
        end
        
        
        F4.WepaonsTab.scroll:Clear()
        for k, cat in pairs(sorted) do
            local category = BUi.Create("DCollapsibleCategory", F4.WepaonsTab.scroll)
            category:Stick(TOP, nil, 10, 10, 10, 0)
            category:SetHeaderHeight(50)
            category:ClearPaint()
            category:SetLabel("")
            category.Header:BUi():ClearPaint():Background(c.light, 8):On("Paint", function(s, w, h)
                BUi.masks.Start()
                surface.SetMaterial(BUi.Grad["Right"])
                surface.SetDrawColor(cat.color)
                surface.DrawTexturedRect(0, 0, w, h)
                surface.SetMaterial(BUi.Grad["Left"])
                surface.SetDrawColor(cat.color)
                surface.DrawTexturedRect(0, 0, w / 2, h)
                BUi.masks.Source()
                draw.RoundedBox(8, 0, 0, w, h, c.tert)
                BUi.masks.End()
                draw.RoundedBox(8, 1, 1, w - 2, h - 2, c.sec)
                draw.SimpleText(cat.name .. "-" .. cat.categorises, "F4s.28", 20, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                BUi.DrawImgur(w - 50, h/2 - h * .4, h * .8, h * .8, category:GetExpanded() and "biMVada" or "gmYCoos", color_white)
            end)

            category.Header:DockMargin(0, 0, 0, 10)
            local categorygrid = BUi.Create("DIconLayout", category)
            category:SetContents(categorygrid)
            categorygrid:Dock(FILL)
            local spacing = 10
            categorygrid:SetSpaceX(spacing)
            categorygrid:SetSpaceY(spacing)
            for k, v in pairs(cat.members) do
                if v.noship and not F4:CheckWeapon(v) or not v.noship and not F4:CheckShipment(v) or not v.id and not F4:CheckAmmo(v) then continue end
                if F4.search:GetValue() ~= "" and not string.find(string.lower(v.name), string.lower(F4.search:GetValue())) then continue end
                category.ListItem = BUi.Create("DButton", categorygrid)
                category.ListItem:DockMargin(0, 10, 0, 0)
                category.ListItem:SetSize((F4.frame:GetWide() - 320) / 2, 80)
                category.ListItem:Text("")
                category.ListItem:ClearPaint():Background(c.light, 8):On("Paint", function(s, w, h)
                    BUi.masks.Start()
                    surface.SetMaterial(BUi.Grad["Right"])
                    surface.SetDrawColor(cat.color)
                    surface.DrawTexturedRect(0, 0, w, h)
                    surface.SetMaterial(BUi.Grad["Left"])
                    surface.SetDrawColor(cat.color)
                    surface.DrawTexturedRect(0, 0, w / 2, h)
                    BUi.masks.Source()
                    draw.RoundedBox(8, 0, 0, w, h, c.tert)
                    BUi.masks.End()
                    draw.RoundedBox(8, 1, 1, w - 2, h - 2, c.sec)
                    draw.RoundedBox(8, h * .1, h * .1, h * .8, h * .8, cat.color)
                    draw.RoundedBox(8, h * .1 + 1, h * .1 + 1, h * .8 - 2, h * .8 - 2, c.sec)
                    BUi.masks.Start()
                    surface.SetMaterial(BUi.Grad["Down"])
                    surface.SetDrawColor(cat.color)
                    surface.DrawTexturedRect(0, 0, w, h)
                    BUi.masks.Source()
                    draw.RoundedBox(4, h * .1 + 1, h * .1 + 1, h * .8 - 2, h * .8 - 2, c.sec)
                    BUi.masks.End()
                    draw.SimpleText(v.name, "F4s.25", h * 1, h / 3, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    draw.SimpleText(DarkRP.formatMoney(v.noship and v.pricesep or v.price), "F4s.22", h * 1, h / 1.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end):CircleClick()

                category.ListItem:On("DoClick", function(s, w, h) 
                    if v.noship  then
                        LocalPlayer():ConCommand("say /buy " .. v.name)
                    else
                        LocalPlayer():ConCommand("say /buyshipment " .. v.name)
                    end
                end)
                local model = BUi.Create("ModelImage", category.ListItem)
                model:Stick(LEFT, 10)
                model:SetWide(category.ListItem:GetTall() * .8)
                if v.noship then
                    model:SetModel(v.model)
                else
                    model:SetModel(v.shipmodel)
                end

            end
        end
    end
    F4.WepaonsTab.Fill()
end


function F4:CheckWeapon(ship)
	local ply = LocalPlayer()
	if not (ship.separate or ship.noship) then return false end
	local cost = ship.pricesep
	if GAMEMODE.Config.restrictbuypistol and not table.HasValue(ship.allowed, ply:Team()) then return false end
	if ship.customCheck and not ship.customCheck(ply) then return false end
	if not ply:canAfford(cost) then return false end


	return true
end

function F4:CheckShipment(ship)
	local ply = LocalPlayer()
	if ship.noship then return false end
	if not table.HasValue(ship.allowed, ply:Team()) then return false end
	if ship.customCheck and not ship.customCheck(ply) then return false end

	local canbuy, suppress, message, price = hook.Call("canBuyShipment", nil, ply, ship)
	local cost = price or ship.getPrice and ship.getPrice(ply, ship.price) or ship.price
	if not ply:canAfford(cost) then return false end

	if canbuy == false then return false end

	return true
end

function F4:CheckEntity(item)
	local ply = LocalPlayer()
	
	if istable(item.allowed) and not table.HasValue(item.allowed, ply:Team()) then return false end
	if item.customCheck and not item.customCheck(ply) then return false end
	if not ply:canAfford(item.price) then return false end


	return true
end

function F4:CheckAmmo(item)
    local ply = LocalPlayer()

    if item.customCheck and not item.customCheck(ply) then return false end

    local canbuy, suppress, message, price = hook.Call("canBuyAmmo", nil, ply, item)
    local cost = price or item.getPrice and item.getPrice(ply, item.price) or item.price
	if not ply:canAfford(cost) then return false end


    if canbuy == false then return false end

    return true
end

hook.Add("OnPlayerChangedTeam", "beep_f4_update_tabs", function(ply)
    if ply != LocalPlayer() then return end
    if F4.frame:IsVisible() then
        F4.frame:AlphaTo(0, 0.2)
        timer.Simple(0.2,function()
            F4.frame:SetVisible(false)
        end)
    end

end)

hook.Add( "ShowSpare2", "aw", function( ply ) 
    F4:Open()
end )

if( not DarkRP ) then
    hook.Add( "DarkRPFinishedLoading", "BRS.DarkRPFinishedLoading_DisableDarkRPF4", function( ply ) 
        function DarkRP.openF4Menu() 

        end
    end )
else
    function DarkRP.openF4Menu()  

    end
end

concommand.Add("p", function()
    local weps = DarkRP.getCategories().weapons
    PrintTable(weps)
end)

