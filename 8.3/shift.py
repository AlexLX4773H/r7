
productions = list()
augmentedProductions = list()
LR_0_items = dict()
NowConsiderLR = 'I0'
I0 = NowConsiderLR
count = 0
totalItems = ""
terminalsAndNonterminals = list()
checkcount = 0
get_follow = None
reductions = dict()
parse_table = None
parse_dict = None

def extract_Productions():
    grammar = open('1.productions.txt','r')
    for production in grammar:
        production = production.rstrip()
        productions.append(production)
    grammar.close()
    return productions

def create_Augmented_Grammar():
    grammar = open('1.productions.txt','a')
    augmentedGrammar = open('2.augment.txt','w')
    startSymbol = productions[0]
    startSymbol = startSymbol[0]
    i = 'X' + '->.' + startSymbol
    j = 'X' + '->' + startSymbol
    augmentedGrammar.write(j + '\n')
    augmentedProductions.append(i)
    for i in productions:
        k = i[:3] + '.' + i[3:]
        j = i[:]
        augmentedGrammar.write(j + '\n')
        augmentedProductions.append(k)
    augmentedGrammar.close()
    grammar.close()
    if I0 not in LR_0_items:
        LR_0_items[I0] = augmentedProductions

def create_canonical_collection_LR_0_items():
    global count
    global NowConsiderLR   
    global totalItems
    global terminalsAndNonterminals
    pair = list()
    for eachItem in LR_0_items[NowConsiderLR]:
        findDot = eachItem.index('.')
        if findDot + 1 == len(eachItem):
            if eachItem[0] == 'X':
                requiredItem = 'Accept'
            else:
                requiredItem = 'Reduce'
        else:
            requiredItem = eachItem[findDot + 1]
        if requiredItem not in pair:
            pair.append(requiredItem)
    for eachPair in pair:
        addPair = [NowConsiderLR,eachPair]
        terminalsAndNonterminals.append(addPair)
    for prod in LR_0_items[NowConsiderLR]:
        checkThisToo = set()
        flag = 0
        LRprod = list()
        prevNonTerminal = list()
        count += 1
        I = 'I' + str(count)
        dotPos = prod.index('.')
        if dotPos == (len(prod)-1) and len(LR_0_items[NowConsiderLR]) >= 1:
            count -= 1
            continue
        if dotPos+1 < len(prod) and ( (not prod[dotPos+1].isupper()) and ( prod[dotPos+1].isalpha() or not(prod[dotPos+1].isalpha())) or prod[dotPos+1].isupper() and prod[dotPos+1].isalpha() ):
            s = prod[:dotPos] + prod[dotPos+1] + '.' + prod[dotPos + 2:]
            LRprod.append(s)
            newdotPos = s.index('.')
            newflag = 0
            for items in LR_0_items:
                for eachprod in LR_0_items[items]:
                    if s == eachprod:
                        flag = 1
            if flag == 1:
                count -= 1
                continue
            if newdotPos + 1 == len(prod):
                newdotPos -= 1
                prevNonTerminal.append(prod[newdotPos + 1])
                if newdotPos+1 < len(prod) and prod[newdotPos+1].isupper():
                    for eachProd in LR_0_items[I0]:
                        prodDotPos = eachProd.index('.')
                        s = eachProd[:prodDotPos] + eachProd[prodDotPos+1] + '.' + eachProd[prodDotPos+2:]
                        if newdotPos+1 < len(eachProd) and eachProd[0] == s[3] and eachProd[0] in prevNonTerminal and s not in LRprod:
                            LRprod.append(s)
            elif newdotPos+1 < len(prod) and not(s[newdotPos+1].isupper()) and not(s[newdotPos+1].isalpha()):
                newdotPos -= 1
                prevNonTerminal.append(s[newdotPos])
                if newdotPos < len(prod) and s[newdotPos].isupper():
                    for eachProd in LR_0_items[NowConsiderLR]:
                        prodDotPos = eachProd.index('.')
                        s = eachProd[:prodDotPos] + eachProd[prodDotPos+1] + '.' + eachProd[prodDotPos+2:]
                        if newdotPos < len(eachProd) and eachProd[0] == s[3] and eachProd[newdotPos] in prevNonTerminal and s not in LRprod:
                            LRprod.append(s)
            elif newdotPos+1 < len(prod) and prod[newdotPos+1].isupper() and prod[newdotPos+1].isalpha():
                for eachProd in LR_0_items[I0]:
                    if eachProd[0] != prod[newdotPos+1] and newflag == 0:
                        continue
                    else:
                        newflag = 1
                        if eachProd[0] == prod[newdotPos+1] or eachProd[0] in checkThisToo:
                            if eachProd not in LRprod:
                                LRprod.append(eachProd)
                        prodDot = eachProd.index('.')
                        if prodDot+1 < len(eachProd) and eachProd[prodDot+1].isupper() and eachProd[prodDot+1].isalpha():
                            checkThisToo.add(eachProd[prodDot+1])
            LR_0_items[I] = LRprod

    for item in terminalsAndNonterminals:
        if item[0] == NowConsiderLR:
            for items in LR_0_items:
                for Prod in LR_0_items[items]:
                    dot = Prod.index('.')
                    if dot < len(Prod) and item[1] == Prod[dot-1] and not(items in item):
                        if len(item) == 3:
                            item[2] = items
                        else:
                            item.append(items)
        if len(item) == 2 and item[1] != 'Accept' and item[1] != 'Reduce':
            item.append(item[0])
        elif len(item) == 2 and item[1] == 'Reduce':
            for eachNonTerminal in get_follow:
                for eachITEMS in LR_0_items[item[0]]:
                    if eachNonTerminal[0] == eachITEMS[0]:
                        for key in reductions:
                            if eachITEMS == reductions[key]:
                                for ITEMS in range(1,len(eachNonTerminal)):
                                     if ITEMS not in item:
                                         item.append(eachNonTerminal[ITEMS])
                                         item.append(key)
        elif len(item) == 2 and item[1] == 'Accept':
            item.append('$')

    totalItems = I
    nextToConsider = str(NowConsiderLR[0] + str(int(NowConsiderLR[1:]) + 1))
    NowConsiderLR = nextToConsider
    if int(NowConsiderLR[1:]) < int(totalItems[1:]):
        create_canonical_collection_LR_0_items()
    else:
        LR_0 = open('3.canonical_collection_LR_0_items().txt','w')
        LR_0.write('\n\tCANONICAL COLLECTION OF LR(0) ITEMS\n\t***********************************\n\n')
        for key in LR_0_items:
            LR_0.write('\n\n' + key + '\n' + '------------' + '\n')
            for items in LR_0_items[key]:
                LR_0.write(items + '\t\t' + '|' + '\n')
            LR_0.write('-------------' + '\n')
        LR_0.close()
        return

def create_follow():
    global get_follow
    import follows
    get_follow = follows.follow
    count = 1  
    for eachProduction in productions:
        R = 'r' + str(count)
        if R not in reductions:
            eachProduction += '.'
            reductions[R] = eachProduction
        count += 1
    return reductions


def create_data_flow_path():
    Data_Flow = open('5.Data_Flow.txt','w')
    Data_Flow.write('\n\t  DATA FLOW\n\t*************\n\n------------------------------------\nACTION |\n------------------------------------')
    for eachItem in terminalsAndNonterminals:
        if eachItem[1] == 'Reduce':
            for i in range(2,len(eachItem),2):
                Data_Flow.write('\nREDUCE |  \t' + eachItem[0] +'  <---  '+ eachItem[i] +'   --->  '+eachItem[i+1])
        elif eachItem[1] == 'Accept':
            Data_Flow.write('\nACCEPT |  \t' + eachItem[0] +'  <---  '+ eachItem[2] +'   --->  '+'ACCEPT')
        else:
            if eachItem[1].isalpha() and eachItem[1].isupper():
                Data_Flow.write('\nGOTO   |  \t' + eachItem[0] +'  <---  '+ eachItem[1] +'   --->  '+eachItem[2])
            else:
                Data_Flow.write('\nSHIFT  | \t' + eachItem[0] +'  <---  '+ eachItem[1] +'   --->  '+eachItem[2])
    Data_Flow.close()

def create_SLR_1_ParseTable():
    global parse_table
    global parse_dict
    global reductions
    import SLR_1_ParseTable
    parse_table = SLR_1_ParseTable.arr      
    parse_dict = SLR_1_ParseTable.parseInfo 
    parse_reductions = create_follow()
    return parse_table,parse_dict,parse_reductions             

def validate_parsing():
    import SLR_1_parsing

def main():
    extract_Productions()
    create_Augmented_Grammar()
    create_follow()
    create_canonical_collection_LR_0_items()
    create_data_flow_path()
    create_SLR_1_ParseTable()
    validate_parsing()
    
if __name__ == '__main__':
    main()
