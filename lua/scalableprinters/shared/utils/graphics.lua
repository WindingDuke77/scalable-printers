scprinters = scprinters or {}

function scprinters.DarkenColor(color, amount)
    local h, s, v = ColorToHSV(color)
    local DColor = {
        h, s, v
    }
    DColor[3] = DColor[3] - amount
    DColor = HSVToColor(unpack(DColor))
    return DColor
end

function scprinters.Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg + 2 do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

function scprinters.DegCircle( x, y, radius, seg, deg, rotation )
	local cir = {}
	
	table.insert( cir, { x = x , y = y } )

	for i = 0, seg - (seg - deg) do
		local a = math.rad( ( i / seg ) * - 360 + rotation )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end
	
	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	//table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	table.insert( cir, { x = x, y = y } )
	surface.DrawPoly( cir )
end

function scprinters.DrawIcon( mat, x, y, col, w, h )
	surface.SetDrawColor( col and col or Color( 255, 255, 255 ) )
	surface.SetMaterial( mat )
	surface.DrawTexturedRect( x, y, w and w or 32, h and h or 32 )
end
