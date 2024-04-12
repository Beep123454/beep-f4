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
ListItem = ""
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
        if IsValid( ListItem.popout) then
            ListItem.popout:Remove()
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

    F4.page = BUi.Create("DPanel",  F4.sidebar)
    F4.page:Stick(TOP)
    F4.page:SetTall(F4.sidebar:GetTall() * .08)
    F4.page:ClearPaint():Background(c.light, 8,true,true,false,false):On("Paint",function(s,w,h)
        draw.RoundedBoxEx(8,1,1,w-2,h-2,c.accent,true,true,false,false)
        draw.SimpleText( "Meta Roleplay", "F4b.25",h,h/3, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText( "The best server", "F4.22",h,h/1.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        BUi.DrawProgressWheel(h * .1, h * .1,h * .8 ,h * .8,color_white)
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
            draw.SimpleText(v.rpname .. " | " .. BUi:FormatMoney(tonumber(v.wallet)), "F4s.25",h * 1.2,h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
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
                    draw.SimpleText(ply:Name(), "F4s.25",h * 1.2,h/3.4, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    draw.SimpleText(ply:GetUserGroup(), "F4.25",h * 1.2,h/1.5, v, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
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
        draw.SimpleText( "Laws Of The Land", "F4s.20",h * .03,20, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end)

    F4.dash.laws.scroll = BUi.Create("DScrollPanel",F4.dash.laws)
    F4.dash.laws.scroll:Stick(FILL,nil,nil,36)
    F4.dash.laws.scroll:HideVBar()

    for k,v in pairs(DarkRP.getLaws()) do
        F4.dash.laws.law = BUi.Create("DPanel",F4.dash.laws.scroll)
        F4.dash.laws.law:Stick(TOP,2)
        F4.dash.laws.law:SetTall(F4.dash.laws:GetTall() * .1)
        F4.dash.laws.law:ClearPaint():On("Paint", function(s, w, h)
            draw.SimpleText( "⋗ " .. v, "F4s.20",h * .03,20, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
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


    for k, cat in pairs( DarkRP.getCategories().jobs ) do
        if not cat.canSee( LocalPlayer() ) or #cat.members <= 0 then continue end
        local category = BUi.Create("DCollapsibleCategory",F4.jobtab.scroll)
        category:Stick(TOP,nil,10,10,10,0)
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
            draw.SimpleText(cat.name, "F4s.28",h * 1,h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            BUi.DrawImgur(h * .4, h* .26,h * .45, h * .45, "EcaCkha", color_white)
            BUi.DrawImgur(w - 50, h * .09, h * .9, h * .9, category:GetExpanded() and "biMVada" or "gmYCoos", color_white)
        end)
        category.Header:DockMargin(0,0,0,10)

        local categorygrid = BUi.Create("DIconLayout",category)
        category:SetContents(categorygrid)
        categorygrid:Dock(FILL)
        local spacing = 10
        categorygrid:SetSpaceX(spacing )
        categorygrid:SetSpaceY(spacing)

        for k,v in pairs(cat.members) do
            ListItem = BUi.Create("DButton",categorygrid)
            ListItem:DockMargin(0,10,0,0)
            ListItem:SetSize( (F4.frame:GetWide() - 320) / 2, 80 )
            ListItem:SetupTransition("jobclick", 0.6, function(s)
                if BUi.Doclick(s) then
                    return math.min(s.jobclick + 10, 255) 
                else
                    return math.max(s.jobclick - 10, 0)  
                end
            end)  
            ListItem:Text("")
            ListItem:ClearPaint():Background(c.light, 8):On("Paint", function(s, w, h)
                BUi.masks.Start()
                surface.SetMaterial(BUi.Grad["Right"])
                surface.SetDrawColor(v.color)
                surface.DrawTexturedRect(0, 0, w, h)
                surface.SetMaterial(BUi.Grad["Left"])
                surface.SetDrawColor( v.color)
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
                draw.RoundedBox(4,h*.9 + 11,h * .55 + 2,h * 5.7 - 2,h * .3 -2,c.sec)
                BUi.masks.End()

                draw.SimpleText(v.name, "F4s.25",h * 1,h/3, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                if v.max > 0 then
                    draw.SimpleText(team.NumPlayers( v.team  ) .. "/" .. v.max or 0, "F4.22",w/1.8,h * .7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                else
                    draw.SimpleText(team.NumPlayers( v.team  ) .. "/∞", "F4.22",w/1.8,h * .7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
            end)

            ListItem:On("DoClick", function(s, w, h)
                if IsValid(ListItem.popout) then
                    ListItem.popout:Remove()
                end
                ListItem.popout = BUi.Create("DPanel",F4.jobtab)
                ListItem.popout:SetSize(F4.jobtab:GetWide() * .4,F4.jobtab:GetTall())
                ListItem.popout:SetPos( F4.jobtab:GetWide() * .8, 0 )
                ListItem.popout:MoveTo(  F4.jobtab:GetWide() * .6, 0, 0.2 )
    
                ListItem.popout:ClearPaint():FadeIn(.5):Background(c.light, 14):On("Paint", function(s, w, h)


                end)


           

                local model = BUi.Create("DModelPanel", ListItem.popout)
                model:SetCamPos(Vector(25, 0, 67))
                model:SetLookAt(Vector(0, 0, 65))
                model:SetFOV(80)
                model:SetMouseInputEnabled(false)
                model.LayoutEntity = function() end
                local basePaint = baseclass.Get("DModelPanel").Paint
                model:SetPos(ListItem.popout:GetWide() - model:GetWide() - 10, 10)
                model:SetWide(ListItem.popout:GetTall() * .5)
                model.Paint = function(s, w, h)
                    pixel = pixel or 1

                    render.ClearStencil()
                    render.SetStencilEnable(true)
                
                    render.SetStencilWriteMask(1)
                    render.SetStencilTestMask(1)
                
                    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
                    render.SetStencilPassOperation(STENCILOPERATION_KEEP)
                    render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
                    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
                    render.SetStencilReferenceValue(pixel)
                
                    BUi.DrawCircle(w * .6, h * .6, 40, color_white)
                
                    render.SetStencilFailOperation(STENCILOPERATION_KEEP)
                    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
                    render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
                    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
                    render.SetStencilReferenceValue(pixel)
                
                    basePaint(s, w, h)
                
                    render.SetStencilEnable(false)
                    render.ClearStencil()
        
                end
                
                if istable(v.model) then
                    model:SetModel(v.model[1])
                else
                    model:SetModel(v.model)
                end
                
            end)

            local model = BUi.Create("ModelImage",ListItem) 
            model:Stick(LEFT, 10)
            model:SetWide(ListItem:GetTall() * .8)

            if istable( v.model )  then
                model:SetModel( v.model[1] )
            else
                model:SetModel( v.model )
            end
        end

    end

end
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