require 'ruby2d'

set title: 'Asteroids'
set width: 800
set height: 600

class Player


    def initialize(image)
        @x_velocity = 10
        @y_velocity = 10
        @x = Window.width * (1/2.0) - 32 * 3 / 2
        @y = 300
        @projectiles = []
        @current_x = @x
        @current_y = @y

        @last_projectile_fired_frame = 0
        @player = Sprite.new(
                image,
                clip_width: 32,
                width: 32 * 3,
                height: 46 * 3,
                x: @x,
                y: @y,
                animations: {
                    moving: 3..4
                }
            )
    end
    
    def set_x(x)
        @current_x = x
    end

    def set_y(y)
        @current_y = y
    end

    def get_x
        return @current_x
    end
    
    def get_y
        return @current_y
    end

    def animate
        @player.play(animation: :moving, loop: true)
    end


    def move(direction)

        case direction
        when :left
            @player.x -= @x_velocity
        when :right
            @player.x += @y_velocity
        when :up
            @player.y -= @x_velocity
        when :down
            @player.y += @y_velocity
        end

        if @player.x > Window.width + @player.width
            @player.x = -@player.width
          elsif @player.x < -@player.width
            @player.x = Window.width + @player.width
          end
      
          if @player.y > Window.height + @player.height
            @player.y = -@player.height
          elsif @player.y < -@player.height
            @player.y = Window.height + @player.height
        end

        set_x(@player.x)
        set_y(@player.y)



    end





end



class Star
    def initialize
        @y_velovity = 1 + rand(4)
        @shape = Circle.new(
            x: rand(Window.width),
            y: rand(Window.height),
            radius: 1 + (rand() % (2-1)),
            color: 'random')
    end

    def move
        @shape.y = (@shape.y + @y_velovity) % Window.height
    end
end

class Asteroids
    def initialize
        @y_velovity = 2 + rand(4)
        @Width =  25 + rand(30)
        @Height = 30 + rand(40)
        @x = 2 + rand(800)
        #@x = 120 + (rand() % (800-120))
        

        @current_x
        @current_y
        @shape = Sprite.new(
            '/Users/evelyngao/desktop/ruby/build/assets/images/asteriods.png',
            x: @x,
            y: 20,
            width: @Width,
            height: @Height,
        )
    end

    def get_width
        return @Width
    end

    def get_height
        return @Height
    end

    def move
        @shape.y = (@shape.y + @y_velovity) % Window.height
        set_x(@shape.x)
        set_y(@shape.y)
    end

    def get_x
        return @current_x
    end

    def get_y
        return @current_y
    end

    def set_x(x)
        @current_x = x
    end

    def set_y(y)
        @current_y = y
    end

end


class PlayerStartScreen
    def initialize
        @stars = Array.new(100).map{ Star.new}
        
        title_text = Text.new('ASTEROIDS', size: 72 , y:40)
        title_text.x = (Window.width - title_text.width)/2

        player = Player.new("/Users/evelyngao/desktop/ruby/build/assets/images/player.png")
    

        player.animate

        start_text = Text.new('Start Game', size: 42 , y:20)
        start_text.x = (Window.width - start_text.width)/2
        start_text.y = 440

        



    end

    def update
        # if Window.frames % 2 == 0
        #    @stars.each{ |star| star.move }
        # end
        if Window.frames % 2 == 0
            for i in (0..99) do
                @stars[i].move
            end
        end



    end
       
end

class GameScreen
    def initialize
        @stars = Array.new(100).map{Star.new}
        

        

        @current_asteriods = Array.new(8).map{Asteroids.new}



        @player = Player.new('/Users/evelyngao/desktop/ruby/build/assets/images/player.png')

        @player.animate


        
        
    end

    def collision
        for i in (0..7) do
            for j in ((@current_asteriods[i].get_x.to_i - @current_asteriods[i].get_width.to_i)..(@current_asteriods[i].get_x + @current_asteriods[i].get_width)) do               
                if (j.between?((@player.get_x-20),(@player.get_x + 20)) && (@current_asteriods[i].get_y.between?((@player.get_y - 26),(@player.get_y + 26))))                  
                    Window.clear
                    end_text = Text.new('Your Died', size: 72 , y:40)
                    end_text.x = (Window.width - end_text.width)/2
                end
            end
        end
    end







    def update

        if Window.frames % 2 == 0
            for i in (0..99) do
                @stars[i].move
            end
        end

 
        for i in (0..7)
            @current_asteriods[i].move
        end
        
     
        

        collision   
    end

    def set_start(start)
        @start_time = start
    end


    def move(direction)
        @player.move(direction)
        
    end




end





current_screen = PlayerStartScreen.new

update do
    current_screen.update
    
end



on :mouse_down do |event|
    case current_screen

    when PlayerStartScreen
        #puts event.x, event.y  
        case event.button
        when :left
            Window.clear
            current_screen = GameScreen.new
        end
    end


end




on :key_held do |event|
    case current_screen
    when GameScreen
        case event.key
        when 'left'
            current_screen.move(:left)
            
        when 'right'
            current_screen.move(:right)
            
        when 'up'
            current_screen.move(:up)
            
        when 'down'
            current_screen.move(:down)
             
        end
    end
end




show