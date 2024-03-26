local progname
if wiivc then progname = "patch-rom-vc" else progname = "patch-rom" end

function usage()
  io.stderr:write("usage: " .. progname ..
                  " [-s] [-o <output-rom>] <input-rom>\n")
  os.exit(1)
end

local arg = {...}
local opt_sub
local opt_out
local opt_rom
while arg[1] do
  if arg[1] == "-s" then
    opt_sub = true
    table.remove(arg, 1)
  elseif arg[1] == "-o" then
    opt_out = arg[2]
    if opt_out == nil then usage() end
    table.remove(arg, 1)
    table.remove(arg, 1)
  elseif opt_rom ~= nil then usage()
  else
    opt_rom = arg[1]
    table.remove(arg, 1)
  end
end
if opt_rom == nil then usage() end

require("lua/rom_table")
local rom = gru.n64rom_load(opt_rom)
local rom_info = rom_table[rom:crc32()]
if rom_info == nil then
  io.stderr:write(progname .. ": unrecognized rom: " .. opt_rom .. "\n")
  return 2
end

local patch = gru.ups_load("ups/" .. rom_info.gz_name .. ".ups")
patch:apply(rom)
if opt_out ~= nil then
  rom:save_file(opt_out)
else
  rom:save_file(rom_info.gz_name ..  ".z64")
end

if opt_sub then print(rom_info.gz_name ..  ".z64") end

return 0
