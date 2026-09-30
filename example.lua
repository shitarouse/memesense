local lib = require("./memesense")

local rgb = Color3.fromRGB
local white = Color3.new(1, 1, 1)

local win = lib:window({ title = "Meme", title2 = "Sense", key = Enum.KeyCode.Insert })

local wpns = { "Desert Eagle", "Glock-18", "USP-S", "AK-47", "M4A4", "M4A1-S", "AWP", "SSG 08" }
local scoped = { ["AWP"] = true, ["SSG 08"] = true }
local groups = { "Head", "Neck", "Chest", "Stomach", "Arms", "Legs" }

local function hasscope(v)
	return scoped[v] == true
end

local lb = win:tab({ name = "Legitbot", icon = "legitbot" })
lb:master({ flag = "lb_master", default = true })
local lbg = lb:gear()
lbg:toggle({ name = "Friendly fire", flag = "lb_ff" })
lbg:toggle({ name = "Visible only", flag = "lb_visonly", default = true })
local lbp = lb:profile({ id = "lb", items = wpns, default = "Glock-18" })

local lgen = lb:section({ name = "General" })
lgen:toggle({ name = "Enable", flag = "lb_enable", default = true })
lgen:toggle({ name = "Aim key", flag = "lb_aimkey", kb = true, bind = "MouseButton2", mode = "hold" })
lgen:toggle({ name = "Draw FOV", flag = "lb_drawfov", default = true })
lgen:slider({ name = "Aim time", flag = "lb_aimtime", min = 0, max = 1000, suffix = "ms", zero = "disabled" })
local lsub = lgen:subtabs({ "Aim", "Accuracy", "RCS", "Misc" })
local laim = lsub[1]
local rtype = laim:dropdown({ name = "Radius type", flag = "lb_rtype", values = { "Static", "Dynamic" }, default = "Dynamic" })
laim:slider({ name = "Radius", flag = "lb_radius", min = 0, max = 30, dec = 3, suffix = "°", ind = { name = "FOV:" } })
laim:slider({ name = "Multiplier", flag = "lb_mult", min = 0, max = 8, dec = 2, default = 4 }):dep(rtype, "Dynamic")
laim:dropdown({ name = "Smooth type", flag = "lb_stype", values = { "Static", "Dynamic" }, default = "Static" })
laim:slider({ name = "Smooth pitch", flag = "lb_spitch", min = 0, max = 20, dec = 3, zero = "disabled" })
laim:slider({ name = "Smooth yaw", flag = "lb_syaw", min = 0, max = 20, dec = 3, zero = "disabled" })
local lacc = lsub[2]
lacc:slider({ name = "Hit chance", flag = "lb_hc", min = 0, max = 100, suffix = "%" })
lacc:toggle({ name = "Wait for stability", flag = "lb_stable" })
lacc:toggle({ name = "Scope only", flag = "lb_scopeonly" }):dep(lbp.idd, hasscope)
local lrcs = lsub[3]
local lrcse = lrcs:toggle({ name = "Standalone RCS", flag = "lb_rcs" })
lrcs:slider({ name = "Pitch", flag = "lb_rcs_p", min = 0, max = 100, suffix = "%", default = 100 }):dep(lrcse)
lrcs:slider({ name = "Yaw", flag = "lb_rcs_y", min = 0, max = 100, suffix = "%", default = 100 }):dep(lrcse)
local lmisc = lsub[4]
lmisc:toggle({ name = "Smoke check", flag = "lb_smoke", default = true })
lmisc:toggle({ name = "Flash check", flag = "lb_flash", default = true })
lmisc:toggle({ name = "Jump check", flag = "lb_jump" })

local lhg = lb:section({ name = "Hit groups", side = 2 })
lhg:dropdown({ name = "Selection", flag = "lb_hitgroups", multi = true, values = groups, default = { "Head", "Neck", "Chest" } })
lhg:toggle({ name = "Only body aim", flag = "lb_baim", kb = true })
lhg:toggle({ name = "Prefer head aim", flag = "lb_phead" })
lhg:toggle({ name = "Prefer body aim", flag = "lb_pbody" })
lhg:toggle({ name = "Body aim if lethal", flag = "lb_blethal" })
lhg:dropdown({ name = "Targets", flag = "lb_targets", values = { "Players", "Bots", "Everyone" }, default = "Players" })
local laf = lhg:subtabs({ "Auto fire", "Auto wall" })
local af = laf[1]
local afe = af:toggle({ name = "Enable", flag = "lb_af", kb = true })
af:toggle({ name = "Auto stop", flag = "lb_af_stop" }):dep(afe)
af:toggle({ name = "Auto scope", flag = "lb_af_scope" }):dep(afe):dep(lbp.idd, hasscope)
af:dropdown({ name = "Hit chance type", flag = "lb_af_hct", values = { "Strict", "Loose" }, default = "Strict" }):dep(afe)
af:slider({ name = "Reaction time", flag = "lb_af_react", min = 0, max = 500, suffix = "ms", zero = "disabled" }):dep(afe)
af:slider({ name = "Delay between shots", flag = "lb_af_delay", min = 0, max = 500, suffix = "ms", zero = "disabled" }):dep(afe)
af:slider({ name = "Minimum hit chance", flag = "lb_af_minhc", min = 0, max = 100, suffix = "%" }):dep(afe)
af:slider({ name = "Ghost time", flag = "lb_af_ghost", min = 0, max = 500, suffix = "ms", zero = "disabled" }):dep(afe)
local aw = laf[2]
local awe = aw:toggle({ name = "Enable", flag = "lb_aw", kb = true, ind = { name = "AWALL", color = rgb(59, 152, 230) } })
aw:slider({ name = "Minimum damage", flag = "lb_aw_dmg", min = 0, max = 100, suffix = " HP", ind = { name = "DMG" } }):dep(awe)
aw:toggle({ name = "Only visible hitbox", flag = "lb_aw_vis" }):dep(awe)

local aa = win:tab({ name = "Aim Assist", icon = "aimassist" })
aa:master({ flag = "aa_master" })
local aag = aa:gear()
aag:toggle({ name = "Humanize", flag = "aa_human", default = true })
local aap = aa:profile({ id = "aa", items = wpns, default = "Desert Eagle" })

local trg = aa:section({ name = "Trigger" })
trg:toggle({ name = "Enable", flag = "aa_trig", kb = true })
trg:toggle({ name = "Through wall", flag = "aa_trig_wall", kb = true })
trg:toggle({ name = "Ignore breakables", flag = "aa_trig_break" })
trg:toggle({ name = "Air check", flag = "aa_trig_air", default = true })
local tr1 = trg:split()
tr1:toggle({ name = "Flash check", flag = "aa_trig_flash" })
tr1:toggle({ name = "Auto scope", flag = "aa_trig_ascope" }):dep(aap.idd, hasscope)
local tr2 = trg:split()
tr2:toggle({ name = "Smoke check", flag = "aa_trig_smoke" })
tr2:toggle({ name = "Scope check", flag = "aa_trig_scope" }):dep(aap.idd, hasscope)
trg:slider({ name = "Delay between shots", flag = "aa_trig_delay", min = 0, max = 500, suffix = "ms", zero = "disabled" })
trg:slider({ name = "Ghost time", flag = "aa_trig_ghost", min = 0, max = 500, suffix = "ms", zero = "disabled" })
trg:slider({ name = "Shot delay", flag = "aa_trig_shot", min = 0, max = 500, suffix = "ms", zero = "disabled" })
trg:slider({ name = "Force mouse speed", flag = "aa_trig_mouse", min = 0, max = 100, suffix = "%", zero = "disabled" })
local tvis = trg:subtabs({ "Visible", "Auto wall" })
tvis[1]:dropdown({ name = "Hit groups", flag = "aa_vis_hg", multi = true, values = groups, default = { "Head" } })
tvis[1]:slider({ name = "Minimum damage", flag = "aa_vis_dmg", min = 0, max = 100, suffix = " HP" })
tvis[1]:slider({ name = "Reaction time", flag = "aa_vis_react", min = 0, max = 500, suffix = "ms", zero = "disabled" })
tvis[2]:dropdown({ name = "Hit groups", flag = "aa_aw_hg", multi = true, values = groups, default = { "Head", "Chest" } })
tvis[2]:slider({ name = "Minimum damage", flag = "aa_aw_dmg", min = 0, max = 100, suffix = " HP", default = 20 })
tvis[2]:slider({ name = "Reaction time", flag = "aa_aw_react", min = 0, max = 500, suffix = "ms", zero = "disabled" })

local arcs = aa:section({ name = "RCS", side = 2 })
local arcse = arcs:toggle({ name = "Enable", flag = "aa_rcs" })
arcs:slider({ name = "Bullet start", flag = "aa_rcs_start", min = 0, max = 50, default = 2 }):dep(arcse)
arcs:slider({ name = "Bullet end", flag = "aa_rcs_end", min = 0, max = 50, default = 30 }):dep(arcse)
arcs:slider({ name = "X", flag = "aa_rcs_x", min = 0, max = 2, dec = 3, default = 1 }):dep(arcse)
arcs:slider({ name = "Y", flag = "aa_rcs_y", min = 0, max = 2, dec = 3, default = 1 }):dep(arcse)
local apst = aa:section({ name = "Auto Pistol", side = 2 })
local apse = apst:toggle({ name = "Enable", flag = "aa_pistol" })
apst:slider({ name = "Delay between shots", flag = "aa_pistol_delay", min = 0, max = 500, suffix = "ms", zero = "disabled" }):dep(apse)

win:gap()

local pl = win:tab({ name = "Players", icon = "players" })
local pesp = pl:section({ name = "ESP" })
pesp:toggle({ name = "Enable", flag = "p_esp", kb = true })
pesp:toggle({ name = "Bounding box", flag = "p_box", default = true }):color({ flag = "p_box_c", default = white })
pesp:toggle({ name = "Name", flag = "p_name", default = true }):color({ flag = "p_name_c", default = white })
local phb = pesp:toggle({ name = "Health bar", flag = "p_hp", default = true })
phb:color({ flag = "p_hp_c1", default = rgb(80, 220, 90) })
phb:color({ flag = "p_hp_c2", default = rgb(230, 60, 60) })
pesp:toggle({ name = "Weapon", flag = "p_weapon" }):dropdown({ flag = "p_weapon_mode", values = { "Text", "Icon", "Both" }, default = "Text" })
pesp:toggle({ name = "Distance", flag = "p_dist" })
pesp:toggle({ name = "Skeleton", flag = "p_skel" }):color({ flag = "p_skel_c", default = white })
pesp:slider({ name = "Max distance", flag = "p_maxdist", min = 0, max = 2000, suffix = " studs", default = 1000 })
local pflt = pl:section({ name = "Filter", side = 2 })
pflt:toggle({ name = "Teammates", flag = "p_team" })
pflt:toggle({ name = "Enemies", flag = "p_enemy", default = true })
pflt:toggle({ name = "Visible only", flag = "p_visonly" })
pflt:dropdown({ name = "Flags", flag = "p_flags", multi = true, values = { "Armor", "Scoped", "Reloading", "Flashed", "Defusing" }, default = { "Armor", "Scoped" } })
local pglow = pl:section({ name = "Glow", side = 2 })
pglow:toggle({ name = "Enable", flag = "p_glow" }):color({ flag = "p_glow_c", default = rgb(238, 8, 8) })
pglow:slider({ name = "Thickness", flag = "p_glow_th", min = 0, max = 10, dec = 1, default = 2 })

local ch = win:tab({ name = "Chams", icon = "chams" })
local chv = ch:section({ name = "Visible" })
chv:toggle({ name = "Enable", flag = "c_vis" }):color({ flag = "c_vis_c", default = rgb(238, 8, 8) })
chv:dropdown({ name = "Material", flag = "c_vis_mat", values = { "Flat", "Glow", "Metallic", "Wireframe" }, default = "Flat" })
chv:slider({ name = "Opacity", flag = "c_vis_op", min = 0, max = 100, suffix = "%", default = 100 })
local chi = ch:section({ name = "Invisible", side = 2 })
chi:toggle({ name = "Enable", flag = "c_inv" }):color({ flag = "c_inv_c", default = rgb(59, 152, 230), alpha = 0.6 })
chi:dropdown({ name = "Material", flag = "c_inv_mat", values = { "Flat", "Glow", "Metallic", "Wireframe" }, default = "Glow" })
chi:slider({ name = "Opacity", flag = "c_inv_op", min = 0, max = 100, suffix = "%", default = 60 })
local chl = ch:section({ name = "Local" })
chl:toggle({ name = "Weapon", flag = "c_weapon" }):color({ flag = "c_weapon_c", default = white })
chl:toggle({ name = "Arms", flag = "c_arms" }):color({ flag = "c_arms_c", default = white })

local it = win:tab({ name = "Items", icon = "items" })
local itw = it:section({ name = "World items" })
itw:toggle({ name = "Dropped weapons", flag = "i_weapons" }):color({ flag = "i_weapons_c", default = white })
itw:toggle({ name = "Grenades", flag = "i_nades" }):color({ flag = "i_nades_c", default = rgb(255, 200, 60) })
itw:toggle({ name = "Bomb", flag = "i_bomb", default = true }):color({ flag = "i_bomb_c", default = rgb(238, 8, 8) })
itw:slider({ name = "Max distance", flag = "i_maxdist", min = 0, max = 2000, suffix = " studs", default = 500 })
local its = it:section({ name = "Style", side = 2 })
its:dropdown({ name = "Display", flag = "i_display", values = { "Text", "Icon" }, default = "Text" })
its:slider({ name = "Text size", flag = "i_size", min = 8, max = 24, default = 13 })

local vis = win:tab({ name = "Visuals", icon = "visuals" })
local vgr = vis:section({ name = "Grenades" })
local vgp = vgr:toggle({ name = "Grenade prediction", flag = "v_gp" })
vgp:color({ flag = "v_gp_c1", default = white })
vgp:color({ flag = "v_gp_c2", default = white })
vgr:toggle({ name = "Smoke grenade timer", flag = "v_smoke" }):color({ flag = "v_smoke_c", default = white })
vgr:toggle({ name = "Incendiary grenade timer", flag = "v_inc" }):color({ flag = "v_inc_c", default = white })
local vgts = vgr:toggle({ name = "Grenade tracers", flag = "v_tracers" }):settings()
vgts:slider({ name = "Duration", flag = "v_tracers_dur", min = 1, max = 10, dec = 1, suffix = "s", default = 3 })
vgts:colorpicker({ name = "Color", flag = "v_tracers_c", default = white })
local vms = vis:section({ name = "Miscellaneous", side = 2 })
vms:toggle({ name = "Bomb timer", flag = "v_bomb" })
vms:toggle({ name = "Spectator list", flag = "v_spec" })
vms:toggle({ name = "Hit marker", flag = "v_hitmarker" }):color({ flag = "v_hitmarker_c", default = white })
local vrad = vms:toggle({ name = "Textured radar", flag = "v_radar" }):settings()
vrad:slider({ name = "Zoom", flag = "v_radar_zoom", min = 0.5, max = 3, dec = 2, default = 1 })
vrad:slider({ name = "Opacity", flag = "v_radar_op", min = 0, max = 100, suffix = "%", default = 100 })

local wd = win:tab({ name = "World", icon = "world" })
local wtx = wd:section({ name = "Textures" })
local wsky = wtx:toggle({ name = "Skybox", flag = "w_sky", default = true })
wsky:color({ flag = "w_sky_c", default = white })
wsky:dropdown({ flag = "w_sky_name", values = { "cs_italy_s2_skybox_2", "sky_dust", "vertigo_hdr", "nukeblank", "jungle", "embassy" }, default = "cs_italy_s2_skybox_2" })
local wpp = wtx:toggle({ name = "Override post-processing", flag = "w_pp", default = true }):settings()
wpp:slider({ name = "Bloom", flag = "w_pp_bloom", min = 0, max = 5, dec = 2, default = 1 })
wpp:slider({ name = "Saturation", flag = "w_pp_sat", min = 0, max = 2, dec = 2, default = 1 })
local wdof = wtx:toggle({ name = "Override DoF", flag = "w_dof", default = true }):settings()
wdof:slider({ name = "Near blur", flag = "w_dof_near", min = 0, max = 100, suffix = "%" })
wdof:slider({ name = "Far blur", flag = "w_dof_far", min = 0, max = 100, suffix = "%", default = 20 })
wtx:toggle({ name = "Custom ambient color", flag = "w_ambient", default = true }):color({ flag = "w_ambient_c", default = rgb(36, 44, 110) })
local wlt = wtx:toggle({ name = "Custom lightning", flag = "w_light", default = true }):settings()
wlt:slider({ name = "Brightness", flag = "w_light_b", min = 0, max = 5, dec = 2, default = 1 })
wlt:colorpicker({ name = "Color", flag = "w_light_c", default = white })
wtx:toggle({ name = "Modulate textures", flag = "w_mod_tex", default = true }):color({ flag = "w_mod_tex_c", default = rgb(194, 151, 151) })
wtx:toggle({ name = "Modulate static props", flag = "w_mod_props", default = true }):color({ flag = "w_mod_props_c", default = white })
wtx:toggle({ name = "Modulate clouds", flag = "w_mod_clouds", default = true }):color({ flag = "w_mod_clouds_c", default = white })
wtx:toggle({ name = "World textures overlay", flag = "w_overlay", default = true })
wtx:slider({ name = "Exposure", flag = "w_exposure", min = 0, max = 1, dec = 2, default = 0.57 })
local wex = wd:section({ name = "Extra" })
wex:toggle({ name = "Force sniper crosshair", flag = "w_sniper" })
wex:toggle({ name = "Penetration crosshair", flag = "w_pen" }):settings():colorpicker({ name = "Color", flag = "w_pen_c", default = rgb(59, 152, 230) })
wex:slider({ name = "Flash scale", flag = "w_flash", min = 0, max = 1, dec = 1, default = 1 })
local wrm = wd:section({ name = "Removals", side = 2 })
for _, n in ipairs({ "Blood", "Shadows", "Zoom hud", "Zoom spread", "Visual recoil", "Smoke", "Flash", "Scope overlay", "Fog" }) do
	wrm:toggle({ name = n, flag = "w_rm_" .. string.lower(string.gsub(n, "%s", "_")) })
end

local vw = win:tab({ name = "View", icon = "view" })
local vwc = vw:section({ name = "Camera" })
vwc:slider({ name = "Field of view", flag = "vw_fov", min = 60, max = 120, default = 90, ind = { on = false, name = "FOV" } })
vwc:toggle({ name = "Override zoom", flag = "vw_zoom" })
vwc:toggle({ name = "Third person", flag = "vw_tp", kb = true })
vwc:slider({ name = "Distance", flag = "vw_tp_dist", min = 5, max = 30, default = 12 })
local vwm = vw:section({ name = "Viewmodel", side = 2 })
vwm:slider({ name = "Viewmodel FOV", flag = "vw_vm_fov", min = 40, max = 110, default = 68 })
vwm:slider({ name = "Offset X", flag = "vw_vm_x", min = -10, max = 10, dec = 1 })
vwm:slider({ name = "Offset Y", flag = "vw_vm_y", min = -10, max = 10, dec = 1 })
vwm:slider({ name = "Offset Z", flag = "vw_vm_z", min = -10, max = 10, dec = 1 })

win:tab({ name = "Indicators", icon = "indicators" }):hud()

win:gap()

local ms = win:tab({ name = "Miscellaneous", icon = "misc" })
local mif = ms:section({ name = "Interface" })
mif:toggle({ name = "Event logs", flag = "m_logs", default = true }):dropdown({
	flag = "m_logs_what",
	multi = true,
	icon = false,
	values = { "View votes", "Bomb", "Hits", "Purchases", "Damage" },
	default = { "View votes", "Bomb" },
})
mif:toggle({ name = "In-game radar", flag = "m_radar", default = true })
mif:toggle({ name = "Preserve kill-feed", flag = "m_killfeed", default = true })
mif:toggle({ name = "Scoreboard reveal", flag = "m_scoreboard", default = true })
local mmv = ms:section({ name = "Movement" })
mmv:toggle({ name = "Bhop", flag = "m_bhop", default = true })
local mgi = ms:section({ name = "Game interactive", side = 2 })
mgi:toggle({ name = "Auto-accept match", flag = "m_accept" })
local mmix = mgi:toggle({ name = "Custom sound mixer", flag = "m_mixer", default = true }):settings()
mmix:slider({ name = "Master", flag = "m_mix_master", min = 0, max = 5, dec = 3, default = 5 })
mmix:slider({ name = "Footsteps", flag = "m_mix_steps", min = 0, max = 5, dec = 3, default = 5 })
mmix:slider({ name = "Weapons", flag = "m_mix_weapons", min = 0, max = 5, dec = 3, default = 5 })
mgi:toggle({ name = "Clan-tag spammer", flag = "m_clantag", risky = true, default = true })
mgi:input({ flag = "m_clantag_text", placeholder = "Enter custom player name...", default = "SHINE" })
local mex = ms:section({ name = "Extra", side = 2 })
local sounds = { "Default", "Bell", "Bubble", "Cod", "Skeet", "Neverlose" }
local mhs = mex:toggle({ name = "Hit sound", flag = "m_hitsound", default = true })
mhs:settings():slider({ name = "Volume", flag = "m_hitsound_vol", min = 0, max = 5, dec = 3, default = 5 })
mhs:dropdown({ flag = "m_hitsound_snd", values = sounds, default = "Default" })
local mks = mex:toggle({ name = "Kill sound", flag = "m_killsound", default = true })
mks:settings():slider({ name = "Volume", flag = "m_killsound_vol", min = 0, max = 5, dec = 3, default = 5 })
mks:dropdown({ flag = "m_killsound_snd", values = sounds, default = "Default" })
mex:toggle({ name = "Region picker", flag = "m_region" }):dropdown({
	flag = "m_region_v",
	values = { "All", "EU West", "EU East", "US East", "US West", "Asia" },
	default = "All",
})
mex:button({
	name = "Unload cheat",
	cb = function()
		lib:unload()
	end,
})

local inv = win:tab({ name = "Inventory", icon = "inventory" })
inv:master({ flag = "inv_master", default = true })
local invs = inv:tbbtn({ name = "Settings", icon = "sliders", pop = true })
invs:toggle({ name = "Show StatTrak", flag = "inv_stattrak", default = true })
invs:toggle({ name = "Apply on spawn", flag = "inv_spawn", default = true })
inv:tbbtn({
	name = "Create from link",
	icon = "load",
	cb = function()
		lib:notify("Copy an inspect link and press again")
	end,
})
local ivt = inv:tabbar({ "Profile", "Equipment", "Containers", "Tools", "Graphic Art" }, { default = 2 })
local ivp = ivt[1]:section({ name = "Profile" })
ivp:dropdown({ name = "Rank", flag = "inv_rank", values = { "Silver I", "Gold Nova", "Master Guardian", "Legendary Eagle", "Global Elite" }, default = "Global Elite" })
ivp:slider({ name = "Level", flag = "inv_level", min = 1, max = 40, default = 40 })
ivp:slider({ name = "Wins", flag = "inv_wins", min = 0, max = 5000, default = 1337 })
local eq = ivt[2]:tabbar({ "Knives", "Pistols", "Mid-Tier", "Rifles", "Misc", "Agents", "Gloves" })
local red = rgb(235, 75, 75)
local knives = eq[1]:grid({ cols = 4 })
local skins = { "Fade", "Fade", "Fade", "Fade", "Slaughter", "Autotronic", "Fade", "Slaughter", "Fade", "Tiger Tooth", "Fade", "Autotronic", "Doppler", "Marble Fade", "Tiger Tooth" }
knives:add({
	cb = function()
		knives:card({ name = "New skin", image = "items", color = rgb(136, 71, 255) })
	end,
})
for _, n in ipairs(skins) do
	knives:card({
		name = n,
		image = "items",
		color = red,
		rcb = function(cd)
			cd:destroy()
		end,
	})
end
for i = 2, #eq do
	eq[i]:grid({}):add({})
end

local gh = win:tab({ name = "Grenade Helper", icon = "grenade", save = false })
gh:master({ flag = "gh_master", default = true })
local ghc = gh:tbbtn({ name = "Create", icon = "create", pop = true, w = 290 })
local ghn = ghc:input({ placeholder = "Name" })
ghc:button({
	name = "Create",
	w = 136,
	cb = function()
		lib:notify("Lineup " .. (ghn.val ~= "" and ghn.val or "unnamed") .. " created")
	end,
})
local ghs = gh:tbbtn({ name = "Settings", icon = "sliders", pop = true })
ghs:toggle({ name = "Show lineups", flag = "gh_show", default = true })
ghs:slider({ name = "Render distance", flag = "gh_dist", min = 50, max = 1000, default = 300, suffix = " studs" })
local ght = gh:tabbar({ "My", "Subscriptions", "Public", "Draft", "Trash" }, { default = 4 })
local ghm = ght[4]:section({})
ghm:image({ image = 131325044235094, h = 345 })
local ghcu = ght[4]:section({ name = "Customizations", side = 2 })
local ghname = ghcu:input({ flag = "gh_draft_name", default = "TRamp - BombsiteB", placeholder = "Lineup name..." })
ghcu:button({
	name = "Create",
	cb = function()
		lib:notify("Lineup " .. ghname.val .. " published")
	end,
})
ghcu:button({
	name = "Discard",
	cb = function()
		ghname:set("")
	end,
})

local cf = win:tab({ name = "Configs", icon = "configs", save = false })
cf:configs()

win:select(lb)
