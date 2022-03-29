#!/usr/bin/env ruby
# || ---------- game.rb ---------- ||
# My game for Assignment A9
# 
# Ben Carpenter
# March 21, 2022
# ------------- game.rb -------------

require 'ruby2d'

$PLAY = 60 # Variable that changes how loose the aming is
$MAX_STARS = 8

def main
    # Sprites
    line = Line.new(x1: 320, y1: 480, x2:320, y2: 0, color: 'red')
    planet = Image.new("#{Ruby2D.ext_base_path}/../Resources/planet.png", y: 440)
    bg = Image.new("#{Ruby2D.ext_base_path}/../Resources/starfield_alpha.png", z: -1)
    stars = [Image.new("#{Ruby2D.ext_base_path}/../Resources/astroid.png", x: 0, y: 0, height: 57, width: 57)]
    
    # Sounds
    fire_sound = Sound.new("#{Ruby2D.ext_base_path}/../Resources/acid6.wav")
    
    # Varibles
    difficulty = 1
    fall_speed = 0.5 # Starting fall speed
    is_loaded = true
    lives = 3
    score = 0
    game_over = false
    score_text = Text.new("Score: #{score}")
    set title: "Space Base Command | Ben Carpenter"

    on :mouse_move do |event| # Runs every time the mouse is moved
        unless game_over
            line.x2 = screen_intercept(event) # Calculate where the line should end!
            line.y2 = 0
        end
    end

    on :mouse_down do |event|
        if is_loaded and !game_over
            fire_sound.play
            for star in stars
                if star_hit?(event, star)
                    score += 1
                    reset_star(star)

                    score_text.text = "Score: #{score}"

                    difficulty += ((difficulty * 0.1) / 2)
                end 
            end
            is_loaded = false
        end

    end

    tick = 1
    update do

        # Add stars according to difficulty
        if difficulty.to_i > stars.length && stars.length <= $MAX_STARS
            star = Image.new("#{Ruby2D.ext_base_path}/../Resources/astroid.png", height: 57, width: 57)
            stars << star
            reset_star(star)
        end

        # Game over
        if lives <= 0
            game_over = true
            Text.new("Game Over. Final Score: #{score}", x: 320, y: 240, color: "red")
            for star in stars do star.remove end
        end
        
        # Reset the stars when they get to the bottom of screen
        for star in stars
            if star.y > 480
                reset_star(star)
                lives -= 1
            end
            star.y = star.y + 0.5
        end
        
        # Reload timer
        unless is_loaded
            if tick == 65
                tick = 0
                is_loaded = true
            end
            fall_speed = difficulty / 2
            tick += 1
            line.width = 1 # Line is thinner when gun is not loaded
        else
            line.width = 3 # Line is thicker when gun is loaded!
        end
    end

    show
end

# Set a star to a random x pos at the top of the screen
def reset_star(star)
    star.y = -72

    if rand(2) == 0
        star.x = rand(246)
    else
        star.x = rand(246) + 395
    end
end

# My intense thank you to our TA, Waka, who was an immense help on this part of the project!

# Calculate where the line should end to intercept with the top of the screen!
def screen_intercept(event)
    x2 = event.x
    y2 = event.y

    x = -480*((x2-320.0)/(y2-480.0)) + 320 # Yay! Equations of lines!!
end

# Calculate weather or not a star is hit, with some wiggle room
def star_hit?(event, star)
    x2 = event.x
    y2 = event.y

    xstar = star.x + (star.width / 2.0)
    ystar = star.y + (star.height / 2.0)

    upper = (((y2 - 480.0) / (x2 - 320.0))*(xstar - 320) + 480) + $PLAY
    lower = (((y2 - 480.0) / (x2 - 320.0))*(xstar - 320) + 480) - $PLAY

    return star.y.between?(lower, upper)
end

main # Run the main function. 