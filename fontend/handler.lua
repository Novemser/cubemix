-- ParseResponseMessage parses a message received from
-- global tcp connection CONNECTION
function ParseResponseMessage(message)
  local m = json.parse(message)
  LOG(m)
  if m.method == "listBucket" 
  then

  elseif m.method == "listObject" 
  then

  elseif m.method == "createBuciet" 
  then

  elseif m.method == "createText"
  then

  elseif m.method == "destroyObject"
  then

  end
end

