#=
ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля
РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки поля промакированы
=#
using HorizonSideRobots
r=Robot(10, 10; animate=true)
println("  ЗАДАЧА 3
 ---Инструкция---
 1. Подключить файл lib.jl, который можно найти в папке Libraries.
 2. Подготовить поле в соответствии с условием задачи.
 3. Для выполнения программы необходимо запустить из консоли предложенную функцию:
    start()
 ----------------")

function start()
    a = moving(r, Nord)
    b = moving(r, Ost)
    cover_surface()
    moving(r, West, b)
    moving(r, Sud, a)
end
function cover_surface()
    while ( ( !isborder(r, Ost) || !isborder(r, West) ) && !isborder(r, Sud) ) || !ismarker(r)
        moving_with_trace(r, West)
        if success_check() break end
        move!(r, Sud)
        moving_with_trace(r, Ost)
        if success_check() break end
        move!(r, Sud)
    end
    moving(r, Ost)
    moving(r, Nord)
end
"""
<Searching successful>
>success_check(::Nothing)::Bool
    Прекращает исполнение цикла, если он достиг поставленной цели. Так как данная функция исполняется сразу
    после "покраски" очередной линии, то единственным условием, необходимым для проверки того, что цикл
    выполнил свою задачу (То есть закрасил всё поле), является проверка существования ёще одной линии снизу
    (Если она существует, то она не закрашена.).
"""
function success_check()
    if isborder(r, Sud)
        moving(r, Ost)
        moving(r, Nord)
        return true
    end
    return false
end