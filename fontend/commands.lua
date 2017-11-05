
function ParseCommand(Split)
	cmd = Split[2]
	LOG(cmd)
	if cmd == "listBucket" 
  	then
  		listBucket()
    elseif cmd == "listObject" 
  	then
		listObject(Split[3])
  	elseif cmd == "createBucket"
  	then
		createBucket(Split[3])
  	elseif cmd == "createText"
  	then
    	createText(Split[3], Split[4])
  	elseif cmd == "destroyObject"
  	then
    	destroyObject(Split[3], Split[4])
    elseif cmd == "destroyBucket"
    then
		destroyBucket(Split[3])
  	end
end

function listBucket()
	SendRequest("listBucket", nil, nil)
end

function listObject(bucketName)
	SendRequest("listObject", {bucketName}, nil)
end

function createBucket(bucketName)
	SendRequest("createBucket", {bucketName}, nil)
end

function createText(bucketName, text)
	SendRequest("createText", {bucketName, text}, nil)
end

function destroyObject(bucketName, objName)
	SendRequest("destroyObject", {bucketName, objName}, nil)
end

function destroyBucket(bucketName)
	SendRequest("destroyBucket", {bucketName}, nil)
end