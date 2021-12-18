#Все команды из lib.jl исправлены и скопированы сюда. Эти команды несовместимы с первыми 5 решениями.

function try_move!(r, side)
    if isborder(r, side) false
    else 
        move!(r, side)
        true 
    end
end
function moving!(r, side::HorizonSide, num_steps::Int)
    for _ in 1:num_steps
        move!(r, side)
    end
end
function moving!(r, side::HorizonSide)
    local a = 0
    while !isborder(r, side)
        move!(r, side)
        a += 1
    end
    return a
end
function moving!(stop_condition::Function, robot, side, max_num_steps)
    n = 0
    while n < max_num_steps && !stop_condition() && try_move!(robot, side) # - в этом логическом выражении порядок аргументов важен!
        n += 1
    end  
    return n 
end
function moving_until_empty_field!(r, side)
    while ismarker(r) && !isborder(r, side)
        move!(r,side)
    end
end
function moving_with_trace!(r, side, num_steps)
    local i = 1
    while !isborder(r, side) && (num_steps >= i)
        putmarker!(r)
        move!(r, side)
        i += 1
    end
    putmarker!(r)
end
function moving_with_trace!(r, side)
    local a = 0
    while !isborder(r, side)
        putmarker!(r)
        move!(r, side)
        a += 1
    end
    putmarker!(r)
    return a
end
function go_to_corner!() # Юго - западный угол.
    while ( !isborder(r, Sud) || !isborder(r, West) )
        if isborder(r, Sud) 
            move!(r, West)
        else
            move!(r, Sud) 
        end
    end
end
function shuttle!(stop_condition::Function, r, side)
    n = 0 
    while !stop_condition()
        n += 1
        moving!(r, side, n)
        side = reverse_side(side)
    end
end

"""
spiral!(stop_condition::Function, robot, side = Nord)

-- stop_condition:   stop_condition(::HorizonSide)::Bool

"""
function spiral!(stop_condition::Function, robot, side = Nord)
    n=1
    while true
        moving!(() -> stop_condition(side), robot, side, n)
        if stop_condition(side)
            return
        end        
        side = left(side)
        moving!(() -> stop_condition(side), robot, side, n)
        if stop_condition(side)
            return
        end        
        side = left(side)
        n += 1
    end
end
# -----------------------------------------------------------------------

#   Функции работы с типом HorizonSide

reverse_side(side::HorizonSide) = HorizonSide(mod(Int(side) + 2, 4))
left(side::HorizonSide) = HorizonSide(mod(Int(side) + 1, 4))
right(side::HorizonSide) = HorizonSide(mod(Int(side) - 1, 4))

# -----------------------------------------------------------------------

#   Вспомогательный тип Coord

mutable struct Coord
    x::Int
    y::Int 
end

Coord() = Coord(0,0)
get_coord(coord::Coord) = (coord.x, coord.y)

import HorizonSideRobots: move! 
function move!(coord::Coord, side::HorizonSide)
    if side==Nord
        coord.y += 1
    elseif side==Sud
        coord.y -= 1
    elseif side==Ost
        coord.x += 1
    else
        coord.x -= 1
    end
    nothing
end
# -----------------------------------------------------------------------

#   Композированный тип CoordRobot

mutable struct CoordRobot
    robot::Robot
    coord::Coord
    CoordRobot(r,(x,y)) = new(r,Coord(0,0)) # внутреннее переопределение конструктора по умолчанию
    CoordRobot(r) = new(r,Coord())
    # new() - Special function available to inner constructors 
    # which created a new object of the type. 
end

function goto!(robot::CoordRobot, coord) # НЕЗАИМСТВОВАННАЯ КОМАНДА. Перемещение на заданные координаты с защитой от врезания в стенки.
    if (typeof(coord) != Coord) coord = Coord(coord[1], coord[2]) end # Проверка типа входных данных и приведение к нужному типу, при необходимости.
    while (robot.coord.x != coord.x) || (robot.coord.y != coord.y)
        if (robot.coord.x == coord.x) && (robot.coord.y > coord.y)
            if isborder(r, Sud)
                println("Стенка на Юге!")
                break
            end
            move!(r, Sud)
        elseif (robot.coord.x == coord.x) && (robot.coord.y < coord.y)
            if isborder(r, Nord)
                println("Стенка на Севере!")
                break
            end
            move!(r, Nord)
        elseif (robot.coord.x > coord.x) && (robot.coord.y == coord.y)
            if isborder(r, West)
                println("Стенка на Западе!")
                break
            end
            move!(r, West)
        elseif (robot.coord.x < coord.x) && (robot.coord.y == coord.y)
            if isborder(r, Ost)
                println("Стенка на Востоке!")
                break
            end
            move!(r, Ost)
        elseif robot.coord.y < coord.y 
            if isborder(r, Nord)
                println("Стенка на Севере!")
                break
            end
            move!(r, Nord)
        elseif robot.coord.y > coord.y
            move!(r, Sud) 
            if isborder(r, Sud)
                println("Стенка на Юге!")
                break
            end
        elseif robot.coord.x < coord.x
            if isborder(r, Ost)
                println("Стенка на Востоке!")
                break
            end
            move!(r, Ost)
        else
            if isborder(r, West)
                println("Стенка на Западе")
                break
            end
            move!(r, West)
        end
    end
end

get_coord(robot::CoordRobot) = (robot.coord.x, robot.coord.y) # НЕЗАИМСТВОВАННАЯ КОМАНДА.

import HorizonSideRobots: move!, isborder, putmarker!, ismarker, temperature
function move!(robot::CoordRobot, side::HorizonSide)
    move!(robot.robot, side)
    move!(robot.coord, side)
end
isborder(robot::CoordRobot, side) = isborder(robot.robot, side)
putmarker!(robot::CoordRobot) = putmarker!(robot.robot)
ismarker(robot::CoordRobot) = ismarker(robot.robot)
temperature(robot::CoordRobot) = temperature(robot.robot)
# ------------------------------------------------------------