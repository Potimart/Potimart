module Chouette::Geocoder
  class Trie  

    # Create a new, empty Trie.
    #
    #   t = Containers::Trie.new
    #   t["hello"] = "world"
    #   t["hello] #=> "world"
    def initialize
      @root = nil
    end
    
    # Adds a key, value pair to the Trie, and returns the value if successful. The to_s method is
    # called on the parameter to turn it into a string.
    #
    # Complexity: O(m)
    #
    #   t = Containers::Trie.new
    #   t["hello"] = "world"
    #   t.push("hello", "world") # does the same thing
    #   t["hello"] #=> "world"
    #   t[1] = 1
    #   t[1] #=> 1
    def push(key, value)
      key = key.to_s
      return nil if key.empty?
      @root = push_recursive(@root, key, 0, value)
      value
    end
    alias_method :[]=, :push
    
    # Returns the value of the desired key, or nil if the key doesn't exist.
    #
    # Complexity: O(m) worst case
    #
    #   t = Containers::Trie.new
    #   t.get("hello") = "world"
    #   t.get("non-existant") #=> nil
    def get(key)
      key = key.to_s
      return nil if key.empty?
      node = get_recursive(@root, key, 0)
      node ? node.last : nil
    end
    alias_method :[], :get

    def start_with(prefix)
      if prefix_root = find(prefix)
        prefix_root.family.inject([]) do |values, node|
          values.push(*node.value) if node.last?
          values
        end.compact
      else
        []
      end
    end

    def count(prefix)
      if node = find(prefix)
        node.value_count
      else
        0
      end
    end

    def find(prefix)
      prefix = prefix.to_s
      return nil if prefix.empty?
      find_recursive(@root, prefix, 0)
    end

    def to_dot(options = {})
      "digraph G { #{@root.to_dot(options)} }"
    end

    def write_dot(filename, options = {})
      extension = File.extname(filename)[1..-1]
      if extension == "dot"
        File.open(filename, "w") { |f| f.write to_dot(options) }
      else
        IO.popen("dot -T#{extension} -o #{filename}","w") do |pipe|
          pipe.print to_dot(options)
          pipe.flush
        end
      end
    end

    class Node # :nodoc: all
      attr_accessor :left, :mid, :right, :char, :value, :end
      attr_accessor :value_count
      
      def initialize(char, value)
        @char = char
        @value = value
        @left = @mid = @right = nil
        @end = false
        @value_count = value ? 1 : 0
      end

      def children
        [ left, mid, right ].compact
      end

      def inspect
        value_string = value.to_s
        if value_string.size > 20
          value_string = value_string.first(20) + "..." 
        end
        children_string = [ :left, :mid, :right ].collect! do |child_name|
          child = send child_name
          "#{child_name}=" + (child.nil? ? "nil" : child.char.chr)
        end.join(' ')
        "#<Node:#{char.chr} #{children_string} value=#{value_string}>"
      end

      def descendants
        children.inject([]) do |descendants, child|
          descendants << child
          descendants + child.descendants
        end
      end

      def family
        returning([self]) do |family|
          if mid
            family.push mid
            family.push *mid.descendants 
          end
        end
      end

      def last?
        @end == true
      end

      def dot_id
        object_id
      end

      def dot_child(child, options = {})
        if Symbol === child
          link_options = "[label=#{child}]"
          child = send(child)
        end
        "#{dot_id} -> #{child.dot_id} #{link_options}; #{child.to_dot(options)}" if child
      end

      def to_dot(options = {})
        returning([]) do |definitions|
          definitions << "#{dot_id} [label=\"#{char.chr} (#{value_count})\"];" 
          definitions << dot_child(:left, options)
          definitions << dot_child(:mid, options)
          definitions << dot_child(:right, options)
          if options[:with_value]
            definitions << "#{value.object_id} [label=\"#{value}\",shape=box]"
            definitions << "#{dot_id} -> #{value.object_id} [style=dotted]"
          end
        end.compact.join(' ')
      end

    end
    
    def push_recursive(node, string, index, value)
      char = string[index]
      node = Node.new(char, nil) if node.nil?
      if (char < node.char)
        node.left = push_recursive(node.left, string, index, value)
      elsif (char > node.char)
        node.right = push_recursive(node.right, string, index, value)
      elsif (index < string.length-1) # We're not at the end of the input string; add next char
        node.value_count += 1
        node.mid = push_recursive(node.mid, string, index+1, value)
      else
        node.value_count += 1
        node.end = true
        if node.value
          node.value << value
        else
          node.value = [value]
        end
      end
      node
    end
    
    # Returns [char, value] if found
    def get_recursive(node, string, index)
      return nil if node.nil?
      char = string[index]
      if (char < node.char)
        return get_recursive(node.left, string, index)
      elsif (char > node.char)
        return get_recursive(node.right, string, index)
      elsif (index < string.length-1) # We're not at the end of the input string; add next char
        return get_recursive(node.mid, string, index+1)
      else
        return node.last? ? [node.char, node.value] : nil
      end
    end

    def find_recursive(node, string, index)
      return nil if node.nil?
      char = string[index]
      if (char < node.char)
        return find_recursive(node.left, string, index)
      elsif (char > node.char)
        return find_recursive(node.right, string, index)
      elsif (index < string.length-1) # We're not at the end of the input string; add next char
        return find_recursive(node.mid, string, index+1)
      else
        return node
      end
    end

  end
end
