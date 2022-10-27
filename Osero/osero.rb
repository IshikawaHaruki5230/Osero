BLACK = "黒"
WHITE = "白"
EMPTY = "・"
WIDTH = 8
HEIGHT = 8
X = 1
Y = 0
class Piece
    #インスタンス生成時の初期処理
    def initialize
        @state = EMPTY
    end
    #裏返す
    def switching
        if @state == WHITE then
            @state = BLACK
        elsif @state == BLACK then
            @state = WHITE
        end
    end
    #状態を返す
    def getState
        return @state
    end
    #コマを置く
    def putPiece(state)
        @state = state
        return nil
    end

end

class Board
    #インスタンス生成時の初期処理
    def initialize
        #ボードの左上の0,0とする
        #方向ベクトル[y,x]
        #左向きから時計回り
        @vectors = [[0,-1],[1,-1],[1,0],[1,1],[0,1],[-1,1],[-1,0],[-1,-1]]
        #裏返す8方向と個数を格納する配列[y,x,個数]
        @chengeVectors = Array.new(8){Array.new(3,0)}
        #盤面の2次元配列
        #各要素にはコマ（初期値EMPTY）を格納する
        @board = Array.new(WIDTH){ Array.new(HEIGHT){Piece.new} }
        @board[HEIGHT/2-1][WIDTH/2].putPiece(BLACK)
        @board[HEIGHT/2][WIDTH/2-1].putPiece(BLACK)
        @board[HEIGHT/2-1][WIDTH/2-1].putPiece(WHITE)
        @board[HEIGHT/2][WIDTH/2].putPiece(WHITE)

    end
    #盤面の配列を返す
    def getBoard
        return @board
    end

    #ひっくり返すことが出来るか確認
    #array[x,y]
    def checkSwitchPiece(state,array)
        #それぞれ範囲外か判定
        isBorderOut = false
        @vectors.each do |vector|
            x = array[0] + vector[X]
            y = array[1] + vector[Y]
            if x < 0 || y < 0 || x >= WIDTH || y >= HEIGHT then
                isBorderOut = true
            else
                isBorderOut = false
                break;
            end
        end
        if isBorderOut then
            return isBorderOut
        else
            isBorderOut = true
        end
        #置いた場所から8方向に走査して、裏返せる所を配列に格納していく
        index = 0
        @chengeVectors = Array.new(8){Array.new(3,0)}
        @vectors.each do |vector|
            x = array[0] + vector[X]
            y = array[1] + vector[Y]
            count = 0
            while x >= 0 && x < WIDTH && y >= 0 && y < HEIGHT && @board[y][x].getState != state && @board[y][x].getState != EMPTY do
                count += 1
                x += vector[X]
                y += vector[Y]
                if x >= 0 && x < WIDTH && y >= 0 && y < HEIGHT && @board[y][x].getState == state then
                    vectorArray = vector + Array.new(1,count)
                    @chengeVectors[index] = vectorArray
                    isBorderOut = false
                end
                index += 1
            end
        end
        return isBorderOut
    end
    #実際に裏返す
    def switchPieceinBoard(array)
        @chengeVectors.compact!
        @chengeVectors.each do |vector|
            vector.compact!
            x = array[0]
            y = array[1]
            if vector == [0,0,0] then
            else
                vector[2].times do
                    x += vector[X]
                    y += vector[Y]
                    @board[y][x].switching
                end
            end
        end
    end
    #盤面をチェックして続けるか、勝者を返す
    def checkResult
        black = 0
        white = 0
        count = 0
        @board.each do |heightIndex|
            heightIndex.each do |widthIndex|
                if widthIndex.getState == WHITE then
                    white += 1
                    count += 1
                elsif widthIndex.getState == BLACK then
                    black += 1
                    count += 1
                end
            end
        end
        if white == 0 || white < black && count == HEIGHT*WIDTH then
            return BLACK
        elsif black == 0 || white > black && count == HEIGHT*WIDTH then
            return WHITE
        else 
            return true
        end
    end
end

#メインクラス
class Main
    #インスタンス生成時の初期処理
    def initialize
        @b

    end
    #始めに実行される関数
    def start
        @b = Board.new
        outputBoard(@b)
        
        return nil
    end
    #繰り返す
    def update
        num = 0
        while @b.checkResult == true do
            turnResult = blackTurn
            if turnResult == "s" then
            elsif turnResult  == false then
                break
            else
                outputBoard(@b)
            end
            turnResult = whiteTurn
            if turnResult == "s" then
            elsif  turnResult == false then
                break
            else
                outputBoard(@b)
            end
            num += 1
        end

        if @b.checkResult == BLACK then
            puts "黒の勝利"
        elsif @b.checkResult == WHITE then
            puts "白の勝利"
        end
    end
    #黒側の処理
    #戻り値
    #false：終了
    #true :スキップ
    #0 通常処理
    def blackTurn
        puts "\n黒側のターンです。駒を置く場所を入力してください。(x,y)例(4,5)\n終了するには0を入力してください。\nスキップの場合sを入力してください。"
        
        strArray = input
        #再入力
        if strArray == false then
            blackTurn
        #終了
        elsif strArray==nil then
            return false
        #スキップ
        elsif strArray=="s" then
            return true
        #通常処理
        else 
            strArray[0] -= 1
            strArray[1] -= 1
            if @b.checkSwitchPiece(BLACK,strArray) then 
                puts "裏返すコマがありません。入力し直してください。"
                blackTurn
            elsif @b.getBoard[strArray[1]][strArray[0]].getState != EMPTY then
                puts "既にコマが置いてあります。入力し直してください。"
                blackTurn
            else
                b = @b.getBoard
                @b.switchPieceinBoard(strArray)
                b[strArray[1]][strArray[0]].putPiece(BLACK)
            end
            return 0
        end
    end
    #白側の処理
    #戻り値
    #false：終了
    #true :スキップ
    #0 通常処理
    def whiteTurn
        puts "\n白側のターンです。駒を置く場所を入力してください。(x,y)例(4,5)\n終了するには0を入力してください。\nスキップの場合sを入力してください。"
        strArray = input
        #再入力
        if strArray == false then
            whiteTurn
        #終了
        elsif strArray==nil then
            return false
        #スキップ
        elsif strArray=="s" then
            return true
        #通常処理
        else 
            strArray[0] -= 1
            strArray[1] -= 1
            if @b.checkSwitchPiece(WHITE,strArray) then 
                puts "裏返すコマがありません。入力し直してください。"
                whiteTurn
            elsif @b.getBoard[strArray[1]][strArray[0]].getState != EMPTY then
                puts "既にコマが置いてあります。入力し直してください。"
                whiteTurn
            else 
                b = @b.getBoard
                @b.switchPieceinBoard(strArray)
                b[strArray[1]][strArray[0]].putPiece(WHITE)
            end
        end
    end
    #入力する関数
    #戻り値nil：終了
    #false：再入力
    #配列[2]：入力された2つの数値
    #"s" :スキップ
    def input
        strArray = gets
        if strArray == "0\n" then
            return nil
        elsif strArray == "s\n" then
            return "s"
        else 
            strArray = strArray.split(",")
        end
        strArray[0] = strArray[0].to_i
        strArray[1] = strArray[1].to_i

        
        if strArray[0] < 1 || strArray[0]> WIDTH then
            puts "1つ目に入力された数値が範囲外です。入力し直してください。"
            return false
        elsif strArray[1] < 1 || strArray[1] > HEIGHT then
            puts "2つ目に入力された数値が範囲外です。入力し直してください。"
            return false
        end
        return strArray
    end
    #盤面を出力する関数
    def outputBoard(board)
        s = "\n0 1 2 3 4 5 6 7 8\n"
        i = 1
        board.getBoard.each do |heightIndex|
            s << i.to_s
            heightIndex.each do |widthIndex|
                s << widthIndex.getState
            end
            s << "\n"
            i += 1
        end
        puts s
        return nil
    end
end

#最初に実行
main = Main.new
main.start

main.update