RECIPE.name = "Recipe Base"
RECIPE.description = "N/A"
RECIPE.model = "models/Items/BoxMRounds.mdl"
RECIPE.category = "Misc"
RECIPE.isBase = true

RECIPE.requirements = { }
RECIPE.results = { }

RECIPE.station = "ix_station_workbench"
RECIPE.craftStartSound = "physics/metal/weapon_impact_hard2.wav"
RECIPE.craftEndSound = "physics/metal/weapon_impact_hard3.wav"
RECIPE.craftTime = nil

RECIPE:PostHook( "OnCanCraft", function( self, ply )
	for _, v in pairs( ents.FindByClass( self.station ) ) do
		if ( ply:GetPos():DistToSqr(v:GetPos()) < 100 * 100 ) then
			if ( ply.isCrafting == true ) then
				return false, "You cannot craft multiple items while you are crafting something else!"
			end
			return true
		end
	end

	return false, "You need to be near a workbench."
end)

if ( SERVER ) then
	RECIPE:PostHook( "OnCraft", function( self, ply )
		ply.isCrafting = true
		ply:Freeze( true )
		ply:EmitSound( self.craftStartEnd or "" )
		ply:SetAction( "Crafting "..self.name.."...", self.craftTime or 5, function()
			ply.isCrafting = false
			ply:Notify( "You successfully crafted a "..self.name.."." or "You successfully crafted a item." )
			ply:Freeze( false )
			ply:EmitSound( self.craftEndSound or "" )
			return true
		end )
	end )
end
