package = "Pinky"
version = "0.1-0"
source = {
   url = "http://github.com/ober/pinky"
}
description = {
   summary = ".",
   detailed = [[
      Pinky is a monitoring system built in Lua on top of open-resty.
   ]],
   homepage = "http://github.com/ober/pinky",
   license = "MIT/X11"
}
dependencies = {
   "lua ~> 5.1",
   "lua-cjson ~> 2.1.0-1",
   "luasql-mysql",
   "lyaml",
   "luadate",
   "luafilesystem",
   "luasocket",
   "luaposix",
   "luaxml",
   "redis-lua"
}
build = {
   type = "builtin",
   modules = {
      pinky_chef = "pinky_chef.lua",
      pinky_disk = "pinky_disk.lua",
      pinky_dpkg = "pinky_dpkg.lua",
      pinky_ec2meta = "pinky_ec2meta.lua",
      pinky_hello = "pinky_hello.lua",
      pinky_load = "pinky_load.lua",
      pinky_log = "pinky_log.lua",
      pinky_memcache = "pinky_memcache.lua",
      pinky_memfree = "pinky_memfree.lua",
      pinky_netstat = "pinky_netstat.lua",
      pinky_md5sum = "pinky_md5sum.lua",
      pinky_mydb = "pinky_mydb.lua",
      pinky_net = "pinky_net.lua",
      pinky_nginx = "pinky_nginx.lua",
      pinky_passenger = "pinky_passenger.lua",
      pinky_ping= "pinky_ping.lua",
      pinky = "pinky.lua",
      pinky_port  = "pinky_port.lua",
      pinky_redis  = "pinky_redis.lua",
      pinky_proc = "pinky_proc.lua",
      pinky_process = "pinky_process.lua",
      pinky_rvm = "pinky_rvm.lua",
      pinky_runit = "pinky_runit.lua",
      pinky_stat = "pinky_stat.lua",
      pinky_unicorn = "pinky_unicorn.lua",
      pinky_vmstat = "pinky_vmstat.lua"
   },
   install = {
      bin = { "pinky" }
   }
}
