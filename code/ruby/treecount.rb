class TextTree
  attr_reader :root, :prefix
  def initialize(tree = {}, prefix: "")
    @root = tree
    @prefix = prefix.to_s
  end

  def ingest(text)
    node = @root
    text.to_s.strip.split(//).each do |letter|
      node[letter] ||= {}
      node[letter][:count] ||= 0
      node[letter][:count] += 1
      node = node[letter]
    end
    node["\0"] ||= 0
    node["\0"] += 1
  end

  def count_for(text, terminal: false)
    node = @root.dig(*text.to_s.strip.split(//))
    return 0 if node.nil?
    terminal ? node["\0"] : node[:count]
  end

  def tally(terminal: false)
    results = []
    @root.each do |key, node|
      if key == "\0"
        results << {text: @prefix, count: node}
      elsif key == :count
        results << {text: @prefix, count: node} if !terminal && split?
      else
        results += TextTree.new(node, prefix: @prefix + key).tally
      end
    end
    return results
  end

  private

  def split?(node = @root)
    (node.keys - [:count, "\0"]).length >= 2
  end
end


tree = TextTree.new
tree.ingest("hello")
tree.ingest("hello")
tree.ingest("help")
tree.ingest("hello, world")
tree.ingest("help me")
