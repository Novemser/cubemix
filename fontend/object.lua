function NewObject()
    c = {
        displayed = false,
        bucketName = "",
        storageClass = "",
        x = 0,
        z = 0,
        size = "",
        lastModified = "",
        key = "",
        init = Object.init,
        setInfos = Object.setInfos,
        destroy = Object.destroy,
        display = Object.display
    }
    return c
end

Object = { displayed = false, bucketName = "", storageClass = "", x = 0, z = 0, size = "", lastModified = "", key = "" }
function Object:init()
    self.displayed = false
end

function Object:setInfos(bucketName, storageClass, size, lastModified, key)
    self.bucketName = bucketName
    self.storageClass = storageClass
    self.size = size
    self.lastModified = lastModified
    self.key = key
end

function Object:destroy()
    local x = self.x
    local z = self.z
    digBlock(UpdateQueue, x, Y_GROUND, z)
end

function Object:display()
    World = cRoot:Get():GetDefaultWorld()

    local bucketX = Buckets[self.bucketName].x
    local bucketZ = Buckets[self.bucketName].z
    objectX = { 1, 2, 4, 5, 1, 2, 4, 5, 1, 2, 4, 5 }
    objectZ = { 2, 2, 2, 2, 4, 4, 4, 4, 6, 6, 6, 6 }


    self.x = objectX[Buckets[self.bucketName].objIndex] + bucketX
    self.z = objectZ[Buckets[self.bucketName].objIndex] + bucketZ
    Buckets[self.bucketName].objIndex = Buckets[self.bucketName].objIndex + 1
    if Buckets[self.bucketName].objIndex == 13 then
        Buckets[self.bucketName].objIndex = 1
    end

    World:SetBlock(self.x, Y_GROUND + 1, self.z, E_BLOCK_BOOKCASE, 0)
    World:SetBlock(self.x, Y_GROUND + 2, self.z, E_BLOCK_SIGN_POST, E_META_CHEST_FACING_ZM)
    LOG("Display obj")
    World:SetSignLines(self.x, Y_GROUND + 2, self.z, self.storageClass, "Key:" .. self.key, "Size:" .. self.size, "Modify:" .. self.lastModified)
    --    updateSign(UpdateQueue, self.x, Y_GROUND, self.z, self.id, self.name, self.key, self.lastModified, 2)
end
