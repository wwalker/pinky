module("pinky", package.seeall)
local json = require 'cjson'
local lfs = require 'lfs'

local function debug (kind, msg)
   if msg then
      msg = kind .. ": " .. msg
   else
      msg = kind
   end
   return ngx.log(ngx.DEBUG, msg)
end

function file_exists(filename)
   if filename then
      local fd = io.open(filename,"r")
      if fd then
         io.close(fd)
         return true
      else
         return false
      end
   else
      return false
   end
end

function exec_command(command,fields,key_field,sep,tokenize)
   local out_table = {}
   local out = ""

   if command and not file_exists(split(command, " ")[1]) then
      return "Error: " .. split(command," ")[1] .. " could not be found"
   end

   local cmd_out, cmd_err = io.popen(command)

   if cmd_out then
      for line in cmd_out:lines() do
         if tokenize then
            line_array = split(line, sep)
            out_table[line_array[key_field]] = line_array
         else
            out = out .. line
         end
      end
      if tokenize then
         if fields then
            return return_fields(out_table, fields)
         else
            return out_table
         end
      else
         return out
      end
   else
      return cmd_err
   end
end

function return_fields(in_table,fields)
   local out_table = {}
   for k,v in pairs(in_table) do
      for I = 1, #fields do
         if v[fields[I]] then
            if out_table[k] then
               table.insert(out_table[k],v[fields[I]])
            else
               out_table[k] = { v[fields[I]] }
            end
         end
      end
   end
   return out_table
end

function show_functions(module)
   local out = ""
   local mymod = require(module)
   for k,v in pairs(mymod) do
      if type(v)=='function' then
         out = out ..  k .. "\n"
      end
   end
   return out
end

function print_table(in_table)
   local out = ""
   for k,v in pairs(ngx.var) do
      out = out .. " " .. k .. " " .. v
   end
   return out
end

function reports(check_type)
   local pinky_method = "report" .. "_" .. check_type
   if type(_M[pinky_method]) == "function" then
      return json.encode(_M[pinky_method]())
   else
      return "Ummm Brain, we have no method called " .. pinky_method
   end
end

-- repetative shit

function report_load()
   return exec_command("/bin/uptime")
end

function report_iostat()
   return exec_command("/bin/iostat 2|head -n 1")
end

function report_mpstat()
   return exec_command("/bin/uptime")
end

function report_socks()
   return exec_command("/bin/uptime")
end

function report_sar()
   return exec_command("/bin/uptime")
end

function report_uptime()
   return exec_command("/bin/uptime")
end

function report_vmstat()
   return exec_command("/bin/uptime")
end

function report_who()
   return exec_command("/bin/uptime")
end

function report_ps()
   return exec_command("/bin/ps auxwww", nil, 11, " +",true)
end

function report_net()
   return exec_command("/bin/netstat -an", nil, 1, " +",true)
end

function report_memfree()
   -- call free(1) -m and return values
   -- total:1        used:2       free:3     shared:4    buffers:5     cached:6"}
   local out = exec_command("/usr/bin/free -m", {1,2,3,4,5,6}, 1, " +", true)
   out.total = nil
   return out
end

function dispatch(uri)
   local uri = split(uri,"/")
   local PINKY_HOME = "/home/jaimef/pinky"
   local custom_lib = uri[2]
   -- local custom_lib = PINKY_HOME .. "/" .. uri[2] .. ".lua"
   local short_uri = ""

   for I=3,#uri do
      short_uri = short_uri .. "/" .. uri[I]
   end

   if file_exists(PINKY_HOME .. "/" .. uri[2] .. ".lua") then
      local custom_lib = require(custom_lib)
      -- make sure main exists first, then error.
      if custom_lib.pinky_main then
         return custom_lib.pinky_main(short_uri)
      else
         return "Could not locate " .. uri[2] .. ".pinky_main"
      end
   else
      return "Error: could not locate " .. custom_lib
   end
end

-- cribbed from http://stackoverflow.com/questions/1426954/split-string-in-luac
function split(pString, pPattern)
   if not pString or not pPattern then
      return "pString or pPattern were nil"
   end
   local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
         table.insert(Table,cap)
      end
      last_end = e+1
      s, e, cap = pString:find(fpat, last_end)
   end
   if last_end <= #pString then
      cap = pString:sub(last_end)
      table.insert(Table, cap)
   end
   return Table
end

function lsdir (path)
   local out_table = {}
   for file in lfs.dir(path) do
      if file ~= "." and file ~= ".." then
         table.insert(out_table, file)
      end
   end
   return out_table
end
