class WebSocketConnection
  attr_reader :socket

  def initialize(socket)
    @socket = socket
  end

  def recv
    # First byte is fin and opcode
    fin_and_opcode = socket.read(1).bytes[0]

    # Second byte has:
    # - First bit: mask indicator
    # - Remaining 7 bits: message length
    mask_and_length_indicator = socket.read(1).bytes[0]
    length_indicator = mask_and_length_indicator & 0x7f
    length = parse_length(length_indicator)

    # Next four bytes are the mask key
    keys = socket.read(4).bytes

    # Encoded content is next #{length} bytes
    encoded = socket.read(length).bytes
    decoded = decode_content(encoded, keys)

    # Return the decoded bytes as a string
    return decoded.pack("c*")
  end

  def send(message)
    bytes = [0x81] # 1 (full message) 000 (reserved) 0001 (text content)
    bytes += length_indicator(message)
    bytes += encode_content(message)
    data = bytes.pack("C*")
    socket << data
  end

  private

  # https://tools.ietf.org/html/rfc6455#page-28
  def parse_length(length_indicator)
    if length_indicator < 125
      # Length is literal
      length_indicator
    elsif length_indicator == 126
      # Read next two bytes as unsinged int
      socket.read(2).unpack("n")[0]
    else # 127
      # Read next eight bytes as 64-bit unisnged int
      socket.read(8).unpack("Q>")[0]
    end
  end

  # https://tools.ietf.org/html/rfc6455#page-33
  def decode_content(encoded, keys)
    encoded.map.with_index do |byte, index|
      byte ^ keys[index % 4]
    end
  end

  def length_indicator(message)
    size = message.bytesize
    if size <= 125
      # Length is literal
      [size]
    elsif size < 2**16
      # Length indicator is 126 + two byte unsigned int
      [126] + [size].pack("n").bytes
    else
      # Length indicator is 127 + eight byte 64-bit unsigned in
      [127] + [size].pack("Q>").bytes
    end
  end

  def encode_content(message)
    message.bytes
  end
end
