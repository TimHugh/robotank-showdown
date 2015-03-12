require 'rrobots'

# Fast and ruthless
class Ruffrida
  include Robot

  attr_reader :last_enemy_sighting_time
  attr_reader :enemy_found

  def initialize
    @enemy_found = false
    @last_enemy_sighting_time = 0
    @current_direction = :clockwise
  end

  def tick(events)
    move

    @previous_energy = energy

    if enemy_found
      maintain_gun_direction
      shoot
    else
      search_for_enemy
    end

    reverse_directions if sustained_injury?
    last_enemy_sighting_time = time if enemy_sighting
    @enemy_found = false if time_since_last_enemy_sighting > 150
  end

  def enemy_sighting
    not events['robot_scanned'].empty?
  end

  def time_since_last_enemy_sighting
    time - last_enemy_sighting_time
  end

  def move_anticlockwise
    accelerate 1
    turn 2
  end

  def sustained_injury?
    energy < @previous_energy
  end

  def search_for_enemy
    if enemy_sighting
      self.enemy_found = true
    else
      turn_gun 10
    end
  end

  def move
    case @current_direction
    when :clockwise
      move_clockwise
    when :anticlockwise
      move_anticlockwise
    end
  end

  def move_clockwise
    accelerate -2
    turn -2
  end

  def enemy_found=(val)
    @last_enemy_sighting_time = time if val
    @enemy_found = val
  end

  def maintain_gun_direction
    case @current_direction
    when :clockwise
      turn_gun 2
    when :anticlockwise
      turn_gun - 2
    end
  end

  def reverse_directions
    if @current_direction == :clockwise
      @current_direction = :anticlockwise
    else
      @current_direction = :clockwise
    end
  end

  def shoot
    fire 0.5
  end
end
