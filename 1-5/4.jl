#=
ДАНО:
РЕЗУЛЬТАТ:
=#
using HorizonSideRobots
r=Robot(animate=true)
println("  ЗАДАЧА 4
 ---Инструкция---
 1. Подключить файл lib.jl, который можно найти в папке Libraries.
 2. Подготовить поле в соответствии с условием задачи.
 3. Для выполнения программы необходимо запустить из консоли предложенную функцию:
    start()
 ----------------")

function start()
    a = moving(r, Sud)
    b = moving(r, West)
    pyramide_and_back()
    moving(r, Ost, b)
    moving(r, Nord, a) 
end

function pyramide_and_back()
    local steps = moving_with_trace(r, Ost)
    while !isborder(r, Nord)
        moving(r, West)
        move!(r, Nord)
        steps -= 1
        moving_with_trace(r, Ost, steps)
    end
    moving(r, West)
    moving(r, Sud)
end

