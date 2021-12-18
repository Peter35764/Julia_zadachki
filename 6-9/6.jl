#=
ДАНО: На ограниченном внешней прямоугольной рамкой поле имеется ровно одна 
внутренняя перегородка в форме прямоугольника. Робот - в произвольной клетке 
поля между внешней и внутренней перегородками. 
РЕЗУЛЬТАТ: Робот - в исходном положении и по всему периметру внутренней 
перегородки поставлены маркеры.
=#
using HorizonSideRobots

println("  ЗАДАЧА 6
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
# вызываемые основными функциями программы, которые прописаны в основной функции start().

function start()
    home = Coord()
    go_to_corner!() 
    find_barrier()
    mark_perimeter!()
    modified_goto!(r, home)
end

"""
<Searching successful>
>success_check(::Nothing)::Bool
    Проверяет, нашел ли робот перегородку. Если возвращает true, то
    исполнение функции find_barrier() завершается.
"""
success_check() = isborder(r, Nord)

function find_barrier()
    local side = Ost
    while !success_check() 
        while !isborder(r, side) 
            move!(r, side)
            if success_check() break end 
        end
        if success_check() break end
        side = reverse_side(side)
        move!(r, Nord)
    end
end

function mark_perimeter!()
    direction = West
    while !ismarker(r)
        while isborder(r, right(direction))
            putmarker!(r)
            move!(r, direction)
            if ismarker(r) break end 
        end
        if ismarker(r) break end 
        direction = right(direction)
        putmarker!(r)
        move!(r, direction)
    end
end

"""
<Searching successful>
>modified_goto!(robot::CoordRobot, coord)
    Модификация функции goto! для решения Задачи 6, позволяющая возвращаться
    роботу на изначальную позицию вне зависимости от его местонахождения.
"""
function modified_goto!(robot, coord)
    if robot.coord.y < coord.y
        moving!(r, Ost)
        moving!(r, Nord)
        goto!(robot, coord)
    else goto!(robot, coord) end
end