
Y_GROUND=100
Buckets={}

function NewBucket()
    c = 
    {
      x = 0,
      z = 0,
      name="",
      creationDate="",
      totalObjCount=0,
      init=Bucket.init,
      setInfos=Bucket.setInfos,
      destroy=Bucket.destroy,
      display=Bucket.display,
      addGround=Bucket.addGround
    }
    return c
end

Bucket = {x=0, z=0, name="",creationDate="",totalObjCount=0}

function Bucket:init(x,z)
    self.x = x
    self.z = z
    Buckets[#Buckets+1]=self
end

function Bucket:setInfos(creationDate,name,totalObjCount)
    self.creationDate = creationDate
    self.totalObjCount = totalObjCount
    self.name = name
    LOG("SetInfo called")
end

function Bucket:destroy()
    World=cRoot:Get():GetDefaultWorld()
    for px=self.x,self.x+6
    do
        for pz=self.z,self.z+7
        do
            World:DigBlock(px,Y_GROUND+1,pz)
        end
    end
    LOG("destroy called")
end
function Bucket:display()
    --draw pillar--
    World=cRoot:Get():GetDefaultWorld()
    for y=Y_GROUND+1,Y_GROUND+2
    do
        setBlock(UpdateQueueself.x,y,self.z,E_BLOCK_WOOL,E_META_WOOL_WHITE)
        setBlock(UpdateQueueself.x,y,self.z+7,E_BLOCK_WOOL,E_META_WOOL_WHITE)
        setBlock(UpdateQueueself.x+6,y,self.z,E_BLOCK_WOOL,E_META_WOOL_WHITE)
        setBlock(UpdateQueueself.x+6,y,self.z+7,E_BLOCK_WOOL,E_META_WOOL_WHITE)
    end
    --draw bookshelf
    --[[for z=self.z+2,self.z+6,2
    do
        setBlock(UpdateQueueself.x+1,Y_GROUND+1,z,E_BLOCK_BOOKCASE,0)--0 may not be right
        setBlock(UpdateQueueself.x+2,Y_GROUND+1,z,E_BLOCK_BOOKCASE,0)--0 may not be right
        setBlock(UpdateQueueself.x+4,Y_GROUND+1,z,E_BLOCK_BOOKCASE,0)--0 may not be right
        setBlock(UpdateQueueself.x+5,Y_GROUND+1,z,E_BLOCK_BOOKCASE,0)--0 may not be right
    end]]

    --draw fense--
    for z=self.z+1,self.z+6
    do
        setBlock(UpdateQueueself.x,Y_GROUND+1,z,E_BLOCK_FENCE,0)--fense - 0
        setBlock(UpdateQueueself.x+6,Y_GROUND+1,z,E_BLOCK_FENCE,0)--door - 2
    end
    for x=self.x+1,self.x+5
    do
        setBlock(UpdateQueuex,Y_GROUND+1,self.z+7,E_BLOCK_FENCE,0)
    end
        setBlock(UpdateQueueself.x+1,Y_GROUND+1,self.z,E_BLOCK_FENCE,0)
        setBlock(UpdateQueueself.x+2,Y_GROUND+1,self.z,E_BLOCK_FENCE,0)
        setBlock(UpdateQueueself.x+4,Y_GROUND+1,self.z,E_BLOCK_FENCE,0)
        setBlock(UpdateQueueself.x+5,Y_GROUND+1,self.z,E_BLOCK_FENCE,0)

    --draw door--
        setBlock(UpdateQueueself.x+3,Y_GROUND+1,self.z,E_BLOCK_FENCE_GATE,2)
        LOG("display called")
end



function Bucket:addGround()
    World=cRoot:Get():GetDefaultWorld()
    for x=self.x-2,self.x+8
    do
        for z=self.z-2,self.z+9
        do
            setBlock(UpdateQueuex,Y_GROUND,z,E_BLOCK_DIAMOND_BLOCK,0)
        end
    end
    LOG("addground called")        
end

function updateBucket(info[iBucket].name,info[iBucket].creationDate,info[iBucket].totalObjCount)





