window.onload = function () {
    // instantiate table var using id
    var table = document.getElementById("board");
    updateBoxBorders(table);
    var status = 0;

    // add action listener for each cell
    for(var r = 0; r < table.rows.length; r++){
        for(var c = 0; c < table.rows[r].cells.length; c++){
            // onclick function for each cell
            table.rows[r].cells[c].onclick = function () {
                //checks if the box is empty ("E") or if game status tells to continue
                if(this.innerHTML == "E" && status == 0){
                    toggleSymbol(this);
                    status = checkStatus(table);
                }
                
            }
        }
    }
}

/*
This function checks game status
if game needs to continue, then returns 0
if player 1 wins, then returns 1
if player 2 wins, then returns 2
if game is draw, then returns 3
*/
function checkStatus(table){
    //check rows and columns
    for (var r = 0; r < table.rows.length; r++){
        //check rows
        if (table.rows[r].cells[0].innerHTML + table.rows[r].cells[1].innerHTML + table.rows[r].cells[2].innerHTML == "XXX"){
            message("PLAYER 1 WINS!");
            return 1;
        }else if (table.rows[r].cells[0].innerHTML + table.rows[r].cells[1].innerHTML + table.rows[r].cells[2].innerHTML == "OOO"){
            message("PLAYER 2 WINS!");
            return 2;
        }

        //check columns
        if (table.rows[0].cells[r].innerHTML + table.rows[1].cells[r].innerHTML + table.rows[2].cells[r].innerHTML == "XXX"){
            message("PLAYER 1 WINS!");
            return 1;
        }else if (table.rows[0].cells[r].innerHTML + table.rows[1].cells[r].innerHTML + table.rows[2].cells[r].innerHTML == "OOO"){
            message("PLAYER 2 WINS!");
            return 2;
        }
    }

    //check diagonals
    if (table.rows[0].cells[0].innerHTML + table.rows[1].cells[1].innerHTML + table.rows[2].cells[2].innerHTML == "XXX"
    || table.rows[0].cells[2].innerHTML + table.rows[1].cells[1].innerHTML + table.rows[2].cells[0].innerHTML == "XXX"){
        message("PLAYER 1 WINS!");
        return 1;
    }else if (table.rows[0].cells[0].innerHTML + table.rows[1].cells[1].innerHTML + table.rows[2].cells[2].innerHTML == "OOO"
    || table.rows[0].cells[2].innerHTML + table.rows[1].cells[1].innerHTML + table.rows[2].cells[0].innerHTML == "OOO"){
        message("PLAYER 2 WINS!");
        return 2;
    }

    //draw check
    var draw = true;
    for(var i = 0; i < table.rows.length; i++){
        for(var j = 0; j < table.rows[i].cells.length; j++){
            if(table.rows[i].cells[j].innerHTML == "E"){
                draw = false;
            }
        }
    }
    if(draw){
        message("DRAW!");
        return 3;
    }

    return 0;
}

/*
Styling function: This helper function just updates the border to look like tic tac game
*/
function updateBoxBorders(table){
    for(var i = 0; i < table.rows.length; i++){
        for(var j = 0; j < table.rows[i].cells.length; j++){
            if(j == 2){
                table.rows[i].cells[j].style.borderBottom = "1px solid black";
                if(i == 2 && j == 2){
                    table.rows[i].cells[j].style.borderRight = "1px solid white";
                    table.rows[i].cells[j].style.borderBottom = "1px solid white";
                }
            }else if(i == 2){
                table.rows[i].cells[j].style.borderRight = "1px solid black";
            }else{
                table.rows[i].cells[j].style.borderRight = "1px solid black";
                table.rows[i].cells[j].style.borderBottom = "1px solid black";
            }
        }
    }
}

/*
This function just checks if a cell is empty, if it is it's font is white, else black.
*/
function updateBoxVisibility(box){
    if(box.innerHTML == "E"){
        box.style.color = "white";
    }else{
        box.style.color = "black";
    }
}

/*
Toggles X or O for the box
*/
function toggleSymbol(box){
    var playerturn = toggleMessage();
    if (playerturn == 1){
        //if its player 1's turn
        box.innerHTML = "X";  
    } else if (playerturn == 2){
        //if its player 2's turn
        box.innerHTML = "O";  
    } 

    //change box visibility
    updateBoxVisibility(box);
}

/*
This function just toggles the message box from player 1 to player 2 and vice versa.
*/
function toggleMessage(){
    var msg = getMessage(); 
    if(msg == "Player Turn: Player 1"){
        message("Player Turn: Player 2");
        return 1;
    }else if (msg == "Player Turn: Player 2"){
        message("Player Turn: Player 1"); 
        return 2;
    }
}

/*
Helper function: Changes message box to txt
*/
function message(txt){
    document.getElementById("PlayerTurn").innerHTML = txt;
}

/*
Helper function: This function gets message
*/
function getMessage(){
    return document.getElementById("PlayerTurn").innerHTML
}