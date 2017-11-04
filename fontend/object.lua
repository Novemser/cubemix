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
function Object:init(x,y,z)
	self.x = x
	self.z = z
	self.y = y
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

end

function Object:display()
	local metaPrimaryColor = E_META_WOOL_LIGHTBLUE
	local metaSecondaryColor = E_META_WOOL_BLUE

	setBlock(UpdateQueue, self.x, self.y, self.z,E_BLOCK_WOOL,metaPrimaryColor)
	setBlock(UpdateQueue,self.x,self.y,self.z,E_BLOCK_WALLSIGN,E_META_CHEST_FACING_XP)
	updateSign(UpdateQueue,self.x,self.y,self.z,"1","2","3","4"£¬2)
end



