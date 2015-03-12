require 'rrobots'

# Fast and ruthless
class Ruffrida
  include Robot

  def initialize
    @enemy_found = false
  end

  def tick(events)
    unless @enemy_found
      move_counter_clockwise
      search_for_enemy
    else
      move_clockwise
      maintain_gun_direction
      shoot
    end
  end

  def enemy_sighting
    not events['robot_scanned'].empty?
  end

  def move_counter_clockwise
    accelerate 1
    turn 2
  end

  def search_for_enemy
    if enemy_sighting
      @enemy_found = true
    else
      turn_gun 20
    end
  end

  def move_clockwise
    accelerate -2
    turn -2
  end

  def maintain_gun_direction
    turn_gun 2
  end

  def shoot
    fire 0.5
  end
end
