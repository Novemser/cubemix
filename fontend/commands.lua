json = require "json"

function ParseCommand(Split)
	cmd = Split[2]
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
  	end
end

function listBucket()
	-- body
	SendRequest("listBucket", nil, nil)
end

function listObject(bucketName)
	-- body
	SendRequest("listObject", {ucketName}, nil)
end

function createBucket(bucketName)
	-- body
	SendRequest("createBucket", {bucketName}, nil)
end

function createText(bucketName, text)
	-- body
	SendRequest("createText", {bucketName, text}, nil)
end