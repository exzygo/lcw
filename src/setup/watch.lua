local lfs = require("lfs")

local PROJECT_DIR = ".."
local BUILD_DIR = lfs.currentdir()

local function sleep(seconds)
    local target = os.clock() + seconds
    while os.clock() < target do end
end

local function read_build()
    local f = io.open("lbuild.txt", "r")
    if not f then
        print("- - - [LCW::ERROR] lbuild.txt not founded on ./build/")
        os.exit(1)
    end
    local cmd = f:read("*l")
    f:close()
    return cmd
end

local function get_files_mtime()
    local mtimes = {}

    for file in lfs.dir(PROJECT_DIR) do
        if file:match("%.c$") or file:match("%.h$") then
            local path = PROJECT_DIR .. "/" .. file
            local attr = lfs.attributes(path)
            if attr then
                mtimes[path] = attr.modification
            end
        end
    end

    return mtimes
end

local function changed(previous, current)
    for file, time in pairs(current) do
        if previous[file] == nil or previous[file] ~= time then
            return true
        end
    end
    return false
end

local old_times = get_files_mtime()
print("- - - [LCW::W] Reading .c e .h on: " .. PROJECT_DIR)

while true do
    sleep(1)

    local new_times = get_files_mtime()
    if changed(old_times, new_times) then
        print("- - - [LCW::W] Change detected! Recompiling...")

        local cmd = read_build()
        print("- - - [LCW::W] Executing: " .. cmd)

        local ok, err = lfs.chdir(PROJECT_DIR)

        if not ok then
            print("- - - [LCW::W] Error when changing directories: " .. err)
        else
            os.execute(cmd)
            lfs.chdir(BUILD_DIR)
        end

        print("- - - [LCW::W] Compilation finished.")
        old_times = new_times
    end
end
