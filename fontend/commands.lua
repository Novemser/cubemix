
function ParseCommand(Split)
	-- body
	cmd = Split[2]
	if m.cmd == "listBucket" 
  	then
  		handleListBucket()
    elseif m.cmd == "listObject" 
  	then
		handleCreateBuciet()
  	elseif m.cmd == "createBuciet" 
  	then
		handleCreateText()
  	elseif m.cmd == "createText"
  	then
    	handleQueryEvent(m.data)
  	end
end

function listBucket()
	-- body

end