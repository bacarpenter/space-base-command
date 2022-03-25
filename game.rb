#!/usr/bin/env ruby
# || ---------- game.rb ---------- ||
# My game for Assignment A9
# 
# Ben Carpenter
# March 21, 2022
# ------------- game.rb -------------

require 'ruby2d'

$PLAY = 50 # Variable that changes how loose the aming is

def main
    # Sprites
    line = Line.new(x1: 320, y1: 480, x2:320, y2: 480, color: 'red')
    boom = Image.new("assets/boom.png")
    stars = [
        Image.new("assets/star.png", x: 0, y: 0, height: 57, width: 57),
        Image.new("assets/star.png", x: 100, y: 0, height: 57, width: 57),
        Image.new("assets/star.png", x: 400, y: 0, height: 57, width: 57),
    ]

    on :mouse_move do |event|
        line.x2 = calc_screen_intercept(event)
        line.y2 = 0
    end

    on :mouse_down do |event|
        for star in stars
            if calc_star_on_line(event, star)
                star.y = 0
            end 
        end
    end

    update do
        for star in stars
            if star.y > 480
                reset_star(star)
            end
            star.y = star.y + 0.5
        end
    end

    show
end

def reset_star(star)
    star.y = -72
    star.x = rand(0..620)
end

def object_clicked?(event, object)
    event.x.between?(star.x, star.x + star.width) and event.y.between?(star.y, star.y + star.height)
end

# My intense thank you to our TA, Waka, who was an immense help on this part of the project!

def calc_screen_intercept(event)
    x2 = event.x
    y2 = event.y

    x = -480*((x2-320.0)/(y2-480.0)) + 320
end

def calc_star_on_line(event, star)
    x2 = event.x
    y2 = event.y

    xstar = star.x + (star.width / 2.0)
    ystar = star.y + (star.height / 2.0)

    upper = (((y2 - 480.0) / (x2 - 320.0))*(xstar - 320) + 480) + $PLAY
    lower = (((y2 - 480.0) / (x2 - 320.0))*(xstar - 320) + 480) - $PLAY

    return star.y.between?(lower, upper)
end

main