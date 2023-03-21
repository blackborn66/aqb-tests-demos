REM
REM create and manipulate a simple linked list
REM 
REM by blackborn66
REM https://github.com/blackborn66/aqb-tests-demos
REM

OPTION EXPLICIT


TYPE Node
id AS INTEGER
nDATA AS STring
nextNode AS Node PTR
END TYPE

SUB AppendNode(list AS Node PTR, nodeID AS Integer, nodeData AS String)
    DIM tempNode AS Node PTR = list
    
    WHILE tempNode->nextNode <> 0 
        tempNode = tempNode->nextNode
    WEND
    DIM newNode AS Node PTR = Allocate(SIZEOF(Node))    
    newNode->id = nodeID
    newNode->nDATA = nodeData
    newNode->nextNode = null
    tempNode->nextNode = newNode    
END SUB


SUB ShowList(rootNode AS Node PTR)
    DIM tempNode AS Node PTR
    tempNode = rootNode
    
    WHILE tempNode <> 0 
        PRINT "Node: ", tempNode->id, " - Data: ", tempNode->nData
        tempNode = tempNode->nextNode 
    WEND
END SUB


SUB DeleteNode(rootNode AS Node PTR, id AS Integer)
    DIM predNode AS Node PTR = null
    DIM tempNode AS Node PTR = rootNode
    
    WHILE tempNode <> 0 
        IF tempNode->id = id THEN
            IF predNode = 0 THEN
                PRINT "first node can't deleted! Try another!"
            ELSE
                predNode->nextNode = tempNode->nextNode
                deallocate tempNode
                PRINT "Node " + STR$(id) + " deleted."                
            END IF
            EXIT SUB
        END IF
        predNode = tempNode
        tempNode = tempNode->nextNode 
    WEND
    PRINT "Node-id " +STR$(id) + " not found! Delete not needed."
END SUB


SUB InsertNode(rootNode AS Node PTR, afterId AS Integer, newId AS Integer, nodeData AS String)
    DIM tempNode AS Node PTR = rootNode
    
    WHILE tempNode <> 0 
        IF tempNode->id = afterId THEN
            DIM newNode AS Node PTR = allocate(SIZEOF(Node))
            newNode->id = newId
            newNode->nData = nodeData
            newNode->nextNode = tempNode->nextNode
            tempNode->nextNode = newNode
            EXIT SUB
        END IF
        tempNode = tempNode->nextNode 
    WEND
    PRINT "Node-id " +STR$(afterId) + " not found! Insert not possible."
END SUB


DIM root AS Node PTR = Allocate(SIZEOF(Node))
root->id = 0
root->nData = "root"
root->nextNode = null

REM root = AppendNode(0, "root")

DIM tempNode AS Node PTR = root

FOR i AS integer = 1 TO 10
    AppendNode root, i, "node" + STR$(i)
NEXT  

DeleteNode root, 5
DeleteNode root, 17
InsertNode root, 3, 11, "insert node 11"
InsertNode root, 15, 12, "insert node 12"
ShowList root

WHILE inkey$ = ""
    sleep
WEND    


