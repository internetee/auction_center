module CupriteHelpers
  # Drop #pause anywhere in a test to stop the execution.
  # Useful when you want to checkout the contents of a web page in the middle of a test
  # running in a headful mode.
  def pause
    page.driver.pause
  end

  # Drop #debug anywhere in a test to open a Chrome inspector and pause the execution
  def debug(binding = nil)
    $stdout.puts '-------------------------------------------------'
    $stdout.puts "🔎 Open Chrome inspector at http://localhost:3333"
    $stdout.puts '-------------------------------------------------'
    $stdout.puts ''
    return binding.pry if binding

    page.driver.pause
  end
end
