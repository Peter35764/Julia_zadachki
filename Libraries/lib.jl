# ЗАДАЧА 1
function moving(r, side, num_steps)
    for i in 1:num_steps
        move!(r, side)
    end
end
function moving(r, side)
    local a = 0
    while !isborder(r, side)
        move!(r, side)
        a += 1
    end
    return a
end
function moving_until_empty_field(r, side)
    while ismarker(r) && !isborder(r, side)
        move!(r,side)
    end
end
function reverse_side(side)
    if side == Nord
        side = Sud
    elseif side == Sud
        side = Nord
    elseif side == West
        side = Ost
    else
        side = West
    end
end
# ЗАДАЧА 3
function moving_with_trace(r, side, num_steps)
    local i = 1
    while !isborder(r, side) && (num_steps >= i)
        putmarker!(r)
        move!(r, side)
        i += 1
    end
    putmarker!(r)
end

function moving_with_trace(r, side)
    local a = 0
    while !isborder(r, side)
        putmarker!(r)
        move!(r, side)
        a += 1
    end
    putmarker!(r)
    return a
end