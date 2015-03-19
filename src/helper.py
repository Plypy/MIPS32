f = open("mem", "r")
i = 0

data = ""
for line in f:

    i += 1

f.close()
f = open("tmp", "w")
f.write(data)
f.close()
