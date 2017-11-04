json = require "json"

CUBEMIX_SERVER_IP = 10.1.1.41
CUBEMIX_SERVER_PORT = 4700
CONNECTION = nil
TCP_DATA = ""

-- Define the callbacks to use for the client connection:
CLIENT_HANDLER = {
  OnConnected = function (TCPConn)
    -- The specified link has succeeded in connecting to the remote server.
    -- Only called if the link is being connected as a client (using cNetwork:Connect() )
    -- Not used for incoming server links
    -- All returned values are ignored
    LOG("tcp client connected")
    CONNECTION = TCPConn
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
    LOG("Incoming data:\r\n" .. Data)
    -- Data has been received on the link
    -- Will get called whenever there's new data on the link
    -- a_Data contains the raw received data, as a string
    -- All returned values are ignored
    -- LOG("CLIENT_HANDLER OnReceivedData")

    -- TCP_DATA = TCP_DATA .. Data
    -- local shiftLen = 0

    -- for message in string.gmatch(TCP_DATA, '([^\n]+\n)') do
    --   shiftLen = shiftLen + string.len(message)
    --   -- remove \n at the end
    --   message = string.sub(message,1,string.len(message)-1)
    --   ParseTCPMessage(message)
    -- end

    -- TCP_DATA = string.sub(TCP_DATA,shiftLen+1)

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

-- SendMessage sends a message over global
-- tcp connection CONNECTION. args and id are optional
-- id stands for the request id.
function SendMessage(cmd, args, data, id)
  if CONNECTION == nil
  then
    LOG("can't send message, client not connected")
    return
  end
  local v = {cmd=cmd,args={args},data=data,id=id}
  local msg = json.stringify(v) .. "\n"
  LOG(msg)
  CONNECTION:Send(msg)
end

-- ParseTCPMessage parses a message received from
-- global tcp connection CONNECTION
function ParseTCPMessage(message)
  local m = json.parse(message)
  -- deal with table events
  if m.cmd == "event" and table.getn(m.args) > 0 and m.args[1] == "table"
  then
    handleTableEvent(m.data)
  -- deal with monitor events
  elseif m.cmd == "monitor" and table.getn(m.args) > 0 and m.args[1] == "all"
  then
    handleMonitorEvent(m.data)
  elseif m.cmd == "event" and table.getn(m.args) > 0 and m.args[1] == "error"
  then
    localPlayer:SendMessage(cCompositeChat()
		:AddTextPart(m.data,"@c"))
  elseif m.cmd == "event" and table.getn(m.args) > 0 and m.args[1] == "result"
  then
    handleQueryEvent(m.data)
  end
end
