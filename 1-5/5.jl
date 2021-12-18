#=
ДАНО: В произвольной клетке ограниченного прямоугольного поля, на котором могут находиться также внутренние
прямоугольные перегородки (все перегородки изолированы друг от друга, прямоугольники могут вырождаться в отрезки.
РЕЗУЛЬТАТ: Робот - в исходном положении и в углах поля стоят маркеры.
=#
using HorizonSideRobots
r=Robot(animate=true)
println("  ЗАДАЧА 5
 ---Инструкция---
 1. Подключить файл lib.jl, который можно найти в папке Libraries.
 2. Подготовить поле в соответствии с условием задачи.
 3. Для выполнения программы необходимо запустить из консоли предложенную функцию:
    start()
 ----------------
 Замечание: Программа во время своей работы ведет отладочную печать. Это было необходимо на
            этапе разработки для понимания того, как программа перемещает массив из одной
            переменной в другую и корректно ли она его считывает при выполнении функции возвращения на
            исходную точку (для решения задачи программа должна была считать его задом на перёд). Так как 
            эта версия программы выполняет поставленную задачу, отладочная печать, что появляется 
            в процессе ее работы, носит исключительно эстетический характер.
 ----------------")
function start()
    a = go_to_corner_br(r) # br = bottom right
    markers_in_vertices_of_rectangle(r)
    rev_go_to_corner(r, a) # функция, обратная к go_to_corner_br(r)
end

function go_to_corner_br(r)
    local map = []
    while !(isborder(r, Sud) && isborder(r, Ost))
        if !isborder(r, Sud)
            move!(r, Sud)
            push!(map, 1)
        else
            move!(r, Ost)
            push!(map, 2)
        end
    end
    for i in 1:length(map) println(map[i]) end # тестовая печать
    println("test") # тестовая печать
    return map
end

function markers_in_vertices_of_rectangle(r)
    for Side in (West, Nord, Ost, Sud)
        putmarker!(r)
        moving(r, Side)
    end
end

function rev_go_to_corner(r, a)
    for i in (length(a):-1:1) # тип с предусловием 'пробегает' массив а в обратном порядке
        if a[i] == 1 
            move!(r, Nord)
        else 
            move!(r, West) 
        end
    end
    for i in (length(a):-1:1) println(a[i]) end #отладочная печать
end