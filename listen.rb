require 'socket'
require 'digest'

def md5_truncated(string, length = 10)
  md5 = Digest::MD5.hexdigest(string)
  md5[0...length]
end

socket_path = 'basecomms.sock'
File.unlink(socket_path) if File.exist?(socket_path)
server = UNIXServer.new(socket_path)
File.chmod(0777, socket_path)

puts "Listening on UNIX socket: #{socket_path}"

loop do
  # Accept incoming connections
  socket = server.accept
  # Read data from the socket
  data = socket.read
  # Print the received data
  puts "#{data}"
  # Close the connection
  socket.close
end
