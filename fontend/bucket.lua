Y_GROUND = 100
NumofBucket = 0;
-----------------------------------------------------
-- x0 and z0 is the initial coordinates of the people
deltax = 15
-----------------------------------------------------
function NewBucket()
    c =
    {
        x = 0,
        z = 0,
        name = "",
        creationDate = "",
        totalObjCount = 0,
        objIndex = 1,
        init = Bucket.init,
        setInfos = Bucket.setInfos,
        destroy = Bucket.destroy,
        display = Bucket.display,
        addGround = Bucket.addGround
    }
    return c
end

Bucket = { x = 0, z = 0, name = "", creationDate = "", totalObjCount = 0, objIndex = 1 }

function Bucket:init()
    self.x = x0 + deltax * NumofBucket
    self.z = z0
    self.objIndex = 1
    NumofBucket = NumofBucket + 1
end

function Bucket:setInfos(creationDate, name, totalObjCount)
    self.creationDate = creationDate
    self.totalObjCount = totalObjCount
    self.name = name
end

function Bucket:destroy()
    World = cRoot:Get():GetDefaultWorld()
    for px = self.x - 1, self.x + 7
    do
        for pz = self.z - 1, self.z + 8
        do
            World:DigBlock(px, Y_GROUND + 1, pz)
            World:DigBlock(px, Y_GROUND + 2, pz)
            World:DigBlock(px, Y_GROUND, pz)
        end
    end
    LOG("destroy called")
end

function Bucket:display()
    --draw pillar--
    local px = self.x
    local py = Y_GROUND
    local pz = self.z
    World = cRoot:Get():GetDefaultWorld()
    for y = Y_GROUND + 1, Y_GROUND + 2
    do
        World:SetBlock(self.x, y, self.z, E_BLOCK_WOOL, E_META_WOOL_WHITE)
        World:SetBlock(self.x, y, self.z + 7, E_BLOCK_WOOL, E_META_WOOL_WHITE)
        World:SetBlock(self.x + 6, y, self.z, E_BLOCK_WOOL, E_META_WOOL_WHITE)
        World:SetBlock(self.x + 6, y, self.z + 7, E_BLOCK_WOOL, E_META_WOOL_WHITE)
    end
    World:SetBlock(self.x, Y_GROUND + 3, self.z, E_BLOCK_SIGN_POST, 3)
    World:SetBlock(self.x, Y_GROUND + 3, self.z + 7, E_BLOCK_SIGN_POST, 3)
    World:SetBlock(self.x + 6, Y_GROUND + 3, self.z, E_BLOCK_SIGN_POST, 3)
    World:SetSignLines(self.x, Y_GROUND + 3, self.z, "Name", "", self.name, "")
    World:SetSignLines(self.x, Y_GROUND + 3, self.z + 7, "creationDate", "", self.creationDate, "")
    World:SetSignLines(self.x + 6, Y_GROUND + 3, self.z, "totalObjCount", "", self.totalObjCount, "")


    --[[World:SetSignLines(self.x,(Y_GROUND+2),self.z,"2","1","creationDate","totalObjCount",2)
    World:SetSignLines(self.x,Y_GROUND+2,self.z + 7,"2","2","creationDate","totalObjCount",2)
    World:SetSignLines(self.x+6,Y_GROUND+2,self.z + 7,"2","2","creationDate","totalObjCount",2)]]
    --draw bookshelf
    --    for z = self.z + 2, self.z + 6, 2
    --    do
    --        World:SetBlock(self.x + 1, Y_GROUND + 1, z, E_BLOCK_BOOKCASE, 0) --0 may not be right
    --        World:SetBlock(self.x + 2, Y_GROUND + 1, z, E_BLOCK_BOOKCASE, 0) --0 may not be right
    --        World:SetBlock(self.x + 4, Y_GROUND + 1, z, E_BLOCK_BOOKCASE, 0) --0 may not be right
    --        World:SetBlock(self.x + 5, Y_GROUND + 1, z, E_BLOCK_BOOKCASE, 0) --0 may not be right
    --    end

    --draw fense--
    for z = self.z + 1, self.z + 6
    do
        World:SetBlock(self.x, Y_GROUND + 1, z, E_BLOCK_FENCE, 0) --fense - 0
        World:SetBlock(self.x + 6, Y_GROUND + 1, z, E_BLOCK_FENCE, 0) --door - 2
    end
    for x = self.x + 1, self.x + 5
    do
        World:SetBlock(x, Y_GROUND + 1, self.z + 7, E_BLOCK_FENCE, 0)
    end
    World:SetBlock(self.x + 1, Y_GROUND + 1, self.z, E_BLOCK_FENCE, 0)
    World:SetBlock(self.x + 2, Y_GROUND + 1, self.z, E_BLOCK_FENCE, 0)
    World:SetBlock(self.x + 4, Y_GROUND + 1, self.z, E_BLOCK_FENCE, 0)
    World:SetBlock(self.x + 5, Y_GROUND + 1, self.z, E_BLOCK_FENCE, 0)

    --draw door--
    World:SetBlock(self.x + 3, Y_GROUND + 1, self.z, E_BLOCK_FENCE_GATE, 2)
    LOG("display called")
end



function Bucket:addGround()
    World = cRoot:Get():GetDefaultWorld()
    for x = self.x - 1, self.x + 7
    do
        for z = self.z - 1, self.z + 8
        do
            World:SetBlock(x, Y_GROUND, z, E_BLOCK_DIAMOND_BLOCK, 0)
        end
    end
    LOG("addground called")
end


