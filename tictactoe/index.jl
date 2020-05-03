
using Random

board_size=3

@enum GameState begin
    IN_PROGRESS = 0 
    DRAW = 1 
    X_WINS = 2 
    O_WINS = 3
end

struct Move    
    x::Int   
    y::Int
   
    function Move(x::Int, y::Int)
        new(x, y)
    end
end

function transform(value)
    return printable[value]
end

function make_move(board,move,player)
    i = move.x
    j = move.y
    board[i][j] = player
    return board
end

function legal_moves(board)
    moves = []
    for i in range(1,stop=board_size)
        for j in range(1,stop=board_size)
            if board[i][j] == 0 
                move = Move(i,j)
                push!(moves, move)
            end
        end
    end
    return shuffle(moves)
end

function player_wins(player)
    if player == 1
        result = X_WINS
    else
        result = O_WINS
    end
    return result
end

function get_game_state(board,player)
    result = IN_PROGRESS

    ## horizonal win
    if (result == IN_PROGRESS)
        for row in board
            if sum(row) == board_size*player
                result = player_wins(player)
            end
        end
    end

    ## vertical win
    if (result == IN_PROGRESS)
        for j in range(1,stop=board_size)
            column = [board[i][j] for i in range(1,stop=board_size)]
            if sum(column) == board_size
                result = player_wins(player)
            end
        end
    end

    ## forward diagonal wins
    if (result == IN_PROGRESS)
        diag = [board[i][i] for i in range(1,stop=board_size)]
        if sum(diag) == board_size
            result = player_wins(player)
        end
    end

    ## backward diagonal wins
    if (result == IN_PROGRESS)
        diag = [board[i][i] for i in board_size:-1:1]
        if sum(diag) == board_size
            result = player_wins(player)
        end
    end

    if (result == IN_PROGRESS)
        ## no moves left
        if length(legal_moves(board)) == 0
            result = DRAW
        end
    end

    return result
end

function print_board(board)
    println()
    for row in board
        println([transform(element) for element in row])
    end
    println()
end



## transform numbers to letters for printed board
printable = Dict{Int64,String}(-1=>"O", 0=>" ",1=>"X")

board=[[0 for j in range(1,stop=board_size)] for i in range(1,stop=board_size)]
##push!(board,row)
##board = [i for i in range(board_size)]
print_board(board)
player = 1

game_state = get_game_state(board,player)
while game_state == IN_PROGRESS 
    global game_state
    global board
    global player
    moves = legal_moves(board)
    board = make_move(board,moves[1],player)
    print_board(board)
    game_state = get_game_state(board,player)
    player = -player
end
println(game_state)
