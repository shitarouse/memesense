[[
	MEMESENSE GUI BY SHITARO
	ФУЛЛ 1 В 1 ГУИ ИЗ МЕМИКА НА КС2, ЛУЧШЕ ТУПОЙ ХУЙНИ ЮГЕЙМА!
	Я - shitaro.lol
	тгк - t.me/shitaromake
	просьба указывать в кредитах
]]


local function svc(n)
	return cloneref(game:GetService(n))
end

local plrs = svc("Players")
local rs = svc("RunService")
local uis = svc("UserInputService")
local ts = svc("TweenService")
local hs = svc("HttpService")
local gsv = svc("GuiService")
local rst = svc("ReplicatedStorage")
local lp = plrs.LocalPlayer

local rgb, hsv, c3 = Color3.fromRGB, Color3.fromHSV, Color3.new
local ud2, ofs, scl, ud, v2 = UDim2.new, UDim2.fromOffset, UDim2.fromScale, UDim.new, Vector2.new
local cseq, ckp, nseq = ColorSequence.new, ColorSequenceKeypoint.new, NumberSequence.new
local clamp, floor, max, min = math.clamp, math.floor, math.max, math.min
local sfmt, ssub, supper, sgsub, smatch = string.format, string.sub, string.upper, string.gsub, string.match
local tfind, tremove, tclear, tconcat, tsort, tclone = table.find, table.remove, table.clear, table.concat, table.sort, table.clone
local spawn, delay = task.spawn, task.delay

local xal = Enum.TextXAlignment
local aix, aiy, aixy = Enum.AutomaticSize.X, Enum.AutomaticSize.Y, Enum.AutomaticSize.XY
local ha, va = Enum.HorizontalAlignment, Enum.VerticalAlignment
local mb1, mb2, mb3 = Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2, Enum.UserInputType.MouseButton3
local mmove, tch = Enum.UserInputType.MouseMovement, Enum.UserInputType.Touch
local iend = Enum.UserInputState.End
local kunk = Enum.KeyCode.Unknown
local white, black = c3(1, 1, 1), c3(0, 0, 0)

local genv = getgenv()
local b64e, b64d = base64encode, base64decode

local maid = {}
maid.__index = maid

function maid.new()
	return setmetatable({}, maid)
end

function maid:add(x)
	self[#self + 1] = x
	return x
end

function maid:clean()
	for i = #self, 1, -1 do
		local x = self[i]
		self[i] = nil
		local t = typeof(x)
		if t == "RBXScriptConnection" then
			x:Disconnect()
		elseif t == "Instance" then
			x:Destroy()
		elseif t == "function" then
			pcall(x)
		elseif t == "thread" then
			pcall(task.cancel, x)
		elseif t == "table" then
			if type(x.destroy) == "function" then
				x:destroy()
			elseif type(x.clean) == "function" then
				x:clean()
			end
		end
	end
end

local function con(s, f, md)
	local c = s:Connect(f)
	if md then
		md[#md + 1] = c
	end
	return c
end

local function jenc(t)
	local ok, r = pcall(hs.JSONEncode, hs, t)
	return ok and r or nil
end

local function jdec(s)
	if type(s) ~= "string" or s == "" then
		return nil
	end
	local ok, r = pcall(hs.JSONDecode, hs, s)
	if ok and type(r) == "table" then
		return r
	end
	return nil
end

local fs = {}

function fs.dir(p)
	local ok, r = pcall(isfolder, p)
	if ok and not r then
		pcall(makefolder, p)
	end
end

function fs.has(p)
	local ok, r = pcall(isfile, p)
	return ok and r == true
end

function fs.read(p)
	if fs.has(p) then
		local ok, r = pcall(readfile, p)
		if ok then
			return r
		end
	end
	return nil
end

function fs.write(p, s)
	return (pcall(writefile, p, s))
end

function fs.del(p)
	if fs.has(p) then
		pcall(delfile, p)
	end
end

function fs.list(p)
	local ok, r = pcall(isfolder, p)
	if ok and r then
		local ok2, l = pcall(listfiles, p)
		if ok2 and type(l) == "table" then
			return l
		end
	end
	return {}
end

local function fetch(u)
	local ok, r = pcall(request, { Url = u, Method = "GET" })
	if ok and type(r) == "table" and r.StatusCode == 200 and type(r.Body) == "string" then
		return r.Body
	end
	return nil
end

local function asset(p, u, minl)
	if not fs.has(p) then
		local b = fetch(u)
		if not b or #b < (minl or 1) then
			return nil
		end
		if not fs.write(p, b) then
			return nil
		end
	end
	local ok, id = pcall(getcustomasset, p)
	if ok and type(id) == "string" then
		return id
	end
	return nil
end

local function hex(c, a)
	local s = sfmt("#%02X%02X%02X", floor(c.R * 255 + 0.5), floor(c.G * 255 + 0.5), floor(c.B * 255 + 0.5))
	if a then
		s ..= sfmt("%02X", floor(a * 255 + 0.5))
	end
	return s
end

local function unhex(s)
	if type(s) ~= "string" then
		return nil
	end
	s = sgsub(s, "[^%x]", "")
	local n = #s
	if n ~= 6 and n ~= 8 then
		return nil
	end
	local r, g, b = tonumber(ssub(s, 1, 2), 16), tonumber(ssub(s, 3, 4), 16), tonumber(ssub(s, 5, 6), 16)
	return rgb(r, g, b), n == 8 and tonumber(ssub(s, 7, 8), 16) / 255 or 1
end

local function esc(s)
	return (sgsub(sgsub(sgsub(tostring(s), "&", "&amp;"), "<", "&lt;"), ">", "&gt;"))
end

local kshort = {
	Insert = "INS", Delete = "DEL", Home = "HOME", End = "END", PageUp = "PGUP", PageDown = "PGDN",
	LeftShift = "LSHIFT", RightShift = "RSHIFT", LeftControl = "LCTRL", RightControl = "RCTRL",
	LeftAlt = "LALT", RightAlt = "RALT", LeftSuper = "LWIN", RightSuper = "RWIN", CapsLock = "CAPS",
	Backspace = "BKSP", Return = "ENTER", Space = "SPACE", Tab = "TAB", Escape = "ESC",
	MouseButton1 = "M1", MouseButton2 = "M2", MouseButton3 = "M3",
	Zero = "0", One = "1", Two = "2", Three = "3", Four = "4", Five = "5", Six = "6", Seven = "7", Eight = "8", Nine = "9",
	Backquote = "`", Minus = "-", Equals = "=", LeftBracket = "[", RightBracket = "]", BackSlash = "\\",
	Semicolon = ";", Quote = "'", Comma = ",", Period = ".", Slash = "/",
	Up = "UP", Down = "DOWN", Left = "LEFT", Right = "RIGHT",
} --кейбинды, по моему я все перенес не ебу сами проверьте

local function kname(k)
	if not k then
		return nil
	end
	local s = kshort[k]
	if s then
		return s
	end
	local np = smatch(k, "^Keypad(.+)$")
	if np then
		return "NUM" .. (kshort[np] or supper(np))
	end
	return supper(k)
end

local function inkey(i)
	if i.KeyCode ~= kunk then
		return i.KeyCode.Name
	end
	local t = i.UserInputType
	if t == mb1 or t == mb2 or t == mb3 then
		return t.Name
	end
	return nil
end

local thm = {
	bg = rgb(17, 18, 20),
	side = rgb(19, 20, 22),
	nav = rgb(24, 25, 29),
	navp = rgb(30, 30, 38),
	sep = rgb(31, 32, 34),
	edge = rgb(5, 5, 8),
	pop = rgb(19, 20, 25),
	ctl = rgb(27, 30, 37),
	ctlh = rgb(34, 37, 46),
	drop = rgb(38, 38, 46),
	droph = rgb(48, 48, 58),
	dsel = rgb(57, 57, 69),
	dselh = rgb(64, 64, 77),
	row = rgb(21, 22, 24),
	rowb = rgb(57, 58, 60),
	card = rgb(27, 28, 33),
	cardh = rgb(34, 35, 41),
	panel = rgb(29, 30, 34),
	trk = rgb(30, 31, 35),
	fill = rgb(114, 118, 127),
	filld = rgb(81, 84, 91),
	acc = rgb(238, 8, 8),
	txt = rgb(240, 240, 242),
	dim = rgb(122, 123, 125),
	dis = rgb(68, 69, 72),
	kb = rgb(71, 72, 75),
	info = rgb(59, 152, 230),
	plus = rgb(69, 69, 77),
}

local bsans = "rbxasset://fonts/families/BuilderSans.json"
local fnt = {
	b = Font.new(bsans, Enum.FontWeight.Bold),
	s = Font.new(bsans, Enum.FontWeight.SemiBold),
	r = Font.new(bsans, Enum.FontWeight.Medium),
}

local fontsrc = {
	reg = "https://raw.githubusercontent.com/fontfen/selawik/master/Selawik-Regular.ttf",
	bold = "https://raw.githubusercontent.com/fontfen/selawik/master/Selawik-Bold.ttf",
}

local ico = {
	legitbot = 80648116191645,
	aimassist = 122014945028597,
	players = 119713822992150,
	chams = 132705178126217,
	items = 121406454377051,
	visuals = 125012650497883,
	world = 120156057895579,
	view = 127234874352422,
	indicators = 136554315335959,
	misc = 133109875194066,
	inventory = 113475652218451,
	grenade = 85112456002145,
	configs = 97828544806816,
	save = 86452290950086,
	load = 109698732019071,
	gear = 106205298246017,
	sliders = 75780544616650,
	create = 74194167957081,
	refresh = 83145058297547,
	pencil = 113132794872298,
	trash = 94712995845562,
	keyboard = 121978468376124,
	list = 133109875194066,
	chevron = 71457658246709,
	check = 86817768619372,
	plus = 101123124881873,
	copy = 116378866141355,
	x = 116396312853810,
	link = 86131768436965,
	image = 114022611279795,
}

local function icon(n)
	if n == nil then
		return ""
	end
	local v = ico[n]
	if v then
		return "rbxassetid://" .. v
	end
	if type(n) == "number" then
		return "rbxassetid://" .. n
	end
	return tostring(n)
end

local defs = {
	Frame = { BorderSizePixel = 0 },
	ScrollingFrame = {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		CanvasSize = ud2(0, 0, 0, 0),
		AutomaticCanvasSize = aiy,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ElasticBehavior = Enum.ElasticBehavior.Never,
	},
	TextLabel = { BorderSizePixel = 0, BackgroundTransparency = 1, TextXAlignment = xal.Left, TextSize = 16, Text = "", AutoLocalize = false },
	TextButton = { BorderSizePixel = 0, BackgroundTransparency = 1, AutoButtonColor = false, Text = "", TextSize = 16, AutoLocalize = false },
	TextBox = { BorderSizePixel = 0, ClearTextOnFocus = false, TextXAlignment = xal.Left, TextSize = 16, Text = "", AutoLocalize = false },
	ImageLabel = { BorderSizePixel = 0, BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Fit },
	ImageButton = { BorderSizePixel = 0, BackgroundTransparency = 1, AutoButtonColor = false, ScaleType = Enum.ScaleType.Fit },
}

local txtcls = { TextLabel = true, TextButton = true, TextBox = true }

local function mk(cls, p, th)
	local o = Instance.new(cls)
	local d = defs[cls]
	if d then
		for k, v in next, d do
			o[k] = v
		end
	end
	if txtcls[cls] then
		o.FontFace = fnt.s
		o.TextColor3 = thm.txt
	end
	local par
	if p then
		for k, v in next, p do
			if k == "Parent" then
				par = v
			else
				o[k] = v
			end
		end
	end
	if th then
		for k, v in next, th do
			o[k] = thm[v]
			o:SetAttribute("t_" .. k, v)
		end
	end
	if par then
		o.Parent = par
	end
	return o
end

local function corner(o, r)
	return mk("UICorner", { CornerRadius = ud(0, r or 3), Parent = o })
end

local function pill(o)
	return mk("UICorner", { CornerRadius = ud(1, 0), Parent = o })
end

local function pad(o, l, r, t, b)
	return mk("UIPadding", {
		PaddingLeft = ud(0, l or 0),
		PaddingRight = ud(0, r or 0),
		PaddingTop = ud(0, t or 0),
		PaddingBottom = ud(0, b or 0),
		Parent = o,
	})
end

local function vlist(o, p)
	return mk("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = ud(0, p or 0), Parent = o })
end

local function hlist(o, p, h)
	return mk("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal,
		Padding = ud(0, p or 0),
		HorizontalAlignment = h or ha.Left,
		VerticalAlignment = va.Center,
		Parent = o,
	})
end

local tis = {}

local function tw(o, p, t)
	t = t or 0.14
	local i = tis[t]
	if not i then
		i = TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		tis[t] = i
	end
	local x = ts:Create(o, i, p)
	x:Play()
	return x
end

local function inside(o, p)
	local a, s = o.AbsolutePosition, o.AbsoluteSize
	return p.X >= a.X and p.Y >= a.Y and p.X <= a.X + s.X and p.Y <= a.Y + s.Y
end

local lib = {
	flags = {},
	els = {},
	fl = {},
	profs = {},
	dir = "memesense",
	thm = thm,
	fnt = fnt,
	ico = ico,
	ver = "1.0.0",
}

local st = {
	md = maid.new(),
	pops = {},
	bmap = {},
	drag = {},
	open = true,
	dead = false,
	cfg = nil,
	ln = 0,
	fn = 0,
	unl = {},
}

local function mpos()
	local t = st.tp
	if t then
		return t
	end
	local m = uis:GetMouseLocation()
	local p = st.probe
	if p then
		return m + p.AbsolutePosition
	end
	return m
end

local function ipos(i)
	local p = i.Position
	return v2(p.X, p.Y)
end

local function isptr(t)
	return t == mb1 or t == tch
end

local hud = { on = true, size = 16, gap = 2, stroke = true }
local wm = { on = false, show = { "Name", "FPS", "Ping", "Time" }, text = "" }

local hudupd, ctxopen, newcont, prefsave

local function startdrag(mv, up, own, i)
	local d = st.drag
	d.mv, d.up, d.own = mv, up, own
	d.ti = i and i.UserInputType == tch and i or nil
end

local function stopdrag(rel)
	local d = st.drag
	local u = d.up
	d.mv, d.up, d.own, d.ti = nil, nil, nil, nil
	if u then
		u(rel)
	end
end

local function covered(pop, mp)
	local ps = st.pops
	local k = pop and tfind(ps, pop) or 0
	for i = #ps, k + 1, -1 do
		if inside(ps[i].frame, mp) then
			return true
		end
	end
	return false
end

local hvs = setmetatable({}, { __mode = "k" })

local function hovchk(r, mp)
	local o, p = r.o, r.p
	if o.Parent == nil then
		r.i = false
		hvs[r] = nil
	end
	local s = r.i and st.open and (p == nil or p.isopen == true) and inside(o, mp) and not covered(p, mp)
	if s ~= r.s then
		r.s = s
		if s then
			r.on()
		else
			r.off()
		end
	end
end

local function hovscan()
	if next(hvs) == nil then
		return
	end
	local mp = mpos()
	for r in next, hvs do
		hovchk(r, mp)
	end
end

local function hover(o, pop, on, off)
	local r = { o = o, p = pop, on = on, off = off, i = false, s = false }
	con(o.MouseEnter, function()
		r.i = true
		hvs[r] = true
		hovchk(r, mpos())
	end)
	con(o.MouseLeave, function()
		r.i = false
		hvs[r] = nil
		hovchk(r, mpos())
	end)
	return r
end

local function lpress(o, fn)
	con(o.InputBegan, function(i)
		if i.UserInputType ~= tch then
			return
		end
		local p0 = i.Position
		delay(0.5, function()
			if i.UserInputState ~= iend and (i.Position - p0).Magnitude < 10 and not st.dead then
				fn(i)
			end
		end)
	end)
end

local function tabhov(b, pop, iscur)
	hover(b, pop, function()
		if not iscur() then
			tw(b, { TextColor3 = thm.dim:Lerp(thm.txt, 0.35) }, 0.1)
		end
	end, function()
		tw(b, { TextColor3 = iscur() and thm.txt or thm.dim }, 0.1)
	end)
end

local function sink(par)
	return mk("TextButton", { Size = scl(1, 1), ZIndex = 0, Parent = par })
end

local done = Enum.PlaybackState.Completed
local pdur, tdur = 0.14, 0.18

local function canfade()
	return st.live == true and st.open and st.ft == nil and not st.dead
end

local wrs = setmetatable({}, { __mode = "k" })

local function gfade(f, v, dur)
	local w = wrs[f]
	if not w then
		if not canfade() or not f.Parent then
			f.Visible = v
			return
		end
		if not v and not f.Visible then
			return
		end
		local a = f.AutomaticSize
		w = { p = f.Parent, pos = f.Position, ap = f.AnchorPoint, sz = f.Size, n = 0 }
		w.g = mk("CanvasGroup", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = w.pos,
			AnchorPoint = w.ap,
			Size = w.sz,
			AutomaticSize = a,
			LayoutOrder = f.LayoutOrder,
			ZIndex = f.ZIndex,
			GroupTransparency = v and 1 or 0,
			Parent = w.p,
		})
		wrs[f] = w
		f.Parent = w.g
		f.AnchorPoint = v2(0, 0)
		f.Position = ofs(0, 0)
		f.Size = ud2(1, 0, (a == aiy or a == aixy) and 0 or 1, 0)
	end
	w.n += 1
	local n = w.n
	if v then
		f.Visible = true
	end
	w.g.Interactable = v
	tw(w.g, { GroupTransparency = v and 0 or 1 }, dur or tdur).Completed:Once(function(s)
		if s ~= done or w.n ~= n or wrs[f] ~= w then
			return
		end
		wrs[f] = nil
		if not v then
			f.Visible = false
		end
		pcall(function()
			f.Parent = w.p
			f.Position, f.AnchorPoint, f.Size = w.pos, w.ap, w.sz
		end)
		w.g:Destroy()
	end)
end

local lks = setmetatable({}, { __mode = "k" })

local tprops = {
	Frame = { "BackgroundTransparency" },
	TextLabel = { "BackgroundTransparency", "TextTransparency", "TextStrokeTransparency" },
	TextButton = { "BackgroundTransparency", "TextTransparency" },
	ImageLabel = { "BackgroundTransparency", "ImageTransparency" },
	ImageButton = { "BackgroundTransparency", "ImageTransparency" },
	UIStroke = { "Transparency" },
}

local function snapt(root)
	local out = {}
	local function add(o)
		local ps = tprops[o.ClassName]
		if ps then
			local t = {}
			for i = 1, #ps do
				t[ps[i]] = o[ps[i]]
			end
			out[#out + 1] = { o, t }
		end
	end
	add(root)
	local ds = root:GetDescendants()
	for i = 1, #ds do
		add(ds[i])
	end
	return out
end

local function pfade(root, parts, v, dur)
	local n = (lks[root] or 0) + 1
	lks[root] = n
	if not v and not root.Visible then
		return
	end
	if v and not root.Visible then
		for i = 1, #parts do
			local x = parts[i]
			for k in next, x[2] do
				x[1][k] = 1
			end
		end
		root.Visible = true
	end
	local last
	for i = 1, #parts do
		local x = parts[i]
		local g = {}
		for k, val in next, x[2] do
			g[k] = v and val or 1
		end
		last = tw(x[1], g, dur or 0.15)
	end
	if not v and last then
		last.Completed:Once(function(s)
			if s == done and lks[root] == n then
				root.Visible = false
			end
		end)
	end
end

local function pagesw(bs, pages, cur, anim)
	for i = 1, #bs do
		local on = i == cur
		local b, f = bs[i], pages[i].frame
		local c = on and thm.txt or thm.dim
		if anim then
			tw(b, { TextColor3 = c }, 0.12)
		else
			b.TextColor3 = c
		end
		if on then
			if anim then
				gfade(f, true)
			else
				f.Visible = true
			end
		else
			f.Visible = false
		end
	end
end

local popcls = {}
popcls.__index = popcls

local function newpop(o)
	local p = setmetatable({
		w = o.w or 300,
		keep = o.keep,
		par = o.par,
		anchor = o.anchor,
		md = maid.new(),
		isopen = false,
		px = 0,
		py = 0,
		an = 0,
	}, popcls)
	p.box = mk("Frame", { BackgroundTransparency = 1, Size = ofs(p.w, 0), AutomaticSize = aiy, Visible = false, Parent = st.pl })
	p.frame = mk("Frame", { Size = ud2(1, 0, 0, 0), AutomaticSize = aiy, Parent = p.box }, { BackgroundColor3 = o.bg or "pop" })
	sink(p.frame)
	if not o.raw then
		local b = mk("Frame", { BackgroundTransparency = 1, Size = ud2(1, 0, 0, 0), AutomaticSize = aiy, Parent = p.frame })
		pad(b, o.px or 14, o.px or 14, o.py or 12, o.py or 12)
		vlist(b, 6)
		p.c = newcont(b, o.tab, p)
		p.c.tmp = o.tmp
	end
	return p
end

function popcls:clampit()
	local b = self.box
	if not b.Parent or not st.root then
		return
	end
	local sc = st.us.Scale
	local ap, gp, gs, as = st.root.AbsolutePosition, st.probe.AbsolutePosition, st.gui.AbsoluteSize, self.frame.AbsoluteSize
	local sx = clamp(ap.X + self.px * sc, gp.X + 4, max(gp.X + 4, gp.X + gs.X - as.X - 4))
	local sy = clamp(ap.Y + self.py * sc, gp.Y + 4, max(gp.Y + 4, gp.Y + gs.Y - as.Y - 4))
	b.Position = ofs((sx - ap.X) / sc, (sy - ap.Y) / sc)
end

function popcls:place(sx, sy)
	local sc = st.us.Scale
	local ap = st.root.AbsolutePosition
	self.px, self.py = (sx - ap.X) / sc, (sy - ap.Y) / sc
	self.box.Position = ofs(self.px, self.py)
	self:clampit()
	self.md:add(self.frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		self:clampit()
	end))
end

function popcls:settle()
	self.an += 1
	local g = self.cg
	if g then
		self.cg = nil
		if self.frame.Parent == g then
			self.frame.Parent = self.box
		end
		g:Destroy()
	end
end

function popcls:anim(v, fin)
	self.an += 1
	local n = self.an
	local g = self.cg
	if not g then
		g = mk("CanvasGroup", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = ud2(1, 0, 0, 0),
			AutomaticSize = aiy,
			GroupTransparency = v and 1 or 0,
			Parent = self.box,
		})
		self.cg = g
		self.frame.Parent = g
	end
	g.Interactable = v
	tw(g, { GroupTransparency = v and 0 or 1 }, pdur).Completed:Once(function(s)
		if s ~= done or self.an ~= n then
			return
		end
		self.cg = nil
		if self.frame.Parent == g then
			self.frame.Parent = self.box
		end
		g:Destroy()
		if fin then
			fin()
		end
	end)
end

function popcls:hide(now)
	if not self.isopen then
		return
	end
	self.isopen = false
	self.md:clean()
	if st.drag.own == self then
		stopdrag()
	end
	local l = st.listen
	if l and l.c and l.c.pop == self then
		st.listen = nil
		l.lst = false
		l:draw()
	end
	local oc = self.onclose
	if oc then
		self.onclose = nil
		oc()
	end
	local b = self.box
	local fin
	if self.keep then
		fin = function()
			b.Visible = false
		end
	else
		self.dead = true
		fin = function()
			b:Destroy()
		end
	end
	if now or not canfade() then
		self:settle()
		fin()
	else
		self:anim(false, fin)
	end
end

local function closefrom(i, now)
	local ps = st.pops
	local n = #ps
	for j = n, max(i, 1), -1 do
		local p = ps[j]
		ps[j] = nil
		p:hide(now)
	end
	if n >= max(i, 1) then
		hovscan()
	end
end

local function closeall(now)
	closefrom(1, now)
end

local function closepop(p)
	local i = tfind(st.pops, p)
	if i then
		closefrom(i)
	end
end

local function openpop(p, sx, sy)
	local ps = st.pops
	local pi = p.par and tfind(ps, p.par) or 0
	closefrom(pi + 1)
	ps[#ps + 1] = p
	p.isopen = true
	p.box.ZIndex = 10 + #ps
	p.box.Visible = true
	p:place(sx, sy)
	if canfade() then
		p:anim(true)
	else
		p:settle()
	end
	hovscan()
end

local function popflip(p, sx, sy)
	if p.isopen then
		closepop(p)
		return
	end
	local mp = mpos()
	openpop(p, sx or mp.X, sy or (mp.Y + 6))
end

local function popclick(mp)
	local ps = st.pops
	for i = #ps, 1, -1 do
		local p = ps[i]
		if inside(p.frame, mp) or (p.anchor and p.anchor.Parent and inside(p.anchor, mp)) then
			closefrom(i + 1)
			return
		end
	end
	closeall()
end

local function bmapadd(e, k)
	local l = st.bmap[k]
	if not l then
		l = {}
		st.bmap[k] = l
	end
	if not tfind(l, e) then
		l[#l + 1] = e
	end
end

local function bmapdel(e, k)
	local l = st.bmap[k]
	if not l then
		return
	end
	local i = tfind(l, e)
	if i then
		tremove(l, i)
	end
	if #l == 0 then
		st.bmap[k] = nil
	end
end

local mbtn = { MouseButton1 = true, MouseButton2 = true, MouseButton3 = true }

local function onmenu(mp)
	if not mp or not st.open or not st.root then
		return false
	end
	if inside(st.root, mp) then
		return true
	end
	local ps = st.pops
	for i = 1, #ps do
		if inside(ps[i].frame, mp) then
			return true
		end
	end
	return false
end

local function onbegan(i)
	if st.dead then
		return
	end
	local t = i.UserInputType
	local mp
	if t == tch then
		mp = ipos(i)
		st.tp = mp
	elseif t == mb1 or t == mb2 or t == mb3 then
		st.tp = nil
		mp = mpos()
	end
	local l = st.listen
	if l then
		local k = inkey(i)
		if k then
			st.listen = nil
			l.lst = false
			if k == "Escape" or k == "Backspace" then
				l:setkey(nil)
			elseif (mbtn[k] and l.o.nomouse) or (k == "MouseButton1" and onmenu(mp)) then
				l:draw()
			else
				if mbtn[k] then
					st.eat = l
					delay(0.35, function()
						if st.eat == l then
							st.eat = nil
						end
					end)
				end
				l:setkey(k)
			end
			return
		end
	end
	if mp and t ~= mb3 and #st.pops > 0 then
		popclick(mp)
	end
	if t == tch then
		return
	end
	local k = inkey(i)
	if not k or uis:GetFocusedTextBox() or onmenu(mp) then
		return
	end
	local b = st.bmap[k]
	if b then
		for j = #b, 1, -1 do
			local e = b[j]
			if e then
				e:bdown()
			end
		end
	end
end

local function onended(i)
	if st.dead then
		return
	end
	local t, d = i.UserInputType, st.drag
	if t == tch then
		local g = st.tg
		if g and g.i == i then
			st.tg = nil
			g.tap(ipos(i))
		end
	end
	if d.mv and ((t == mb1 and not d.ti) or (t == tch and d.ti == i)) then
		stopdrag(true)
	end
	local k = inkey(i)
	if not k then
		return
	end
	local b = st.bmap[k]
	if b then
		for j = #b, 1, -1 do
			local e = b[j]
			if e then
				e:bup()
			end
		end
	end
end

local function onchanged(i)
	if st.dead then
		return
	end
	local t, d = i.UserInputType, st.drag
	if t == mmove then
		st.tp = nil
		if d.mv and not d.ti then
			d.mv(mpos())
		end
		hovscan()
	elseif t == tch then
		local p = ipos(i)
		st.tp = p
		local g = st.tg
		if g and g.i == i then
			local dx, dy = math.abs(p.X - g.p0.X), math.abs(p.Y - g.p0.Y)
			if dx > 6 and dx >= dy then
				st.tg = nil
				g.drag(p)
			elseif dy > 6 then
				st.tg = nil
			end
		end
		if d.mv and d.ti == i then
			d.mv(p)
		end
	end
end

local function relall()
	for _, l in next, st.bmap do
		for j = #l, 1, -1 do
			local e = l[j]
			if e then
				e:bup()
			end
		end
	end
end

local elm = {}
elm.__index = elm
local eid = 0

local function newel(cls, c, o, kind)
	eid += 1
	return setmetatable({
		id = eid,
		kind = kind,
		c = c,
		o = o,
		name = o.name or o.text or "",
		flag = o.flag,
		cb = o.cb or o.callback,
		dis = false,
		tmp = o.tmp or (c and c.tmp) or false,
	}, cls)
end

function elm:get()
	return self.val
end

function elm:eff()
	return self.val
end

function elm:ser()
	return self.val
end

function elm:unser(v)
	return v
end

function elm:load() end

function elm:draw() end

function elm:kbdraw() end

function elm:bdown()
	local b = self.bnd
	if not b or self.dis or self.dead then
		return
	end
	if b.mode == "hold" then
		if not b.act then
			b.act = true
			self:draw()
			self:fire()
		end
	elseif self.kind == "tgl" then
		self:set(not self.val)
	else
		b.act = not b.act
		self:draw()
		self:fire()
	end
end

function elm:bup()
	local b = self.bnd
	if b and b.mode == "hold" and b.act then
		b.act = false
		self:draw()
		self:fire()
	end
end

function elm:onchange(f)
	local u = self.ucb
	if not u then
		u = {}
		self.ucb = u
	end
	u[#u + 1] = f
	return self
end

function elm:fire(nocb)
	local v = self:eff()
	if self.flag and not self.tmp then
		lib.flags[self.flag] = v
		if self.a ~= nil then
			lib.flags[self.flag .. "_a"] = self.a
		end
	end
	if not nocb then
		if self.cb then
			spawn(self.cb, v, self.a)
		end
		local u = self.ucb
		if u then
			for i = 1, #u do
				spawn(u[i], v, self.a)
			end
		end
	end
	local d = self.dnt
	if d then
		for i = 1, #d do
			d[i]:chkdep()
		end
	end
	if self.ind then
		hudupd(self)
	end
end

function elm:dep(src, want)
	local d = self.deps
	if not d then
		d = {}
		self.deps = d
	end
	d[#d + 1] = { src = src, want = want }
	local n = src.dnt
	if not n then
		n = {}
		src.dnt = n
	end
	if not tfind(n, self) then
		n[#n + 1] = self
	end
	self:chkdep()
	return self
end

function elm:chkdep()
	local ok = true
	local d = self.deps
	if d then
		for i = 1, #d do
			local x = d[i]
			local s, w = x.src, x.want
			local v = s:eff()
			local r
			if type(w) == "function" then
				r = w(v)
			elseif w == nil then
				r = v == true
			elseif type(v) == "table" then
				r = tfind(v, w) ~= nil
			else
				r = v == w
			end
			if not r or s.dis then
				ok = false
				break
			end
		end
	end
	self:setdis(not ok)
end

function elm:setdis(b)
	b = b == true
	if self.dis == b then
		return self
	end
	self.dis = b
	self:draw()
	if self.ind then
		hudupd(self)
	end
	local a = self.accs
	if a then
		for i = 1, #a do
			a[i]:setdis(b)
		end
	end
	local n = self.dnt
	if n then
		for i = 1, #n do
			n[i]:chkdep()
		end
	end
	return self
end

function elm:vis(b)
	local r = self.row
	if r then
		r.Visible = b ~= false
	end
	return self
end

function elm:setbind(k, m)
	local b = self.bnd
	if not b then
		return self
	end
	if b.key then
		bmapdel(self, b.key)
	end
	b.act = false
	b.key = k
	if m then
		b.mode = m
	end
	if k then
		bmapadd(self, k)
	end
	self:kbdraw()
	self:draw()
	self:fire()
	return self
end

function elm:destroy()
	if self.dead then
		return
	end
	self.dead = true
	local b = self.bnd
	if b and b.key then
		bmapdel(self, b.key)
	end
	if self.kind == "kbd" and self.val then
		bmapdel(self, self.val)
	end
	if st.listen == self then
		st.listen = nil
	end
	if self.hl then
		self.hl:Destroy()
		self.hl = nil
	end
	local i = tfind(lib.els, self)
	if i then
		tremove(lib.els, i)
	end
	if self.prof then
		local pe = self.prof.els
		local j = tfind(pe, self)
		if j then
			tremove(pe, j)
		end
	end
	if self.flag and lib.fl[self.flag] == self then
		lib.fl[self.flag] = nil
		lib.flags[self.flag] = nil
	end
	local a = self.accs
	if a then
		for j = #a, 1, -1 do
			a[j]:destroy()
		end
	end
	if self.sw then
		self.sw:Destroy()
	end
	if self.btn and not self.row then
		self.btn:Destroy()
	end
	if self.row and self.row.Parent then
		self.row:Destroy()
	end
end

local function reg(e)
	if e.tmp then
		return
	end
	local els = lib.els
	els[#els + 1] = e
	local d = e:ser()
	if type(d) == "table" then
		d = tclone(d)
	end
	e.def = d
	if e.flag then
		lib.fl[e.flag] = e
		lib.flags[e.flag] = e:eff()
		if e.a ~= nil then
			lib.flags[e.flag .. "_a"] = e.a
		end
		local tb = e.c and e.c.tab
		local p = tb and tb.prof
		if p and not e.o.noprof then
			e.prof = p
			p.els[#p.els + 1] = e
		end
	end
end

local cont = {}
cont.__index = cont

newcont = function(f, tab, pop)
	return setmetatable({ frame = f, tab = tab, pop = pop, n = 0 }, cont)
end

function cont:row(h)
	self.n += 1
	return mk("Frame", { BackgroundTransparency = 1, Size = ud2(1, 0, 0, h), LayoutOrder = self.n, Parent = self.frame })
end

function cont:header(s)
	local r = self:row(26)
	mk("TextLabel", { Size = scl(1, 1), TextXAlignment = xal.Center, Text = tostring(s or ""), Parent = r }, { TextColor3 = "dim" })
	return r
end

function cont:space(h)
	return self:row(h or 6)
end

local function mkcheck(p)
	local h = mk("Frame", { BackgroundTransparency = 1, Size = scl(1, 1), Parent = p })
	local a = mk("Frame", {
		AnchorPoint = v2(0.5, 0.5),
		Position = scl(0.357, 0.63),
		Size = scl(0.305, 0.125),
		Rotation = 45,
		BackgroundColor3 = white,
		BackgroundTransparency = 1,
		Parent = h,
	})
	local b = mk("Frame", {
		AnchorPoint = v2(0.5, 0.5),
		Position = scl(0.569, 0.533),
		Size = scl(0.555, 0.125),
		Rotation = -48,
		BackgroundColor3 = white,
		BackgroundTransparency = 1,
		Parent = h,
	})
	pill(a)
	pill(b)
	return { a, b }
end

local tgl = setmetatable({}, elm)
tgl.__index = tgl

function cont:toggle(o, row)
	o = o or {}
	local e = newel(tgl, self, o, "tgl")
	e.val = o.default == true
	local r = row or self:row(31)
	e.row = r
	local hit = mk("TextButton", { Size = scl(1, 1), Parent = r })
	local box = mk("Frame", { AnchorPoint = v2(0, 0.5), Position = scl(0, 0.5), Size = ofs(22, 22), Parent = r })
	corner(box, 3)
	e.chk = mkcheck(box)
	local lb = mk("TextLabel", { Position = ofs(33, 0), Size = ud2(1, -33, 1, 0), Text = e.name, Parent = r })
	if o.auto then
		lb.Size = ud2(0, 0, 1, 0)
		lb.AutomaticSize = aix
	else
		e.accf = mk("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = v2(1, 0.5),
			Position = scl(1, 0.5),
			Size = ofs(0, 37),
			AutomaticSize = aix,
			ZIndex = 2,
			Parent = r,
		})
		hlist(e.accf, 9, ha.Right)
	end
	e.box, e.lbl, e.hit, e.an = box, lb, hit, 0
	e.bnd = { key = nil, mode = o.mode or "toggle", act = false }
	e.ind = { on = false, name = "", col = white, sv = false }
	local oi = o.ind
	if type(oi) == "table" then
		e.ind.on = oi.on ~= false
		e.ind.name = oi.name or ""
		e.ind.col = oi.color or white
	end
	con(hit.MouseButton1Click, function()
		if e.lpd then
			e.lpd = false
			return
		end
		if not e.dis then
			e:set(not e.val)
		end
	end)
	con(hit.MouseButton2Click, function()
		ctxopen(e)
	end)
	lpress(hit, function()
		e.lpd = true
		ctxopen(e)
	end)
	hover(hit, self.pop, function()
		e.hov = true
		e:draw()
	end, function()
		e.hov = false
		e:draw()
	end)
	if o.kb then
		e:kbicon()
	end
	if o.bind then
		e.bnd.key = o.bind
		bmapadd(e, o.bind)
		e:kbdraw()
	end
	e:draw(true)
	reg(e)
	if e.ind.on then
		hudupd(e)
	end
	return e
end

function tgl:nexta()
	self.an += 1
	return self.an
end

function tgl:eff()
	local b = self.bnd
	if b.act and b.mode == "hold" then
		return not self.val
	end
	return self.val
end

function tgl:set(v, nocb)
	v = v == true
	if self.val == v then
		return self
	end
	self.val = v
	self:draw()
	self:fire(nocb)
	return self
end

function tgl:load(v)
	if type(v) == "boolean" then
		self:set(v)
	end
end

function tgl:draw(now)
	local on, dis = self:eff(), self.dis
	local lc, bc
	if on then
		lc = dis and thm.dim or (self.o.risky and thm.acc or thm.txt)
		bc = dis and thm.acc:Lerp(thm.bg, 0.55) or thm.acc
	else
		lc = dis and thm.dis or (self.hov and thm.dim:Lerp(thm.txt, 0.3) or thm.dim)
		bc = dis and thm.ctl:Lerp(thm.bg, 0.5) or thm.ctl
	end
	local ct = on and 0 or 1
	local ck = self.chk
	if now then
		self.lbl.TextColor3 = lc
		self.box.BackgroundColor3 = bc
		ck[1].BackgroundTransparency, ck[2].BackgroundTransparency = ct, ct
	else
		tw(self.lbl, { TextColor3 = lc }, 0.12)
		tw(self.box, { BackgroundColor3 = bc }, 0.12)
		tw(ck[1], { BackgroundTransparency = ct }, 0.12)
		tw(ck[2], { BackgroundTransparency = ct }, 0.12)
	end
	self:kbdraw()
end

function tgl:kbicon()
	local i = self.kbi
	if i or not self.accf then
		return i
	end
	i = mk("ImageButton", { Size = ofs(20, 20), Image = icon("keyboard"), LayoutOrder = 0, Parent = self.accf }, { ImageColor3 = "kb" })
	con(i.MouseButton1Click, function()
		ctxopen(self)
	end)
	self.kbi = i
	return i
end

function tgl:kbdraw()
	local b = self.bnd
	local k = b.key
	if k and not self.kbi then
		self:kbicon()
	end
	local i = self.kbi
	if i then
		i.ImageColor3 = k and (b.act and thm.info or thm.acc) or thm.kb
		i.Visible = k ~= nil or self.o.kb == true
	end
end

function tgl:color(o)
	return self.c:colorpicker(o or {}, self)
end

function tgl:dropdown(o)
	return self.c:dropdown(o or {}, self)
end

function tgl:settings(o)
	o = o or {}
	local b = mk("ImageButton", { Size = ofs(20, 20), Image = icon("list"), LayoutOrder = self:nexta(), Parent = self.accf }, { ImageColor3 = "txt" })
	local p = newpop({ w = o.w or 300, keep = true, anchor = b, par = self.c.pop, tab = self.c.tab, tmp = self.tmp })
	con(b.MouseButton1Click, function()
		if not self.dis then
			popflip(p, nil, nil)
		end
	end)
	self.sp = p
	return p.c
end

local sld = setmetatable({}, elm)
sld.__index = sld

function cont:slider(o)
	o = o or {}
	local e = newel(sld, self, o, "sld")
	e.min, e.max = o.min or 0, o.max or 100
	e.dec = o.dec or o.decimals or 0
	e.step = o.step or 10 ^ -e.dec
	e.pat = "%." .. e.dec .. "f"
	e.suf = o.suffix or ""
	e.zero = o.zero
	e.val = e:rnd(o.default or e.min)
	local r = self:row(40)
	e.row = r
	local hit = mk("TextButton", { Size = scl(1, 1), Parent = r })
	e.lbl = mk("TextLabel", { Position = ofs(0, 2), Size = ud2(1, -110, 0, 22), RichText = true, Parent = r })
	e.vl = mk("TextLabel", { AnchorPoint = v2(1, 0), Position = ud2(1, 0, 0, 2), Size = ofs(110, 22), TextXAlignment = xal.Right, Parent = r })
	local tk = mk("Frame", { Position = ofs(0, 26), Size = ud2(1, 0, 0, 5), Parent = r }, { BackgroundColor3 = "trk" })
	e.fil = mk("Frame", { Size = scl(0, 1), Parent = tk })
	mk("UISizeConstraint", { MinSize = v2(3, 0), Parent = e.fil })
	e.trk = tk
	e.bnd = { key = nil, mode = o.mode or "hold", act = false, v = e.val }
	e.ind = { on = false, name = "", col = white, sv = true }
	local oi = o.ind
	if type(oi) == "table" then
		e.ind.on = oi.on ~= false
		e.ind.name = oi.name or ""
		e.ind.col = oi.color or white
		e.ind.sv = oi.value ~= false
	end
	if o.bindvalue ~= nil then
		e.bnd.v = e:rnd(o.bindvalue)
	end
	e.mv = function(p)
		local ax, aw = tk.AbsolutePosition.X, tk.AbsoluteSize.X
		if aw <= 0 then
			return
		end
		local v = e.min + clamp((p.X - ax) / aw, 0, 1) * (e.max - e.min)
		if e.bnd.act then
			e:setbv(v)
		else
			e:set(v)
		end
	end
	e.mu = function()
		e.drg = false
		if e.pend then
			e.pend = false
			e:fire()
		end
	end
	con(hit.InputBegan, function(i)
		if e.dis then
			return
		end
		local t = i.UserInputType
		if t == mb1 then
			e.drg = true
			e.mv(mpos())
			startdrag(e.mv, e.mu, self.pop, i)
		elseif t == tch then
			local g = { i = i, p0 = ipos(i) }
			g.drag = function(p)
				e.drg = true
				e.mv(p)
				startdrag(e.mv, e.mu, self.pop, i)
			end
			g.tap = function(p)
				e.mv(p)
				e.mu()
			end
			st.tg = g
			delay(0.5, function()
				if st.tg == g then
					st.tg = nil
					ctxopen(e)
				end
			end)
		end
	end)
	con(hit.MouseButton2Click, function()
		ctxopen(e)
	end)
	if o.bind then
		e.bnd.key = o.bind
		bmapadd(e, o.bind)
	end
	e:draw()
	reg(e)
	if e.ind.on then
		hudupd(e)
	end
	return e
end

function sld:rnd(v)
	local lo, hi = self.min, self.max
	v = clamp(tonumber(v) or lo, lo, hi)
	local s = self.step
	if s > 0 then
		v = lo + floor((v - lo) / s + 0.5) * s
	end
	return tonumber(sfmt(self.pat, clamp(v, lo, hi)))
end

function sld:eff()
	local b = self.bnd
	if b and b.act then
		return b.v
	end
	return self.val
end

function sld:set(v, nocb)
	v = self:rnd(v)
	if v == self.val then
		return self
	end
	self.val = v
	self:draw()
	if self.bnd.act then
		return self
	end
	if self.drg and self.o.release then
		self.pend = true
		return self
	end
	self:fire(nocb)
	return self
end

function sld:setbv(v)
	v = self:rnd(v)
	local b = self.bnd
	if b.v == v then
		return self
	end
	b.v = v
	if b.act then
		self:draw()
		self:fire()
	end
	return self
end

function sld:load(v)
	if type(v) == "number" then
		self:set(v)
	end
end

function sld:fmtv(v)
	local f = self.o.fmt
	if f then
		return f(v)
	end
	if self.zero and v <= self.min then
		return self.zero
	end
	return sfmt(self.pat, v) .. self.suf
end

function sld:draw()
	local v, dis = self:eff(), self.dis
	local b = self.bnd
	local rng = self.max - self.min
	local fs_ = scl(rng > 0 and (v - self.min) / rng or 0, 1)
	local fc = dis and thm.filld or thm.fill
	if self.drawn then
		tw(self.fil, { Size = fs_, BackgroundColor3 = fc }, 0.08)
	else
		self.drawn = true
		self.fil.Size = fs_
		self.fil.BackgroundColor3 = fc
	end
	local nm = esc(self.name)
	if b.key then
		nm ..= sfmt('  <font color="%s">[%s]</font>', hex(b.act and thm.info or thm.kb), esc(kname(b.key)))
	end
	self.lbl.Text = nm
	self.lbl.TextColor3 = dis and thm.dim or thm.txt
	self.vl.Text = self:fmtv(v)
	self.vl.TextColor3 = dis and thm.dim or (b.act and thm.info or thm.txt)
end

local drp = setmetatable({}, elm)
drp.__index = drp

local function ddbtn(par, w, lo, pop)
	local b = mk("TextButton", { Size = ofs(w, 37), BackgroundTransparency = 0, LayoutOrder = lo or 0, Parent = par }, { BackgroundColor3 = "drop" })
	corner(b, 3)
	local cl = mk("Frame", { BackgroundTransparency = 1, Position = ofs(10, 0), Size = ud2(1, -36, 1, 0), ClipsDescendants = true, Parent = b })
	local t = mk("TextLabel", { Size = ud2(0, 600, 1, 0), Parent = cl })
	local ch = mk("ImageLabel", {
		AnchorPoint = v2(1, 0.5),
		Position = ud2(1, -10, 0.5, 0),
		Size = ofs(16, 16),
		Image = icon("chevron"),
		Parent = b,
	}, { ImageColor3 = "txt" })
	hover(b, pop, function()
		tw(b, { BackgroundColor3 = thm.droph }, 0.1)
	end, function()
		tw(b, { BackgroundColor3 = thm.drop }, 0.1)
	end)
	return b, t, ch
end

function cont:dropdown(o, host)
	o = o or {}
	local e = newel(drp, self, o, "drp")
	e.multi = o.multi == true
	e.values = o.values or o.options or {}
	if e.multi then
		e.val = {}
		local d = o.default
		if type(d) == "table" then
			for i = 1, #d do
				e.val[i] = d[i]
			end
		elseif d ~= nil then
			e.val[1] = d
		end
	else
		e.val = o.default
		if e.val == nil and not o.none then
			e.val = e.values[1]
		end
	end
	e.srt = function(a, b)
		return (tfind(e.values, a) or 0) < (tfind(e.values, b) or 0)
	end
	local w = o.w or 133
	if host then
		local a = host.accs
		if not a then
			a = {}
			host.accs = a
		end
		a[#a + 1] = e
		if e.multi and o.icon ~= false then
			e.li = mk("ImageLabel", { Size = ofs(20, 20), Image = icon("list"), LayoutOrder = host:nexta(), Parent = host.accf }, { ImageColor3 = "txt" })
		end
		e.btn, e.t, e.ch = ddbtn(host.accf, w, host:nexta(), self.pop)
	elseif o.par then
		e.btn, e.t, e.ch = ddbtn(o.par, w, o.lo, self.pop)
	else
		local r = self:row(37)
		e.row = r
		if e.name ~= "" then
			e.lbl = mk("TextLabel", { Size = ud2(1, -w - 44, 1, 0), Text = e.name, Parent = r })
		end
		local hd = mk("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = v2(1, 0.5),
			Position = scl(1, 0.5),
			Size = ofs(0, 37),
			AutomaticSize = aix,
			Parent = r,
		})
		hlist(hd, 10, ha.Right)
		if e.multi and o.icon ~= false then
			e.li = mk("ImageLabel", { Size = ofs(20, 20), Image = icon("list"), LayoutOrder = 1, Parent = hd }, { ImageColor3 = "txt" })
		end
		e.btn, e.t, e.ch = ddbtn(hd, w, 2, self.pop)
	end
	con(e.btn.MouseButton1Click, function()
		if e.dis then
			return
		end
		if e.lp and e.lp.isopen then
			closepop(e.lp)
		else
			e:openlist()
		end
	end)
	e:draw()
	reg(e)
	return e
end

function drp:has(v)
	if self.multi then
		return tfind(self.val, v) ~= nil
	end
	return self.val == v
end

function drp:text()
	if self.multi then
		local n = #self.val
		if n == 0 then
			return "None"
		end
		local t = table.create(n)
		for i = 1, n do
			t[i] = tostring(self.val[i])
		end
		return tconcat(t, ", ")
	end
	if self.val == nil then
		return "None"
	end
	return tostring(self.val)
end

function drp:draw()
	local dis = self.dis
	local c = dis and thm.dim or thm.txt
	self.t.Text = self:text()
	self.t.TextColor3 = c
	self.ch.ImageColor3 = c
	if self.lbl then
		self.lbl.TextColor3 = c
	end
	if self.li then
		self.li.ImageColor3 = c
	end
	local it = self.items
	if it then
		local hv = self.hv
		for i = 1, #it do
			local x = it[i]
			local on = self:has(x.v)
			local h = hv == x
			tw(x.b, { BackgroundTransparency = (on or h) and 0 or 1, BackgroundColor3 = on and (h and thm.dselh or thm.dsel) or thm.droph }, 0.08)
			tw(x.t, { TextColor3 = (on or h) and thm.txt or thm.dim }, 0.08)
			if x.ck then
				tw(x.ck, { ImageTransparency = on and 0 or 1 }, 0.08)
			end
		end
	end
end

function drp:set(v, nocb)
	if self.multi then
		local t = self.val
		if v == t then
			v = tclone(v)
		end
		tclear(t)
		if type(v) == "table" then
			for i = 1, #v do
				local x = v[i]
				if tfind(self.values, x) and not tfind(t, x) then
					t[#t + 1] = x
				end
			end
		elseif v ~= nil and tfind(self.values, v) then
			t[1] = v
		end
		tsort(t, self.srt)
	else
		if v ~= nil and not tfind(self.values, v) then
			return self
		end
		if self.val == v then
			return self
		end
		self.val = v
	end
	self:draw()
	self:fire(nocb)
	return self
end

function drp:flip(v)
	local t = self.val
	local i = tfind(t, v)
	if i then
		if self.o.min1 and #t == 1 then
			return
		end
		tremove(t, i)
	else
		t[#t + 1] = v
		tsort(t, self.srt)
	end
	self:draw()
	self:fire()
end

function drp:setvalues(vals)
	self.values = vals or {}
	if self.multi then
		local t = self.val
		for i = #t, 1, -1 do
			if not tfind(self.values, t[i]) then
				tremove(t, i)
			end
		end
	elseif self.val ~= nil and not tfind(self.values, self.val) then
		self.val = self.values[1]
	end
	if self.lp and self.lp.isopen then
		closepop(self.lp)
	end
	self:draw()
	self:fire()
	return self
end

function drp:ser()
	if self.multi then
		return tclone(self.val)
	end
	return self.val
end

function drp:load(v)
	if self.multi then
		if type(v) == "table" then
			self:set(v)
		end
	elseif v ~= nil then
		self:set(v)
	end
end

function drp:openlist()
	local b = self.btn
	local sc = st.us.Scale
	local as = b.AbsoluteSize
	local p = newpop({ w = max(as.X / sc, 133), raw = true, anchor = b, par = self.c and self.c.pop, bg = "drop" })
	local vals = self.values
	local n = #vals
	local h = min(n, 8) * 30
	local anim = canfade()
	local sf = mk("ScrollingFrame", {
		Size = ud2(1, 0, 0, anim and 0 or h),
		ScrollBarThickness = n > 8 and 2 or 0,
		Parent = p.frame,
	}, { ScrollBarImageColor3 = "fill" })
	vlist(sf, 0)
	local items = table.create(n)
	for i = 1, n do
		local v = vals[i]
		local on = self:has(v)
		local ib = mk("TextButton", {
			Size = ud2(1, 0, 0, 30),
			LayoutOrder = i,
			BackgroundTransparency = on and 0 or 1,
			BackgroundColor3 = on and thm.dsel or thm.droph,
			Parent = sf,
		})
		local t = mk("TextLabel", {
			Position = ofs(10, 0),
			Size = ud2(1, -38, 1, 0),
			Text = tostring(v),
			TextColor3 = on and thm.txt or thm.dim,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = ib,
		})
		local ck
		if self.multi then
			ck = mk("ImageLabel", {
				AnchorPoint = v2(1, 0.5),
				Position = ud2(1, -10, 0.5, 0),
				Size = ofs(14, 14),
				Image = icon("check"),
				ImageTransparency = on and 0 or 1,
				Parent = ib,
			}, { ImageColor3 = "acc" })
		end
		local x = { b = ib, t = t, ck = ck, v = v }
		hover(ib, p, function()
			self.hv = x
			self:draw()
		end, function()
			if self.hv == x then
				self.hv = nil
				self:draw()
			end
		end)
		con(ib.MouseButton1Click, function()
			if self.multi then
				self:flip(v)
			else
				closepop(p)
				self:set(v)
			end
		end)
		items[i] = x
	end
	self.items = items
	self.lp = p
	p.onclose = function()
		self.items = nil
		self.hv = nil
		self.lp = nil
		tw(self.ch, { Rotation = 0 }, pdur)
	end
	local ap = b.AbsolutePosition
	openpop(p, ap.X, ap.Y + as.Y + 3)
	tw(self.ch, { Rotation = 180 }, pdur)
	if anim then
		tw(sf, { Size = ud2(1, 0, 0, h) }, pdur)
	end
end

local cpk = setmetatable({}, elm)
cpk.__index = cpk

local function checker(par)
	local im = st.chk
	if not im then
		return nil
	end
	return mk("ImageLabel", {
		Size = scl(1, 1),
		Image = im,
		ScaleType = Enum.ScaleType.Tile,
		TileSize = ofs(14, 14),
		ResampleMode = Enum.ResamplerMode.Pixelated,
		Parent = par,
	})
end

local function marker(bar)
	local m = mk("Frame", { BackgroundTransparency = 1, Size = ud2(1, 0, 0, 0), ZIndex = 3, Parent = bar })
	for i = 0, 1 do
		local d = mk("Frame", {
			AnchorPoint = v2(0.5, 0.5),
			Position = scl(i, 0),
			Size = ofs(8, 8),
			Rotation = 45,
			BackgroundColor3 = white,
			ZIndex = 3,
			Parent = m,
		})
		mk("UIStroke", { Color = black, Transparency = 0.35, Thickness = 1, Parent = d })
	end
	return m
end

function cont:colorpicker(o, host)
	o = o or {}
	local e = newel(cpk, self, o, "cpk")
	local c = o.default or o.color or white
	e.val = c
	e.a = o.alpha or 1
	e.h, e.s, e.v = c:ToHSV()
	local par, lo
	if host then
		local a = host.accs
		if not a then
			a = {}
			host.accs = a
		end
		a[#a + 1] = e
		par, lo = host.accf, host:nexta()
	else
		local r = self:row(31)
		e.row = r
		e.lbl = mk("TextLabel", { Size = ud2(1, -30, 1, 0), Text = e.name, Parent = r })
		par = mk("Frame", { BackgroundTransparency = 1, AnchorPoint = v2(1, 0.5), Position = scl(1, 0.5), Size = ofs(16, 16), Parent = r })
		lo = 0
	end
	local sw = mk("TextButton", { Size = ofs(16, 16), BackgroundTransparency = 0, LayoutOrder = lo, Parent = par })
	corner(sw, 2)
	mk("UIStroke", { Color = black, Transparency = 0.4, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = sw })
	e.sw = sw
	con(sw.MouseButton1Click, function()
		if e.dis then
			return
		end
		if e.pp and e.pp.isopen then
			closepop(e.pp)
		else
			e:openpick()
		end
	end)
	e:draw()
	reg(e)
	return e
end

function cpk:ser()
	return hex(self.val, self.a)
end

function cpk:unser(v)
	local c = unhex(v)
	return c or v
end

function cpk:load(v)
	local c, a = unhex(v)
	if c then
		self:set(c, a)
	end
end

function cpk:set(c, a, nocb)
	if typeof(c) ~= "Color3" then
		return self
	end
	a = a or self.a
	if c == self.val and a == self.a then
		return self
	end
	self.val, self.a = c, a
	local h, s, v = c:ToHSV()
	if s > 0 and v > 0 then
		self.h = h
	end
	self.s, self.v = s, v
	self:draw()
	self:fire(nocb)
	return self
end

function cpk:sethsv(h, s, v, a)
	self.h, self.s, self.v = h, s, v
	if a then
		self.a = a
	end
	self.val = hsv(h, s, v)
	self:draw()
	self:fire()
end

function cpk:draw()
	local sw = self.sw
	sw.BackgroundColor3 = self.val
	sw.BackgroundTransparency = (1 - self.a) * 0.85
	if self.lbl then
		self.lbl.TextColor3 = self.dis and thm.dim or thm.txt
	end
	local pu = self.pu
	if pu then
		pu()
	end
end

function cpk:openpick()
	local e = self
	local p = newpop({ w = 372, raw = true, anchor = self.sw, par = self.c and self.c.pop })
	e.pp = p
	local bd = mk("Frame", { BackgroundTransparency = 1, Size = ofs(372, 308), Parent = p.frame })
	local sv = mk("TextButton", { Position = ofs(12, 12), Size = ofs(248, 243), BackgroundTransparency = 0, Parent = bd })
	local wl = mk("Frame", { Size = scl(1, 1), BackgroundColor3 = white, Parent = sv })
	mk("UIGradient", { Transparency = nseq(0, 1), Parent = wl })
	local bl = mk("Frame", { Size = scl(1, 1), BackgroundColor3 = black, Parent = sv })
	mk("UIGradient", { Rotation = 90, Transparency = nseq(1, 0), Parent = bl })
	local cur = mk("Frame", { AnchorPoint = v2(0.5, 0.5), Size = ofs(11, 11), BackgroundTransparency = 1, ZIndex = 3, Parent = sv })
	pill(cur)
	mk("UIStroke", { Color = white, Thickness = 1.5, Parent = cur })
	local hb = mk("TextButton", { Position = ofs(274, 12), Size = ofs(35, 243), BackgroundTransparency = 0, BackgroundColor3 = white, Parent = bd })
	local hk = table.create(7)
	for i = 0, 6 do
		hk[i + 1] = ckp(i / 6, hsv((i / 6) % 1, 1, 1))
	end
	mk("UIGradient", { Rotation = 90, Color = cseq(hk), Parent = hb })
	local hm = marker(hb)
	local ab = mk("TextButton", { Position = ofs(321, 12), Size = ofs(39, 243), Parent = bd })
	checker(ab)
	local af = mk("Frame", { Size = scl(1, 1), Parent = ab })
	mk("UIGradient", { Rotation = 90, Transparency = nseq(0, 1), Parent = af })
	local am = marker(ab)
	local hx = mk("TextBox", { Position = ofs(12, 263), Size = ofs(248, 33), BackgroundTransparency = 0, Parent = bd }, { BackgroundColor3 = "ctl" })
	pad(hx, 10, 10, 0, 0)
	local pv = mk("Frame", { Position = ofs(321, 263), Size = ofs(39, 33), BackgroundTransparency = 1, ClipsDescendants = true, Parent = bd })
	checker(pv)
	local pc = mk("Frame", { Size = scl(1, 1), Parent = pv })
	e.pu = function()
		sv.BackgroundColor3 = hsv(e.h, 1, 1)
		cur.Position = scl(e.s, 1 - e.v)
		hm.Position = scl(0, e.h)
		af.BackgroundColor3 = e.val
		am.Position = scl(0, 1 - e.a)
		pc.BackgroundColor3 = e.val
		pc.BackgroundTransparency = 1 - e.a
		if not hx:IsFocused() then
			hx.Text = hex(e.val, e.a)
		end
	end
	local function drg(b, fn)
		con(b.InputBegan, function(i)
			local t = i.UserInputType
			if isptr(t) then
				fn(t == tch and ipos(i) or mpos())
				startdrag(fn, nil, p, i)
			end
		end)
	end
	drg(sv, function(m)
		local a, s = sv.AbsolutePosition, sv.AbsoluteSize
		e:sethsv(e.h, clamp((m.X - a.X) / s.X, 0, 1), 1 - clamp((m.Y - a.Y) / s.Y, 0, 1))
	end)
	drg(hb, function(m)
		local a, s = hb.AbsolutePosition, hb.AbsoluteSize
		e:sethsv(clamp((m.Y - a.Y) / s.Y, 0, 0.9999), e.s, e.v)
	end)
	drg(ab, function(m)
		local a, s = ab.AbsolutePosition, ab.AbsoluteSize
		e:sethsv(e.h, e.s, e.v, 1 - clamp((m.Y - a.Y) / s.Y, 0, 1))
	end)
	con(hx.FocusLost, function()
		local c, a = unhex(hx.Text)
		if c then
			e:set(c, a)
		end
		if e.pu then
			e.pu()
		end
	end)
	p.onclose = function()
		e.pu = nil
		e.pp = nil
	end
	e.pu()
	local mp = mpos()
	openpop(p, mp.X + 4, mp.Y + 4)
end

local kbd = setmetatable({}, elm)
kbd.__index = kbd

function cont:keybind(o)
	o = o or {}
	local e = newel(kbd, self, o, "kbd")
	local d = o.default
	if typeof(d) == "EnumItem" then
		d = d.Name
	end
	if d == "None" then
		d = nil
	end
	e.val = d
	local r = self:row(37)
	e.row = r
	local b
	if e.name ~= "" then
		e.lbl = mk("TextLabel", { Size = ud2(1, -143, 1, 0), Text = e.name, Parent = r })
		b = mk("TextButton", {
			AnchorPoint = v2(1, 0.5),
			Position = scl(1, 0.5),
			Size = ofs(o.w or 133, 37),
			BackgroundTransparency = 0,
			Parent = r,
		}, { BackgroundColor3 = "drop" })
	else
		b = mk("TextButton", { Size = scl(1, 1), BackgroundTransparency = 0, Parent = r }, { BackgroundColor3 = "ctl" })
	end
	corner(b, 3)
	e.b = b
	local bk = e.name ~= "" and "drop" or "ctl"
	local hk = e.name ~= "" and "droph" or "ctlh"
	hover(b, self.pop, function()
		if not e.dis then
			tw(b, { BackgroundColor3 = thm[hk] }, 0.1)
		end
	end, function()
		tw(b, { BackgroundColor3 = thm[bk] }, 0.1)
	end)
	con(b.MouseButton1Click, function()
		if st.eat ~= e and not e.dis then
			e:listen()
		end
	end)
	con(b.MouseButton2Click, function()
		if st.eat ~= e and not e.dis and not o.nonone then
			e:setkey(nil)
		end
	end)
	if d and not e.tmp then
		bmapadd(e, d)
	end
	e:draw()
	reg(e)
	return e
end

function kbd:listen()
	local l = st.listen
	if l and l ~= self then
		l.lst = false
		l:draw()
	end
	st.listen = self
	self.lst = true
	self:draw()
end

function kbd:setkey(k, nocb)
	self.lst = false
	if st.listen == self then
		st.listen = nil
	end
	if k == nil and self.o.nonone then
		self:draw()
		return self
	end
	if k == self.val then
		self:draw()
		return self
	end
	if self.val and not self.tmp then
		bmapdel(self, self.val)
	end
	self.val = k
	if k and not self.tmp then
		bmapadd(self, k)
	end
	self:draw()
	self:fire(nocb)
	return self
end

function kbd:set(k)
	return self:setkey(k)
end

function kbd:ser()
	return self.val or "None"
end

function kbd:unser(v)
	if v == "None" then
		return nil
	end
	return v
end

function kbd:load(v)
	if v == nil or v == "None" then
		self:setkey(nil)
	elseif type(v) == "string" then
		self:setkey(v)
	end
end

function kbd:bdown()
	local f = self.o.onpress
	if f and not self.dis then
		spawn(f, self.val)
	end
end

function kbd:bup()
	local f = self.o.onrelease
	if f and not self.dis then
		spawn(f, self.val)
	end
end

function kbd:down()
	local k = self.val
	if not k then
		return false
	end
	if k == "MouseButton1" or k == "MouseButton2" or k == "MouseButton3" then
		return uis:IsMouseButtonPressed(Enum.UserInputType[k])
	end
	local ok, kc = pcall(function()
		return Enum.KeyCode[k]
	end)
	return ok and uis:IsKeyDown(kc) or false
end

function kbd:draw()
	local b = self.b
	b.Text = self.lst and "..." or (kname(self.val) or "None")
	tw(b, { TextColor3 = self.dis and thm.dim or (self.lst and thm.acc or thm.txt) }, 0.12)
	if self.lbl then
		tw(self.lbl, { TextColor3 = self.dis and thm.dim or thm.txt }, 0.12)
	end
end

local inp = setmetatable({}, elm)
inp.__index = inp

function cont:input(o)
	o = o or {}
	local e = newel(inp, self, o, "inp")
	e.val = tostring(o.default or "")
	local r = self:row(37)
	e.row = r
	local b = mk("TextBox", {
		Size = scl(1, 1),
		BackgroundTransparency = 0,
		Text = e.val,
		PlaceholderText = o.placeholder or "",
		Parent = r,
	}, { BackgroundColor3 = "ctl", PlaceholderColor3 = "dim" })
	pad(b, 10, 10, 0, 0)
	local ul = mk("Frame", { AnchorPoint = v2(0.5, 1), Position = scl(0.5, 1), Size = ud2(0, 0, 0, 2), ZIndex = 2, Parent = r }, { BackgroundColor3 = "acc" })
	e.b, e.ul = b, ul
	hover(b, self.pop, function()
		if not e.dis then
			tw(b, { BackgroundColor3 = thm.ctlh }, 0.1)
		end
	end, function()
		tw(b, { BackgroundColor3 = thm.ctl }, 0.1)
	end)
	con(b.Focused, function()
		tw(ul, { Size = ud2(1, 0, 0, 2) }, 0.16)
	end)
	con(b.FocusLost, function(ent)
		tw(ul, { Size = ud2(0, 0, 0, 2) }, 0.16)
		e:set(b.Text)
		if ent and o.onenter then
			spawn(o.onenter, e.val)
		end
	end)
	if o.live then
		con(b:GetPropertyChangedSignal("Text"), function()
			if b:IsFocused() and b.Text ~= e.val then
				e.val = b.Text
				e:fire()
			end
		end)
	end
	e:draw()
	reg(e)
	return e
end

function inp:set(v, nocb)
	v = tostring(v or "")
	local m = self.o.max
	if m then
		v = ssub(v, 1, m)
	end
	if self.b.Text ~= v then
		self.b.Text = v
	end
	if v == self.val then
		return self
	end
	self.val = v
	self:fire(nocb)
	return self
end

function inp:load(v)
	if type(v) == "string" then
		self:set(v)
	end
end

function inp:draw()
	self.b.TextColor3 = self.dis and thm.dim or thm.txt
	self.b.TextEditable = not self.dis
end

function inp:focus()
	self.b:CaptureFocus()
	return self
end

local btn = setmetatable({}, elm)
btn.__index = btn

function cont:button(o)
	o = o or {}
	local e = newel(btn, self, o, "btn")
	local r = self:row(o.h or 37)
	e.row = r
	local b = mk("TextButton", {
		Size = o.w and ud2(0, o.w, 1, 0) or scl(1, 1),
		BackgroundTransparency = 0,
		TextXAlignment = xal.Center,
		Text = e.name,
		Parent = r,
	}, { BackgroundColor3 = "ctl" })
	corner(b, 3)
	e.b = b
	hover(b, self.pop, function()
		if not e.dis then
			tw(b, { BackgroundColor3 = thm.ctlh }, 0.1)
		end
	end, function()
		tw(b, { BackgroundColor3 = thm.ctl }, 0.1)
	end)
	con(b.MouseButton1Click, function()
		if not e.dis and e.cb then
			spawn(e.cb)
		end
	end)
	e:draw()
	return e
end

function btn:draw()
	self.b.TextColor3 = self.dis and thm.dim or thm.txt
end

function btn:press()
	if self.cb then
		spawn(self.cb)
	end
end

local lbl = setmetatable({}, elm)
lbl.__index = lbl

function cont:label(o)
	if type(o) == "string" then
		o = { text = o }
	end
	o = o or {}
	local e = newel(lbl, self, o, "lbl")
	local r = self:row(o.h or 24)
	e.row = r
	e.l = mk("TextLabel", {
		Size = scl(1, 1),
		TextWrapped = true,
		RichText = o.rich == true,
		TextXAlignment = o.center and xal.Center or xal.Left,
		Text = e.name,
		Parent = r,
	}, { TextColor3 = o.bright and "txt" or "dim" })
	return e
end

function lbl:settext(s)
	self.name = tostring(s or "")
	self.l.Text = self.name
	return self
end

local img = setmetatable({}, elm)
img.__index = img

function cont:image(o)
	o = o or {}
	local e = newel(img, self, o, "img")
	local r = self:row(o.h or 300)
	e.row = r
	local pn = mk("Frame", { Size = scl(1, 1), Parent = r }, { BackgroundColor3 = "panel" })
	corner(pn, 3)
	e.i = mk("ImageLabel", { Position = ofs(8, 8), Size = ud2(1, -16, 1, -16), Image = icon(o.image), Parent = pn })
	return e
end

function img:set(id)
	self.i.Image = icon(id)
	return self
end

function cont:subtabs(names, o)
	o = o or {}
	local r = self:row(46)
	local n = #names
	local pages, bs = table.create(n), table.create(n)
	local cur = o.default or 1
	for i = 1, n do
		local f = n > 1 and (i - 1) / (n - 1) or 0
		local b = mk("TextButton", { AnchorPoint = v2(f, 0.5), Position = scl(f, 0.5), Size = ofs(0, 30), AutomaticSize = aix, Text = names[i], Parent = r })
		bs[i] = b
		self.n += 1
		local pf = mk("Frame", { BackgroundTransparency = 1, Size = ud2(1, 0, 0, 0), AutomaticSize = aiy, LayoutOrder = self.n, Parent = self.frame })
		vlist(pf, 6)
		local pc = newcont(pf, self.tab, self.pop)
		pc.tmp = self.tmp
		pages[i] = pc
		con(b.MouseButton1Click, function()
			if cur ~= i then
				cur = i
				pagesw(bs, pages, cur, true)
				if o.cb then
					spawn(o.cb, i, names[i])
				end
			end
		end)
		tabhov(b, self.pop, function()
			return cur == i
		end)
	end
	pagesw(bs, pages, cur, false)
	return pages
end

local splcls = {}
splcls.__index = splcls

function cont:split()
	local r = self:row(31)
	return setmetatable({
		c = self,
		i = 0,
		h = {
			mk("Frame", { BackgroundTransparency = 1, Size = scl(0.5, 1), Parent = r }),
			mk("Frame", { BackgroundTransparency = 1, Position = scl(0.5, 0), Size = scl(0.5, 1), Parent = r }),
		},
	}, splcls)
end

function splcls:toggle(o)
	self.i = min(self.i + 1, 2)
	return self.c:toggle(o, self.h[self.i])
end

ctxopen = function(e)
	if e.tmp or e.dead or st.dead or st.eat then
		return
	end
	local p = newpop({ w = 300, tmp = true, par = e.c and e.c.pop })
	local c = p.c
	local ind, bnd = e.ind, e.bnd
	c:header(e.name)
	local ti = c:toggle({
		name = "Indicator",
		default = ind.on,
		cb = function(v)
			ind.on = v
			hudupd(e)
		end,
	})
	ti:color({
		default = ind.col,
		cb = function(v)
			ind.col = v
			hudupd(e)
		end,
	})
	c:input({
		placeholder = "Indicator name...",
		default = ind.name,
		cb = function(v)
			ind.name = v
			hudupd(e)
		end,
	})
	if e.kind == "sld" then
		c:toggle({
			name = "Show value",
			default = ind.sv,
			cb = function(v)
				ind.sv = v
				hudupd(e)
			end,
		})
	end
	local bvs
	c:keybind({
		name = "Bind",
		default = bnd.key,
		cb = function(k)
			if k and not bnd.key and bvs and bnd.v == e.val then
				e:setbv(e.val >= e.max and e.min or e.max)
				bvs:set(bnd.v, true)
			end
			e:setbind(k)
		end,
	})
	c:dropdown({
		name = "Mode",
		values = { "Toggle", "Hold" },
		default = bnd.mode == "hold" and "Hold" or "Toggle",
		cb = function(v)
			e:setbind(bnd.key, v == "Hold" and "hold" or "toggle")
		end,
	})
	if e.kind == "sld" then
		bvs = c:slider({
			name = "Bind value",
			min = e.min,
			max = e.max,
			dec = e.dec,
			step = e.step,
			suffix = e.suf,
			zero = e.zero,
			fmt = e.o.fmt,
			default = bnd.v,
			cb = function(v)
				e:setbv(v)
			end,
		})
	end
	c:button({
		name = "Clear",
		cb = function()
			closepop(p)
			e:setbind(nil)
			ind.on = false
			ind.name = ""
			hudupd(e)
		end,
	})
	local mp = mpos()
	openpop(p, mp.X + 2, mp.Y + 2)
end

local function hudlbl(lo)
	return mk("TextLabel", {
		Size = ofs(0, 0),
		AutomaticSize = aixy,
		FontFace = fnt.b,
		TextSize = hud.size,
		TextStrokeTransparency = hud.stroke and 0.35 or 1,
		TextStrokeColor3 = black,
		LayoutOrder = lo,
		Visible = false,
		Parent = hud.f,
	})
end

hudupd = function(e)
	if not hud.f then
		return
	end
	local ind = e.ind
	local show = hud.on and ind.on and not e.dead and not e.dis
	if show then
		if e.kind == "tgl" then
			show = e:eff()
		else
			show = e.bnd.key == nil or e.bnd.act
		end
	end
	local l = e.hl
	if not show then
		if l and e.hs then
			e.hs = false
			pfade(l, { { l, { TextTransparency = 0, TextStrokeTransparency = hud.stroke and 0.35 or 1 } } }, false)
		end
		return
	end
	if not l then
		l = hudlbl(e.id)
		e.hl = l
	end
	local s = ind.name ~= "" and ind.name or e.name
	if e.kind == "sld" and ind.sv then
		s ..= " " .. e:fmtv(e:eff())
	end
	l.Text = s
	l.TextColor3 = ind.col
	if not e.hs then
		e.hs = true
		pfade(l, { { l, { TextTransparency = 0, TextStrokeTransparency = hud.stroke and 0.35 or 1 } } }, true)
	end
end

local function hudall()
	local els = lib.els
	for i = 1, #els do
		local e = els[i]
		if e.ind then
			hudupd(e)
		end
	end
end

local function hudstyle()
	local f = hud.f
	if not f then
		return
	end
	hud.ll.Padding = ud(0, hud.gap)
	local ch = f:GetChildren()
	for i = 1, #ch do
		local l = ch[i]
		if l:IsA("TextLabel") then
			l.TextSize = hud.size
			if l.Visible then
				l.TextStrokeTransparency = hud.stroke and 0.35 or 1
			end
		end
	end
end

local function gradline(par, h, sp)
	local gl = mk("Frame", { BackgroundTransparency = 1, Size = ud2(1, 0, 0, h), ClipsDescendants = true, ZIndex = 6, Parent = par })
	local gb = mk("Frame", { Size = ud2(6, 0, 1, 0), BackgroundColor3 = white, ZIndex = 6, Parent = gl })
	local kp = table.create(13)
	for i = 0, 12 do
		kp[i + 1] = ckp(i / 12, hsv((1 - (i % 6) / 6) % 1, st.gsat or 0.72, 1))
	end
	mk("UIGradient", { Color = cseq(kp), Parent = gb })
	local gt = ts:Create(gb, TweenInfo.new(sp or st.gspd or 10, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1), { Position = ud2(-3, 0, 0, 0) })
	gt:Play()
	st.md:add(function()
		gt:Cancel()
	end)
	mk("Frame", { Position = ofs(0, h), Size = ud2(1, 0, 0, 1), ZIndex = 6, Parent = par }, { BackgroundColor3 = "edge" })
	return gl
end

local function wmupd()
	local l = wm.l
	if not l or not wm.on then
		return
	end
	local sp = sfmt('  <font color="%s">|</font>  ', hex(thm.dim))
	local s = sfmt('<font color="%s">%s</font>%s', hex(thm.acc), esc(st.t1 or ""), esc(st.t2 or ""))
	local sh = wm.show
	if wm.text ~= "" then
		s ..= sp .. esc(wm.text)
	end
	if tfind(sh, "Name") then
		s ..= sp .. esc(lp and lp.Name or "")
	end
	if tfind(sh, "FPS") then
		s ..= sp .. (st.fps or 0) .. " fps"
	end
	if tfind(sh, "Ping") then
		local ok, p = pcall(lp.GetNetworkPing, lp)
		s ..= sp .. floor((ok and p or 0) * 1000 + 0.5) .. " ms"
	end
	if tfind(sh, "Time") then
		s ..= sp .. os.date("%H:%M:%S")
	end
	l.Text = s
end

local function wmstyle()
	local f = wm.f
	if not f then
		return
	end
	wmupd()
	pfade(f, wm.parts, wm.on)
end

function lib:notify(s, t)
	local lf = st.logs
	if not lf or st.dead then
		return
	end
	st.ln += 1
	local l = mk("TextLabel", {
		Size = ofs(0, 20),
		AutomaticSize = aix,
		RichText = true,
		FontFace = fnt.b,
		TextSize = 15,
		TextTransparency = 1,
		TextStrokeTransparency = 1,
		TextStrokeColor3 = black,
		LayoutOrder = st.ln,
		Parent = lf,
	})
	l.Text = sfmt('<font color="%s">%s</font>  %s', hex(thm.acc), esc(st.title or "memesense"), esc(tostring(s)))
	tw(l, { TextTransparency = 0, TextStrokeTransparency = 0.45 }, 0.2)
	local ch = lf:GetChildren()
	local n, old, ol = 0, nil, math.huge
	for i = 1, #ch do
		local x = ch[i]
		if x:IsA("TextLabel") then
			n += 1
			if x.LayoutOrder < ol then
				ol, old = x.LayoutOrder, x
			end
		end
	end
	if n > 7 and old then
		old:Destroy()
	end
	delay(t or 3, function()
		if not l.Parent then
			return
		end
		tw(l, { TextTransparency = 1, TextStrokeTransparency = 1 }, 0.3)
		delay(0.3, function()
			if l.Parent then
				l:Destroy()
			end
		end)
	end)
end

local pagecls = {}
pagecls.__index = pagecls

local function newpage(f, tab, y0)
	return setmetatable({ frame = f, tab = tab, y0 = y0 or 0, sn = 0 }, pagecls)
end

function pagecls:cols()
	if self.cl then
		return self.cl, self.cr
	end
	local y = self.y0
	local function col(x)
		local s = mk("ScrollingFrame", { Position = ofs(x, y), Size = ud2(0, 317, 1, -y), Parent = self.frame })
		pad(s, 0, 0, 13, 14)
		vlist(s, 10)
		return s
	end
	self.cl, self.cr = col(38), col(393)
	return self.cl, self.cr
end

function pagecls:section(o)
	if type(o) == "string" then
		o = { name = o }
	end
	o = o or {}
	local l, r = self:cols()
	self.sn += 1
	local f = mk("Frame", {
		BackgroundTransparency = 1,
		Size = ud2(1, 0, 0, 0),
		AutomaticSize = aiy,
		LayoutOrder = self.sn,
		Parent = (o.side == 2 or o.side == "right") and r or l,
	})
	vlist(f, 6)
	local c = newcont(f, self.tab)
	if o.name then
		c:header(o.name)
	end
	return c
end

function pagecls:tabbar(names, o)
	o = o or {}
	local y = self.y0
	local bar = mk("Frame", { BackgroundTransparency = 1, Position = ofs(38, y), Size = ud2(1, -76, 0, 56), Parent = self.frame })
	mk("Frame", { Position = ofs(0, 55), Size = ud2(1, 0, 0, 1), Parent = bar }, { BackgroundColor3 = "sep" })
	local n = #names
	local cur = o.default or 1
	local pages, bs = table.create(n), table.create(n)
	for i = 1, n do
		local f = n > 1 and (i - 1) / (n - 1) or 0
		local b = mk("TextButton", { AnchorPoint = v2(f, 0.5), Position = ud2(f, 0, 0, 27), Size = ofs(0, 34), AutomaticSize = aix, Text = names[i], Parent = bar })
		bs[i] = b
		local pf = mk("Frame", { BackgroundTransparency = 1, Size = scl(1, 1), Parent = self.frame })
		pages[i] = newpage(pf, self.tab, y + 56)
		con(b.MouseButton1Click, function()
			if cur ~= i then
				cur = i
				closeall()
				pagesw(bs, pages, cur, true)
				if o.cb then
					spawn(o.cb, i, names[i])
				end
			end
		end)
		tabhov(b, nil, function()
			return cur == i
		end)
	end
	pagesw(bs, pages, cur, false)
	return pages
end

local gridcls = {}
gridcls.__index = gridcls

function pagecls:grid(o)
	o = o or {}
	local y = self.y0 + 22
	local sf = mk("ScrollingFrame", { Position = ofs(38, y), Size = ud2(1, -76, 1, -y), Parent = self.frame })
	mk("UIGridLayout", {
		CellSize = ofs(o.cw or 157, o.ch or 170),
		CellPadding = ofs(14, 14),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = sf,
	})
	pad(sf, 0, 0, 0, 16)
	return setmetatable({ sf = sf, n = 0, cards = {} }, gridcls)
end

local function hov(b, a, c)
	hover(b, nil, function()
		tw(b, { BackgroundColor3 = thm[c] }, 0.1)
	end, function()
		tw(b, { BackgroundColor3 = thm[a] }, 0.1)
	end)
end

function gridcls:add(o)
	o = o or {}
	self.n += 1
	local b = mk("TextButton", { BackgroundTransparency = 0, LayoutOrder = o.order or self.n, Parent = self.sf }, { BackgroundColor3 = "ctl" })
	corner(b, 3)
	local c = mk("Frame", { AnchorPoint = v2(0.5, 0.5), Position = scl(0.5, 0.5), Size = ofs(48, 48), Parent = b }, { BackgroundColor3 = "plus" })
	pill(c)
	mk("ImageLabel", { AnchorPoint = v2(0.5, 0.5), Position = scl(0.5, 0.5), Size = ofs(24, 24), Image = icon("plus"), Parent = c }, { ImageColor3 = "txt" })
	hov(b, "ctl", "ctlh")
	con(b.MouseButton1Click, function()
		if o.cb then
			spawn(o.cb)
		end
	end)
	self.plus = b
	return b
end

local cardcls = {}
cardcls.__index = cardcls

function gridcls:card(o)
	o = o or {}
	self.n += 1
	local b = mk("TextButton", { BackgroundTransparency = 0, LayoutOrder = o.order or self.n, Parent = self.sf }, { BackgroundColor3 = "card" })
	corner(b, 3)
	local cd = setmetatable({ g = self, o = o }, cardcls)
	cd.b = b
	cd.i = mk("ImageLabel", { Position = ofs(10, 8), Size = ud2(1, -20, 1, -48), Image = icon(o.image), Parent = b })
	cd.t = mk("TextLabel", {
		Position = ud2(0, 10, 1, -34),
		Size = ud2(1, -20, 0, 22),
		FontFace = fnt.b,
		TextSize = 14,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Text = o.name or "",
		Parent = b,
	})
	cd.bar = mk("Frame", { AnchorPoint = v2(0, 1), Position = scl(0, 1), Size = ud2(1, 0, 0, 3), BackgroundColor3 = o.color or thm.acc, Parent = b })
	hov(b, "card", "cardh")
	con(b.MouseButton1Click, function()
		if o.cb then
			spawn(o.cb, cd)
		end
	end)
	con(b.MouseButton2Click, function()
		if o.rcb then
			spawn(o.rcb, cd)
		end
	end)
	local cs = self.cards
	cs[#cs + 1] = cd
	return cd
end

function cardcls:set(o)
	if o.name then
		self.t.Text = o.name
	end
	if o.image then
		self.i.Image = icon(o.image)
	end
	if o.color then
		self.bar.BackgroundColor3 = o.color
	end
	return self
end

function cardcls:destroy()
	local cs = self.g.cards
	local i = tfind(cs, self)
	if i then
		tremove(cs, i)
	end
	self.b:Destroy()
end

function gridcls:clear()
	local cs = self.cards
	for i = #cs, 1, -1 do
		cs[i].b:Destroy()
		cs[i] = nil
	end
end

local function mkbtn(par, ic, name, lo, bk, hk)
	bk = bk or "drop"
	local b = mk("TextButton", { Size = ofs(0, 37), AutomaticSize = aix, BackgroundTransparency = 0, LayoutOrder = lo or 0, Parent = par }, { BackgroundColor3 = bk })
	corner(b, 3)
	pad(b, 12, 15, 0, 0)
	hlist(b, 9)
	if ic then
		mk("ImageLabel", { Size = ofs(20, 20), Image = icon(ic), LayoutOrder = 1, Parent = b }, { ImageColor3 = "txt" })
	end
	mk("TextLabel", { Size = ofs(0, 37), AutomaticSize = aix, LayoutOrder = 2, Text = name or "", Parent = b })
	hov(b, bk, hk or "droph")
	return b
end

local tabcls = setmetatable({}, pagecls)
tabcls.__index = tabcls

function tabcls:navdraw()
	local on = self.win.cur == self
	local p = self.prs
	local hl = on or p
	tw(self.nb, { BackgroundTransparency = hl and 0 or 1, BackgroundColor3 = p and thm.navp or thm.nav }, 0.12)
	tw(self.ni, { ImageColor3 = hl and thm.acc or thm.txt }, 0.12)
	tw(self.nbar, { Size = ud2(0, 3, hl and 1 or 0, 0) }, 0.16)
end

function tabcls:tbc()
	local c = self.tbcont
	if not c then
		c = newcont(self.tbl, nil, nil)
		self.tbcont = c
	end
	return c
end

function tabcls:master(o)
	o = o or {}
	o.name = o.name or "Master switch"
	o.auto = true
	o.noprof = true
	self.tn += 1
	local r = mk("Frame", { BackgroundTransparency = 1, Size = ofs(0, 37), AutomaticSize = aix, LayoutOrder = self.tn, Parent = self.tbl })
	local e = self:tbc():toggle(o, r)
	self.ms = e
	return e
end

function tabcls:gear(o)
	o = o or {}
	self.tn += 1
	local b = mk("ImageButton", { Size = ofs(22, 22), Image = icon(o.icon or "gear"), LayoutOrder = self.tn, Parent = self.tbl }, { ImageColor3 = "txt" })
	local p = newpop({ w = o.w or 300, keep = true, anchor = b, tab = o.prof and self or nil })
	con(b.MouseButton1Click, function()
		popflip(p)
	end)
	return p.c, b
end

function tabcls:tbdrop(o)
	o = o or {}
	o.noprof = true
	self.tn += 1
	o.par = self.tbl
	o.lo = self.tn
	o.w = o.w or 158
	return self:tbc():dropdown(o)
end

function tabcls:tbbtn(o)
	o = o or {}
	self.tn += 1
	local b = mkbtn(self.tbl, o.icon, o.name, self.tn)
	if o.pop then
		local p = newpop({ w = o.w or 300, keep = true, anchor = b, tab = o.prof and self or nil })
		con(b.MouseButton1Click, function()
			popflip(p)
		end)
		return p.c, b, p
	end
	con(b.MouseButton1Click, function()
		if o.cb then
			spawn(o.cb)
		end
	end)
	return b
end

function tabcls:savebtn()
	local b = mkbtn(self.tb, "save", "Save")
	b.AnchorPoint = v2(1, 0.5)
	b.Position = ud2(1, -36, 0.5, 0)
	con(b.MouseButton1Click, function()
		lib:save()
	end)
	self.sb = b
	return b
end

local profcls = {}
profcls.__index = profcls

function tabcls:profile(o)
	o = o or {}
	local p = setmetatable({
		tab = self,
		items = o.items or {},
		modes = o.modes or { "Global", "Per weapons" },
		data = {},
		els = {},
		id = o.id or o.flag or self.name,
	}, profcls)
	p.mode = o.mode or p.modes[#p.modes]
	p.cur = o.default or p.items[1]
	self.prof = p
	p.mdd = self:tbdrop({
		values = p.modes,
		default = p.mode,
		w = o.w or 158,
		cb = function(v)
			p:setmode(v)
		end,
	})
	p.idd = self:tbdrop({
		values = p.items,
		default = p.cur,
		w = o.w2 or o.w or 158,
		cb = function(v)
			p:select(v)
		end,
	})
	p.idd.btn.Visible = p.mode ~= p.modes[1]
	lib.profs[#lib.profs + 1] = p
	return p
end

function profcls:key()
	if self.mode == self.modes[1] then
		return "__global"
	end
	return tostring(self.cur)
end

function profcls:store()
	local k = self:key()
	local d = self.data[k]
	if not d then
		d = {}
		self.data[k] = d
	end
	local els = self.els
	for i = 1, #els do
		local e = els[i]
		d[e.flag] = e:ser()
	end
end

function profcls:apply()
	local d = self.data[self:key()]
	local els = self.els
	for i = 1, #els do
		local e = els[i]
		local v = d and d[e.flag]
		if v == nil then
			v = e.def
		end
		e:load(v)
	end
	if self.cb then
		spawn(self.cb, self.mode, self.cur)
	end
end

function profcls:select(v)
	if v == self.cur then
		return
	end
	self:store()
	self.cur = v
	if self.idd.val ~= v then
		self.idd:set(v, true)
	end
	self:apply()
end

function profcls:setmode(v)
	if v == self.mode then
		return
	end
	self:store()
	self.mode = v
	if self.mdd.val ~= v then
		self.mdd:set(v, true)
	end
	self.idd.btn.Visible = v ~= self.modes[1]
	self:apply()
end

function profcls:get(flag, item)
	local e = lib.fl[flag]
	if self.mode == self.modes[1] or item == nil or item == self.cur then
		return lib.flags[flag]
	end
	local d = self.data[tostring(item)]
	local v = d and d[flag]
	if v == nil then
		v = e and e.def
	end
	if e then
		v = e:unser(v)
	end
	return v
end

function profcls:ser()
	self:store()
	return { mode = self.mode, cur = self.cur, data = self.data }
end

function profcls:load(t)
	if type(t) ~= "table" then
		return
	end
	self.data = type(t.data) == "table" and t.data or {}
	if t.mode ~= nil and tfind(self.modes, t.mode) then
		self.mode = t.mode
		self.mdd:set(t.mode, true)
	end
	if t.cur ~= nil and tfind(self.items, t.cur) then
		self.cur = t.cur
		self.idd:set(t.cur, true)
	end
	self.idd.btn.Visible = self.mode ~= self.modes[1]
	self:apply()
end

local cfgref = function() end

local function cdir()
	return lib.dir .. "/configs"
end

local function cpath(n)
	return cdir() .. "/" .. n .. ".json"
end

local function cname(n)
	n = sgsub(tostring(n or ""), '[\\/:%*%?"<>|]', "")
	n = smatch(n, "^%s*(.-)%s*$") or ""
	return ssub(n, 1, 40)
end

local function now()
	return os.date("%Y/%m/%d %H:%M:%S")
end

local function snap()
	local d = { flags = {}, binds = {}, inds = {}, profs = {} }
	local ps = lib.profs
	for i = 1, #ps do
		local p = ps[i]
		d.profs[p.id] = p:ser()
	end
	local els = lib.els
	for i = 1, #els do
		local e = els[i]
		local f = e.flag
		if f and not e.o.nocfg then
			if not e.prof then
				d.flags[f] = e:ser()
			end
			local b = e.bnd
			if b and (b.key or (e.kind == "sld" and b.v ~= e.val)) then
				d.binds[f] = { k = b.key, m = b.mode, v = b.v }
			end
			local n = e.ind
			if n and (n.on or n.name ~= "") then
				d.inds[f] = { on = n.on, n = n.name, c = hex(n.col), v = n.sv }
			end
		end
	end
	local hf = hud.hf
	if hf then
		d.hud = { x = hf.Position.X.Offset, y = hf.Position.Y.Offset }
	end
	local wf = wm.f
	if wf then
		local p = wf.Position
		d.wm = { xs = p.X.Scale, xo = p.X.Offset, ys = p.Y.Scale, yo = p.Y.Offset }
	end
	return d
end

local function applysnap(d)
	if type(d) ~= "table" then
		return false
	end
	local fl = type(d.flags) == "table" and d.flags or {}
	local bs = type(d.binds) == "table" and d.binds or {}
	local ns = type(d.inds) == "table" and d.inds or {}
	local ps = type(d.profs) == "table" and d.profs or {}
	local els = lib.els
	for i = 1, #els do
		local e = els[i]
		local f = e.flag
		if f and not e.o.nocfg then
			if not e.prof then
				local v = fl[f]
				if v == nil then
					v = e.def
				end
				e:load(v)
			end
			local b = e.bnd
			if b then
				local x = bs[f]
				local k, m = nil, nil
				if type(x) == "table" then
					k = type(x.k) == "string" and x.k or nil
					m = (x.m == "hold" or x.m == "toggle") and x.m or nil
					if e.kind == "sld" and type(x.v) == "number" then
						b.v = e:rnd(x.v)
					end
				elseif e.kind == "sld" then
					b.v = e.val
				end
				if b.key ~= k or (m and b.mode ~= m) then
					e:setbind(k, m)
				end
			end
			local n = e.ind
			if n then
				local x = ns[f]
				if type(x) == "table" then
					n.on = x.on == true
					n.name = type(x.n) == "string" and x.n or ""
					n.col = unhex(x.c) or white
					if x.v ~= nil then
						n.sv = x.v == true
					end
				else
					n.on = false
					n.name = ""
					n.col = white
				end
				hudupd(e)
			end
		end
	end
	local pl = lib.profs
	for i = 1, #pl do
		local p = pl[i]
		local x = ps[p.id]
		if type(x) == "table" then
			p:load(x)
		else
			p.data = {}
			p:apply()
		end
	end
	local h = d.hud
	if type(h) == "table" and hud.hf and tonumber(h.x) and tonumber(h.y) then
		hud.hf.Position = ofs(tonumber(h.x), tonumber(h.y))
	end
	local w = d.wm
	if type(w) == "table" and wm.f and tonumber(w.xs) and tonumber(w.xo) and tonumber(w.ys) and tonumber(w.yo) then
		wm.f.Position = ud2(tonumber(w.xs), tonumber(w.xo), tonumber(w.ys), tonumber(w.yo))
	end
	return true
end

local function writecfg(n, d)
	local s = jenc({ meta = { name = n, modified = now(), ver = lib.ver }, data = d })
	return s ~= nil and fs.write(cpath(n), s)
end

local function setcur(n)
	st.cfg = n
	fs.write(lib.dir .. "/last.txt", n or "")
end

local function decode(s)
	if type(s) ~= "string" or s == "" then
		return nil
	end
	local d = jdec(s)
	if not d then
		local ok, r = pcall(b64d, s)
		if ok then
			d = jdec(r)
		end
	end
	if d and type(d.data) == "table" then
		return d.data
	end
	return d
end

function lib:export()
	return jenc({ meta = { name = st.cfg or "shared", modified = now(), ver = lib.ver }, data = snap() })
end

function lib:share()
	local s = self:export()
	return s and b64e(s) or nil
end

function lib:import(s)
	local d = decode(s)
	if not d then
		return false
	end
	return applysnap(d)
end

function lib:save(n)
	n = cname(n or st.cfg or "default")
	if n == "" then
		n = "default"
	end
	if writecfg(n, snap()) then
		setcur(n)
		self:notify("Config saved")
		cfgref()
		return true
	end
	return false
end

function lib:load(n)
	n = cname(n)
	local d = decode(fs.read(cpath(n)))
	if not d then
		return false
	end
	applysnap(d)
	setcur(n)
	self:notify("Config loaded")
	cfgref()
	return true
end

function lib:create(n, code)
	n = cname(n)
	if n == "" then
		self:notify("Enter a name")
		return false
	end
	if fs.has(cpath(n)) then
		self:notify("Config already exists")
		return false
	end
	if code and code ~= "" then
		local d = decode(code)
		if not d then
			self:notify("Invalid share code")
			return false
		end
		applysnap(d)
	end
	writecfg(n, snap())
	setcur(n)
	self:notify("Config created")
	cfgref()
	return true
end

function lib:delete(n)
	n = cname(n)
	fs.del(cpath(n))
	if st.cfg == n then
		setcur(nil)
	end
	self:notify("Config deleted")
	cfgref()
end

function lib:rename(a, b)
	a, b = cname(a), cname(b)
	if b == "" or a == b or fs.has(cpath(b)) then
		return false
	end
	local d = jdec(fs.read(cpath(a)))
	if not d then
		return false
	end
	if type(d.meta) == "table" then
		d.meta.name = b
	end
	local s = jenc(d)
	if not s or not fs.write(cpath(b), s) then
		return false
	end
	fs.del(cpath(a))
	if st.cfg == a then
		setcur(b)
	end
	self:notify("Config renamed")
	cfgref()
	return true
end

function lib:list()
	local out = {}
	local fl = fs.list(cdir())
	for i = 1, #fl do
		local p = fl[i]
		local n = smatch(p, "([^/\\]+)%.json$")
		if n then
			local d = jdec(fs.read(p))
			local m = d and d.meta
			out[#out + 1] = { name = n, modified = type(m) == "table" and tostring(m.modified or "") or "" }
		end
	end
	tsort(out, function(x, y)
		return string.lower(x.name) < string.lower(y.name)
	end)
	return out
end

function lib:current()
	return st.cfg
end

function lib:get(f)
	return self.flags[f]
end

function lib:set(f, v, a)
	local e = self.fl[f]
	if not e then
		return nil
	end
	if e.kind == "cpk" then
		e:set(v, a)
	else
		e:set(v)
	end
	return e
end

function lib:el(f)
	return self.fl[f]
end

function lib:onunload(f)
	st.unl[#st.unl + 1] = f
end

local thp = { "BackgroundColor3", "TextColor3", "ImageColor3", "Color", "PlaceholderColor3", "ScrollBarImageColor3" }
local tha = {}
for i = 1, #thp do
	tha[i] = "t_" .. thp[i]
end

local function relogo()
	local l = st.logo
	if l then
		l.Text = sfmt('<font color="%s">%s</font>%s', hex(thm.acc), esc(st.t1), esc(st.t2))
	end
end

local function redrawall()
	local els = lib.els
	for i = 1, #els do
		els[i]:draw()
	end
	local w = st.win
	if w then
		for i = 1, #w.tabs do
			w.tabs[i]:navdraw()
		end
	end
	relogo()
	hudall()
	cfgref()
end

function lib:settheme(k, c)
	if thm[k] == nil or typeof(c) ~= "Color3" then
		return
	end
	thm[k] = c
	local g = st.gui
	if g then
		local ds = g:GetDescendants()
		for i = 1, #ds do
			local o = ds[i]
			for j = 1, #tha do
				if o:GetAttribute(tha[j]) == k then
					o[thp[j]] = c
				end
			end
		end
	end
	redrawall()
end

local mus = { key = "MemeSense", rk = hs:GenerateGUID(false) }
local mdef = Enum.MouseBehavior.Default

local function loaded(m)
	local ok, l = pcall(getloadedmodules)
	return ok and type(l) == "table" and tfind(l, m) ~= nil
end

local function lockt()
	local t = mus.t
	if t == nil then
		t = false
		local f = rst:FindFirstChild("Controllers")
		local m = f and f:FindFirstChild("CameraController")
		if m and m:IsA("ModuleScript") and loaded(m) then
			local ok, c = pcall(require, m)
			local fn = ok and type(c) == "table" and c.isForceLockOverrideActive
			if type(fn) == "function" then
				local ok2, ups = pcall(debug.getupvalues, fn)
				if ok2 and type(ups) == "table" then
					for _, u in next, ups do
						if type(u) == "table" then
							t = u
							break
						end
					end
				end
			end
		end
		mus.t = t
	end
	return t or nil
end

local function mfree(v)
	v = v == true
	if mus.on == v then
		return
	end
	mus.on = v
	if st.modal then
		st.modal.Visible = v
	end
	local t = lockt()
	if v then
		if t then
			t[mus.key] = true
		else
			mus.mb, mus.mi = uis.MouseBehavior, uis.MouseIconEnabled
		end
		rs:BindToRenderStep(mus.rk, Enum.RenderPriority.Last.Value, function()
			if t and t[mus.key] == nil then
				t[mus.key] = true
			end
			if uis.MouseBehavior ~= mdef then
				uis.MouseBehavior = mdef
			end
			if not uis.MouseIconEnabled then
				uis.MouseIconEnabled = true
			end
		end)
		return
	end
	pcall(rs.UnbindFromRenderStep, rs, mus.rk)
	if t then
		t[mus.key] = nil
	elseif mus.mb then
		uis.MouseBehavior = mus.mb
		uis.MouseIconEnabled = mus.mi
	end
	mus.mb, mus.mi = nil, nil
end

local fti = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function fade(v)
	local root, cv = st.root, st.cv
	st.fn += 1
	local id = st.fn
	if st.ft then
		st.ft:Cancel()
		st.ft = nil
	end
	if root.Parent ~= cv then
		cv.GroupTransparency = v and 1 or 0
		root.Parent = cv
	end
	root.Visible = true
	cv.Visible = true
	cv.Interactable = v
	local t = ts:Create(cv, fti, { GroupTransparency = v and 0 or 1 })
	st.ft = t
	t.Completed:Once(function(s)
		if st.dead or st.fn ~= id or s ~= Enum.PlaybackState.Completed then
			return
		end
		st.ft = nil
		root.Visible = v
		root.Parent = st.gui
		cv.Visible = false
	end)
	t:Play()
end

local function rescale()
	local us, g = st.us, st.gui
	if not us or not g then
		return
	end
	local f = lib.flags
	local s
	if f.ms_fscale and type(f.ms_scale) == "number" then
		s = f.ms_scale
	else
		local sz = g.AbsoluteSize
		if sz.Y <= 0 then
			sz = workspace.CurrentCamera.ViewportSize
		end
		s = clamp(min((sz.Y - 40) / 767, (sz.X - 40) / 936), 0.35, 1)
	end
	if us.Scale == s then
		return
	end
	us.Scale = s
	task.defer(function()
		local ps = st.pops
		for i = 1, #ps do
			ps[i]:clampit()
		end
	end)
end

function lib:toggle(v)
	if st.dead or not st.root then
		return
	end
	if v == nil then
		v = not st.open
	end
	if v == st.open then
		return
	end
	st.open = v
	if hud.hh then
		hud.hh.Visible = v
	end
	if wm.hh then
		wm.hh.Visible = v
	end
	if not v then
		closeall(true)
		stopdrag()
		local l = st.listen
		if l then
			st.listen = nil
			l.lst = false
			l:draw()
		end
	end
	mfree(v)
	fade(v)
	hovscan()
end

local function prefload()
	st.prefs = jdec(fs.read(lib.dir .. "/prefs.json")) or {}
end

prefsave = function()
	if st.pst then
		return
	end
	st.pst = true
	delay(0.5, function()
		st.pst = false
		if st.dead then
			return
		end
		local f = lib.flags
		local mb = st.mob
		local mp = mb and mb.Position
		fs.write(lib.dir .. "/prefs.json", jenc({
			fscale = f.ms_fscale,
			scale = f.ms_scale,
			bg = typeof(f.ms_bg) == "Color3" and hex(f.ms_bg) or nil,
			key = f.ms_key,
			mbtn = f.ms_mbtn,
			mbx = mp and mp.X.Offset,
			mby = mp and mp.Y.Offset,
		}) or "{}")
	end)
end

local function iconbtn(par, ic, lo)
	local b = mk("ImageButton", { Size = ofs(20, 20), Image = icon(ic), LayoutOrder = lo, Parent = par }, { ImageColor3 = "txt" })
	hover(b, nil, function()
		tw(b, { ImageTransparency = 0.3 }, 0.1)
	end, function()
		tw(b, { ImageTransparency = 0 }, 0.1)
	end)
	return b
end

local function cfgrow(sf, it, i)
	local n = it.name
	local cur = st.cfg == n
	local r = mk("Frame", { Size = ud2(1, 0, 0, 66), LayoutOrder = i, Parent = sf }, { BackgroundColor3 = "row" })
	corner(r, 3)
	local hit = mk("TextButton", { Size = scl(1, 1), Parent = r })
	mk("ImageLabel", { Position = ofs(14, 12), Size = ofs(18, 18), Image = icon("gear"), Parent = r }, { ImageColor3 = "txt" })
	local nm = mk("TextLabel", {
		Position = ofs(42, 10),
		Size = ud2(1, -340, 0, 22),
		Text = n,
		FontFace = fnt.b,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = r,
	})
	local md = mk("TextLabel", { Position = ofs(14, 36), Size = ud2(1, -340, 0, 20), RichText = true, TextSize = 15, Parent = r })
	md.Text = sfmt('<font color="%s">Modified:</font> <font color="%s">%s</font>', hex(thm.dim), hex(thm.acc), esc(it.modified))
	local hd = mk("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = v2(1, 0.5),
		Position = ud2(1, -14, 0.5, 0),
		Size = ofs(0, 38),
		AutomaticSize = aix,
		ZIndex = 2,
		Parent = r,
	})
	hlist(hd, 14, ha.Right)
	if cur then
		local rb = iconbtn(hd, "refresh", 1)
		con(rb.MouseButton1Click, function()
			lib:load(n)
		end)
	end
	local pb = iconbtn(hd, "pencil", 2)
	local tb = iconbtn(hd, "trash", 3)
	local ab = mkbtn(hd, cur and "save" or "load", cur and "Save" or "Load", 4, cur and "drop" or "rowb", cur and "droph" or "droph")
	ab.Size = ofs(0, 38)
	con(ab.MouseButton1Click, function()
		if cur then
			lib:save(n)
		else
			lib:load(n)
		end
	end)
	local armed = false
	con(tb.MouseButton1Click, function()
		if armed then
			lib:delete(n)
			return
		end
		armed = true
		tb.ImageColor3 = thm.acc
		lib:notify("Click again to delete", 2)
		delay(2.5, function()
			if tb.Parent then
				armed = false
				tb.ImageColor3 = thm.txt
			end
		end)
	end)
	con(pb.MouseButton1Click, function()
		nm.Visible = false
		local bx = mk("TextBox", {
			Position = ofs(38, 8),
			Size = ud2(1, -346, 0, 26),
			BackgroundTransparency = 0,
			Text = n,
			FontFace = fnt.b,
			ZIndex = 3,
			Parent = r,
		}, { BackgroundColor3 = "ctl" })
		corner(bx, 3)
		pad(bx, 6, 6, 0, 0)
		con(bx.FocusLost, function(ent)
			local nn = cname(bx.Text)
			bx:Destroy()
			nm.Visible = true
			if ent and nn ~= "" and nn ~= n then
				lib:rename(n, nn)
			end
		end)
		bx:CaptureFocus()
	end)
	con(hit.MouseButton2Click, function()
		local d = fs.read(cpath(n))
		if d then
			setclipboard(b64e(d))
			lib:notify("Share code copied")
		end
	end)
	return r
end

local function buildprefs(c)
	local pf = st.prefs or {}
	bmapdel(st.mk, st.mkey)
	c:toggle({
		name = "Mobile button",
		flag = "ms_mbtn",
		nocfg = true,
		default = st.mob ~= nil and st.mob.Visible,
		cb = function(v)
			local b = st.mob
			if b and b.Visible ~= v then
				pfade(b, st.mobp, v)
			end
			prefsave()
		end,
	})
	local fsx = c:toggle({
		name = "Force menu scale",
		flag = "ms_fscale",
		nocfg = true,
		default = pf.fscale == true,
		cb = function()
			rescale()
			prefsave()
		end,
	})
	c:slider({
		name = "Menu scale",
		flag = "ms_scale",
		nocfg = true,
		release = true,
		min = 0.5,
		max = 1.5,
		dec = 2,
		default = tonumber(pf.scale) or 1,
		cb = function()
			rescale()
			prefsave()
		end,
	}):dep(fsx)
	c:colorpicker({
		name = "Background",
		flag = "ms_bg",
		nocfg = true,
		default = unhex(pf.bg) or thm.bg,
		cb = function(v)
			lib:settheme("bg", v)
			prefsave()
		end,
	})
	c:keybind({
		flag = "ms_key",
		nocfg = true,
		nonone = true,
		nomouse = true,
		default = st.mkey,
		onpress = function()
			lib:toggle()
		end,
		cb = function(k)
			st.mkey = k
			prefsave()
		end,
	})
	rescale()
end

function tabcls:configs(o)
	o = o or {}
	if self.sb then
		self.sb:Destroy()
		self.sb = nil
	end
	local cc, _, cp = self:tbbtn({ name = "Create", icon = "create", pop = true, w = 290 })
	cc.tmp = true
	local ni = cc:input({ placeholder = "Name" })
	local si = cc:input({ placeholder = "Share code" })
	cc:button({
		name = "Create",
		w = 136,
		cb = function()
			if lib:create(ni.val, si.val) then
				ni:set("", true)
				si:set("", true)
				closepop(cp)
			end
		end,
	})
	self:tbbtn({
		name = "Refresh",
		icon = "refresh",
		cb = function()
			cfgref()
		end,
	})
	local pc = self:tbbtn({ name = "Personalization", icon = "sliders", pop = true, w = 325 })
	buildprefs(pc)
	local sf = mk("ScrollingFrame", { Position = ofs(30, 0), Size = ud2(1, -60, 1, 0), Parent = self.frame })
	pad(sf, 0, 0, 12, 14)
	vlist(sf, 11)
	local rows = maid.new()
	st.md:add(rows)
	cfgref = function()
		rows:clean()
		if st.dead then
			return
		end
		local l = lib:list()
		for i = 1, #l do
			rows:add(cfgrow(sf, l[i], i))
		end
	end
	cfgref()
	if o.autoload ~= false then
		task.defer(function()
			local n = fs.read(lib.dir .. "/last.txt")
			if n and n ~= "" and fs.has(cpath(n)) and not st.dead then
				lib:load(n)
			end
		end)
	end
	return self
end

function tabcls:hud()
	local s = self:section({ name = "Indicators" })
	s:toggle({
		name = "Enable",
		flag = "hud_on",
		default = hud.on,
		cb = function(v)
			hud.on = v
			hudstyle()
			hudall()
		end,
	})
	s:slider({
		name = "Font size",
		flag = "hud_size",
		min = 10,
		max = 30,
		default = hud.size,
		cb = function(v)
			hud.size = v
			hudstyle()
		end,
	})
	s:slider({
		name = "Spacing",
		flag = "hud_gap",
		min = 0,
		max = 12,
		default = hud.gap,
		cb = function(v)
			hud.gap = v
			hudstyle()
		end,
	})
	s:toggle({
		name = "Outline",
		flag = "hud_stroke",
		default = hud.stroke,
		cb = function(v)
			hud.stroke = v
			hudstyle()
		end,
	})
	s:button({
		name = "Reset position",
		cb = function()
			if hud.hf and hud.def then
				hud.hf.Position = hud.def
			end
		end,
	})
	local w = self:section({ name = "Watermark", side = 2 })
	w:toggle({
		name = "Enable",
		flag = "wm_on",
		default = true,
		cb = function(v)
			wm.on = v
			wmstyle()
		end,
	})
	w:dropdown({
		name = "Show",
		flag = "wm_show",
		multi = true,
		icon = false,
		values = { "Name", "FPS", "Ping", "Time" },
		default = { "Name", "FPS", "Ping", "Time" },
		cb = function(v)
			wm.show = v
			wmupd()
		end,
	})
	w:input({
		flag = "wm_text",
		placeholder = "Custom text...",
		cb = function(v)
			wm.text = v
			wmupd()
		end,
	})
	w:button({
		name = "Reset position",
		cb = function()
			if wm.f and wm.def then
				wm.f.Position = wm.def
			end
		end,
	})
	wm.on = lib.flags.wm_on == true
	wm.show = lib.flags.wm_show or wm.show
	wm.text = lib.flags.wm_text or ""
	wmstyle()
	return self
end

local wincls = {}
wincls.__index = wincls

function wincls:tab(o)
	if type(o) == "string" then
		o = { name = o }
	end
	o = o or {}
	self.nn += 1
	local t = setmetatable({ win = self, o = o, name = o.name or "Tab", y0 = 0, sn = 0, tn = 0 }, tabcls)
	t.tab = t
	local b = mk("TextButton", { Size = ud2(1, 0, 0, 34), LayoutOrder = self.nn, Parent = self.nav }, { BackgroundColor3 = "nav" })
	t.nbar = mk("Frame", { AnchorPoint = v2(0, 0.5), Position = scl(0, 0.5), Size = ud2(0, 3, 0, 0), Parent = b }, { BackgroundColor3 = "acc" })
	t.ni = mk("ImageLabel", { Position = ofs(21, 7), Size = ofs(20, 20), Image = icon(o.icon), Parent = b }, { ImageColor3 = "txt" })
	mk("TextLabel", { Position = ofs(52, 0), Size = ud2(1, -52, 1, 0), FontFace = fnt.b, Text = t.name, Parent = b })
	t.nb = b
	t.frame = mk("Frame", { BackgroundTransparency = 1, Size = scl(1, 1), Visible = false, Parent = self.body })
	t.tb = mk("Frame", { BackgroundTransparency = 1, Size = scl(1, 1), Visible = false, Parent = self.top })
	t.tbl = mk("Frame", { BackgroundTransparency = 1, Position = ofs(38, 0), Size = ud2(1, -76, 1, 0), Parent = t.tb })
	hlist(t.tbl, 16)
	if o.save ~= false then
		t:savebtn()
	end
	con(b.MouseButton1Down, function()
		t.prs = true
		t:navdraw()
	end)
	con(b.MouseButton1Up, function()
		if t.prs then
			t.prs = false
			t:navdraw()
		end
	end)
	con(b.MouseLeave, function()
		if t.prs then
			t.prs = false
			t:navdraw()
		end
	end)
	con(b.MouseButton1Click, function()
		self:select(t)
	end)
	local ts_ = self.tabs
	ts_[#ts_ + 1] = t
	if not self.cur then
		self:select(t)
	else
		t:navdraw()
	end
	return t
end

function wincls:select(t)
	local c = self.cur
	if c == t then
		return
	end
	closeall()
	self.cur = t
	if c then
		c.frame.Visible = false
		c.tb.Visible = false
		c:navdraw()
	end
	gfade(t.frame, true)
	gfade(t.tb, true)
	t:navdraw()
end

function wincls:gap(h)
	self.nn += 1
	mk("Frame", { BackgroundTransparency = 1, Size = ud2(1, 0, 0, h or 4), LayoutOrder = self.nn, Parent = self.nav })
	return self
end

function wincls:toggle(v)
	lib:toggle(v)
	return self
end

local chkpng = "iVBORw0KGgoAAAANSUhEUgAAAAIAAAACCAYAAABytg0kAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAWSURBVBhXYzhz5sz/hoaG/wwgAsQBAGfgC8UEosMyAAAAAElFTkSuQmCC"
local astolfo = "https://cdn3.emoji.gg/emojis/3859-astolfowink.png" --я другой хуйни не нашел сорян

local function loadchk()
	local p = lib.dir .. "/assets/checker.png"
	if not fs.has(p) and not fs.write(p, b64d(chkpng)) then
		return
	end
	local ok, id = pcall(getcustomasset, p)
	if ok and type(id) == "string" then
		st.chk = id
	end
end

local function loadfonts()
	local dir = lib.dir .. "/fonts"
	local r = asset(dir .. "/selawik-reg.ttf", fontsrc.reg, 10000)
	local b = asset(dir .. "/selawik-bold.ttf", fontsrc.bold, 10000)
	if not r or not b then
		return false
	end
	local fam = dir .. "/selawik.json"
	local j = jenc({
		name = "selawik",
		faces = {
			{ name = "Regular", weight = 400, style = "normal", assetId = r },
			{ name = "Bold", weight = 700, style = "normal", assetId = b },
		},
	})
	if not j or not fs.write(fam, j) then
		return false
	end
	local ok, id = pcall(getcustomasset, fam)
	if not ok or type(id) ~= "string" then
		return false
	end
	fnt.b = Font.new(id, Enum.FontWeight.Bold)
	fnt.s = Font.new(id, Enum.FontWeight.Bold)
	fnt.r = Font.new(id, Enum.FontWeight.Regular)
	return true
end

local function dragger(hit, obj, cond, fin)
	con(hit.InputBegan, function(i)
		local t = i.UserInputType
		if not isptr(t) or (cond and not cond()) then
			return
		end
		local m0, p0 = t == tch and ipos(i) or mpos(), obj.Position
		startdrag(function(m)
			obj.Position = ud2(p0.X.Scale, p0.X.Offset + m.X - m0.X, p0.Y.Scale, p0.Y.Offset + m.Y - m0.Y)
		end, fin, nil, i)
	end)
end

local function mobile(o, pf)
	local img = asset(lib.dir .. "/assets/astolfo.png", o.mobimg or astolfo, 1000)
	local sz = uis.TouchEnabled and 44 or 52
	local gs = st.gui.AbsoluteSize
	local x, y = tonumber(pf.mbx), tonumber(pf.mby)
	local on = pf.mbtn
	if on == nil then
		on = o.mobile == true or (o.mobile == nil and uis.TouchEnabled)
	end
	local b = mk("ImageButton", {
		Size = ofs(sz, sz),
		Position = (x and y) and ofs(x, y) or ofs(16, floor(max(gs.Y, 400) * 0.32)),
		Image = img or icon("misc"),
		ZIndex = 20,
		Visible = on == true,
		Parent = st.gui,
	})
	local s = mk("UIScale", { Parent = b })
	con(b.InputBegan, function(i)
		local t = i.UserInputType
		if not isptr(t) then
			return
		end
		local m0, p0 = t == tch and ipos(i) or mpos(), b.Position
		local mv = false
		tw(s, { Scale = 0.9 }, 0.08)
		startdrag(function(m)
			local d = m - m0
			if not mv and d.Magnitude < 6 then
				return
			end
			mv = true
			local g = st.gui.AbsoluteSize
			b.Position = ofs(clamp(p0.X.Offset + d.X, 0, max(0, g.X - sz)), clamp(p0.Y.Offset + d.Y, 0, max(0, g.Y - sz)))
		end, function(rel)
			tw(s, { Scale = 1 }, 0.12)
			if mv then
				prefsave()
			elseif rel then
				lib:toggle()
			end
		end, nil, i)
	end)
	st.mobp = snapt(b)
	return b
end

function lib:window(o)
	o = o or {}
	local old = genv.memesense_lib
	if old and old ~= lib and type(old.unload) == "function" then
		pcall(old.unload, old)
	end
	genv.memesense_lib = lib
	lib.dir = o.folder or lib.dir
	st.title = o.log or "memesense"
	fs.dir(lib.dir)
	fs.dir(cdir())
	fs.dir(lib.dir .. "/fonts")
	fs.dir(lib.dir .. "/assets")
	if o.font ~= false then
		loadfonts()
	end
	loadchk()
	prefload()
	local pf = st.prefs
	local bg = unhex(pf.bg)
	if bg then
		thm.bg = bg
	end
	local k0 = o.key
	if typeof(k0) == "EnumItem" then
		k0 = k0.Name
	end
	st.mkey = type(pf.key) == "string" and pf.key or k0 or "Insert"
	local gui = mk("ScreenGui", {
		Name = hs:GenerateGUID(false),
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 10000,
		AutoLocalize = false,
	})
	st.gui = gui
	st.probe = mk("Frame", { BackgroundTransparency = 1, Size = ofs(0, 0), Parent = gui })
	st.gsat, st.gspd = o.gsat or 0.72, o.gspeed or 10
	st.cv = mk("CanvasGroup", { BackgroundTransparency = 1, BorderSizePixel = 0, Size = scl(1, 1), GroupTransparency = 1, Visible = false, ZIndex = 5, Parent = gui })
	local root = mk("Frame", { AnchorPoint = v2(0.5, 0.5), Position = scl(0.5, 0.5), Size = ofs(936, 767), Visible = false, ZIndex = 5, Parent = gui }, { BackgroundColor3 = "bg" })
	st.root = root
	sink(root)
	mk("UIStroke", { Thickness = 1, Parent = root }, { Color = "edge" })
	st.us = mk("UIScale", { Parent = root })
	gradline(root, 3)
	local side = mk("Frame", { Position = ofs(0, 4), Size = ud2(0, 188, 1, -4), Parent = root }, { BackgroundColor3 = "side" })
	st.logo = mk("TextLabel", { Position = ofs(24, 0), Size = ofs(164, 70), FontFace = fnt.b, TextSize = 23, RichText = true, Parent = side })
	st.t1, st.t2 = o.title or "Meme", o.title2 or "Sense"
	relogo()
	local drg2 = mk("TextButton", { Size = ofs(188, 70), Parent = side })
	local nav = mk("Frame", { BackgroundTransparency = 1, Position = ofs(0, 78), Size = ud2(1, 0, 1, -78), Parent = side })
	vlist(nav, 6)
	local top = mk("Frame", { BackgroundTransparency = 1, Position = ofs(188, 4), Size = ud2(1, -188, 0, 70), Parent = root })
	local drg = mk("TextButton", { Size = scl(1, 1), Parent = top })
	mk("Frame", { Position = ofs(188, 74), Size = ud2(1, -188, 0, 1), Parent = root }, { BackgroundColor3 = "sep" })
	local body = mk("Frame", { BackgroundTransparency = 1, Position = ofs(188, 75), Size = ud2(1, -188, 1, -75), ClipsDescendants = true, Parent = root })
	st.pl = mk("Frame", { BackgroundTransparency = 1, Size = scl(1, 1), ZIndex = 50, Parent = root })
	st.modal = mk("TextButton", { Modal = true, Size = ofs(0, 0), Visible = false, Parent = gui })
	dragger(drg, root)
	dragger(drg2, root)
	local ins = gsv:GetGuiInset()
	local vy = workspace.CurrentCamera.ViewportSize.Y
	local isopen = function()
		return st.open
	end
	hud.def = ofs(14, floor(vy * 0.42))
	local hf = mk("Frame", { BackgroundTransparency = 1, Position = hud.def, Size = ofs(0, 0), AutomaticSize = aixy, Parent = gui })
	local hl = mk("Frame", { BackgroundTransparency = 1, Size = ofs(0, 0), AutomaticSize = aixy, Parent = hf })
	hud.ll = vlist(hl, hud.gap)
	hud.f, hud.hf = hl, hf
	hud.hh = mk("TextButton", { Size = scl(1, 1), ZIndex = 5, Visible = false, Parent = hf })
	dragger(hud.hh, hf, isopen)
	hudstyle()
	wm.def = ud2(1, -14, 0, ins.Y + 10)
	local wf = mk("Frame", {
		AnchorPoint = v2(1, 0),
		Position = wm.def,
		Size = ofs(200, 33),
		Visible = wm.on,
		Parent = gui,
	}, { BackgroundColor3 = "bg" })
	mk("UIStroke", { Thickness = 1, Parent = wf }, { Color = "edge" })
	gradline(wf, 2, st.gspd)
	local wl = mk("TextLabel", {
		Position = ofs(0, 3),
		Size = ud2(0, 0, 1, -3),
		AutomaticSize = aix,
		FontFace = fnt.b,
		TextSize = 15,
		RichText = true,
		Parent = wf,
	})
	pad(wl, 12, 12, 0, 0)
	con(wl:GetPropertyChangedSignal("AbsoluteSize"), function()
		local x = wl.AbsoluteSize.X
		if x > 0 then
			wf.Size = ofs(x, 33)
		end
	end)
	wm.l = wl
	wm.f = wf
	wm.hh = mk("TextButton", { Size = scl(1, 1), ZIndex = 8, Visible = false, Parent = wf })
	dragger(wm.hh, wf, isopen)
	wm.parts = snapt(wf)
	local fa, fc = 0, 0
	st.md:add(rs.Heartbeat:Connect(function(dt)
		fc += 1
		fa += dt
		if fa >= 0.5 then
			st.fps = floor(fc / fa + 0.5)
			fa, fc = 0, 0
			if wm.on then
				wmupd()
			end
		end
	end))
	wmstyle()
	st.logs = mk("Frame", { BackgroundTransparency = 1, Position = ofs(12, ins.Y + 8), Size = ofs(0, 0), AutomaticSize = aixy, Parent = gui })
	vlist(st.logs, 2)
	st.md:add(uis.InputBegan:Connect(onbegan))
	st.md:add(uis.InputEnded:Connect(onended))
	st.md:add(uis.InputChanged:Connect(onchanged))
	st.md:add(uis.WindowFocusReleased:Connect(relall))
	st.md:add(gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(rescale))
	st.mk = {
		bdown = function()
			lib:toggle()
		end,
		bup = function() end,
	}
	bmapadd(st.mk, st.mkey)
	local w = setmetatable({ tabs = {}, nav = nav, top = top, body = body, root = root, nn = 0 }, wincls)
	st.win = w
	if protect_gui then
		protect_gui(gui)
	end
	gui.Parent = gethui()
	st.mob = mobile(o, pf)
	rescale()
	st.open = false
	st.live = true
	lib:toggle(true)
	return w
end

function lib:unload()
	if st.dead then
		return
	end
	closeall(true)
	stopdrag()
	mfree(false)
	st.dead = true
	st.live = false
	st.listen = nil
	st.tg = nil
	if st.ft then
		st.ft:Cancel()
		st.ft = nil
	end
	st.md:clean()
	if st.gui then
		st.gui:Destroy()
	end
	local u = st.unl
	for i = 1, #u do
		pcall(u[i])
	end
	tclear(u)
	tclear(hvs)
	tclear(wrs)
	tclear(lks)
	tclear(st.bmap)
	tclear(st.pops)
	tclear(self.els)
	tclear(self.fl)
	tclear(self.flags)
	tclear(self.profs)
	st.gui, st.root, st.pl, st.win, st.logs, st.us, st.logo, st.mk, st.probe, st.cv, st.mob, st.mobp, st.modal = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	hud.f, hud.hf, hud.hh, hud.ll = nil, nil, nil, nil
	wm.f, wm.l, wm.hh, wm.parts = nil, nil, nil, nil
	mus.t = nil
	cfgref = function() end
	if genv.memesense_lib == self then
		genv.memesense_lib = nil
	end
end

return lib
