local lfs = require("lfs")

local BUILD_DIR = lfs.currentdir()

local PROJECT_DIR = arg[1]

if not PROJECT_DIR then
    print("[LCW::ERROR] Missing project directory argument")
    os.exit(1)
end

local function abspath(path)
    local old = lfs.currentdir()
    local ok = lfs.chdir(path)
    if not ok then
        print("[LCW::ERROR] Invalid project directory: " .. path)
        os.exit(1)
    end
    local abs = lfs.currentdir()
    lfs.chdir(old)
    return abs
end

PROJECT_DIR = abspath(PROJECT_DIR)

print("[LCW::W] Watching project directory:", PROJECT_DIR)
print("[LCW::W] Build directory:           ", BUILD_DIR)

local function sleep(seconds)
    local target = os.clock() + seconds
    while os.clock() < target do end
end

local function read_build()
    local path = BUILD_DIR .. "/lbuild.txt"
    local f = io.open(path, "r")
    if not f then
        print("[LCW::ERROR] lbuild.txt not found in build directory")
        print("Path: " .. path)
        os.exit(1)
    end
    local cmd = f:read("*l")
    f:close()
    return cmd
end

local function get_mtimes()
    local mt = {}
    for f in lfs.dir(PROJECT_DIR) do
        if f:match("%.c$") or f:match("%.h$") then
            local p = PROJECT_DIR .. "/" .. f
            local a = lfs.attributes(p)
            if a then mt[p] = a.modification end
        end
    end
    return mt
end

local function changed(prev, curr)
    for f, t in pairs(curr) do
        if prev[f] ~= t then return true end
    end
    return false
end

local old = get_mtimes()

while true do
    sleep(1)
    local new = get_mtimes()

    if changed(old, new) then
        print("[LCW::W] Change detected! Running build...")

        local cmd = read_build()

        local olddir = lfs.currentdir()
        lfs.chdir(PROJECT_DIR)
        os.execute(cmd)
        lfs.chdir(olddir)

        print("[LCW::W] Done.")
        old = new
    end
end
