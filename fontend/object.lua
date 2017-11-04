function NewObject()
	c = {
		displayed = false,
		bucketName = "",
		storageClass="",
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

Object = {displayed = false, bucketName="",storageClass="", x = 0, z = 0,size = "",lastModified="", key=""}
function Object:init()
	self.displayed = false
end

function Object:setInfos(bucketName,storageClass,size,lastModified,key)
	self.bucketName = bucketName
	self.storageClass = storageClass
	self.size = size
	self.lastModified = lastModified
	self.key = key
end

function Object:destroy()
	local x = self.x
	local z = self.z
	digBlock(UpdateQueue,x,Y_GROUND,z)
end

function Object:display()
	local bucketX = Bucketsf.bucketId].x
	local bucketZ = Buckets[self.bucketId].z
	local objectX={1,2,4,5,1,2,4,5,1,2,4,5}
	local objectY={2,2,2,2,4,4,4,4,6,6,6,6}

	self.x = objectX[id]+bucketX
	self.z = objectZ[id]+bucketZ
	setBlock(UpdateQueue, self.x, Y_GROUND, self.z,E_BLOCK_BOOKCASE, 0)
	setBlock(UpdateQueue,self.x,Y_GROUND,self.z,E_BLOCK_WALLSIGN,E_META_CHEST_FACING_XP)
	updateSign(UpdateQueue,self.x,Y_GROUND,self.z,self.id,self.name,self.key,self.lastModified，2)
end
