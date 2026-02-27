local _ENV = (getgenv or getrenv or getfenv)()
local CURRENT_VERSION = _ENV.Version or "V2"

local Versions = {
	V1 = "https://raw.githubusercontent.com/Redz-Roblox/Blox-fruit/refs/heads/main/MAIN.V1",
	V2 = "https://raw.githubusercontent.com/Redz-Roblox/Blox-fruit/refs/heads/main/MAIN.V2",
	V3 = "https://raw.githubusercontent.com/Redz-Roblox/Blox-fruit/refs/heads/main/Main.v3",
	V4 = "https://pastefy.app/DfRcfh2V/raw",
}

do
	local last_exec = _ENV.xeter_execute_debounce
	if last_exec and (tick() - last_exec) <= 5 then
		return nil
	end
	_ENV.xeter_execute_debounce = tick()
end

do
	local executor = syn or fluxus
	local queueteleport = queue_on_teleport or (executor and executor.queue_on_teleport)

	if not _ENV.xeter_teleport_queue and type(queueteleport) == "function" then
		_ENV.xeter_teleport_queue = true

		local SourceCode = ("loadstring(game:HttpGet('%s'))()"):format(Versions[CURRENT_VERSION] or Versions.V2)

		pcall(queueteleport, SourceCode)
	end
end

local fetcher = {}

local function CreateMessageError(Text)
	if _ENV.xeter_error_message then
		_ENV.xeter_error_message:Destroy()
	end
	local Message = Instance.new("Message", workspace)
	Message.Text = Text
	error(Text, 2)
end

function fetcher.get(url)
	local success, response = pcall(function()
		return game:HttpGet(url)
	end)
	if success then
		return response
	else
		CreateMessageError(`[Fetcher Error] Failed to get URL: {url}\n>>{response}<<`)
	end
end

function fetcher.load(url)
	local raw = fetcher.get(url)
	local func, err = loadstring(raw)
	if type(func) ~= "function" then
		CreateMessageError(`[Load Error] Syntax error at: {url}\n>>{err}<<`)
	else
		return func
	end
end

local versionUrl = Versions[CURRENT_VERSION] or Versions.V2
return fetcher.load(versionUrl)()
