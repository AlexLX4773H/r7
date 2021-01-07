stack = list()
import shift
table,detailTable,reductions = shift.create_SLR_1_ParseTable()

parseString = "(a+(a+(a+(a)+a)*a)+a)$"
top = '$0'
headings = table[0]
prev = top
flag = 1

def recursive(i):
    try:
        global flag
        global top
        global prev
        for items in range(1,len(table)):
            if top[len(top) - 1].isdigit() and top[len(top) - 2].isdigit():
                match = top[len(top) - 2:] 
            else:
                match = top[len(top) - 1]
            if table[items][0][1:] == match:
                findStringPos = headings.index(parseString[i])
                if table[items][findStringPos] == 'ACC':
                    prev = top
                    action = 'PARSING SUCCESSFUL'
                    stackTop = [prev,'$',action]
                    top = '$'
                    prev = top
                    if stackTop not in stack:
                        stack.append(stackTop)
                    break
                elif table[items][findStringPos][0] == 'S':
                    action = 'Shift ' + parseString[i] + table[items][findStringPos][1:]
                    stackTop = [prev,parseString[i:],action]
                    if stackTop not in stack:
                        stack.append(stackTop)
                    top += (parseString[i] + table[items][findStringPos][1:])
                    prev = top
                    break
                elif table[items][findStringPos][0] == 'r':
                    action = 'Reduce ' + reductions[table[items][findStringPos]][:-1] + ' (' + table[items][findStringPos] + ')'
                    passReducePos = reductions[table[items][findStringPos]]
                    reverseTop = ""
                    for j in range(len(top)-1,-1,-1):
                        if top[j].isalpha() or not(top[j].isdigit()):
                            reverseTop += top[j]
                            checkReverseTop = reverseTop[::-1]
                            check = passReducePos[3:-1]
                            if checkReverseTop == check:
                                reduceNonTerminal = passReducePos[0]
                                newlength = j
                                newtop = top[0:newlength]
                                top = newtop + reduceNonTerminal
                                colPos = headings.index(reduceNonTerminal)
                                state = 'I'+ top[len(top) - 2]
                                for items in range(1,len(table)):
                                    if table[items][0] == state:
                                        requiredState = table[items][colPos]
                                        top = (top + requiredState)
                                        stackTop = [prev,parseString[i:],action]
                                        prev = top
                                        if stackTop not in stack:
                                            stack.append(stackTop)
                    recursive(i)
                    break
                elif table[items][findStringPos][0] == ' ':
                    action = 'PARSING FAILED'
                    stackTop = [prev,parseString[i:],action]
                    if stackTop not in stack:
                        stack.append(stackTop)
                    flag = -1
                    break
        return
    except:
            action = 'PARSING FAILED'
            stackTop = [prev,parseString[i:],action]
            if stackTop not in stack:
                stack.append(stackTop)
            flag = -1
      

for i in range(0,len(parseString)):
    if flag == 1:
        recursive(i)


parsing = stack


f = open('7.Parsing.txt','w')
for eachRow in parsing:
    for eachColumn in eachRow:
        f.write(eachColumn + '\t\t')
    f.write('\n')
f.close()

