json = require "json"

CUBEMIX_SERVER_IP = "10.1.1.41"
CUBEMIX_SERVER_PORT = 4700
CONNECTION = nil
TCP_DATA = ""


TCP_CLIENT = {

  OnConnected = function (TCPConn)
    -- The specified link has succeeded in connecting to the remote server.
    -- Only called if the link is being connected as a client (using cNetwork:Connect() )
    -- Not used for incoming server links
    -- All returned values are ignored
    LOG("tcp client connected")
    TCP_CONN = TCPConn

    -- list buckets
    LOG("listing buckets and objects...")
    SendTCPMessage("listObject",{},nil)
    SendTCPMessage("listBucket",{},nil)
  end,

  OnError = function (TCPConn, ErrorCode, ErrorMsg)
    -- The specified error has occurred on the link
    -- No other callback will be called for this link from now on
    -- For a client link being connected, this reports a connection error (destination unreachable etc.)
    -- It is an Undefined Behavior to send data to a_TCPLink in or after this callback
    -- All returned values are ignored
    LOG("tcp client OnError: " .. ErrorCode .. ": " .. ErrorMsg)

    -- retry to establish connection
    LOG("retry cNetwork:Connect")
    cNetwork:Connect(CUBEMIX_SERVER_IP,CUBEMIX_SERVER_PORT,CLIENT_HANDLER)
  end,

  OnReceivedData = function (TCPConn, Data)
    -- Data has been received on the link
    -- Will get called whenever there's new data on the link
    -- a_Data contains the raw received data, as a string
    -- All returned values are ignored
    -- LOG("TCP_CLIENT OnReceivedData")

    TCP_DATA = TCP_DATA .. Data
    local shiftLen = 0

    for message in string.gmatch(TCP_DATA, '([^\n]+\n)') do
      shiftLen = shiftLen + string.len(message)
      -- remove \n at the end
      message = string.sub(message,1,string.len(message)-1)
      ParseTCPMessage(message)
    end

    TCP_DATA = string.sub(TCP_DATA,shiftLen+1)

  end,

  OnRemoteClosed = function (TCPConn)
    -- The remote peer has closed the link
    -- The link is already closed, any data sent to it now will be lost
    -- No other callback will be called for this link from now on
    -- All returned values are ignored
    LOG("tcp client OnRemoteClosed")

    -- retry to establish connection
    LOG("retry cNetwork:Connect")
    cNetwork:Connect(CUBEMIX_SERVER_IP,CUBEMIX_SERVER_PORT,CLIENT_HANDLER)
  end,
}

-- SendTCPMessage sends a message over global
-- tcp connection TCP_CONN. args and id are optional
-- id stands for the request id.
function SendTCPMessage(method, args, data)
  if TCP_CONN == nil
  then
    LOG("can't send TCP message, TCP_CLIENT not connected")
    return
  end
  local v = {method=method, args=args, data=data}
  local msg = json.stringify(v) .. "\n"
  TCP_CONN:Send(msg)
end

-- ParseTCPMessage parses a message received from
-- global tcp connection TCP_CONN
function ParseTCPMessage(message)
  local m = json.parse(message)
  if m.method == "listBucket" and table.getn(m.args) == 0 
  then
    local info = m.data
    for iBucket = 1, info.totalBucketCount
    do
      updateBucket(info[iBucket].name,info[iBucket].creationDate,info[iBucket].totalObjCount)
    end
    return
  end
  if m.method == "listObject" and table.getn(m.args) == 1
  then
    local info = m.data
    totalObjNum = findBucket(m.args[1]).totalObjCount
    for iObject = 1, info.totalBucketCount
    do
      updateObject(info[iObject].storageClass,info[iObject].creationDate,info[iObject].size,info[iObject].key)
    end
    return
  end
  if m.method == "createBucket" and table.getn(m.args) == 1
  then
    local info = m.data    
    updateBucket(info.name,info.creationDate,info.totalObjCount)
    return
  end
  if m.method == "createText" and table.getn(m.args) == 2
  then
    local info = m.data
    updateObject(m.args[1],info.storageClass,info.creationDate,info.size,info.key)
    return
  end
  if m.method == "destroyObject" and table.getn(m.args) == 2 and m.data == true
  then
    destroyObject(m.args[1],m.args[2])
    return
  end
  if m.method == "destroyBucket" and table.getn(m.args) == 1 and m.data == true
  then
    destroyBucket(m.args[1])
    return
  end
end

