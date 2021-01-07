parseInfo = dict()
headings = list()
file = open("5.Data_Flow.txt")
for eachLine in file:
    eachLine = eachLine.rstrip()
    if eachLine.startswith('GOTO')  or eachLine.startswith('SHIFT') or eachLine.startswith('REDUCE') or eachLine.startswith('ACCEPT'):
        eachLine = eachLine.split('\t')[1]
        eachLine = eachLine.split()
        eachLine.pop(1)
        eachLine.pop(2)
        key = eachLine[0]
        if eachLine[1].isupper():
            value = eachLine[2][1:]
            add = [eachLine[1],value]
        else:
            if eachLine[2][0] == 'A':
                value = 'ACC'
                add = [eachLine[1],value]
            elif eachLine[2][0] != 'r':
                value = 'S' + eachLine[2][1:]
                add = [eachLine[1],value]
            else:
                value = eachLine[2]
                add = [eachLine[1],value]
        if key not in parseInfo:
            parseInfo.setdefault(key,[])
            parseInfo[key].append(add)
        else:
            parseInfo[key].append(add)
        if eachLine[1] not in headings:
            headings.append(eachLine[1])
headings = headings[::-1]
headings[:0] = ['No']
rows = len(parseInfo)
cols = len(headings)
arr = []
arr.append(headings)
count = 0
for i in range(rows):
    col = []
    for c in range(cols):
        col.append(' ')
    state = 'I' + str(count)
    for j in headings:
        for items in parseInfo[state]:
            if j == items[0]:
                findHeadPos = headings.index(j)
                col[findHeadPos] = items[1]
            else:
                continue
    col[0] = state 
    count += 1
    arr.append(col)

f = open('6.Parse_Table.txt','w')
f.write('----------------------------------------------------------------------------------------------------------------------------------------------------------\n')
flag = 0
for eachRow in arr:
    for elements in eachRow:
        f.write(elements+'\t|\t')
    if flag == 0:
        f.write('\n----------------------------------------------------------------------------------------------------------------------------------------------------------')
        flag = 1
    f.write('\n')
f.write('----------------------------------------------------------------------------------------------------------------------------------------------------------')
f.close()



