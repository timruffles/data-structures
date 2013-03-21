LinkedList = require '../LinkedList'

# Shorthand for logging
l = (linkedList) ->
	output = ""
	currentNode = linkedList.head
	for i in [0...linkedList._length]
		output += currentNode.value + " "
		currentNode = currentNode.next
	console.log output

fill = (linkedList) ->
	linkedList.add 5
	linkedList.add 2
	linkedList.add 9
	linkedList.add 0
	linkedList.add 12


checkValues = (linkedList, nodeValues...) ->
	expect(linkedList.head.prev).toBeUndefined()
	expect(linkedList.tail.next).toBeUndefined()
	expect(linkedList.head.value).toBe nodeValues[0]
	expect(linkedList.tail.value).toBe nodeValues[nodeValues.length - 1]

	if nodeValues.length is 0 or nodeValues.length is 1
		expect(linkedList.head.next).toBeUndefined()
		expect(linkedList.tail.prev).toBeUndefined()

	if nodeValues.length is 1
		expect(linkedList.head).toBe linkedList.tail
	else if nodeValues.length isnt 0
		expect(linkedList.head.next.value).toBe nodeValues[1]
		expect(linkedList.tail.prev.value).toBe nodeValues[nodeValues.length - 2]

		currentNode = linkedList.head.next
		for i in [1...nodeValues.length - 1]
			expect(currentNode.value).toBe nodeValues[i]
			expect(currentNode.next.value).toBe nodeValues[i + 1]
			expect(currentNode.prev.value).toBe nodeValues[i - 1]
			currentNode = currentNode.next

describe "Create new linked list", ->
	linkedList = new LinkedList()
	it "should have all head and tail properties unitialized to undefined", ->
		checkValues linkedList
	linkedList2 = new LinkedList([])
	it "should create an empty list too, if the parameter passed is empty", ->
		checkValues linkedList2
	linkedList3 = new LinkedList([1, 2, 3, 4])
	it "should create a list prepopulated with items of the passed array", ->
		checkValues linkedList3, 1, 2, 3, 4


describe "Add node", ->	
	describe "at the end", ->
		linkedList = new LinkedList()
		it "should return the value added", ->
			expect(linkedList.add 1).toBe 1
			expect(linkedList.add null).toBeNull()
			expect(linkedList.add undefined).toBeUndefined()
		linkedList2 = new LinkedList()
		it "should add to the head when the list's empty. It's also the tail", ->
			linkedList2.add "item0"
			checkValues linkedList2, "item0"
		it "should add a second item and get head and tail right", ->
			linkedList2.add "item1"
			checkValues linkedList2, "item0", "item1"
		it "should add items in order", ->
			fill linkedList2
			checkValues linkedList2, "item0", "item1", 5, 2, 9, 0, 12
			
	describe "using offset", ->
		linkedList = new LinkedList()
		it "should return the value added", ->
			expect(linkedList.add 1).toBe 1
			expect(linkedList.add null).toBeNull()
			expect(linkedList.add undefined).toBeUndefined()
		linkedList2 = new LinkedList()
		it "should insert a new first item correctly", ->
			linkedList2.add 9, 0
			linkedList2.add 10, 0
			checkValues linkedList2, 10, 9
		it "should add more items in the correct order", ->
			linkedList2.add 99, 2
			linkedList2.add 2, 3
			linkedList2.add "hi", 3
			linkedList2.add null, 0
			linkedList2.add "orange", 5
			linkedList2.add undefined, 7
			checkValues linkedList2, null, 10, 9, 99, "hi", "orange", 2, undefined
		linkedList3 = new LinkedList()
		it "should return undefined and keep the list intact when the position parameter is invalid", ->
			expect(linkedList3.add "item", 1).toBeUndefined()
			expect(linkedList3.add "item", -1).toBeUndefined()
			expect(linkedList3.head.value).toBeUndefined()
			expect(linkedList3.tail.value).toBeUndefined()
			fill linkedList3
			expect(linkedList3.add 99, -100).toBeUndefined()
			checkValues linkedList3, 5, 2, 9, 0, 12
		it "should allow valid negative position index", ->
			expect(linkedList3.add "apple", -3).toBe "apple"
			linkedList3.add 12, -3
			linkedList3.add 15, 0
			linkedList3.add 88, -6
			linkedList3.add -4, -2
			checkValues linkedList3, 15, 5, 88, 2, "apple", 12, 9, -4, 0, 12

describe "Remove node", ->
	describe "from the end", ->
		linkedList = new LinkedList()
		it "should not error when removing empty linked list", ->
			expect(linkedList.remove()).toBeUndefined()
		linkedList2 = new LinkedList()
		it "should return the value of the removed node", ->
			fill linkedList2
			expect(linkedList2.remove()).toBe 12
			expect(linkedList2.remove()).toBe 0
			expect(linkedList2.remove()).toBe 9
			expect(linkedList2.remove()).toBe 2
			expect(linkedList2.remove()).toBe 5
		linkedList3 = new LinkedList()
		it "should remove node and join its sides correctly", ->
			fill linkedList3
			linkedList3.remove()
			checkValues linkedList3, 5, 2, 9, 0
			linkedList3.remove()
			checkValues linkedList3, 5, 2, 9
			linkedList3.remove()
			checkValues linkedList3, 5, 2
			linkedList3.remove()
			checkValues linkedList3, 5
			linkedList3.remove()
			checkValues linkedList3

	describe "using offset", ->
		linkedList = new LinkedList()
		it "should remove the right item", ->
			fill linkedList
			expect(linkedList.remove 0).toBe 5
			expect(linkedList.remove -1).toBe 12
			expect(linkedList.remove -3).toBe 2
			expect(linkedList.remove 1).toBe 0
			expect(linkedList.remove 0).toBe 9
			expect(linkedList.remove()).toBeUndefined()
		linkedList2 = new LinkedList()
		it "should return undefined when the remove is invalid", ->
			fill linkedList2
			expect(linkedList2.remove 9).toBeUndefined()
			expect(linkedList2.remove -100).toBeUndefined()
		it "should not modify linked list after invalid removes", ->
			checkValues linkedList2, 5, 2, 9, 0, 12

describe "Get node", ->
	linkedList = new LinkedList()
	it "should return undefined for invalid node", ->
		expect(linkedList.get()).toBeUndefined()
		expect(linkedList.get 0).toBeUndefined()
		fill linkedList
		expect(linkedList.get 5).toBeUndefined()
		expect(linkedList.get -6).toBeUndefined()
	it "should return the value for a valid node", ->
		expect(linkedList.get(0).value).toBe 5
		expect(linkedList.get(-5).value).toBe 5
		expect(linkedList.get(1).value).toBe 2
		expect(linkedList.get(-4).value).toBe 2
		expect(linkedList.get(2).value).toBe 9
		expect(linkedList.get(-3).value).toBe 9
		expect(linkedList.get(3).value).toBe 0
		expect(linkedList.get(-2).value).toBe 0
		expect(linkedList.get(4).value).toBe 12
		expect(linkedList.get(-1).value).toBe 12

describe "indexOf", ->
	linkedList = new LinkedList()
	array = [1, 2, 3]
	it "returns -1 if the item isn't found", ->
		linkedList.add "hello"
		linkedList.add -1
		linkedList.add [1, 2, 3]
		linkedList.add array
		linkedList.add 10
		linkedList.add 10
		linkedList.add ""
		expect(linkedList.indexOf [1, 2, 3]).toBe -1
		expect(linkedList.indexOf 99).toBe -1
	it "returns the index of the item found", ->
		expect(linkedList.indexOf "hello").toBe 0
		expect(linkedList.indexOf -1).toBe 1
		expect(linkedList.indexOf array).toBe 3
		expect(linkedList.indexOf 10).toBe 4
		expect(linkedList.indexOf "").toBe 6
	linkedList2 = new LinkedList()
	it "shouldn't find anything in an empty linked list", ->
		expect(linkedList2.indexOf "").toBe -1
		expect(linkedList2.indexOf "hello").toBe -1
	linkedList3 = new LinkedList()
	it "should find undefined and null if they're present only", ->
		expect(linkedList3.indexOf undefined).toBe -1
		expect(linkedList3.indexOf null).toBe -1
		linkedList3.add undefined
		linkedList3.add null
		expect(linkedList3.indexOf undefined).toBe 0
		expect(linkedList3.indexOf null).toBe 1



