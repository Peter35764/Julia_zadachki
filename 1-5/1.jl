#=
ДАНО: Робот находится в произвольной клетке ограниченного прямоугольного поля без внутренних перегородок и маркеров.
РЕЗУЛЬТАТ: Робот — в исходном положении в центре прямого креста из маркеров, расставленных вплоть до внешней рамки.
=#
using HorizonSideRobots
r=Robot(animate=true)
println("  ЗАДАЧА 1
 ---Инструкция---
 1. Подключить файл lib.jl, который можно найти в папке Libraries.
 2. Подготовить поле в соответствии с условием задачи.
 3. Для выполнения программы необходимо запустить из консоли одну из предложенных функций:
    start()     1 вариант, построенный по принципу подсчета шагов.
    start1()    2 вариант, в котором робот ориентируется на оставленные маркеры
 ----------------")

function start()
    for side in (Nord, West, Sud, Ost)
        cross(r, side)
    end
    putmarker!(r)
end
function start1()
    for side in (Nord, West, Sud, Ost)
        cross1(r, side)
    end
    putmarker!(r)
end
function cross(r, side)
    local num_steps = 0
    while !isborder(r, side)
        move!(r, side)
        putmarker!(r)
        num_steps += 1
    end
    moving(r, reverse_side(side), num_steps)
end
function cross1(r, side)
    while !isborder(r, side)
        move!(r, side)
        putmarker!(r)
    end
    moving_until_empty_field(r, reverse_side(side))
end

    