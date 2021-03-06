require 'exogenesis/support/passenger'

# Installs and Removes Fonts
class Fonts < Passenger
  register_as :fonts
  needs :fonts_path

  def up
    install_all_fonts
  end

  def down
    collect_fonts do |file|
      rm_rf target_font_path(file)
    end
  end

  private

  def install_all_fonts
    collect_fonts do |file|
      install_font(file)
    end
  end

  def collect_fonts
    Dir.glob(File.join(fonts_path, "**/*.{ttf,otf}")).each do |file|
      yield file
    end
  end

  def install_font(file)
    unless File.exist? target_font_path(file)
      execute "Copying #{File.basename file}", "cp #{file} #{target_font_path(file)}"
    else
      skip_task "Copying #{File.basename file}", "Already copied"
    end
  end

  def target_font_path(file)
    File.join(ENV['HOME'], "Library/Fonts", File.basename(file))
  end

end
