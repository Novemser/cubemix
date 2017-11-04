json = require "json"

CUBEMIX_SERVER_IP = "10.1.1.41"
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
    ParseResponseMessage(message)
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

-- SendRequest sends a message over global
-- tcp connection CONNECTION. args and id are optional
-- id stands for the request id.
function SendRequest(name, args, data)
  if CONNECTION == nil
  then
    LOG("can't send message, client not connected")
    return
  end
  local v = {method=name,args=args,data=nil}
  local req = json.stringify(v) .. "\n"
  LOG("Sending request:" .. req)
  CONNECTION:Send(req)
end