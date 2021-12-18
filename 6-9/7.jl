#=
ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля (без внутренних перегородок) 
РЕЗУЛЬТАТ: Робот - в исходном положении, в клетке с роботом стоит маркер, и все остальные клетки 
поля промаркированы в шахматном порядке
=#
using HorizonSideRobots

println("  ЗАДАЧА 7
 ---Инструкция---
 1. Подключить с помощью команды include() файл lib2.jl, который можно найти в папке Libraries.
 2. Создать робота командой r=Robot(10, 10; animate=true), после чего сменить тип робота с Robot на CoordRobot с помощью команды r=CoordRobot(r)
 3. Подготовить поле в соответствии с условием задачи.
 4. Для выполнения программы нужно запустить из консоли данную функцию:
    start()
 ----------------
 Замечание: При создании робота необходимо присваивать его в переменную r.
 ----------------")
# README
# Все функции, определенные при помощи оператора присваивания '=' это подфункции других функций,
# вызываемые главными функциями программы, которые прописаны в основной функции start().

function start()
    home = Coord()
    go_to_corner!()
    chessboard!()
    goto!(r, home)
end

success_check() = isborder(r, Nord) && ( isborder(r, West) || isborder(r, Ost) )

set_marker!() = if ( (r.coord.x + r.coord.y) % 2 == 0 ) putmarker!(r) end

function chessboard!()
    local side = Ost
    while true
        while !isborder(r, side) 
            set_marker!()
            move!(r, side)
        end
        set_marker!()
        side = reverse_side(side)
        if success_check() break end
        move!(r, Nord)
    end
end