function NewObject()
	c = {
		displayed = false,
		bucketId = "",
		storageClass="",
		x = 0,
		z = 0,
		size = "",
		lastModified = "",
		name = "",
		id = "",
		key = "",
		init = Object.init,
		setInfos = Object.setInfos,
		destroy = Object.destroy,
		display = Object.display
	}
	return c
end

Object = {displayed = false, bucketId = "",storageClass="", x = 0, z = 0,size = "",lastModified="", name = "", id="",key="",text = ""}
function Object:init()
	self.displayed = false
end

function Object:setInfos(id,name,text,bucketId,storageClass,size,lastModified,key)
	self.id = id
	self.name = name
	self.text = text
	self.bucketId = bucketId
	self.storageClass = storageClass
	self.size = size
	self.lastModified = lastModified
	self.key = key
end

function Object:destroy()
	local x = self.x
	local z = self.z
	digBlock(UpdateQueue,x,Y_GROUND,z)
	Objects[self.id] = nil

end

function Object:display()
	local bucketX = Buckets[self.bucketId].x
	local bucketZ = Buckets[self.bucketId].z
	local objectX={1,2,4,5,1,2,4,5,1,2,4,5}
	local objectY={2,2,2,2,4,4,4,4,6,6,6,6}

	if Objects[self.id] == nil
	then
		self.x = objectX[id]+bucketX
		self.z = objectZ[id]+bucketZ
		setBlock(UpdateQueue, self.x, Y_GROUND, self.z,E_BLOCK_BOOKCASE, 0)
		setBlock(UpdateQueue,self.x,Y_GROUND,self.z,E_BLOCK_WALLSIGN,E_META_CHEST_FACING_XP)
		updateSign(UpdateQueue,self.x,Y_GROUND,self.z,self.id,self.name,self.key,self.lastModified，2)
		break
	end
end
