


if fileExists("update.cfg") then 
open = fileOpen("update.cfg",false)
else
open = fileCreate("update.cfg",false)
end 
reads =  fileRead(open,fileGetSize(open))

Version = reads
update  =  "https://raw.githubusercontent.com/Ahmed-Ly/test"
count = 0
countRemote = 0
updatePeriodTime = 1 --hour

function  started ()
fetchRemote(update.."/master/update.cfg",function(data,err)
if err == 0 then 

Remote = data

if Remote > Version then 

print("[Update]Remote Version Got [Remote:"..Remote.." Current:"..Version.."]")

print("[Update]Update? Command: update")
end
end
end)
end
addEventHandler("onResourceStart",resourceRoot,started)


function checkUpdate () 
fetchRemote(update.."/master/update.cfg",function(data,err)

if err == 0 then 

VersionRemote = data

if VersionRemote > Version then 

print("[Update]Remote Version Got [Remote:"..VersionRemote.." Current:"..Version.."]")

print("[Update]Update? Command: dowload")

							
if isTimer(check) then 

killTimer(check) 

end

check = setTimer(function ()


if VersionRemote > Version then 

print("[Update]Remote Version Got [Remote:"..VersionRemote.." Current:"..Version.."]")

else 

killTimer(check)

end

end ,60000,0)


end 

end

end)

end

 
 
 updatePeriodTimer = setTimer(checkUpdate,updatePeriodTime*3600000,0)



addCommandHandler("dowload",function (player,_) 

if VersionRemote > Version  then 


print("Done")

meta()

end
end 
)



addCommandHandler("update",function (player,_) 

if Remote > Version  then 


print("Done")

meta()

end
end 
)




function meta () 
fetchRemote(update.."/master/meta.xml",function(data,err)

print("[Update]Downloading meta.xml")


if err == 0 then 

if  fileExists("updated/meta.xml") then 

fileDelete("updated/meta.xml")

end 

created = fileCreate("updated/meta.xml") 


fileWrite(created,data)

fileClose(created)


putfiles()

else 
print("[Update]Can't Get meta.xml, Update Failed ("..err..")")
end 
end)
end

scripts = {}




function putfiles () 
print("[Update]checking meta.xml")
xml = xmlLoadFile("updated/meta.xml") 
for k,v in pairs(xmlNodeGetChildren(xml)) do
if xmlNodeGetName(v) == "script" or xmlNodeGetName(v) == "file" then
countRemote = k - 1
local files = xmlNodeGetAttribute(v,"src")
scripts[#scripts + 1] = files
end
end 
for i = 1,#scripts do 
fetchRemote(""..update.."/master/"..scripts[i],function(data,err)
count = count + 1
if fileExists(""..scripts[i].."") then 
fileDelete(""..scripts[i].."")
end 
print("[Update] Created "..scripts[i].."")
local file = fileCreate(""..scripts[i].."")
print("[Update]: "..countRemote.."/"..count.."")
fileWrite(file,data)
print("[Update]Downloading "..scripts[i].." | Size:"..fileGetSize(file).."K")
fileClose(file)
if count == countRemote then 
dowloadEnd ()  
end
end)
end
end 

function  dowloadEnd ()  
fileDelete("meta.xml")
fileRename("updated/meta.xml","meta.xml")
print("[Update]Update Complete (Updated "..count.." Files)")
print("[Update]Please Restart Resource")
scripts = {}
count = 0 
countRemote = 0
end
