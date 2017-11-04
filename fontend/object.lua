function NewObject()
	c = {
		displayed = false,
		bucketId = "",
		x = 0,
		z = 0,
		y = 0,
		name = "",
		id = "",
		text = "",
		imageTag = "",
		init = Object.init,
		setInfos = Object.setInfos,
		destroy = Object.destroy,
		display = Object.display
	}
	return c
end

Object = {displayed = false, bucketId = "", x = 0, z = 0, y = 0, name = "", id="",text = ""}
function Object:init()
	self.displayed = false
end

function Object:setInfos(id,name,text,bucketId)
	self.id = id
	self.name = name
	self.text = text
	self.bucketId = bucketId
end

function Object:destroy()
	local x = self.x
	local y = self.y
	local z = self.z
	digBlock(UpdateQueue,x,y,z)
	Object[self.id] = nil

end

function Object:display()
	local bucketX = Buckets[self.bucketId].x
	local bucketZ = Buckets[self.bucketId].z
	local objectX={1,2,4,5,1,2,4,5,1,2,4,5}
	local objectY={2,2,2,2,4,4,4,4,6,6,6,6}

	for i=0,id
	do
		if Objects[i] == nil
		then
			self.x = objectX+bucketX
			self.y = Y_GROUND
			self.z = objectZ+bucketZ
			setBlock(UpdateQueue, self.x, self.y, self.z,E_BLOCK_BOOKCASE, 0)
			setBlock(UpdateQueue,self.x,self.y,self.z,E_BLOCK_WALLSIGN,E_META_CHEST_FACING_XP)
			updateSign(UpdateQueue,self.x,self.y,self.z,"1","2","3","4"£¬2)
			break
		end
	end
end



