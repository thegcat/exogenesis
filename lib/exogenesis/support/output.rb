require "singleton"
require 'megingiard/centered_canvas'
require 'megingiard/emoji_node'
require 'megingiard/bold_node'
require 'megingiard/color_node'
require 'megingiard/node'

# Output is a Singleton. Get the instance
# via `Output.instance`
class Output
  include Singleton
  include Megingiard

  def initialize
    @canvas = CenteredCanvas.new(STDOUT)
    @success_node = EmojiNode.new(:thumbsup)
    @failure_node = EmojiNode.new(:thumbsdown)
    @skipped_node = EmojiNode.new(:point_right)
  end

  # Set the emoji for successful actions
  # def success_emoji=(success_emoji)
    # @success_node = EmojiNode.new(success_emoji)
  # end

  # Set the emoji for failed actions
  # def failure_emoji=(failure_emoji)
    # @failure_node = EmojiNode.new(failure_emoji)
  # end

  # Set the emoji for skipped actions
  # def skipped_emoji=(skipped_emoji)
    # @skipped_node = EmojiNode.new(skipped_emoji)
  # end

  # Print the text as a decorated header
  def decorated_header(text, emoji_name = :alien)
    emoji = EmojiNode.new(emoji_name)
    header = Node.new(emoji, '  ', BoldNode.new(text), ' ', emoji)
    @canvas.draw_centered_row(header)
  end

  # Print the left side of an output
  def left(text)
    text_with_colon = Node.new(text, ':')
    left = ColorNode.new(:white, BoldNode.new(text_with_colon))
    @canvas.draw_left_column(left)
  end

  # Print the right side with a success message
  def success(info)
    success = Node.new(' ', @success_node)
    @canvas.draw_right_column(success)
  end

  # Print the right side with a failure message
  def failure(info)
    failure = Node.new(' ', info, ' ', @failure_node)
    @canvas.draw_right_column(failure)
  end

  # Print the right side with a skipped message
  def skipped(info)
    skipped = Node.new(' ', @skipped_node)
    @canvas.draw_right_column(skipped)
  end

  # Print some arbitrary information on the right
  def info(info)
    info_node = Node.new(' ', info)
    @canvas.draw_right_column(info_node)
  end

  # Draw the upper bound of a border
  def start_border(info)
    # TODO: Implement this in clean way
    width = (terminal_width - 4 - info.length) / 2
    puts "\u250C#{("\u2500" * width)} #{info} #{("\u2500" * width)}\u2510"
  end

  # Draw the lower bound of a border
  def end_border
    # TODO: Implement this in clean way
    puts "\u2514#{"\u2500" * (terminal_width - 2)}\u2518"
  end

  private

  # Determine the width of the terminal
  def terminal_width
    # TODO: Implement this in clean way
    Integer(`tput cols`)
  end
end
