NonTerminals = list()
follow = list()
import shift
productions = shift.extract_Productions()

def find_follow():
    for eachProd in productions:
        if eachProd[0] not in NonTerminals:
            NonTerminals.append(eachProd[0])
        else:
            continue
    startSymbol = NonTerminals[0]
    pair = [startSymbol,'$']
    follow.append(pair)

    for item in NonTerminals:
        for prods in productions:
            checkPos = prods.index('>')
            check = prods[checkPos+1:]
            if item in check:
                itemPos = check.index(item)
                if itemPos + 1 == len(check):
                    for eachNonTerminal in NonTerminals:
                        if eachNonTerminal == prods[0]:
                            addFollow = []
                            addFollow.append(item)
                            for eachNonTerminal in follow:
                                if eachNonTerminal[0] == prods[0]:
                                    for i in range(1,len(eachNonTerminal)):
                                        if i not in addFollow:
                                            addFollow.append(eachNonTerminal[i])
                            if addFollow not in follow:
                                follow.append(addFollow)
                else:
                    for eachNonTerminal in follow:
                        if eachNonTerminal[0] == item:
                            if check[itemPos+1] not in eachNonTerminal:
                                eachNonTerminal.append(check[itemPos+1]) 
    return follow

returnedFollow = find_follow()
f = open('4.follow.txt','w')
f.write('\tFOLLOW\n' + '\t******\n\n')
for items in follow:
    for eachItem in items:
        f.write(eachItem + '\t')
    f.write('\n')