class Node
    include Comparable
    attr_accessor :value, :left, :right

    def initialize(value = nil, left = nil, right = nil)
        @value = value
        @left = left
        @right = right
    end

    def <=>(other)
        @value <=> other.value
    end
end

class Tree
    attr_accessor :root

    def initialize(array)
        @root = build_tree array
    end

    def build_tree(arr)
        return nil if arr.empty?
        return Node.new(arr.first) if arr.length < 2
    
        arr.sort!
        mid = arr.length / 2
        root = Node.new(arr[mid])
        root.left = build_tree(arr.take(mid))
        root.right = build_tree(arr.drop(mid + 1))
        root
    end

    def insert(value)
        current = @root
        key = true
        while key
            if value == current.value
                return
            elsif value > current.value
                if current.right.nil?
                    current.right = Node.new value
                    key = false
                else
                    current = current.right
                end
            elsif value < current.value
                if current.left.nil?
                    current.left = Node.new value
                    key = false
                else
                    current = current.left
                end
            end
        end
    end

    def get_leftmost_child_with_parent(node)
        current = node
        parent = current
        while current.left
            parent = current
            current = current.left
        end
        return [current, parent]
    end
    
    def delete(value, node = @root, parent = nil)
        current = node
        if value < current.value
            delete(value, current.left, current)
            return
        elsif value > current.value
            delete(value, current.right, current)
            return
        end
        if current.left && current.right
            successor, par = get_leftmost_child_with_parent(current)
            current.value = successor.value
            delete(current.value, successor, par)
        elsif current.left
            parent.right = current.left
        elsif current.right
            parent.left = current.right
        else
            current = nil
        end
    end
    
    def find(value, node = @root)
        if value == node.value
            return node
        elsif value < node.value
            return find(value, node.left)
        elsif value > node.value
            return find(value, node.right)
        end
    end

    def level_order(queue = [@root], arr = [], &block)
        current = queue.shift
        return if current.nil?

        queue << current.left unless current.left.nil?
        queue << current.right unless current.right.nil?
        block_given? ? (yield current) : arr << current.value
        level_order(queue, arr, &block)
        arr unless block_given?
    end

    def inorder(root = @root, arr = [], &block)
        return if root.nil?
        inorder(root.left, arr, &block)
        block_given? ? (yield root) : arr << root.value
        inorder(root.right, arr, &block)
        return arr
    end

    def preorder(root = @root, arr = [], &block)
        return if root.nil?
        block_given? ? (yield root) : arr << root.value
        preorder(root.left, arr, &block)
        preorder(root.right, arr, &block)
        return arr
    end

    def postorder(root = @root, arr = [], &block)
        return if root.nil?
        postorder(root.left, arr, &block)
        postorder(root.right, arr, &block)
        block_given? ? (yield root) : arr << root.value
    end

    def depth(node = @root)
        if node.nil?
            return -1
        end

        left_depth = 1 + depth(node.left)
        right_depth = 1 + depth(node.right)
        left_depth > right_depth ? left_depth : right_depth
    end

    def balanced?(root = @root)
        return false unless (depth(@root.left) - depth(@root.right)).abs <= 1

        if root.left
            return false unless balanced?(root.left)
        end
        if root.right
            return false unless balanced?(root.right)
        end
        true
    end

    def rebalance!
        return if balanced?
        @root = build_tree(level_order)
    end
end

puts 'Creating tree..'
# tree = Tree.new(`Array.new(15) { rand(1..100) }`)
tree = Tree.new [0,1,2,34,3,4]
p tree
puts "The tree is balanced - #{tree.balanced?}"
puts "Level order: #{tree.level_order}"
puts "Preorder: #{tree.preorder}"
puts "Postorder: #{tree.postorder}"
puts "Inorder: #{tree.inorder}"
puts 'Inserting a few numbers...'
tree.insert 200
tree.insert 150
tree.insert 124
tree.insert 204
puts "The tree is balanced - #{tree.balanced?}"
puts "Rebalancing tree.."
tree.rebalance!
puts "The tree is balanced - #{tree.balanced?}"
puts "Level order: #{tree.level_order}"
puts "Preorder: #{tree.preorder}"
puts "Postorder: #{tree.postorder}"
puts "Inorder: #{tree.inorder}"
