-- ParseTCPMessage parses a message received from
-- global tcp connection TCP_CONN

function ParseTCPMessage(message)
    local m = json.parse(message)
    if m.method == "listBucket" then
        local info = m.data
        for iBucket = 1, m.totalBucketCount
        do
            createABucket(info[iBucket].name, info[iBucket].creationDate, info[iBucket].totalObjCount)
        end

        for iBucket = 1, m.totalBucketCount
        do
            Buckets[info[iBucket].name].objIndex = 1
        end

        for iBucket = 1, m.totalBucketCount
        do
            listObject(info[iBucket].name)
        end
        return
    end
    if m.method == "listObject" and #m.args == 1 then
        local info = m.data
        local bucketName = m.args[1]

        for iObject = 1, #info
        do
            createAnObject(bucketName,
                info[iObject].storageClass,
                info[iObject].lastModified,
                info[iObject].size,
                info[iObject].key)
        end
        return
    end
    if m.method == "createBucket" and #m.args == 1 then
        local info = m.data
        createABucket(info.name, info.creationDate, info.totalObjCount)
        return
    end
    if m.method == "createText" and #m.args == 2 then
        local info = m.data
        createAnObject(m.args[1], info.storageClass, info.creationDate, info.size, info.key)
        return
    end
    if m.method == "destroyObject" and #m.args == 2 and m.data == true then
        destroyAnObject(m.args[1], m.args[2])
        return
    end
    if m.method == "destroyBucket" and #m.args == 1 and m.data == true then
        destroyABucket(m.args[1])
        return
    end
end


-- destroyBucket looks for the first Bucket having the given id,
-- removes it from the Minecraft world and from the 'Buckets' array

function destroyABucket(name)
    Buckets[name]:destroy()
end

-- updateBucket accepts 3 different states: running, stopped, created
-- sometimes "start" events arrive before "create" ones
function createABucket(name, creationDate, totalObjCount)
    local bucket = NewBucket()
    bucket:init()
    bucket:setInfos(creationDate, name, totalObjCount)
    bucket:display()
    bucket:addGround()
    Buckets[name] = bucket
    -- We init a new object map for each bucket
    Objects[name] = {}
end

function createAnObject(bucketName, storageClass, lastModified, size, key)
    obj = NewObject()
    obj:init()
    obj:setInfos(bucketName, storageClass, size, lastModified, key)
    obj:display()
    Objects[bucketName][key] = obj
end