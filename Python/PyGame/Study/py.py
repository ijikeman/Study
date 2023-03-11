array = ('green', 'apple')
result = 'apple' in array
print(result)

result = array.index('apple')
print(result)

print("%d %d" % (10, 20))

print("Hello %s" % "John")
print("Hello %s" " Your Score = %d" % ("John", 60))
print("Hello {} Your Score = {}".format("John", 60))
print("Hello {1} Your Score = {0}".format(60, "John"))
print("Hello {name} Your Score = {score}".format(score=60, name="John"))
