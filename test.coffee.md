*Note: this is a doubly linked list.*

The initial idea was to use a "Node" class to store prev/next/node
value. But this requires additional space and is kind of heavy.

An array "node" consisting of `[prevReference, value, nextReference]`
would be fast and light, but would degrade the readability. Wrapper
methods like next(arrayAsNode) or nextOf(arrayAsNode) don't work well
in chaining for the public api. Adding prototype methods to Array as
to enable arrayAsNode.next() is dirty and comes back to the
alternative of using objects.

The best option is to use {prev, value, next} object.

    class LinkedList
        constructor: ->
            @head =
                prev: undefined
                value: undefined
                next: undefined
            @tail =
                prev: undefined
                value: undefined
                next: undefined

We keep track of the length for operations such as detecting empty
linked list and determining whether to start at the head or the tail
when getting a node.

            @length = 0

The initial version uses short, comprehensive methods such as
`add(value position = @length)` and `remove: (position = @length - 1)`
to encapsulate Array's `push`, `shift` and other mutator methods. The
debate is whether to mimic Array or to use our own methods, that are
more concise. We could defer the Array methods to `add` and `remove`.
But since this is a lightweight library, we'll pass for now.

        add: (value, position = @length) ->

Position allows negative index for python style quick access to last
items. Position smaller than -length or bigger than length is
discarded, as they're more likely done by mistakes.

            if not -@length <= position <= @length then return

Off-by-one problems are annoying. The rule of thumb there is, the
position specifies the place the value's going to be. `add(-2)` on
length of 7 is the same as `add(5)`.

               V here
[1, 2, 3, 9, 5, 7, 10]

We also need to make sure the edge cases work, e.g. length of 1. They
are in this case.

		    if position < 0 then position = @length + position
		    nodeToAdd = {value: value}
		    currentNode = @head

Stop at position - 1, the 

		    for i in [0...position - 1]






            if position is 0
                # If list empty, old @head is undefined
                [@head, nodeToAdd.next] = [nodeToAdd, @head]
            else
                currentNode = @head
                # Get to the node before the insertion position.
                for i in [0...position - 1]
                    currentNode = currentNode.next
                [currentNode.next, nodeToAdd.next] = [nodeToAdd, currentNode.next]
            @length++
            return value

        remove: (position = @length - 1) ->
            if @length is 0 or position < 0 or position >= @length then return
            if @length is 1 or position is 0
                nodeToRemove = @head
                # In the case of length === 1, @head.next is undefined
                @head = @head.next
            else
                currentNode = @head
                # Get to the node before the removing position.
                for i in [0...position - 1]
                    currentNode = currentNode.next
                nodeToRemove = currentNode.next
                currentNode.next = nodeToRemove.next
                nodeToRemove.next = undefined
            @length--
            return nodeToRemove.value

        get: (position) ->
            if position >= @length then return
            currentNode = @head
            for i in [0...position]
                currentNode = currentNode.next
            return currentNode

        indexOf: (value) ->
            currentNode = @head
            position = 0
            while currentNode
                if currentNode.value is value then break
                currentNode = currentNode.next
                position++
            return if position is @length then -1 else position

        toString: ->
            if not @head then return "[]"
            output = "[" + @head.value.toString()
            currentNode = @head.next
            while currentNode
                output += "," + currentNode.value.toString()
                currentNode = currentNode.next
            output += "]"
            return output

    module.exports = LinkedList
